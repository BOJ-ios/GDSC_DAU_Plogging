import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:plogging/core/app_export.dart';
import 'package:plogging/widgets/custom_outlined_button.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    fetchDataFromFirebase();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // This will ensure data is refreshed every time the widget is returned to from a different screen.
    fetchDataFromFirebase();
  }

  void fetchDataFromFirebase() async {
    // Fetch your data from Firebase and then update the state
    var schoolsSnapshot = await getSchools();
    if (mounted) {
      setState(() {
        // Update your state with the new data
      });
    }
  }

  Future<QuerySnapshot> getSchools() {
    return FirebaseFirestore.instance
        .collection('schools')
        .orderBy('point', descending: true)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return SafeArea(
        child: Scaffold(
            body: Container(
                width: double.maxFinite,
                padding: EdgeInsets.symmetric(horizontal: 21.h, vertical: 22.v),
                child: Column(children: [
                  Align(
                      alignment: Alignment.centerRight,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            CustomImageView(
                                imagePath: ImageConstant.imgHeart,
                                height: 24.adaptSize,
                                width: 24.adaptSize,
                                margin: EdgeInsets.symmetric(vertical: 2.v),
                                onTap: () {
                                  onTapImgHeart(context);
                                }),
                            CustomImageView(
                                imagePath: ImageConstant.imgMapPin,
                                height: 24.adaptSize,
                                width: 24.adaptSize,
                                margin: EdgeInsets.only(
                                    left: 28.h, top: 2.v, bottom: 2.v),
                                onTap: () {
                                  onTapImgMapPin(context);
                                }),
                            CustomImageView(
                                imagePath: ImageConstant.imgUser,
                                height: 29.adaptSize,
                                width: 29.adaptSize,
                                margin: EdgeInsets.only(left: 28.h),
                                onTap: () {
                                  onTapImgUser(context);
                                })
                          ])),
                  SizedBox(height: 1.v),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                          padding: EdgeInsets.only(left: 12.h),
                          child: Text("My Point : 1000 P",
                              style: CustomTextStyles
                                  .titleMediumOnErrorContainer))),
                  SizedBox(height: 17.v),
                  _buildFive(context),
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
                                            AsyncSnapshot<QuerySnapshot>
                                                snapshot) {
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
                                                String schoolName = e.value
                                                    .id; // 'doc.id'는 문서의 이름(id)입니다.
                                                String englishName =
                                                    e.value['englishName'];
                                                int point = e.value[
                                                    'point']; // 'point' 필드의 데이터를 가져옵니다.
                                                String rank = (e.key + 1)
                                                    .toString(); // index를 활용하여 등수를 매깁니다.
                                                String formattedPoint =
                                                    "${NumberFormat("#,###").format(point)}P";

                                                return Column(
                                                  children: [
                                                    Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 19.h),
                                                        child: Text(
                                                          englishName,
                                                          style: theme.textTheme
                                                              .bodySmall,
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 5.h),
                                                      child: _buildText(
                                                        context,
                                                        one:
                                                            "$rank위", // 등수는 실제 데이터에 따라 동적으로 설정해야 합니다.
                                                        one1: schoolName,
                                                        pCounter:
                                                            formattedPoint, // 포인트는 실제 데이터에 따라 동적으로 설정해야 합니다.
                                                        backgroundColor: rank ==
                                                                "1"
                                                            ? appTheme.yellow600
                                                            : const Color
                                                                .fromARGB(255,
                                                                219, 219, 219),
                                                      ),
                                                    ),
                                                    SizedBox(height: 12.v),
                                                  ],
                                                );
                                              }).toList(),
                                            );
                                          }

                                          if (snapshot.hasError) {
                                            return Text(
                                                'Error: ${snapshot.error}');
                                          }

                                          return const Text('No data');
                                        },
                                      ),
                                    ]))),
                        CustomOutlinedButton(
                            width: 130.h,
                            text: "Ranking",
                            margin: EdgeInsets.only(left: 3.h),
                            leftIcon: Container(
                                margin: EdgeInsets.only(right: 11.h),
                                child: CustomImageView(
                                    imagePath: ImageConstant.imgTrophy,
                                    height: 25.adaptSize,
                                    width: 25.adaptSize)),
                            alignment: Alignment.topLeft)
                      ])),
                  SizedBox(height: 5.v)
                ]))));
  }

  /// Section Widget
  Widget _buildFive(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: 3.h),
        padding: EdgeInsets.symmetric(horizontal: 13.h, vertical: 19.v),
        decoration: AppDecoration.fillIndigoA
            .copyWith(borderRadius: BorderRadiusStyle.roundedBorder25),
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
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text("0%", style: theme.textTheme.labelLarge),
                const Spacer(),
                Text("80%", style: theme.textTheme.labelLarge),
                Padding(
                    padding: EdgeInsets.only(left: 29.h),
                    child: Text("100%", style: theme.textTheme.labelLarge))
              ]))
        ]));
  }

  /// Common widget
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
        color: backgroundColor, // 배경색을 설정합니다.
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

  /// Navigates to the cameraScreen when the action is triggered.
  onTapImgHeart(BuildContext context) async {
    await Navigator.pushNamed(context, AppRoutes.cameraScreen);
    fetchDataFromFirebase();
  }

  /// Navigates to the mapScreen when the action is triggered.
  onTapImgMapPin(BuildContext context) async {
    await Navigator.pushNamed(context, AppRoutes.mapScreen);
    fetchDataFromFirebase();
  }

  /// Navigates to the profileScreen when the action is triggered.
  onTapImgUser(BuildContext context) async {
    // Navigate to the ProfileScreen and wait for it to return
    await Navigator.pushNamed(context, AppRoutes.profileScreen);
    // After returning from the ProfileScreen, fetch the data again
    fetchDataFromFirebase();
  }
}
