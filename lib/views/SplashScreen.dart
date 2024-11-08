import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
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

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin{

  late AnimationController controller;
  late Animation<double> animation;

  UserController userController = UserController();

  @override
  void initState() {
    controller = AnimationController(
        duration: const Duration(seconds: 1), vsync: this)..addListener(() =>
        setState(() {}));
    animation = Tween(begin: -500.0, end: 0.0).animate(controller);
    controller.forward();


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
      backgroundColor: AppColors.white,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                bottom: Get.height * 0.25,
                child: Transform.translate(
                  offset: Offset( 0.0, animation.value),
                  child: Container(
                    height: Get.height,
                    width: Get.height,
                    decoration: BoxDecoration(
                        color: AppColors.secondary,
                        borderRadius: BorderRadius.circular(1000)
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: Get.height * 0.3,
                child: Transform.translate(
                  offset: Offset( 0.0, animation.value),
                  child: Container(
                    height: Get.height,
                    width: Get.height,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(1000)
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: Get.height * 0.1,
              child: AnimationConfiguration.synchronized(
                child: FadeInAnimation(
                    duration: const Duration(seconds: 2),
                    delay: const Duration(seconds: 2),
                    child: ScaleAnimation(
                        duration: const Duration(seconds: 2),
                        delay: const Duration(seconds: 1),
                        child: Image.asset(
                          "assets/images/lock.png",
                        ))),
              ),
          ),
        ],
      ),
    );
  }
}