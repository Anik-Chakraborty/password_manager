import 'package:get/get.dart';
import 'package:password_manager/views/CategoryWisePassword.dart';
import 'package:password_manager/views/CreatePassword.dart';
import 'package:password_manager/views/EditPassword.dart';
import 'package:password_manager/views/GroupWisePassword.dart';
import 'package:password_manager/views/LoginScreen.dart';
import 'package:password_manager/views/NavigationScreen.dart';
import 'package:password_manager/views/PasswordDetailScreen.dart';
import 'package:password_manager/views/SearchPage.dart';
import 'package:password_manager/views/SplashScreen.dart';
import 'package:password_manager/views/UserProfileScreen.dart';

class AppRoutes {
  static const String splash = "/splash";
  static const String logIn = "/logIn";
  static const String nav = "/nav";
  static const String profile = "/profile";
  static const String createPass = "/createPass";
  static const String passDetail = "/passDetail";
  static const String search = "/search";
  static const String uptPass = "/uptPass";
  static const String categories = "/categories";
  static const String groups = "/groups";




}

final getRoutes = [
  GetPage(name: AppRoutes.splash, page: () => SplashScreen()),
  GetPage(name: AppRoutes.logIn, page: () => const LoginScreen()),
  GetPage(name: AppRoutes.nav, page: () => NavigationScreen()),
  GetPage(name: AppRoutes.profile, page: () => const UserProfileScreen()),
  GetPage(name: AppRoutes.createPass, page: () => const CreatePassword()),
  GetPage(name: AppRoutes.passDetail, page: () => const PasswordDetailScreen()),
  GetPage(name: AppRoutes.search, page: () => const SearchPage()),
  GetPage(name: AppRoutes.uptPass, page: () => const EditPasswordScreen()),
  GetPage(name: AppRoutes.categories, page: () => const CategoryWisePassword()),
  GetPage(name: AppRoutes.groups, page: () => const GroupWisePassword())
];
