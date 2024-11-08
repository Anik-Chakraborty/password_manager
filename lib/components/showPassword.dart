import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:password_manager/components/TextInputWidget.dart';
import 'package:password_manager/components/Toast.dart';
import 'package:password_manager/configs/colors.dart';

showPassword(String password) async {
  return Get.dialog(
    AlertDialog(
      backgroundColor: AppColors.white,
      alignment: Alignment.center,
      surfaceTintColor: Colors.transparent,
      contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Show Password",
              style: GoogleFonts.montserrat(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondary)),
          const SizedBox(height: 10),
          InkWell(
            onTap: () async {
              await Clipboard.setData(ClipboardData(text: password));
              showToast("Copied", false);
            },
            child: TextInputWidget(
                controller: TextEditingController(text: password),
                hintText: "Password",
                readOnly: true,
                isObscureText: false,
                keyboardType: TextInputType.text),
          ),
          const SizedBox(height: 20),
        ],
      ),
    ),
    barrierDismissible: true,
  );
}
