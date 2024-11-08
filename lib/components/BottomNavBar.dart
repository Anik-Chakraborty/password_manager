import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:motion_tab_bar/MotionTabBar.dart';
import 'package:motion_tab_bar/MotionTabBarController.dart';
import 'package:password_manager/configs/colors.dart';

class BottomNavBar extends StatefulWidget {
  final MotionTabBarController? controller;

  const BottomNavBar({super.key, required this.controller});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return MotionTabBar(
      controller: widget.controller,
      // ADD THIS if you need to change your tab programmatically
      initialSelectedTab: "Home",
      labels: const ["Home", "Passwords", "Setting"],
      icons: const [
        BootstrapIcons.house_fill,
        BootstrapIcons.shield_fill,
        BootstrapIcons.gear_wide_connected
      ],
      tabSize: 50,
      tabBarHeight: 55,
      textStyle: GoogleFonts.montserrat(
        fontSize: 12,
        color: AppColors.blue,
      ),
      tabIconColor: AppColors.blue,
      tabIconSize: 28.0,
      tabIconSelectedSize: 26.0,
      tabSelectedColor: AppColors.blue,
      tabIconSelectedColor: AppColors.white,
      tabBarColor: Colors.white,
      onTabItemSelected: (int value) {
        setState(() {
          widget.controller!.index = value;
        });
      },
    );
  }
}
