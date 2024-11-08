import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:password_manager/configs/colors.dart';

class TextInputWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isObscureText;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatter;
  final FocusNode? focusNode;
  final String? labelText;
  final bool? readOnly;
  final IconData? suffixIcon;

  const TextInputWidget(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.isObscureText,
      required this.keyboardType,
      this.inputFormatter,
      this.focusNode,
      this.suffixIcon,
      this.readOnly = false,
      this.labelText});

  @override
  Widget build(BuildContext context) {
    return ClayContainer(
      color: AppColors.offWhite,
      borderRadius: 5,
      child: TextFormField(
          controller: controller,
          obscureText: isObscureText,
          keyboardType: keyboardType,
          focusNode: focusNode,
          readOnly: readOnly ?? false,
          autofocus: false,
          inputFormatters: inputFormatter,
          style: GoogleFonts.montserrat(
            fontSize: 16,
            color: AppColors.blue,
          ),
          decoration: InputDecoration(
              hintText: hintText,
              prefixIconColor: AppColors.blue,
              prefixIcon: suffixIcon != null ? Icon(suffixIcon, color: AppColors.blue, size: 20) : null,
              hintStyle: GoogleFonts.montserrat(
                color: Colors.grey,
                fontSize: 16,
              ),
              label: labelText != null
                  ? Text(labelText ?? "",
                      style: GoogleFonts.montserrat(
                        color: AppColors.secondary,
                        fontSize: 16,
                      ))
                  : null,
              floatingLabelBehavior:
                  labelText != null ? FloatingLabelBehavior.always : null,
              border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.circular(5)),
              focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: AppColors.blue, width: 1),
                  borderRadius: BorderRadius.circular(5)),
              contentPadding:
                  const EdgeInsets.only(top: 5, bottom: 0, left: 10, right: 10))),
    );
  }
}
