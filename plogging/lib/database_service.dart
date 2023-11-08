import 'package:cloud_firestore/cloud_firestore.dart';

// 사용자의 uid를 받아요.
class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});

// users collection을 변수로 만들어줄게요.
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

//회원가입시 사용자가 입력한 email, password를 받아서
  Future updateUserData(
    String email,
    String schoolName,
    String name,
  ) async {
//users 컬렉션에서 고유한 uid document를 만들고 그 안에 email, password 필드값을 채워넣어요.
    return await userCollection.doc(uid).set({
      'email': email,
      'schoolName': schoolName,
      'name': name,
    });
  }
}
