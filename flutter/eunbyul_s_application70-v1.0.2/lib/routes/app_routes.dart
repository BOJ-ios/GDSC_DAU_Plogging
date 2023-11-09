import 'package:flutter/material.dart';
import 'package:eunbyul_s_application70/presentation/get_started_screen/get_started_screen.dart';
import 'package:eunbyul_s_application70/presentation/log_in_screen/log_in_screen.dart';
import 'package:eunbyul_s_application70/presentation/register_screen/register_screen.dart';
import 'package:eunbyul_s_application70/presentation/get_started_one_screen/get_started_one_screen.dart';
import 'package:eunbyul_s_application70/presentation/main_screen/main_screen.dart';
import 'package:eunbyul_s_application70/presentation/map_screen/map_screen.dart';
import 'package:eunbyul_s_application70/presentation/camera_screen/camera_screen.dart';
import 'package:eunbyul_s_application70/presentation/profile_screen/profile_screen.dart';
import 'package:eunbyul_s_application70/presentation/app_navigation_screen/app_navigation_screen.dart';

class AppRoutes {
  static const String getStartedScreen = '/get_started_screen';

  static const String logInScreen = '/log_in_screen';

  static const String registerScreen = '/register_screen';

  static const String getStartedOneScreen = '/get_started_one_screen';

  static const String mainScreen = '/main_screen';

  static const String mapScreen = '/map_screen';

  static const String cameraScreen = '/camera_screen';

  static const String profileScreen = '/profile_screen';

  static const String appNavigationScreen = '/app_navigation_screen';

  static Map<String, WidgetBuilder> routes = {
    getStartedScreen: (context) => GetStartedScreen(),
    logInScreen: (context) => LogInScreen(),
    registerScreen: (context) => RegisterScreen(),
    getStartedOneScreen: (context) => GetStartedOneScreen(),
    mainScreen: (context) => MainScreen(),
    mapScreen: (context) => MapScreen(),
    cameraScreen: (context) => CameraScreen(),
    profileScreen: (context) => ProfileScreen(),
    appNavigationScreen: (context) => AppNavigationScreen()
  };
}
