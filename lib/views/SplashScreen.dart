import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:password_manager/configs/colors.dart';
import 'package:password_manager/configs/routes.dart';
import 'package:password_manager/controllers/UserController.dart';
import 'package:password_manager/models/UserModel.dart';

class SplashScreen extends StatefulWidget{
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  UserController userController = UserController();

  @override
  void initState() {

    UserModel userModel = userController.getUserDetails();

    Future.delayed(const Duration(seconds: 3), () {

      if(userModel.token != null && userModel.token!.isNotEmpty){
        Get.offAllNamed(AppRoutes.nav);
      }
      else{
        Get.offAllNamed(AppRoutes.logIn);
      }

    },);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: AppColors.primary, // status bar color
    ));


    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(10)
                ),
                child: const Icon(FontAwesomeIcons.key, color: AppColors.primary, size: 50)),
            const SizedBox(height: 10),
            Text("Password Manager", style: GoogleFonts.merriweather(
              color: AppColors.white, fontSize: 20, fontWeight: FontWeight.bold
            ))
          ],
        ),
      ),
    );
  }
}