import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart' as Path;
import 'dart:io';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        _controller = CameraController(cameras.first, ResolutionPreset.max);
        // _controller!.initialize() 호출 후에 UI 업데이트
        await _controller!.initialize().then((_) {
          if (!mounted) return;
          setState(() {}); // UI 업데이트를 위한 setState 호출
        });
      } else {
        print('No cameras available');
      }
    } on CameraException catch (e) {
      print('CameraException: $e');
    }
  }

  Future<void> _takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      print('Error: select a camera first.');
      return;
    }
    try {
      // Ensure the camera is initialized
      await _initializeControllerFuture;

      // Attempt to take a picture and get the file where it's saved.
      final XFile image = await _controller!.takePicture();

      // Save the picture to Firebase Storage
      await _uploadPictureToFirebase(image);
    } catch (e) {
      // If an error occurs, log the error to the console.
      print(e);
    }
  }

  Future<void> _uploadPictureToFirebase(XFile image) async {
    String fileName = Path.basename(image.path);
    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('uploads/$fileName');
    UploadTask uploadTask = firebaseStorageRef.putFile(File(image.path));

    TaskSnapshot taskSnapshot = await uploadTask;
    taskSnapshot.ref.getDownloadURL().then(
      (imageUrl) {
        // Store download URL in Firestore
        FirebaseFirestore.instance.collection('pictures').add({
          'url': imageUrl,
          'timestamp': FieldValue.serverTimestamp(),
        });
      },
      onError: (e) {
        print(e); // Handle errors of Firebase upload here
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Take a picture')),
      // Use a FutureBuilder to display a loading spinner until the controller
      // has finished initializing.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return CameraPreview(_controller!);
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _takePicture,
        child: const Icon(Icons.camera),
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
