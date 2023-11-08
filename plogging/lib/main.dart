import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:plogging/auth_service.dart';
import 'package:plogging/firebase_options.dart';
import 'package:plogging/homepage.dart';
import 'package:plogging/loginpage.dart';
import 'package:provider/provider.dart';
// Import the firebase_app_check plugin
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:logger/logger.dart';

var logger = Logger();

Future<void> printAppCheckToken() async {
  try {
    // Get the App Check token
    String? token = await FirebaseAppCheck.instance.getToken(true);
    // Print the token
    logger.d('App Check token: $token');
  } catch (e) {
    logger.e('Error getting App Check token: $e');
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAppCheck.instance.activate(
    webProvider:
        ReCaptchaV3Provider('6LcEuwcpAAAAAEfrXMnjRurEG2lzx4lxOZmk75um'),
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.appAttest,
  );
  await printAppCheckToken();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 로그인 여부 체크 후, LoginPage 또는 Homepage를 띄운다.
    User? user = context.read<AuthService>().currentUser();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: user == null ? const LoginPage() : const HomePage(),
    );
  }
}
