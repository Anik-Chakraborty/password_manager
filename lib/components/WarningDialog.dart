import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:password_manager/configs/colors.dart';

Future<bool> showWarningDialog() async {
  bool allow = false;

  await Get.dialog(
    AlertDialog(
      backgroundColor: AppColors.white,
      surfaceTintColor: Colors.transparent,
      contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Are You Sure ?",
              overflow: TextOverflow.ellipsis,
              maxLines: null,
              style: GoogleFonts.montserrat(
                  color: AppColors.primary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                  onPressed: () {
                    Get.back();
                    allow = true;
                  },
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 20),
                      backgroundColor: AppColors.blue,
                      surfaceTintColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30))),
                  child: Text(
                    "Yes",
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      color: AppColors.white,
                    ),
                  )),
              const SizedBox(width: 30),
              ElevatedButton(
                  onPressed: () {
                    Get.back();
                    allow = false;
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
                      fontSize: 16,
                      color: AppColors.white,
                    ),
                  ))
            ],
          )
        ],
      ),
    ),
    barrierDismissible: false,
  );

  return allow;
}
