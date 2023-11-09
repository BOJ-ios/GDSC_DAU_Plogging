import 'package:eunbyul_s_application70/core/app_export.dart';
import 'package:flutter/material.dart';

class CameraScreen extends StatelessWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return SafeArea(
        child: Scaffold(
            body: SizedBox(
                width: double.maxFinite,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 13.v),
                      Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                              padding:
                                  EdgeInsets.only(left: 211.h, right: 15.h),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    CustomImageView(
                                        imagePath: ImageConstant.imgMapPin,
                                        height: 24.adaptSize,
                                        width: 24.adaptSize,
                                        margin: EdgeInsets.only(bottom: 3.v),
                                        onTap: () {
                                          onTapImgMapPin(context);
                                        }),
                                    Spacer(flex: 50),
                                    CustomImageView(
                                        imagePath: ImageConstant.imgGroup952,
                                        height: 22.v,
                                        width: 14.h,
                                        margin:
                                            EdgeInsets.symmetric(vertical: 3.v),
                                        onTap: () {
                                          onTapImgImage(context);
                                        }),
                                    Spacer(flex: 50),
                                    CustomImageView(
                                        imagePath: ImageConstant.imgUser,
                                        height: 29.adaptSize,
                                        width: 29.adaptSize,
                                        onTap: () {
                                          onTapImgUser(context);
                                        })
                                  ]))),
                      SizedBox(height: 9.v),
                      Padding(
                          padding: EdgeInsets.only(left: 33.h),
                          child: Text("Move us, Move Earth with Busan",
                              style: CustomTextStyles
                                  .titleMediumOnErrorContainer)),
                      SizedBox(height: 22.v),
                      Container(
                          height: 545.v,
                          width: double.maxFinite,
                          decoration: BoxDecoration(color: appTheme.gray200))
                    ]))));
  }

  /// Navigates to the mapScreen when the action is triggered.
  onTapImgMapPin(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.mapScreen);
  }

  /// Navigates to the mainScreen when the action is triggered.
  onTapImgImage(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.mainScreen);
  }

  /// Navigates to the profileScreen when the action is triggered.
  onTapImgUser(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.profileScreen);
  }
}
