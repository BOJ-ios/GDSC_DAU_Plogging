import 'package:eunbyul_s_application70/core/app_export.dart';
import 'package:eunbyul_s_application70/widgets/custom_elevated_button.dart';
import 'package:eunbyul_s_application70/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';

// ignore_for_file: must_be_immutable
class RegisterScreen extends StatelessWidget {
  RegisterScreen({Key? key}) : super(key: key);

  TextEditingController editTextController = TextEditingController();

  TextEditingController editTextController1 = TextEditingController();

  TextEditingController editTextController2 = TextEditingController();

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
                            imagePath: ImageConstant.imgEllipse11,
                            height: 445.v,
                            width: 360.h,
                            alignment: Alignment.center),
                        Align(
                            alignment: Alignment.center,
                            child: Padding(
                                padding:
                                    EdgeInsets.fromLTRB(12.h, 14.v, 18.h, 9.v),
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
                                          alignment: Alignment.center,
                                          child: Text("Register",
                                              style: theme
                                                  .textTheme.displayMedium)),
                                      SizedBox(height: 45.v),
                                      Padding(
                                          padding: EdgeInsets.only(left: 56.h),
                                          child: Text("Full name",
                                              style: CustomTextStyles
                                                  .titleSmallInterBlack900)),
                                      _buildEditText(context),
                                      SizedBox(height: 6.v),
                                      Padding(
                                          padding: EdgeInsets.only(left: 56.h),
                                          child: Text("Email",
                                              style: CustomTextStyles
                                                  .titleSmallInterBlack900)),
                                      SizedBox(height: 1.v),
                                      _buildEditText1(context),
                                      SizedBox(height: 7.v),
                                      Padding(
                                          padding: EdgeInsets.only(left: 56.h),
                                          child: Text("Password",
                                              style: CustomTextStyles
                                                  .titleSmallInterBlack900)),
                                      _buildEditText2(context)
                                    ])))
                      ])),
                  SizedBox(height: 77.v),
                  _buildCreateAccount(context),
                  SizedBox(height: 5.v)
                ]))));
  }

  /// Section Widget
  Widget _buildEditText(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: 24.h),
        child: CustomTextFormField(
            controller: editTextController, alignment: Alignment.centerRight));
  }

  /// Section Widget
  Widget _buildEditText1(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: 24.h),
        child: CustomTextFormField(
            controller: editTextController1, alignment: Alignment.centerRight));
  }

  /// Section Widget
  Widget _buildEditText2(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: 24.h),
        child: CustomTextFormField(
            controller: editTextController2,
            textInputAction: TextInputAction.done,
            alignment: Alignment.centerRight,
            obscureText: true));
  }

  /// Section Widget
  Widget _buildCreateAccount(BuildContext context) {
    return CustomElevatedButton(
        width: 229.h,
        text: "Create Account",
        onPressed: () {
          onTapCreateAccount(context);
        });
  }

  /// Navigates back to the previous screen.
  onTapImgArrowLeft(BuildContext context) {
    Navigator.pop(context);
  }

  /// Navigates to the getStartedOneScreen when the action is triggered.
  onTapCreateAccount(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.getStartedOneScreen);
  }
}
