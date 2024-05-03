import 'package:get/get.dart';
import 'package:password_manager/views/CreatePassword.dart';
import 'package:password_manager/views/HomeScreen.dart';
import 'package:password_manager/views/LoginScreen.dart';
import 'package:password_manager/views/PasswordDetailScreen.dart';
import 'package:password_manager/views/SplashScreen.dart';
import 'package:password_manager/views/UserProfileScreen.dart';

class AppRoutes {
  static const String splash = "/splash";
  static const String logIn = "/logIn";
  static const String home = "/home";
  static const String profile = "/profile";
  static const String createPass = "/createPass";
  static const String passDetail = "/passDetail";

}

final getRoutes = [
  GetPage(name: AppRoutes.splash, page: () => SplashScreen()),
  GetPage(name: AppRoutes.logIn, page: () => const LoginScreen()),
  GetPage(name: AppRoutes.home, page: () => const HomeScreen()),
  GetPage(name: AppRoutes.profile, page: () => const UserProfileScreen()),
  GetPage(name: AppRoutes.createPass, page: () => const CreatePassword()),
  GetPage(name: AppRoutes.passDetail, page: () => const PasswordDetailScreen())
];
