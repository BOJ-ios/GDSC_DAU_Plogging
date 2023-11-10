import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plogging/core/app_export.dart';
import 'package:plogging/auth_service.dart';
import 'package:plogging/presentation/main_screen/main_screen.dart';
import 'package:plogging/widgets/custom_elevated_button.dart';
import 'package:plogging/widgets/custom_text_form_field.dart';
import 'package:provider/provider.dart';

// ignore_for_file: must_be_immutable
class LogInScreen extends StatelessWidget {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  LogInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Fetch MediaQuery data for responsive UI
    mediaQueryData = MediaQuery.of(context);
    // Access the AuthService from the provider
    return Consumer<AuthService>(
      builder: (context, authService, child) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: buildBody(context, authService),
        );
      },
    );
  }

  Widget buildBody(BuildContext context, AuthService authService) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        children: [
          buildTopSection(context),
          SizedBox(height: 22.v),
          buildSignInButton(context, authService),
          SizedBox(height: 30.v),
          buildDivider(context),
          SizedBox(height: 25.v),
          buildSignUpSection(context),
        ],
      ),
    );
  }

  Widget buildTopSection(BuildContext context) {
    return SizedBox(
      height: 445.v,
      width: double.maxFinite,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background ellipse image
          CustomImageView(
            imagePath: ImageConstant.imgEllipse1445x360,
            height: 445.v,
            width: 360.h,
            alignment: Alignment.center,
          ),
          // Sign in Text and form fields
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: 20.h), // Set horizontal padding to 20
            child: buildSignInForm(context),
          ),
        ],
      ),
    );
  }

  Widget buildSignInForm(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildBackButton(context),
          const Spacer(),
          buildSignInText(),
          SizedBox(height: 44.v),
          buildEmailField(),
          SizedBox(height: 7.v),
          buildEmailInput(),
          SizedBox(height: 15.v),
          buildPasswordField(),
          SizedBox(height: 7.v),
          buildPasswordInput(),
          SizedBox(height: 10.v),
          buildPasswordRecovery(context),
        ],
      ),
    );
  }

  Widget buildBackButton(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding:
            const EdgeInsets.only(top: 20), // Adjust the top padding as needed
        child: CustomImageView(
          imagePath: ImageConstant.imgArrowLeft,
          height: 24.adaptSize,
          width: 24.adaptSize,
          onTap: () => Navigator.pop(context),
        ),
      ),
    );
  }

  Widget buildSignInText() {
    return Align(
      alignment: Alignment.center,
      child: Text("Sign in", style: theme.textTheme.displayMedium),
    );
  }

  Widget buildEmailField() {
    return Text("Enter your email",
        style: CustomTextStyles.titleSmallInterBlack900);
  }

  Widget buildEmailInput() {
    return CustomTextFormField(
      controller: emailController,
      textInputAction: TextInputAction.done,
      textInputType: TextInputType.emailAddress,
      alignment: Alignment.centerRight,
    );
  }

  Widget buildPasswordField() {
    return Text("Enter your Password",
        style: CustomTextStyles.titleSmallInterBlack900);
  }

  Widget buildPasswordInput() {
    return CustomTextFormField(
      controller: passwordController,
      textInputAction: TextInputAction.done,
      alignment: Alignment.centerRight,
      obscureText: true,
    );
  }

  Widget buildPasswordRecovery(BuildContext context) {
    return GestureDetector(
      onTap: () => {},
      child: Text("Recovery Password",
          style: CustomTextStyles.titleSmallInterBluegray400),
    );
  }

  Widget buildSignInButton(BuildContext context, AuthService authService) {
    return CustomElevatedButton(
      width: 150.h,
      text: "Sign in",
      onPressed: () => signIn(context, authService),
    );
  }

  Widget buildDivider(BuildContext context) {
    return Divider(indent: 50.h, endIndent: 49.h);
  }

  Widget buildSignUpSection(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Not A Member?",
            style: CustomTextStyles.titleSmallInterBluegray400),
        GestureDetector(
          onTap: () => navigateToRegisterScreen(context),
          child: Padding(
            padding: EdgeInsets.only(left: 12.h),
            child: Text("Register Now",
                style: CustomTextStyles.titleSmallInterRedA200),
          ),
        ),
      ],
    );
  }

  void signIn(BuildContext context, AuthService authService) {
    authService.signIn(
      email: emailController.text,
      password: passwordController.text,
      onSuccess: () => onSignInSuccess(context),
      onError: (err) => onSignInError(context, err),
    );
  }

  void initiatePasswordRecovery(BuildContext context, AuthService authService) {
    // 3. 버튼 이벤트 처리: authService의 비밀번호 찾기 기능 호출
    if (emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("이메일을 입력해주세요.")),
      );
    } else {
      authService.resetPassword(
        email: emailController.text,
        onSuccess: () {
          // 4. 사용자 피드백 제공: 성공 알림
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("비밀번호 재설정 이메일을 보냈습니다.")),
          );
        },
        onError: (error) {
          // 4. 사용자 피드백 제공: 에러 알림
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error : $error")),
          );
        },
      );
    }
  }

  void navigateToRegisterScreen(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.registerScreen);
  }

  void onSignInSuccess(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("로그인 성공")),
    );
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const MainScreen()),
      ModalRoute.withName('/'),
    );
  }

  void onSignInError(BuildContext context, String err) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error : $err")),
    );
  }
}
