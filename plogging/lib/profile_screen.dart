import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plogging/core/app_export.dart';
import 'package:plogging/auth_service.dart';
import 'package:plogging/main_screen.dart';
import 'package:plogging/log_in_screen.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<int> _markersCountFuture;

  @override
  void initState() {
    super.initState();
    _markersCountFuture = _calculateMarkersCount();
  }

  Future<int> _calculateMarkersCount() async {
    final String userId = FirebaseAuth.instance.currentUser!.uid;
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('markers')
        .get();
    return querySnapshot.size;
  }

  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<AuthService>(context).currentUser();
    return FutureBuilder<DocumentSnapshot>(
      future:
          FirebaseFirestore.instance.collection('users').doc(user?.uid).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          Map<String, dynamic> userData =
              snapshot.data!.data() as Map<String, dynamic>;
          String userName = userData['name'] ?? 'No Name';
          String userEmail = userData['email'] ?? 'No Email';
          String userSchool = userData['schoolName'] ?? 'No School';
          int trashCount = userData['trashCount'] ?? 0;
          int point = userData['point'] ?? 0;

          return FutureBuilder<int>(
            future: _markersCountFuture,
            builder: (context, markersSnapshot) {
              int markersCount = markersSnapshot.data ?? 0;

              return Scaffold(
                body: Column(
                  children: [
                    Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 80.h, vertical: 24.v),
                        decoration: AppDecoration.gradientIndigoAToIndigoA
                            .copyWith(
                                borderRadius:
                                    BorderRadiusStyle.customBorderBL50),
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(height: 60.v),
                              CustomImageView(
                                  imagePath: ImageConstant.imgRectangle1565,
                                  height: 141.adaptSize,
                                  width: 141.adaptSize,
                                  radius: BorderRadius.circular(70.h),
                                  alignment: Alignment.center),
                              SizedBox(height: 15.v),
                              Text(userName,
                                  style: theme.textTheme.headlineSmall),
                              SizedBox(height: 15.v),
                              Text(userEmail,
                                  style: theme.textTheme.labelMedium),
                              SizedBox(height: 10.v),
                              Text(userSchool,
                                  style: theme.textTheme.labelMedium)
                            ])),
                    const SizedBox(height: 40),
                    Padding(
                      padding: EdgeInsets.only(left: 60.h, right: 60.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text("Markers",
                                  style: theme.textTheme.bodyMedium),
                              Text("$markersCount",
                                  style: CustomTextStyles
                                      .titleMediumRobotoBlueA200),
                            ],
                          ),
                          Column(
                            children: [
                              Text("Picked", style: theme.textTheme.bodyMedium),
                              Text("$trashCount",
                                  style: CustomTextStyles
                                      .titleMediumRobotoBlueA200),
                            ],
                          ),
                          Column(children: [
                            Text("Total Point",
                                style: theme.textTheme.bodyMedium),
                            Text("$point",
                                style:
                                    CustomTextStyles.titleMediumRobotoBlueA200)
                          ]),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.v),
                    Divider(indent: 49.h, endIndent: 50.h),
                    SizedBox(height: 25.v),
                    CustomImageView(
                        imagePath: ImageConstant.imgSaly18,
                        height: 147.v,
                        width: 157.h),
                    SizedBox(height: 40.v),
                  ],
                ),
                bottomNavigationBar: Container(
                  padding: EdgeInsets.symmetric(vertical: 15.v),
                  decoration: BoxDecoration(
                    color: Colors.white, // 바탕색 설정
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 0,
                        blurRadius: 10,
                        offset:
                            const Offset(0, -1), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CustomImageView(
                        imagePath: ImageConstant.imgGroup952,
                        height: 24.v,
                        width: 24.h,
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const MainScreen()),
                          );
                        },
                      ),
                      CustomImageView(
                        imagePath: ImageConstant.imgMapPin,
                        height: 27.adaptSize,
                        width: 27.adaptSize,
                        onTap: () {
                          Navigator.pushNamed(context, AppRoutes.mapScreen);
                        },
                      ),
                    ],
                  ),
                ),
                floatingActionButton: Padding(
                  padding: EdgeInsets.only(top: 8.h), // 상단 패딩 조정
                  child: FloatingActionButton(
                    backgroundColor: Colors.white,
                    elevation: 2,
                    onPressed: () {
                      // 로그아웃 메서드를 호출
                      Provider.of<AuthService>(context, listen: false)
                          .signOut();
                      // 로그인 페이지로 이동하고 뒤로 가기 스택을 비웁니다.
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => LogInScreen()),
                        ModalRoute.withName('/'),
                      );
                    },
                    child: const Icon(Icons.logout, color: Colors.black),
                  ),
                ),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.miniStartTop,
              );
            },
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        // If the connection to the Firestore is still ongoing, show a loader
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
