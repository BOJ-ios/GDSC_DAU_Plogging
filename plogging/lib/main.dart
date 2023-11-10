import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plogging/theme/theme_helper.dart';
import 'package:plogging/routes/app_routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:plogging/auth_service.dart';
import 'package:plogging/firebase_options.dart';
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
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  ///Please update theme as per your need if required.
  ThemeHelper().changeTheme('primary');
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
      theme: theme,
      title: 'plogging',
      debugShowCheckedModeBanner: false,
      initialRoute:
          user == null ? AppRoutes.getStartedScreen : AppRoutes.mainScreen,
      routes: AppRoutes.routes,
    );
  }
}
