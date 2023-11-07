import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plogging/loginpage.dart';
import 'package:provider/provider.dart';
import 'package:plogging/mappage.dart';

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
        // child: Text(user != null ? '환영합니다, ${user.email}' : '로그인 상태가 아닙니다.'),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(user != null ? '환영합니다, ${user.email}' : '로그인 상태가 아닙니다.'),
            SizedBox(height: 20), // 공간을 띄워줍니다.
            ElevatedButton(
              onPressed: () {
                // mapPage로 이동
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => MapPage(), // MapPage로 이동하도록 수정
                ));
              },
              child: Text('지도 보기'),
            ),
          ],
        ),
      ),
    );
  }
}
