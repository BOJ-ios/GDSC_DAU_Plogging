import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plogging/auth_service.dart';
import 'package:plogging/homepage.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  String? _selectedSchoolName;
  @override
  void initState() {
    super.initState();
    _selectedSchoolName = null;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(builder: (context, authService, child) {
      User? user = authService.currentUser();
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Login Page',
            style: TextStyle(fontSize: 20),
          ),
          centerTitle: true, // 안드로이드에서 센터
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: '이메일'),
                ),
                TextField(
                  obscureText: true,
                  controller: passwordController,
                  decoration: const InputDecoration(labelText: '비밀번호'),
                ),
                const SizedBox(height: 50),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 16),
                  child: ElevatedButton(
                    onPressed: () {
                      // 로그인 시도
                      authService.signIn(
                          email: emailController.text,
                          password: passwordController.text,
                          onSuccess: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("로그인 성공")),
                            );
                            // 로그인 성공 시 HomePage로 이동
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const HomePage()),
                            );
                          },
                          onError: (err) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Error : $err")),
                            );
                          });
                    },
                    child: const Text('로그인'),
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 16),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_selectedSchoolName == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("학교를 선택하세요")),
                        );
                      } else {
                        authService.signUp(
                          email: emailController.text,
                          password: passwordController.text,
                          schoolName: _selectedSchoolName!,
                          name: nameController.text,
                          onSuccess: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("회원가입 성공")));
                          },
                          onError: (error) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(content: Text(error)));
                          },
                        );
                      }
                    },
                    child: const Text('회원가입'),
                  ),
                ),
                // 1. 비밀번호 찾기 UI 추가
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 16),
                  child: ElevatedButton(
                    onPressed: () {
                      // 3. 버튼 이벤트 처리: authService의 비밀번호 찾기 기능 호출
                      if (emailController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("이메일을 입력해주세요.")),
                        );
                      } else {
                        authService.resetPassword(
                          email: emailController.text,
                          onSuccess: () {
                            // 4. 사용자 피드백 제공: 성공 알림
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("비밀번호 재설정 이메일을 보냈습니다.")),
                            );
                          },
                          onError: (error) {
                            // 4. 사용자 피드백 제공: 에러 알림
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Error : $error")),
                            );
                          },
                        );
                      }
                    },
                    child: const Text('비밀번호 찾기'),
                  ),
                ),
                DropdownButton<String?>(
                  value: _selectedSchoolName,
                  items: [null, '동아대학교', '기타대학교'].map((String? i) {
                    return DropdownMenuItem<String?>(
                      value: i,
                      child: Text(i == null ? '미선택' : i.toString()),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedSchoolName = newValue;
                    });
                  },
                ),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: '이름'),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
