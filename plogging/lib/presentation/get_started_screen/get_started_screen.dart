import 'package:plogging/core/app_export.dart';
import 'package:plogging/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return Scaffold(
        body: SizedBox(
            width: double.maxFinite,
            child: Column(children: [
              SizedBox(
                  height: 598.v,
                  width: double.maxFinite,
                  child: Stack(alignment: Alignment.bottomRight, children: [
                    CustomImageView(
                        imagePath: ImageConstant.imgEllipse1,
                        height: 486.v,
                        width: 360.h,
                        alignment: Alignment.topCenter),
                    Align(
                        alignment: Alignment.bottomRight,
                        child: SizedBox(
                            height: 510.v,
                            width: 333.h,
                            child: Stack(
                                alignment: Alignment.bottomLeft,
                                children: [
                                  CustomImageView(
                                      imagePath: ImageConstant.imgSaly44,
                                      height: 510.v,
                                      width: 333.h,
                                      alignment: Alignment.center),
                                  CustomElevatedButton(
                                      width: 143.h,
                                      text: "Get started",
                                      margin: EdgeInsets.only(left: 82.h),
                                      onPressed: () {
                                        onTapGetStarted(context);
                                      },
                                      alignment: Alignment.bottomLeft)
                                ]))),
                    Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                            padding: EdgeInsets.only(left: 30.v, top: 103.v),
                            child: Text(
                                "Busan area,Plogging competition by university",
                                style: theme.textTheme.titleLarge))),
                    Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                            padding: EdgeInsets.only(left: 15.h, top: 43.v),
                            child: Text("Balance",
                                style:
                                    CustomTextStyles.displayMediumBlack90050)))
                  ])),
              SizedBox(height: 5.v),
              Text("Welcome  back", style: theme.textTheme.bodySmall),
              SizedBox(height: 5.v)
            ])));
  }

  /// Navigates to the logInScreen when the action is triggered.
  onTapGetStarted(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.logInScreen);
  }
}
