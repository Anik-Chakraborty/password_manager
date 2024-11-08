import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:password_manager/components/Toast.dart';
import 'package:password_manager/configs/colors.dart';

Future<bool> showQr(Map data) async{
  bool state = false;
  await Get.dialog(
    AlertDialog(
      backgroundColor: AppColors.white,
      alignment: Alignment.center,
      surfaceTintColor: Colors.transparent,
      contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      content: (data["QR_Image"] ?? "").isEmpty
          ? Text("Something Went Wrong",
              style: GoogleFonts.montserrat(color: AppColors.primary))
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: GoogleFonts.montserrat(
                      color: AppColors.primary,
                      fontSize: 16,
                    ),
                    children: [
                      const TextSpan(
                        text: 'Scan This Or Use this Code ',
                      ),
                      TextSpan(
                        text: data["secret"] ?? "",
                        style: GoogleFonts.montserrat(
                            color: AppColors.secondary,
                            fontWeight: FontWeight.bold),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
                            await Clipboard.setData(
                                ClipboardData(text: data["secret"] ?? ""));
                            showToast("Copied", false);
                          },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                SvgPicture.string(data["QR_Image"],
                    alignment: Alignment.center,
                    fit: BoxFit.contain,
                    height: Get.width * 0.7,
                    width: Get.width * 0.7),
                const SizedBox(height: 20),
                TextButton(
                    onPressed: () {
                      state = true;
                      Get.back();
                    },
                    style: ButtonStyle(
                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                            side: const BorderSide(
                                color: AppColors.blue, width: 2),
                            borderRadius: BorderRadius.circular(50))),
                        backgroundColor:
                        const MaterialStatePropertyAll(Colors.transparent),
                        surfaceTintColor:
                        const MaterialStatePropertyAll(Colors.transparent),
                        shadowColor:
                        const MaterialStatePropertyAll(Colors.transparent),
                        padding: const MaterialStatePropertyAll(
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20))),
                    child: Text(
                      "Next",
                      style: GoogleFonts.montserrat(
                          fontSize: 20,
                          color: AppColors.blue,
                          fontWeight: FontWeight.bold),
                    ))
              ],
            ),
    ),
    barrierDismissible: true,
  );

  return state;
}
