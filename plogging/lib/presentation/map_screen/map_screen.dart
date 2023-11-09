import 'package:plogging/core/app_export.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:plogging/presentation/main_screen/main_screen.dart';
import 'package:plogging/presentation/profile_screen/profile_screen.dart';

var logger = Logger();

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  Position? currentPosition;
  bool isLocationPermissionGranted = false;
  Set<Marker> markers = {}; // 마커를 저장할 Set

  @override
  void initState() {
    super.initState();
    _determinePosition();
    _loadMarkers(); // Firestore로부터 마커를 로드하는 메서드 호출
  }

  Future<void> _determinePosition() async {
    Position position;
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // 권한 확인 후 상태를 업데이트합니다.
    setState(() {
      currentPosition = position;
      isLocationPermissionGranted = true; // 권한이 부여되었음을 표시합니다.
    });

    // 위치 권한이 있는 경우에만 카메라를 현재 위치로 이동합니다.
    if (isLocationPermissionGranted) {
      mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 15.0,
        ),
      ));
    }
  }

  Future<BitmapDescriptor> getResizedMarkerImageFromUrl(
      String url, int targetWidth, int targetHeight) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        // 이미지 데이터로부터 BitmapDescriptor를 생성합니다.
        final Uint8List imageData = response.bodyBytes;
        final codec = await ui.instantiateImageCodec(
          imageData,
          targetWidth: targetWidth,
          targetHeight: targetHeight,
        );
        final ui.FrameInfo fi = await codec.getNextFrame();
        final data = await fi.image.toByteData(format: ui.ImageByteFormat.png);

        // 캐시 디렉토리에 이미지를 저장합니다.
        final cacheDir = await getTemporaryDirectory();
        final fileName = path.basename(url);
        final cacheImagePath = path.join(cacheDir.path, fileName);
        final cacheImageFile = File(cacheImagePath);
        await cacheImageFile.writeAsBytes(data!.buffer.asUint8List());

        // 캐시된 이미지 파일로부터 BitmapDescriptor를 생성합니다.
        return BitmapDescriptor.fromBytes(data.buffer.asUint8List());
      } else {
        // HTTP 요청이 실패한 경우 에러를 기록합니다.
        throw Exception(
            'Failed to load marker image, status code: ${response.statusCode}');
      }
    } catch (e) {
      // 에러를 캐치하여 추가적인 디버깅 정보를 제공합니다.
      logger.e(e);
      rethrow; // 에러를 다시 발생시킵니다.
    }
  }

// 캐시에 이미지가 있는지 확인하고, 있으면 바로 불러오고 없으면 다운로드 후 캐시에 저장하는 메서드
  Future<BitmapDescriptor> getCachedImage(
      String imageUrl, int width, int height) async {
    final fileName = path.basename(imageUrl); // 파일 이름 추출
    final cacheDir = await getTemporaryDirectory(); // 캐시 디렉토리 경로 가져오기
    final filePath = path.join(cacheDir.path, fileName); // 파일 경로 결합

    final file = File(filePath); // 파일 객체 생성

    if (await file.exists()) {
      // 파일이 존재하면 바로 불러옴
      final bytes = await file.readAsBytes();
      return BitmapDescriptor.fromBytes(bytes);
    } else {
      // 파일이 없으면 다운로드 후 캐시에 저장
      final Uint8List bytes =
          await downloadImageAndResize(imageUrl, width, height);
      await file.writeAsBytes(bytes); // 캐시에 바이트 데이터를 씁니다.
      return BitmapDescriptor.fromBytes(
          bytes); // 바이트 데이터로부터 BitmapDescriptor 생성
    }
  }

  // URL에서 이미지를 다운로드하고 크기를 조정하는 메서드
  Future<Uint8List> downloadImageAndResize(
      String imageUrl, int targetWidth, int targetHeight) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        // 이미지 데이터로부터 Uint8List를 생성합니다.
        final Uint8List imageData = response.bodyBytes;
        final codec = await ui.instantiateImageCodec(
          imageData,
          targetWidth: targetWidth,
          targetHeight: targetHeight,
        );
        final ui.FrameInfo fi = await codec.getNextFrame();
        final data = await fi.image.toByteData(format: ui.ImageByteFormat.png);
        return data!.buffer.asUint8List();
      } else {
        // HTTP 요청이 실패한 경우 에러를 기록합니다.
        throw Exception(
            'Failed to load marker image, status code: ${response.statusCode}');
      }
    } catch (e) {
      // 에러를 캐치하여 추가적인 디버깅 정보를 제공합니다.
      logger.e(e);
      rethrow; // 에러를 다시 발생시킵니다.
    }
  }

  // Firestore로부터 마커를 로드하는 메서드
  // Firestore로부터 마커를 로드하는 메서드
  void _loadMarkers() async {
    final String userId = FirebaseAuth.instance.currentUser!.uid;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    QuerySnapshot querySnapshot = await firestore
        .collection('users')
        .doc(userId)
        .collection('markers')
        .get();
    Set<Marker> newMarkers = {};

    for (var doc in querySnapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;

      // getCachedImage()를 호출하여 캐시된 이미지를 불러오거나 새로 다운로드합니다.
      final markerIcon = await getCachedImage(
          data['url'], // 마커 이미지의 URL
          130, // 원하는 이미지 너비
          130 // 원하는 이미지 높이
          );

      final marker = Marker(
        markerId: MarkerId(doc.id),
        position: LatLng(data['latitude'], data['longitude']),
        icon: markerIcon, // 캐시에서 불러오거나 다운로드한 이미지를 사용한 마커 아이콘
      );
      newMarkers.add(marker);
    }

    setState(() {
      markers = newMarkers; // 새로운 마커 세트로 상태를 업데이트합니다.
    });
  }

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: Colors
                  .black), // Change the color to black or any color that contrasts with white
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        toolbarHeight: 55.v,
        title: Text("Map", style: CustomTextStyles.titleMediumOnErrorContainer),
        actions: [
          CustomImageView(
              imagePath: ImageConstant.imgHeart,
              height: 24
                  .adaptSize, // 'adaptSize' is a custom extension method to handle responsiveness
              width: 24.adaptSize,
              margin: EdgeInsets.symmetric(vertical: 2.v),
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.cameraScreen);
              }),
          const SizedBox(
            width: 35,
          ),
          CustomImageView(
              imagePath: ImageConstant.imgGroup952,
              height: 16.adaptSize,
              width: 16.adaptSize,
              margin: EdgeInsets.symmetric(vertical: 3.v),
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => const MainScreen()));
              }),
          const SizedBox(
            width: 35,
          ),
          CustomImageView(
              imagePath: ImageConstant.imgUser,
              height: 29.adaptSize,
              width: 29.adaptSize,
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => const ProfileScreen()));
              }),
          const SizedBox(
            width: 20,
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
            },
            initialCameraPosition: const CameraPosition(
              target: LatLng(0, 0),
              zoom: 10,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: true, //기본값 : true
            markers: markers,
          ),
          // 마커 개수 표시
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: const EdgeInsets.only(top: 10), // 상단 바로 아래에 위치
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                'Markers: ${markers.length}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }
}
