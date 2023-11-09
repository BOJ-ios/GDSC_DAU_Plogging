import 'package:plogging/core/app_export.dart';
import 'package:plogging/widgets/custom_outlined_button.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

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
                                      SizedBox(
                                          height: 52.v,
                                          width: 285.h,
                                          child: Stack(
                                              alignment: Alignment.bottomCenter,
                                              children: [
                                                Align(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 12.h),
                                                        child: Text(
                                                            "Donga-A University",
                                                            style: theme
                                                                .textTheme
                                                                .bodySmall))),
                                                Align(
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    child: Card(
                                                        clipBehavior:
                                                            Clip.antiAlias,
                                                        elevation: 0,
                                                        margin:
                                                            EdgeInsets.all(0),
                                                        color:
                                                            appTheme.gray30001,
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadiusStyle
                                                                    .roundedBorder5),
                                                        child: Container(
                                                            height: 37.v,
                                                            width: 283.h,
                                                            decoration: AppDecoration
                                                                .fillGray
                                                                .copyWith(
                                                                    borderRadius:
                                                                        BorderRadiusStyle
                                                                            .roundedBorder5),
                                                            child: Stack(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                children: [
                                                                  Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .bottomLeft,
                                                                      child: Padding(
                                                                          padding: EdgeInsets.fromLTRB(18.h, 10.v, 28.h, 7.v),
                                                                          child: Row(children: [
                                                                            Text("1위",
                                                                                style: theme.textTheme.titleSmall),
                                                                            Padding(
                                                                                padding: EdgeInsets.only(left: 8.h),
                                                                                child: Text("동아대학교", style: theme.textTheme.titleSmall)),
                                                                            Spacer(),
                                                                            Text("55,000 P",
                                                                                style: theme.textTheme.titleSmall)
                                                                          ]))),
                                                                  _buildText(
                                                                      context,
                                                                      one: "1위",
                                                                      one1:
                                                                          "동아대학교",
                                                                      pCounter:
                                                                          "55,000 P")
                                                                ])))),
                                                Align(
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    child: Card(
                                                        clipBehavior:
                                                            Clip.antiAlias,
                                                        elevation: 0,
                                                        margin:
                                                            EdgeInsets.all(0),
                                                        color:
                                                            appTheme.yellow600,
                                                        shape: RoundedRectangleBorder(
                                                            side: BorderSide(
                                                                color: theme
                                                                    .colorScheme
                                                                    .primaryContainer,
                                                                width: 1.h),
                                                            borderRadius:
                                                                BorderRadiusStyle
                                                                    .roundedBorder5),
                                                        child: Container(
                                                            height: 37.v,
                                                            width: 283.h,
                                                            padding: EdgeInsets.symmetric(
                                                                horizontal:
                                                                    17.h,
                                                                vertical: 6.v),
                                                            decoration: AppDecoration
                                                                .outlinePrimaryContainer
                                                                .copyWith(
                                                                    borderRadius:
                                                                        BorderRadiusStyle
                                                                            .roundedBorder5),
                                                            child: Stack(
                                                                alignment: Alignment
                                                                    .bottomLeft,
                                                                children: [
                                                                  Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .bottomLeft,
                                                                      child: Container(
                                                                          height: 14
                                                                              .v,
                                                                          width: 236
                                                                              .h,
                                                                          margin:
                                                                              EdgeInsets.only(bottom: 1.v),
                                                                          decoration: BoxDecoration(color: appTheme.yellow600))),
                                                                  Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .bottomLeft,
                                                                      child: Padding(
                                                                          padding: EdgeInsets.only(bottom: 1.v),
                                                                          child: Row(children: [
                                                                            Text("1위",
                                                                                style: theme.textTheme.titleSmall),
                                                                            Padding(
                                                                                padding: EdgeInsets.only(left: 8.h),
                                                                                child: Text("동아대학교", style: theme.textTheme.titleSmall))
                                                                          ]))),
                                                                  Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .bottomRight,
                                                                      child: Padding(
                                                                          padding: EdgeInsets.only(
                                                                              right: 10
                                                                                  .h),
                                                                          child: Text(
                                                                              "550,000 P",
                                                                              style: CustomTextStyles.titleSmallInter)))
                                                                ]))))
                                              ])),
                                      SizedBox(height: 8.v),
                                      Align(
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                              padding:
                                                  EdgeInsets.only(left: 19.h),
                                              child: Text(
                                                  "Bukyong National University",
                                                  style: theme
                                                      .textTheme.bodySmall))),
                                      Padding(
                                          padding: EdgeInsets.only(left: 5.h),
                                          child: _buildText(context,
                                              one: "2위",
                                              one1: "부경대학교",
                                              pCounter: "500,000 P")),
                                      SizedBox(height: 12.v),
                                      Align(
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                              padding:
                                                  EdgeInsets.only(left: 18.h),
                                              child: Text(
                                                  "Busan National University",
                                                  style: theme
                                                      .textTheme.bodySmall))),
                                      Padding(
                                          padding: EdgeInsets.only(left: 5.h),
                                          child: _buildText(context,
                                              one: "3위",
                                              one1: "부산대학교",
                                              pCounter: "480,000 P")),
                                      SizedBox(height: 12.v),
                                      Align(
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                              padding:
                                                  EdgeInsets.only(left: 17.h),
                                              child: Text(
                                                  "Kyungsung University",
                                                  style: theme
                                                      .textTheme.bodySmall))),
                                      Padding(
                                          padding: EdgeInsets.only(left: 5.h),
                                          child: _buildText(context,
                                              one: "4위",
                                              one1: "경상대학교",
                                              pCounter: "450,000 P")),
                                      SizedBox(height: 13.v),
                                      Align(
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                              padding:
                                                  EdgeInsets.only(left: 20.h),
                                              child: Text(
                                                  "Korea Maritime and Ocean University",
                                                  style: theme
                                                      .textTheme.bodySmall))),
                                      Padding(
                                          padding: EdgeInsets.only(left: 5.h),
                                          child: _buildText(context,
                                              one: "4위",
                                              one1: "한국한양대학교",
                                              pCounter: "400,000 P"))
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
                Spacer(),
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
  }) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 18.h, vertical: 7.v),
        decoration: AppDecoration.fillGray
            .copyWith(borderRadius: BorderRadiusStyle.roundedBorder5),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                  padding: EdgeInsets.only(top: 3.v),
                  child: Text(one,
                      style: theme.textTheme.titleSmall!
                          .copyWith(color: appTheme.black900))),
              Padding(
                  padding: EdgeInsets.only(left: 9.h, top: 3.v),
                  child: Text(one1,
                      style: theme.textTheme.titleSmall!
                          .copyWith(color: appTheme.black900))),
              Spacer(),
              Padding(
                  padding: EdgeInsets.only(top: 3.v, right: 10.h),
                  child: Text(pCounter,
                      style: CustomTextStyles.titleSmallInter
                          .copyWith(color: appTheme.black900)))
            ]));
  }

  /// Navigates to the cameraScreen when the action is triggered.
  onTapImgHeart(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.cameraScreen);
  }

  /// Navigates to the mapScreen when the action is triggered.
  onTapImgMapPin(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.mapScreen);
  }

  /// Navigates to the profileScreen when the action is triggered.
  onTapImgUser(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.profileScreen);
  }
}
