import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:password_manager/configs/colors.dart';

class NoDataWidget extends StatelessWidget {
  final onTap;

  const NoDataWidget({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("No Data Found",
              style: GoogleFonts.montserrat(
                  color: AppColors.blue,
                  fontSize: 18)),
          const SizedBox(height: 5),
          TextButton(
              onPressed: onTap,
              child: Text("Refresh",
                  style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.bold,
                      color: AppColors.blue,
                      fontSize: 18)))
        ],
      ),
    );
  }
}
