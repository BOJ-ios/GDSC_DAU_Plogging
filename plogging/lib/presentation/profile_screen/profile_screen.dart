import 'package:plogging/core/app_export.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plogging/camerapage.dart';
import 'package:plogging/loginpage.dart';
import 'package:plogging/presentation/log_in_screen/log_in_screen.dart';
import 'package:provider/provider.dart';
import 'package:plogging/mappage.dart';
import 'package:plogging/pedometer.dart';
import 'package:plogging/auth_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<AuthService>(context).currentUser(); // 현재 사용자 가져오기
    mediaQueryData = MediaQuery.of(context);
    return SafeArea(
        child: Scaffold(
            body: SizedBox(
                width: double.maxFinite,
                child: Column(children: [
                  IconButton(
                    icon: const Icon(Icons.logout),
                    onPressed: () {
                      // 로그아웃 메서드를 호출
                      Provider.of<AuthService>(context, listen: false)
                          .signOut();
                      // 로그인 페이지로 이동
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => LogInScreen()),
                      );
                    },
                  ),
                  _buildOne(context),
                  SizedBox(height: 40.v),
                  Padding(
                      padding: EdgeInsets.only(left: 80.h, right: 77.h),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(children: [
                              Text("Photo", style: theme.textTheme.bodyMedium),
                              Text("50",
                                  style: CustomTextStyles
                                      .titleMediumRobotoBlueA200)
                            ]),
                            CustomImageView(
                                imagePath: ImageConstant.imgQrcode,
                                height: 32.v,
                                width: 73.h,
                                margin: EdgeInsets.only(top: 2.v, bottom: 3.v))
                          ])),
                  SizedBox(height: 16.v),
                  Divider(indent: 49.h, endIndent: 50.h),
                  SizedBox(height: 23.v),
                  CustomImageView(
                      imagePath: ImageConstant.imgSaly18,
                      height: 147.v,
                      width: 157.h),
                  SizedBox(height: 5.v)
                ])),
            bottomNavigationBar: _buildSixteen(context)));
  }

  /// Section Widget
  Widget _buildOne(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 102.h, vertical: 24.v),
        decoration: AppDecoration.gradientIndigoAToIndigoA
            .copyWith(borderRadius: BorderRadiusStyle.customBorderBL50),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(height: 29.v),
              CustomImageView(
                  imagePath: ImageConstant.imgRectangle1565,
                  height: 141.adaptSize,
                  width: 141.adaptSize,
                  radius: BorderRadius.circular(70.h),
                  alignment: Alignment.center),
              SizedBox(height: 9.v),
              Text("KIM MINGYU", style: theme.textTheme.headlineSmall),
              Padding(
                  padding: EdgeInsets.only(left: 24.h),
                  child: Text("noreply@github.com",
                      style: theme.textTheme.labelMedium)),
              Padding(
                  padding: EdgeInsets.only(left: 28.h),
                  child: Text("Donga-A University",
                      style: theme.textTheme.labelMedium))
            ]));
  }

  /// Section Widget
  Widget _buildSixteen(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: 69.h, right: 69.h, bottom: 32.v),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          CustomImageView(
              imagePath: ImageConstant.imgHeart,
              height: 24.adaptSize,
              width: 24.adaptSize,
              onTap: () {
                onTapImgImage(context);
              }),
          CustomImageView(
              imagePath: ImageConstant.imgGroup952,
              height: 22.v,
              width: 14.h,
              onTap: () {
                onTapImgImage1(context);
              }),
          CustomImageView(
              imagePath: ImageConstant.imgMapPin,
              height: 24.adaptSize,
              width: 24.adaptSize,
              onTap: () {
                onTapImgMapPin(context);
              })
        ]));
  }

  /// Navigates to the cameraScreen when the action is triggered.
  onTapImgImage(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.cameraScreen);
  }

  /// Navigates to the mainScreen when the action is triggered.
  onTapImgImage1(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.mainScreen);
  }

  /// Navigates to the mapScreen when the action is triggered.
  onTapImgMapPin(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.mapScreen);
  }
}
