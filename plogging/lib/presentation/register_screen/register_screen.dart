import 'package:flutter/material.dart';
import 'package:plogging/core/app_export.dart';
import 'package:plogging/auth_service.dart';
import 'package:plogging/widgets/custom_elevated_button.dart';
import 'package:plogging/widgets/custom_text_form_field.dart';
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
      child: Column(children: [
        buildTopSection(context, authService),
        SizedBox(height: 50.v),
        createAccount(context, authService),
      ]),
    );
  }

  Widget buildTopSection(BuildContext context, AuthService authService) {
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
            child: buildResisterForm(context, authService),
          ),
        ],
      ),
    );
  }

  Widget buildResisterForm(BuildContext context, AuthService authService) {
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
          buildTextField("Full Name", CustomTextStyles.titleSmallInterBlack900),
          SizedBox(height: 7.v),
          buildNameInput(),
          SizedBox(height: 15.v),
          buildTextField("Email", CustomTextStyles.titleSmallInterBlack900),
          SizedBox(height: 7.v),
          buildEmailInput(),
          SizedBox(height: 15.v),
          buildTextField("Password", CustomTextStyles.titleSmallInterBlack900),
          SizedBox(height: 7.v),
          buildPasswordInput(),
          SizedBox(height: 15.v),
          buildTextField("School", CustomTextStyles.titleSmallInterBlack900),
          SizedBox(height: 7.v),
          selectSchoolButton(context),
          SizedBox(height: 7.v),
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
      child: Text("Resister", style: theme.textTheme.displayMedium),
    );
  }

  Widget buildTextField(String text, TextStyle? style) {
    return Text(text, style: style);
  }

  Widget buildNameInput() {
    return CustomTextFormField(
        controller: nameController, alignment: Alignment.centerRight);
  }

  Widget buildEmailInput() {
    return CustomTextFormField(
        controller: emailController, alignment: Alignment.centerRight);
  }

  Widget buildPasswordInput() {
    return CustomTextFormField(
        controller: passwordController,
        textInputAction: TextInputAction.done,
        alignment: Alignment.centerRight,
        obscureText: true);
  }

  Widget selectSchoolButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.h),
        border: Border.all(color: Colors.grey),
        color: Colors.white,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String?>(
          value: _selectedSchoolName,
          isExpanded: true,
          icon: const Icon(Icons.arrow_drop_down, color: Colors.blue),
          iconSize: 24,
          elevation: 16,
          style: const TextStyle(color: Colors.black, fontSize: 16),
          dropdownColor: Colors.white,
          items: [null, '동아대학교', '경상대학교', '부경대학교', '부산대학교', '한국해양대학교']
              .map((String? i) {
            return DropdownMenuItem<String?>(
              value: i,
              child: Text(i == null ? '미선택' : i.toString()),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedSchoolName = newValue;
            });
          },
        ),
      ),
    );
  }

  Widget createAccount(BuildContext context, AuthService authService) {
    return CustomElevatedButton(
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
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(content: Text("회원가입 성공")));
                Navigator.pushNamed(context, AppRoutes.getStartedOneScreen);
              },
              onError: (error) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(error)));
              },
            );
          }
        });
  }
}
