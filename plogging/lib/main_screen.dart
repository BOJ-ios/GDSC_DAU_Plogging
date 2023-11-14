import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:plogging/core/app_export.dart';
import 'package:plogging/widgets/custom_outlined_button.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:plogging/auth_service.dart';
import 'package:provider/provider.dart';

//Todo: 뒤로가기 2번 누르면 앱 꺼지도록
class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Map<String, dynamic> userData = {};
  List<Map<String, dynamic>> schoolsData = [];

  @override
  void initState() {
    super.initState();
    fetchSchoolsData();
    fetchUserData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchSchoolsData();
    fetchUserData();
  }

  Future<QuerySnapshot> getSchools() {
    return FirebaseFirestore.instance
        .collection('schools')
        .orderBy('point', descending: true)
        .get();
  }

  void fetchSchoolsData() async {
    QuerySnapshot<Map<String, dynamic>> schoolsSnapshot =
        await FirebaseFirestore.instance
            .collection('schools')
            .orderBy('point', descending: true)
            .get();

    setState(() {
      schoolsData = schoolsSnapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  void fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        if (userDoc.exists) {
          setState(() {
            userData = userDoc.data() as Map<String, dynamic>;
          });
        }
      } catch (e) {
        print("Error fetching user data: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    int userPoint = userData['point'] ?? 0;

    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 55.v,
        backgroundColor: Colors.white,
        leading: null,
        actions: [
          CustomImageView(
              imagePath: ImageConstant.imgHeart,
              height: 24.adaptSize,
              width: 24.adaptSize,
              margin: EdgeInsets.symmetric(vertical: 2.v),
              onTap: () {
                movePage(context, AppRoutes.cameraScreen);
              }),
          const SizedBox(
            width: 35,
          ),
          CustomImageView(
              imagePath: ImageConstant.imgMapPin,
              height: 24.adaptSize,
              width: 24.adaptSize,
              margin: EdgeInsets.symmetric(vertical: 3.v),
              onTap: () {
                movePage(context, AppRoutes.mapScreen);
              }),
          const SizedBox(
            width: 35,
          ),
          CustomImageView(
              imagePath: ImageConstant.imgUser,
              height: 29.adaptSize,
              width: 29.adaptSize,
              onTap: () {
                movePage(context, AppRoutes.profileScreen);
              }),
          const SizedBox(
            width: 20,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(horizontal: 21.h, vertical: 5.v),
          child: Column(
            children: [
              SizedBox(height: 1.v),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 10.h),
                  child: Text(
                    "My Point : ${userPoint}P",
                    style: CustomTextStyles.pointTest,
                  ),
                ),
              ),
              SizedBox(height: 10.v),
              Container(
                  margin: EdgeInsets.only(left: 3.h),
                  padding:
                      EdgeInsets.symmetric(horizontal: 13.h, vertical: 19.v),
                  decoration: AppDecoration.fillIndigoA.copyWith(
                      borderRadius: BorderRadiusStyle.roundedBorder25),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Garbage Collection Point",
                            style: CustomTextStyles.titleMediumRoboto)),
                    SizedBox(height: 9.v),
                    CustomImageView(
                        imagePath: ImageConstant.imgFrame1566,
                        height: 32.v,
                        width: 286.h),
                    SizedBox(height: 5.v),
                    Padding(
                        padding: EdgeInsets.only(right: 3.h),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("0%", style: theme.textTheme.labelLarge),
                              const Spacer(),
                              Text("80%", style: theme.textTheme.labelLarge),
                              Padding(
                                  padding: EdgeInsets.only(left: 29.h),
                                  child: Text("100%",
                                      style: theme.textTheme.labelLarge))
                            ]))
                  ])),
              SizedBox(height: 16.v),
              SizedBox(
                  height: 374.v,
                  width: 317.h,
                  child: Stack(alignment: Alignment.topLeft, children: [
                    Align(
                        alignment: Alignment.center,
                        child: Container(
                            padding:
                                EdgeInsets.fromLTRB(13.h, 19.v, 13.h, 20.v),
                            decoration: AppDecoration.outlineGrayCc,
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  SizedBox(height: 9.v),
                                  FutureBuilder<QuerySnapshot>(
                                    future: getSchools(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const CircularProgressIndicator();
                                      }
                                      if (snapshot.hasData) {
                                        return Column(
                                          children: snapshot.data!.docs
                                              .asMap()
                                              .entries
                                              .map((e) {
                                            String schoolName = e.value.id;
                                            String englishName =
                                                e.value['englishName'];
                                            int point = e.value['point'];
                                            String rank =
                                                (e.key + 1).toString();
                                            String formattedPoint =
                                                "${NumberFormat("#,###").format(point)}P";
                                            return Column(
                                              children: [
                                                Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 13.h),
                                                    child: Text(englishName,
                                                        style: theme.textTheme
                                                            .bodySmall),
                                                  ),
                                                ),
                                                SizedBox(height: 2.v),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 5.h),
                                                  child: _buildText(
                                                    context,
                                                    one: "$rank위",
                                                    one1: schoolName,
                                                    pCounter: formattedPoint,
                                                    backgroundColor: rank == "1"
                                                        ? appTheme.yellow600
                                                        : const Color.fromARGB(
                                                            255, 219, 219, 219),
                                                  ),
                                                ),
                                                SizedBox(height: 10.v),
                                              ],
                                            );
                                          }).toList(),
                                        );
                                      }
                                      if (snapshot.hasError) {
                                        return Text('Error: ${snapshot.error}');
                                      }
                                      return const Text('No data');
                                    },
                                  ),
                                ]))),
                    CustomOutlinedButton(
                      text: "Ranking",
                      backgroundColor: const Color.fromARGB(255, 209, 209, 209),
                      leftIcon: Padding(
                        padding: EdgeInsets.only(right: 11.h),
                        child: CustomImageView(
                          imagePath: ImageConstant.imgTrophy,
                          height: 25.adaptSize,
                          width: 25.adaptSize,
                        ),
                      ),
                      width: 130.h,
                      margin: EdgeInsets.only(left: 10.h),
                    )
                  ])),
              SizedBox(height: 5.v)
            ],
          ),
        ),
      ),
    );
  }

  movePage(BuildContext context, String path) async {
    await Navigator.pushNamed(context, path);
    fetchSchoolsData();
    fetchUserData();
  }

  Widget _buildText(
    BuildContext context, {
    required String one,
    required String one1,
    required String pCounter,
    required Color backgroundColor,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18.h, vertical: 7.v),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadiusStyle.roundedBorder5,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 3.v),
            child: Text(one,
                style: theme.textTheme.titleSmall!
                    .copyWith(color: appTheme.black900)),
          ),
          Padding(
            padding: EdgeInsets.only(left: 9.h, top: 3.v),
            child: Text(one1,
                style: theme.textTheme.titleSmall!
                    .copyWith(color: appTheme.black900)),
          ),
          const Spacer(),
          Padding(
            padding: EdgeInsets.only(top: 3.v, right: 10.h),
            child: Text(pCounter,
                style: CustomTextStyles.titleSmallInter
                    .copyWith(color: appTheme.black900)),
          ),
        ],
      ),
    );
  }
}
