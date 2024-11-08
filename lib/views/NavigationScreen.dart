import 'package:flutter/material.dart';
import 'package:motion_tab_bar/MotionTabBarController.dart';
import 'package:password_manager/components/BottomNavBar.dart';
import 'package:password_manager/views/AllPasswordScreen.dart';
import 'package:password_manager/views/HomeScreen.dart';
import 'package:password_manager/views/SettingScreen.dart';
import 'package:password_manager/views/UserProfileScreen.dart';

class NavigationScreen extends StatefulWidget{
  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> with TickerProviderStateMixin{

  MotionTabBarController? motionTabBarController;

  @override
  void initState() {
    motionTabBarController = MotionTabBarController(
      initialIndex: 0,
      length: 3,
      vsync: this,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavBar(controller: motionTabBarController),
        body: TabBarView(
          controller: motionTabBarController,
          children: [
            // const UserProfileScreen(),
            const HomeScreen(),
            const AllPasswordScreen(),
            SettingScreen(tabController: motionTabBarController)
          ],
        ),
    );
  }
}