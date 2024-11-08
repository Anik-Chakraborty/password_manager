import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:password_manager/components/TextInputWidget.dart';
import 'package:password_manager/components/Toast.dart';
import 'package:password_manager/configs/colors.dart';
import 'package:password_manager/controllers/AuthController.dart';

Future<bool> check2FA() async{
  AuthController authController = Get.put(AuthController());
  TextEditingController codeCnt = TextEditingController();
  bool state = false;
  await Get.dialog(
    AlertDialog(
      backgroundColor: AppColors.white,
      alignment: Alignment.center,
      surfaceTintColor: Colors.transparent,
      contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextInputWidget(controller: codeCnt, hintText: "Enter 2FA", isObscureText: false, keyboardType: TextInputType.text),
          const SizedBox(height: 20),
          TextButton(
              onPressed: () async{
                if(codeCnt.text.isEmpty){
                  showToast("Enter 2FA", true);
                  return;
                }

                state = await authController.check2FA(codeCnt.text.trim());

                if(state){
                  showToast("Verified", true);
                }
                else{
                  showToast("Wrong 2FA", true);
                }

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
                "Submit",
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
