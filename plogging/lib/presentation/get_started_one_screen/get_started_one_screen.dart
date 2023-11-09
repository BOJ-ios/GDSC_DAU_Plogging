import 'package:plogging/core/app_export.dart';
import 'package:plogging/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';

class GetStartedOneScreen extends StatelessWidget {
  const GetStartedOneScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return SafeArea(
        child: Scaffold(
            body: SizedBox(
                height: 549.v,
                width: double.maxFinite,
                child: Stack(alignment: Alignment.bottomCenter, children: [
                  Align(
                      alignment: Alignment.topCenter,
                      child: SizedBox(
                          height: 486.v,
                          width: double.maxFinite,
                          child:
                              Stack(alignment: Alignment.topCenter, children: [
                            CustomImageView(
                                imagePath: ImageConstant.imgEllipse1486x360,
                                height: 486.v,
                                width: 360.h,
                                alignment: Alignment.center),
                            _buildTwentyFour(context)
                          ]))),
                  CustomImageView(
                      imagePath: ImageConstant.imgSaly32,
                      height: 477.v,
                      width: 360.h,
                      alignment: Alignment.bottomCenter)
                ])),
            bottomNavigationBar: _buildSignIn(context)));
  }

  /// Section Widget
  Widget _buildTwentyFour(BuildContext context) {
    return Align(
        alignment: Alignment.topCenter,
        child: Padding(
            padding: EdgeInsets.only(left: 17.h, top: 58.v, right: 20.h),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Congratulations",
                      style: CustomTextStyles.displayMediumBlack900),
                  SizedBox(height: 15.v),
                  SizedBox(
                      width: 240.h,
                      child: Text(
                          "Your subscription has been successfully completed !",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: CustomTextStyles.titleMediumBlack900)),
                  SizedBox(height: 13.v),
                  Text("인증 이메일이 전송되었습니다.",
                      style: CustomTextStyles.titleMediumBlack900)
                ])));
  }

  /// Section Widget
  Widget _buildSignIn(BuildContext context) {
    return CustomElevatedButton(
        width: 143.h,
        text: "Sign in",
        margin: EdgeInsets.only(left: 108.h, right: 109.h, bottom: 45.v),
        onPressed: () {
          onTapSignIn(context);
        });
  }

  /// Navigates to the logInScreen when the action is triggered.
  onTapSignIn(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.logInScreen);
  }
}
