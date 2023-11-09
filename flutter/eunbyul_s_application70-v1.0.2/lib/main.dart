import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/scheduler.dart';
import 'package:eunbyul_s_application70/theme/theme_helper.dart';
import 'package:eunbyul_s_application70/routes/app_routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  ///Please update theme as per your need if required.
  ThemeHelper().changeTheme('primary');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      title: 'eunbyul_s_application70',
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.getStartedScreen,
      routes: AppRoutes.routes,
    );
  }
}
