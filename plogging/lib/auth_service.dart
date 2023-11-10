import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// 로그인 상태가 변할 시, 화면 초기화를 위해 ChangeNotifier
class AuthService extends ChangeNotifier {
  // firebase_auth의 User클래스
  User? currentUser() {
    // 현재 로그인 된 유저의 객체 (User) 반환(로그인 되지 않은 경우 null 반환)
    return FirebaseAuth.instance.currentUser;
  }

  void signUp({
    required String email, // 이메일
    required String password, // 비밀번호
    required Function() onSuccess, // 가입 성공시 호출되는 함수
    required Function(String err) onError, // 에러 발생시 호출되는 함수
    required String? schoolName, // 비밀번호
    required String name, // 이름
  }) async {
    // 회원가입 유효성 검사, 이메일 및 비밀번호 입력 여부 확인
    if (email.isEmpty) {
      onError("이메일을 입력해 주세요");
      return;
    } else if (password.isEmpty) {
      onError("비밀번호를 입력해 주세요");
      return;
    } else if (schoolName == null) {
      onError("학교를 선택해주세요");
      return;
    } else if (name.isEmpty) {
      onError("이름 입력해 주세요");
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      await FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
        'email': email,
        'schoolName': schoolName,
        'name': name,
        'trashCount': 0,
        'point': 0
      });
      await user.sendEmailVerification();
      signOut();
      onSuccess(); // 성공 콜백 호출
    } on FirebaseAuthException catch (e) {
      // Firebase auth 에러; email 형식을 지키지 않았거나, 등
      // onError(e.message!);
      // onError를 한국어로 나오게 경우의 수 추가
      if (e.code == 'weak-password') {
        onError('비밀번호를 6자리 이상 입력해 주세요.');
      } else if (e.code == 'email-already-in-use') {
        onError('이미 가입된 이메일 입니다.');
      } else if (e.code == 'invalid-email') {
        onError('이메일 형식을 확인해주세요.');
      } else if (e.code == 'user-not-found') {
        onError('일치하는 이메일이 없습니다.');
      } else if (e.code == 'wrong-password') {
        onError('비밀번호가 일치하지 않습니다.');
      } else {
        onError(e.message!);
      }
    } catch (e) {
      // Firebase auth 이외의 에러
      onError(e.toString());
    }
  }

  void signIn({
    required String email, // 이메일
    required String password, // 비밀번호
    required Function() onSuccess, // 로그인 성공시 호출되는 함수
    required Function(String err) onError, // 에러 발생시 호출되는 함수
  }) async {
    // 로그인 유효성 검사
    if (email.isEmpty) {
      onError('이메일을 입력해 주세요.');
      return;
    } else if (password.isEmpty) {
      onError('비밀번호를 입력해 주세요.');
      return;
    }

    // 로그인 시도
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      if (user!.emailVerified) {
        onSuccess(); // 성공 시
        notifyListeners(); // 로그인 성공 시, 상태 변경
      } else {
        onError('이메일 확인 안됨');
      }
    } on FirebaseAuthException {
      // Firebase auth 에러; email 형식을 지키지 않았거나, 등
      onError('로그인 실패');
      // onError(e.message!);
    } catch (e) {
      // Firebase auth 이외의 에러
      onError(e.toString());
    }
  }

  void signOut() async {
    // 로그아웃
    await FirebaseAuth.instance.signOut();
    notifyListeners(); // 로그아웃 시, 상태 변경
  }

  Future<void> resetPassword({
    required String email,
    required VoidCallback onSuccess,
    required Function(String) onError,
  }) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      onSuccess();
    } catch (error) {
      onError(error.toString());
    }
  }

  void deleteAccount() {
    User? user = FirebaseAuth.instance.currentUser;
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    users.doc(user?.uid).delete();
    user?.delete();
  }
}
