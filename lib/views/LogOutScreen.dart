import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:password_manager/configs/colors.dart';
import 'package:password_manager/controllers/AuthController.dart';

class LogOutScreen extends StatelessWidget {
  LogOutScreen({super.key, required this.tabController});

  final TabController tabController;
  AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Logout",
            style: GoogleFonts.merriweather(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.white)),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        surfaceTintColor: Colors.transparent,
      ),
      backgroundColor: AppColors.primary,
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
              color: AppColors.white, borderRadius: BorderRadius.circular(10)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Are You Sure ?",
                  overflow: TextOverflow.ellipsis,
                  maxLines: null,
                  style: GoogleFonts.montserrat(
                      color: AppColors.primary,
                      fontSize: 24,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        authController.logout();
                      },
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 20),
                          backgroundColor: AppColors.green,
                          surfaceTintColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30))),
                      child: Text(
                        "Yes",
                        style: GoogleFonts.montserrat(
                          fontSize: 20,
                          color: AppColors.white,
                        ),
                      )),
                  const SizedBox(width: 30),
                  ElevatedButton(
                      onPressed: () {
                        tabController.animateTo(tabController.previousIndex);
                      },
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 20),
                          backgroundColor: AppColors.secondary,
                          surfaceTintColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30))),
                      child: Text(
                        "No",
                        style: GoogleFonts.montserrat(
                          fontSize: 20,
                          color: AppColors.white,
                        ),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
