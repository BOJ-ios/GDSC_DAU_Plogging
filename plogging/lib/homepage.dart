import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plogging/loginpage.dart';
import 'package:provider/provider.dart';
import 'package:plogging/mappage.dart';

import 'auth_service.dart';
import 'camerapage.dart'; // Import the camera_example.dart file

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<AuthService>(context).currentUser();

    return Scaffold(
      appBar: AppBar(
        title: const Text('홈페이지'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Provider.of<AuthService>(context, listen: false).signOut();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(user != null ? '환영합니다, ${user.email}' : '로그인 상태가 아닙니다.'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => MapPage(),
                ));
              },
              child: Text('지도 보기'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CameraExample(), // Show CameraExample widget
                ));
              },
              child: Text('사진 업로드'), // Add a button for photo upload
            ),
          ],
        ),
      ),
    );
  }
}
