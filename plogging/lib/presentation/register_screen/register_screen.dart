import 'package:plogging/core/app_export.dart';
import 'package:plogging/widgets/custom_elevated_button.dart';
import 'package:plogging/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plogging/auth_service.dart';
import 'package:plogging/homepage.dart';
import 'package:provider/provider.dart';

// ignore_for_file: must_be_immutable
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String? _selectedSchoolName;
  @override
  void initState() {
    super.initState();
    _selectedSchoolName = null;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(builder: (context, authService, child) {
      User? user = authService.currentUser();
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
                                  padding: EdgeInsets.fromLTRB(
                                      12.h, 14.v, 18.h, 9.v),
                                  child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CustomImageView(
                                            imagePath:
                                                ImageConstant.imgArrowLeft,
                                            height: 24.adaptSize,
                                            width: 24.adaptSize,
                                            onTap: () {
                                              Navigator.pop(context);
                                            }),
                                        const Spacer(),
                                        Align(
                                            alignment: Alignment.center,
                                            child: Text("Register",
                                                style: theme
                                                    .textTheme.displayMedium)),
                                        SizedBox(height: 45.v),
                                        Padding(
                                            padding:
                                                EdgeInsets.only(left: 56.h),
                                            child: Text("Full name",
                                                style: CustomTextStyles
                                                    .titleSmallInterBlack900)),
                                        _editTextName(context),
                                        SizedBox(height: 6.v),
                                        Padding(
                                            padding:
                                                EdgeInsets.only(left: 56.h),
                                            child: Text("Email",
                                                style: CustomTextStyles
                                                    .titleSmallInterBlack900)),
                                        SizedBox(height: 1.v),
                                        _editTextEmail(context),
                                        SizedBox(height: 7.v),
                                        Padding(
                                            padding:
                                                EdgeInsets.only(left: 56.h),
                                            child: Text("Password",
                                                style: CustomTextStyles
                                                    .titleSmallInterBlack900)),
                                        _editTextPassword(context),
                                        DropdownButton<String?>(
                                          value: _selectedSchoolName,
                                          items: [null, '동아대학교', '기타대학교']
                                              .map((String? i) {
                                            return DropdownMenuItem<String?>(
                                              value: i,
                                              child: Text(i == null
                                                  ? '미선택'
                                                  : i.toString()),
                                            );
                                          }).toList(),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              _selectedSchoolName = newValue;
                                            });
                                          },
                                        ),
                                      ])))
                        ])),
                    SizedBox(height: 77.v),
                    CustomElevatedButton(
                        width: 229.h,
                        text: "Create Account",
                        onPressed: () {
                          if (_selectedSchoolName == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("학교를 선택하세요")),
                            );
                          } else {
                            authService.signUp(
                              email: emailController.text,
                              password: passwordController.text,
                              schoolName: _selectedSchoolName!,
                              name: nameController.text,
                              onSuccess: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("회원가입 성공")));
                                Navigator.pushNamed(
                                    context, AppRoutes.getStartedOneScreen);
                              },
                              onError: (error) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(error)));
                              },
                            );
                          }
                        }),
                    SizedBox(height: 5.v)
                  ]))));
    });
  }

  /// Section Widget
  Widget _editTextName(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: 24.h),
        child: CustomTextFormField(
            controller: nameController, alignment: Alignment.centerRight));
  }

  /// Section Widget
  Widget _editTextEmail(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: 24.h),
        child: CustomTextFormField(
            controller: emailController, alignment: Alignment.centerRight));
  }

  /// Section Widget
  Widget _editTextPassword(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: 24.h),
        child: CustomTextFormField(
            controller: passwordController,
            textInputAction: TextInputAction.done,
            alignment: Alignment.centerRight,
            obscureText: true));
  }
}
