import 'package:flutter/material.dart';
import 'package:plogging/camera_page.dart';
import 'package:plogging/get_started_screen.dart';
import 'package:plogging/log_in_screen.dart';
import 'package:plogging/register_screen.dart';
import 'package:plogging/get_started_one_screen.dart';
import 'package:plogging/main_screen.dart';
import 'package:plogging/map_screen.dart';
import 'package:plogging/profile_screen.dart';
import 'package:plogging/app_navigation_screen.dart';

class AppRoutes {
  static const String getStartedScreen = '/get_started_screen';

  static const String logInScreen = '/log_in_screen';

  static const String registerScreen = '/register_screen';

  static const String getStartedOneScreen = '/get_started_one_screen';

  static const String mainScreen = '/main_screen';

  static const String mapScreen = '/map_screen';

  static const String cameraScreen = '/camera_page';
  static const String profileScreen = '/profile_screen';

  static const String appNavigationScreen = '/app_navigation_screen';

  static Map<String, WidgetBuilder> routes = {
    getStartedScreen: (context) => const GetStartedScreen(),
    logInScreen: (context) => LogInScreen(),
    registerScreen: (context) => const RegisterScreen(),
    getStartedOneScreen: (context) => const GetStartedOneScreen(),
    mainScreen: (context) => const MainScreen(),
    mapScreen: (context) => const MapScreen(),
    cameraScreen: (context) => const CameraExample(),
    profileScreen: (context) => const ProfileScreen(),
    appNavigationScreen: (context) => const AppNavigationScreen()
  };
}
