import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vision/flutter_vision.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:ui' as ui;

Location location = Location();
var logger = Logger();
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class CameraExample extends StatefulWidget {
  const CameraExample({Key? key}) : super(key: key);

  @override
  _CameraExampleState createState() => _CameraExampleState();
}

class _CameraExampleState extends State<CameraExample> {
  //! 위치 서비스와 권한 요청:
  Future<void> requestPermission() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }

  XFile? _image;
  final ImagePicker picker = ImagePicker();
  final FlutterVision vision = FlutterVision();
  Uint8List? detectedImage;
  // !이미지를 가져오는 함수
  Future getImage(ImageSource imageSource) async {
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final fileSize = await file.length();
      // 5MB 이하인지 확인
      if (fileSize <= 5 * 1024 * 1024) {
        setState(() {
          _image = pickedFile;
        });
      } else {
        // 사용자에게 파일이 너무 크다고 알립니다.
        showErrorSnackbar('파일이 너무 큽니다. 5MB 이하의 파일을 선택해 주세요.');
      }
    }
  }

  // !이미지를 Firebase Storage에 업로드하는 함수
  Future<void> uploadImage() async {
    // 권한 요청
    await requestPermission();
    if (_image != null) {
      String fileName = path.basename(_image!.path);
      // 파일 확장자 추출
      String fileExtension = fileName.split('.').last.toLowerCase();
      // 지원되는 확장자 목록
      List<String> supportedExtensions = ['jpg', 'jpeg', 'png'];
      // 파일 확장자 확인
      if (supportedExtensions.contains(fileExtension)) {
        Reference storageReference =
            FirebaseStorage.instance.ref().child("image/$fileName");
        try {
          UploadTask uploadTask = storageReference.putFile(File(_image!.path));
          TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => {});
          final urlDownload = await taskSnapshot.ref.getDownloadURL();
          logger.d('이미지 업로드 성공');
          logger.d('url : $urlDownload');
          showSuccessSnackbar();
          // !Firestore에 URL과 타임스탬프 저장
          // Todo : 위치 데이터 추가? => 완료
          // 현재 위치 가져오기
          LocationData locationData = await location.getLocation();
          await FirebaseFirestore.instance.collection('pictures').add({
            'url': urlDownload,
            'timestamp': FieldValue.serverTimestamp(),
            'latitude': locationData.latitude,
            'longitude': locationData.longitude,
          });
          // 현재 로그인한 사용자의 UID를 얻습니다.
          final String userId = FirebaseAuth.instance.currentUser!.uid;
          // Firestore에 사용자의 마커 위치 데이터를 추가합니다.
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .collection('markers')
              .add({
            'url': urlDownload, // 이미지의 다운로드 URL
            'timestamp': FieldValue.serverTimestamp(), // 서버의 타임스탬프
            'latitude': locationData.latitude, // 위도
            'longitude': locationData.longitude, // 경도
          });
          // Analyze the image using flutter_vision
          analyzeImage(urlDownload);
        } catch (e) {
          logger.e('이미지 업로드 실패: $e');
          showErrorSnackbar('이미지 업로드에 실패했습니다. 에러: $e');
        }
      } else {
        // 지원되지 않는 파일 형식입니다. 사용자에게 알립니다.
        logger.e('지원되지 않는 파일 형식입니다.');
        showErrorSnackbar('지원되지 않는 파일 형식입니다. JPG, JPEG, PNG 파일만 업로드할 수 있습니다.');
      }
    } else {
      logger.e('이미지가 선택되지 않았습니다.');
      showSelectionErrorSnackbar();
    }
  }

  Future<void> analyzeImage(String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        Uint8List imageBytes = response.bodyBytes;

        // Use image package to decode the image and find out the dimensions
        final image = img.decodeImage(imageBytes); // The image package function
        if (image == null) throw 'Unable to decode image';

        // Load the YOLO model before running inference.
        await vision.loadYoloModel(
            modelPath: 'assets/yolov8m_float16.tflite',
            labels: 'assets/coco_label.txt',
            modelVersion: 'yolov8',
            quantization: false,
            numThreads: 2,
            useGpu: true);

        // Run inference using the YOLO model with actual image dimensions
        List<Map<String, dynamic>> results = await vision.yoloOnImage(
          bytesList: imageBytes,
          imageHeight: image.height,
          imageWidth: image.width,
          // Provide other parameters as needed
        );
        logger.d(results);
        setState(() {});
        //감지된 사진을 화면에 표시
      } else {
        logger.e('Failed to fetch image for analysis.');
      }
    } catch (e) {
      logger.e('An error occurred while analyzing the image: $e');
    }
  }

  Widget _buildPhotoArea() {
    return _image != null
        ? SizedBox(
            width: 300,
            height: 300,
            child: Image.file(File(_image!.path)),
          )
        : Container(
            width: 300,
            height: 300,
            color: Colors.grey,
          );
  }

  Widget _buildButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            getImage(ImageSource.camera);
          },
          child: const Text("카메라"),
        ),
        const SizedBox(width: 30),
        ElevatedButton(
          onPressed: () {
            getImage(ImageSource.gallery);
          },
          child: const Text("갤러리"),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: scaffoldMessengerKey,
      home: Scaffold(
        appBar: AppBar(title: const Text("Camera Test")),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30, width: double.infinity),
            _buildPhotoArea(),
            const SizedBox(height: 20),
            _buildButton(),
            ElevatedButton(
              onPressed: uploadImage, // 이미지 업로드 함수 호출
              child: const Text("이미지 업로드"),
            ),
          ],
        ),
      ),
    );
  }

  Future<ui.Image> loadImage(Uint8List imgBytes) async {
    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(imgBytes, (ui.Image img) {
      return completer.complete(img);
    });
    return completer.future;
  }

  //! 스낵바
  void showSuccessSnackbar() {
    if (mounted) {
      scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
      scaffoldMessengerKey.currentState?.showSnackBar(
        const SnackBar(
          content: Text('이미지가 성공적으로 업로드되었습니다!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  void showErrorSnackbar(String message) {
    if (mounted) {
      scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
      scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void showSelectionErrorSnackbar() {
    if (mounted) {
      scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
      scaffoldMessengerKey.currentState?.showSnackBar(
        const SnackBar(
          content: Text('이미지를 선택해주세요.'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }
}
