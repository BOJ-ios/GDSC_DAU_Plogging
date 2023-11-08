import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plogging/camerapage.dart';
import 'package:plogging/loginpage.dart';
import 'package:provider/provider.dart';
import 'package:plogging/mappage.dart';
import 'package:plogging/pedometer.dart';
import 'package:plogging/upload_state.dart';

import 'auth_service.dart';
import 'package:plogging/camera.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<AuthService>(context).currentUser(); // 현재 사용자 가져오기
    return Scaffold(
      appBar: AppBar(
        title: const Text('홈페이지'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // 로그아웃 메서드를 호출
              Provider.of<AuthService>(context, listen: false).signOut();
              // 로그인 페이지로 이동
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
            Text(user != null ? 'UID, ${user.uid}' : '로그인 상태가 아닙니다.'),
            const SizedBox(height: 20), // 공간을 띄워줍니다.
            ElevatedButton(
              onPressed: () {
                // mapPage로 이동
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const MapPage(), // MapPage로 이동하도록 수정
                ));
              },
              child: const Text('지도 보기'),
            ),
            const SizedBox(height: 20), // 공간을 띄워줍니다.
            ElevatedButton(
              onPressed: () {
                // PedometerPage로 이동
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const PedometerPage(),
                ));
              },
              child: const Text('만보계 보기'),
            ),
            const SizedBox(height: 20),
            // 카메라 페이지로 가는 버튼 추가
            ElevatedButton(
              onPressed: () {
                // CameraPage로 이동
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      const CameraExample(), // CameraPage 클래스를 생성해야 함
                ));
              },
              child: const Text('사진선택 업로드'),
            ),
            const SizedBox(height: 20), // 공간을 띄워줍니다.
            // 카메라 페이지로 가는 버튼 추가
            ElevatedButton(
              onPressed: () {
                // CameraPage로 이동
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      const CameraPage(), // CameraPage 클래스를 생성해야 함
                ));
              },
              child: const Text('카메라 촬영'),
            ),
            const SizedBox(height: 50), // 공간을 띄워줍니다.
            ElevatedButton(
              onPressed: () {
                // 탈퇴 메서드를 호출
                Provider.of<AuthService>(context, listen: false)
                    .deleteAccount();
                // 로그인 페이지로 이동
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              child: const Text('바로 탈퇴'),
            ),
            const SizedBox(height: 20),
            Consumer<UploadState>(
              // Consumer 위젯을 사용하여 UploadState의 상태를 가져옵니다.
              builder: (context, uploadState, child) {
                return ElevatedButton(
                  onPressed: () {
                    // UploadState의 현재 상태를 가져와서 반대로 설정
                    bool currentStatus = uploadState.isUploaded;
                    uploadState.setUploadStatus(!currentStatus);
                  },
                  child: Text(
                      '상태 변경 (현재: ${uploadState.isUploaded ? "true" : "false"})'), // 버튼의 텍스트를 동적으로 변경합니다.
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
