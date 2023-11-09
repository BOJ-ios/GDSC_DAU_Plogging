import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plogging/camerapage.dart';
import 'package:plogging/loginpage.dart';
import 'package:provider/provider.dart';
import 'package:plogging/pedometer.dart';
import 'auth_service.dart';

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
                // Navigator.of(context).push(MaterialPageRoute(
                //   builder: (context) => const MapPage(), // MapPage로 이동하도록 수정
                // ));
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
              child: const Text('사진찰영, 선택 => 업로드'),
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
          ],
        ),
      ),
    );
  }
}
