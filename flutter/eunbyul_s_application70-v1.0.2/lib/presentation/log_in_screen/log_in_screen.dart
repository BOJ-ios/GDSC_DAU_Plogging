import 'package:eunbyul_s_application70/core/app_export.dart';
import 'package:eunbyul_s_application70/widgets/custom_elevated_button.dart';
import 'package:eunbyul_s_application70/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';

// ignore_for_file: must_be_immutable
class LogInScreen extends StatelessWidget {
  LogInScreen({Key? key}) : super(key: key);

  TextEditingController editTextController = TextEditingController();

  TextEditingController editTextController1 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: SizedBox(
                width: double.maxFinite,
                child: Column(children: [
                  SizedBox(
                      height: 445.v,
                      width: double.maxFinite,
                      child: Stack(alignment: Alignment.center, children: [
                        CustomImageView(
                            imagePath: ImageConstant.imgEllipse1445x360,
                            height: 445.v,
                            width: 360.h,
                            alignment: Alignment.center),
                        Align(
                            alignment: Alignment.center,
                            child: Padding(
                                padding:
                                    EdgeInsets.fromLTRB(12.h, 14.v, 18.h, 21.v),
                                child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomImageView(
                                          imagePath: ImageConstant.imgArrowLeft,
                                          height: 24.adaptSize,
                                          width: 24.adaptSize,
                                          onTap: () {
                                            onTapImgArrowLeft(context);
                                          }),
                                      Spacer(),
                                      Align(
                                          alignment: Alignment.centerRight,
                                          child: Padding(
                                              padding:
                                                  EdgeInsets.only(right: 64.h),
                                              child: Text("Sign in",
                                                  style: theme.textTheme
                                                      .displayMedium))),
                                      SizedBox(height: 44.v),
                                      Padding(
                                          padding: EdgeInsets.only(left: 56.h),
                                          child: Text(
                                              "Enter user name or email",
                                              style: CustomTextStyles
                                                  .titleSmallInterBlack900)),
                                      SizedBox(height: 1.v),
                                      Padding(
                                          padding: EdgeInsets.only(left: 24.h),
                                          child: CustomTextFormField(
                                              controller: editTextController,
                                              alignment:
                                                  Alignment.centerRight)),
                                      SizedBox(height: 7.v),
                                      Padding(
                                          padding: EdgeInsets.only(left: 56.h),
                                          child: Text("Password",
                                              style: CustomTextStyles
                                                  .titleSmallInterBlack900)),
                                      Padding(
                                          padding: EdgeInsets.only(left: 24.h),
                                          child: CustomTextFormField(
                                              controller: editTextController1,
                                              textInputAction:
                                                  TextInputAction.done,
                                              alignment: Alignment.centerRight,
                                              obscureText: true)),
                                      SizedBox(height: 29.v),
                                      Padding(
                                          padding: EdgeInsets.only(left: 24.h),
                                          child: Text("Recovery Password",
                                              style: CustomTextStyles
                                                  .titleSmallInterBluegray400))
                                    ])))
                      ])),
                  SizedBox(height: 39.v),
                  CustomElevatedButton(
                      width: 150.h,
                      text: "Sign in",
                      onPressed: () {
                        onTapSignIn(context);
                      }),
                  SizedBox(height: 28.v),
                  Divider(indent: 50.h, endIndent: 49.h),
                  SizedBox(height: 12.v),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Padding(
                        padding: EdgeInsets.only(bottom: 1.v),
                        child: Text("Not A Member?",
                            style:
                                CustomTextStyles.titleSmallInterBluegray400)),
                    GestureDetector(
                        onTap: () {
                          onTapTxtRegisterNow(context);
                        },
                        child: Padding(
                            padding: EdgeInsets.only(left: 12.h),
                            child: Text("Register Now",
                                style:
                                    CustomTextStyles.titleSmallInterRedA200)))
                  ]),
                  SizedBox(height: 5.v)
                ]))));
  }

  /// Navigates back to the previous screen.
  onTapImgArrowLeft(BuildContext context) {
    Navigator.pop(context);
  }

  /// Navigates to the mainScreen when the action is triggered.
  onTapSignIn(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.mainScreen);
  }

  /// Navigates to the registerScreen when the action is triggered.
  onTapTxtRegisterNow(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.registerScreen);
  }
}
