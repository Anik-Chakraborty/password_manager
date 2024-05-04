import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:password_manager/configs/colors.dart';

class BottomNavBar extends StatefulWidget {
  final TabController controller;

  const BottomNavBar({super.key, required this.controller});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  List<BottomNavigationBarItem> items = [
    const BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.user), label: "Profile"),
    const BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.key), label: "Home"),
    const BottomNavigationBarItem(icon: Icon(Icons.logout), label: "Logout")
  ];

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: widget.controller.index,
      items: items,
      onTap: (value) {
        setState(() {
          widget.controller.animateTo(value);
        });
      },
      backgroundColor: AppColors.white,
      selectedItemColor: AppColors.secondary,
      unselectedItemColor: AppColors.primary,
      selectedLabelStyle: GoogleFonts.montserrat(fontSize: 14),
      unselectedLabelStyle: GoogleFonts.montserrat(fontSize: 14),
    );
  }
}
