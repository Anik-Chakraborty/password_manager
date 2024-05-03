import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:password_manager/configs/colors.dart';

class BottomNavBar extends StatelessWidget {
  final TabController controller;

  BottomNavBar({super.key, required this.controller});


  List<BottomNavigationBarItem> items = [
    BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Home"),
    BottomNavigationBarItem(icon: Icon(Icons.logout), label: "Logout"),
    BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.user), label: "Profile")
  ];

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: items,
      onTap: (value) {
        controller.animateTo(value);
      },
      backgroundColor: AppColors.white,
      selectedIconTheme: IconThemeData(color: AppColors.secondary),
      selectedLabelStyle:
          GoogleFonts.montserrat(color: AppColors.secondary, fontSize: 14),
      unselectedIconTheme: IconThemeData(color: AppColors.primary),
      unselectedLabelStyle:
          GoogleFonts.montserrat(color: AppColors.primary, fontSize: 14),
    );
  }
}
