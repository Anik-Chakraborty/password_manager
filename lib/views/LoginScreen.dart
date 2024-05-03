import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:password_manager/components/CustomButton.dart';
import 'package:password_manager/components/LoadingWidget.dart';
import 'package:password_manager/components/TextInputWidget.dart';
import 'package:password_manager/configs/colors.dart';
import 'package:password_manager/configs/routes.dart';
import 'package:password_manager/controllers/AuthController.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AuthController authController = Get.put(AuthController());

  TextEditingController emailTxtCnt = TextEditingController();
  TextEditingController passTxtCnt = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.primary,
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Expanded(child: SizedBox()),
              Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: const Icon(FontAwesomeIcons.key,
                      color: AppColors.primary, size: 50)),
              const SizedBox(height: 10),
              Text("Password Manager", style: GoogleFonts.merriweather(
                  color: AppColors.white, fontSize: 20, fontWeight: FontWeight.bold
              )),
              const Expanded(child: SizedBox()),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Card(
                    elevation: 5,
                    surfaceTintColor: Colors.transparent,
                    margin: const EdgeInsets.only(bottom: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextInputWidget(
                              hintText: 'Email',
                              isObscureText: false,
                              keyboardType: TextInputType.text,
                              controller: emailTxtCnt),
                          const SizedBox(height: 10),
                          TextInputWidget(
                              hintText: 'Password',
                              isObscureText: true,
                              keyboardType: TextInputType.text,
                              inputFormatter: null,
                              controller: passTxtCnt),
                          const SizedBox(height: 30),
                          Obx(() => authController.loadingState.value
                              ? const LoadingWidget()
                              : Button(
                                  buttonText: 'Login',
                                  onPress: () async {
                                    authController.updateLoadingState(true);
                                    bool isSuccessful =
                                        await authController.login(
                                            emailTxtCnt.text.trim(),
                                            passTxtCnt.text.trim());

                                    authController.updateLoadingState(false);

                                    if (isSuccessful) {
                                      Get.offAllNamed(AppRoutes.home);
                                    }
                                  }))
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30)
            ],
          ),
        ));
  }
}
