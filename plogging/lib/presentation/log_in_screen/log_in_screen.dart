import 'package:firebase_auth/firebase_auth.dart';
import 'package:plogging/presentation/main_screen/main_screen.dart';
import 'package:plogging/widgets/custom_text_form_field.dart';
import 'package:plogging/widgets/custom_elevated_button.dart';
import 'package:plogging/core/app_export.dart';
import 'package:plogging/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

// ignore_for_file: must_be_immutable
class LogInScreen extends StatelessWidget {
  LogInScreen({Key? key}) : super(key: key);

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(builder: (context, authService, child) {
      mediaQueryData = MediaQuery.of(context);
      User? user = authService.currentUser();
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
                                  padding: EdgeInsets.fromLTRB(
                                      12.h, 14.v, 18.h, 21.v),
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
                                            alignment: Alignment.centerRight,
                                            child: Padding(
                                                padding: EdgeInsets.only(
                                                    right: 64.h),
                                                child: Text("Sign in",
                                                    style: theme.textTheme
                                                        .displayMedium))),
                                        SizedBox(height: 44.v),
                                        Padding(
                                            padding:
                                                EdgeInsets.only(left: 30.h),
                                            child: Text("Enter your email",
                                                style: CustomTextStyles
                                                    .titleSmallInterBlack900)),
                                        SizedBox(height: 1.v),
                                        Padding(
                                            padding:
                                                EdgeInsets.only(left: 24.h),
                                            child: CustomTextFormField(
                                                textInputType:
                                                    TextInputType.emailAddress,
                                                controller: emailController,
                                                alignment:
                                                    Alignment.centerRight)),
                                        SizedBox(height: 7.v),
                                        Padding(
                                            padding:
                                                EdgeInsets.only(left: 30.h),
                                            child: Text("Password",
                                                style: CustomTextStyles
                                                    .titleSmallInterBlack900)),
                                        Padding(
                                            padding:
                                                EdgeInsets.only(left: 24.h),
                                            child: CustomTextFormField(
                                                controller: passwordController,
                                                textInputAction:
                                                    TextInputAction.done,
                                                alignment:
                                                    Alignment.centerRight,
                                                obscureText: true)),
                                        SizedBox(height: 29.v),
                                        Padding(
                                            padding:
                                                EdgeInsets.only(left: 24.h),
                                            child: GestureDetector(
                                                onTap: () {
                                                  // 3. 버튼 이벤트 처리: authService의 비밀번호 찾기 기능 호출
                                                  if (emailController
                                                      .text.isEmpty) {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                          content: Text(
                                                              "이메일을 입력해주세요.")),
                                                    );
                                                  } else {
                                                    authService.resetPassword(
                                                      email:
                                                          emailController.text,
                                                      onSuccess: () {
                                                        // 4. 사용자 피드백 제공: 성공 알림
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          const SnackBar(
                                                              content: Text(
                                                                  "비밀번호 재설정 이메일을 보냈습니다.")),
                                                        );
                                                      },
                                                      onError: (error) {
                                                        // 4. 사용자 피드백 제공: 에러 알림
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          SnackBar(
                                                              content: Text(
                                                                  "Error : $error")),
                                                        );
                                                      },
                                                    );
                                                  }
                                                },
                                                child: Text("Recovery Password",
                                                    style: CustomTextStyles
                                                        .titleSmallInterBluegray400)))
                                      ])))
                        ])),
                    SizedBox(height: 39.v),
                    CustomElevatedButton(
                        width: 150.h,
                        text: "Sign in",
                        onPressed: () {
                          // 로그인 시도
                          authService.signIn(
                              email: emailController.text,
                              password: passwordController.text,
                              onSuccess: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("로그인 성공")),
                                );
                                // 로그인 성공 시 MainScreen으로 이동

                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const MainScreen()),
                                );
                              },
                              onError: (err) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Error : $err")),
                                );
                              });
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
                            Navigator.pushNamed(
                                context, AppRoutes.registerScreen);
                          },
                          child: Padding(
                              padding: EdgeInsets.only(left: 12.h),
                              child: Text("Register Now",
                                  style:
                                      CustomTextStyles.titleSmallInterRedA200)))
                    ]),
                    SizedBox(height: 5.v)
                  ]))));
    });
  }
}
