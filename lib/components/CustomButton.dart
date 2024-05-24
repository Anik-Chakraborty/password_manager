import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:password_manager/configs/colors.dart';

class Button extends StatelessWidget{

  final String buttonText;
  final Function onPress;
  final FocusNode? focusNode;
  Button({super.key, required this.buttonText, required this.onPress, this.focusNode});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: () => onPress(),
        focusNode: focusNode,
        style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.secondary,
            surfaceTintColor: Colors.transparent,
            alignment: Alignment.center,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              buttonText,
              style: GoogleFonts.montserrat(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ));
  }
}