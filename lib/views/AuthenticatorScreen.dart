import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:password_manager/components/LoadingWidget.dart';
import 'package:password_manager/components/ShowQR.dart';
import 'package:password_manager/components/Toast.dart';
import 'package:password_manager/components/check2FA.dart';
import 'package:password_manager/configs/colors.dart';
import 'package:password_manager/configs/routes.dart';
import 'package:password_manager/controllers/AuthController.dart';
import 'package:password_manager/controllers/UserController.dart';
import 'package:password_manager/models/UserProfileModel.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthenticatorScreen extends StatefulWidget {
  const AuthenticatorScreen({super.key});

  @override
  State<AuthenticatorScreen> createState() => _AuthenticatorScreenState();
}

class _AuthenticatorScreenState extends State<AuthenticatorScreen> {
  UserController userController = Get.put(UserController());
  AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.primary,
        body: Stack(
          children: [
            Center(
              child: Icon(FontAwesomeIcons.key,
                  color: AppColors.white.withOpacity(0.1), size: 100),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 25, left: 10, right: 10, bottom: 10),
              child: Column(
                children: [
                  Text(
                    "Authenticator",
                    style: GoogleFonts.montserrat(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                  const SizedBox(height: 40),
                  FutureBuilder(
                    future: userController.getUserProfile(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Expanded(
                            child: Center(child: LoadingWidget()));
                      } else if (snapshot.connectionState ==
                          ConnectionState.done) {
                        UserProfileModel? user =
                            snapshot.data as UserProfileModel?;

                        if (user == null) {
                          return wentWrong();
                        } else if (user.isAuthenticator == "1") {
                          return Expanded(
                            child: Center(
                                child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  "assets/images/google_authenticator.png",
                                  alignment: Alignment.center,
                                  fit: BoxFit.contain,
                                  height: Get.width * 0.3,
                                  width: Get.width * 0.3,
                                ),
                                const SizedBox(height: 10),
                                Text("Google Authenticator is enabled",
                                    style: GoogleFonts.montserrat(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              ],
                            )),
                          );
                        } else {
                          return Container(
                            constraints:
                                BoxConstraints(maxHeight: Get.height * 0.7),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              // color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListView(
                              children: [
                                Text("Google Authenticator is not Enable",
                                    style: GoogleFonts.montserrat(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20)),
                                const SizedBox(height: 10),
                                Text(
                                    "To enable Google authenticator follow below steps",
                                    style: GoogleFonts.montserrat(
                                        color: Colors.white, fontSize: 16)),
                                const SizedBox(height: 5),
                                RichText(
                                  text: TextSpan(
                                    style: GoogleFonts.montserrat(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: 'Step 1: ',
                                        style: GoogleFonts.montserrat(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const TextSpan(
                                        text: 'Install and Setup ',
                                      ),
                                      TextSpan(
                                        text: 'Google Authenticator',
                                        style: GoogleFonts.montserrat(
                                            color: AppColors.secondary,
                                            fontWeight: FontWeight.bold),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () async {
                                            await canLaunchUrl(Uri.parse(
                                                'https://play.google.com/store/apps/details?id=com.google.android.apps.authenticator2'));
                                          },
                                      ),
                                      const TextSpan(
                                        text: ' in your mobile',
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 5),
                                RichText(
                                  text: TextSpan(
                                    style: GoogleFonts.montserrat(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: 'Step 2: ',
                                        style: GoogleFonts.montserrat(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const TextSpan(
                                        text: 'Add an account and Choose ',
                                      ),
                                      TextSpan(
                                        text: 'Scan QR Code',
                                        style: GoogleFonts.montserrat(
                                            color: AppColors.secondary,
                                            fontWeight: FontWeight.bold),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () async {
                                            var qr = await authController
                                                .showAuthenticatorQR();
                                            if (qr == null) {
                                              showToast(
                                                  "Something went wrong", true);
                                              return;
                                            }

                                            if (context.mounted) {
                                              bool state = await showQr(qr);

                                              if (state) {
                                                bool isVerified =
                                                    await check2FA();

                                                if (isVerified) {
                                                  setState(() {});
                                                }
                                              }
                                            }
                                          },
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 5),
                                RichText(
                                  text: TextSpan(
                                    style: GoogleFonts.montserrat(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: 'Step 3: ',
                                        style: GoogleFonts.montserrat(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const TextSpan(
                                        text: 'Press ',
                                      ),
                                      TextSpan(
                                        text: 'Next ',
                                        style: GoogleFonts.montserrat(
                                            color: AppColors.secondary,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const TextSpan(
                                        text: '& Enter 2FA code and Press ',
                                      ),
                                      TextSpan(
                                        text: 'Submit',
                                        style: GoogleFonts.montserrat(
                                            color: AppColors.secondary,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      } else {
                        return wentWrong();
                      }
                    },
                  )
                ],
              ),
            ),
            Positioned(
                top: 20,
                left: 20,
                child: IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: AppColors.primary,
                  ),
                  style: const ButtonStyle(
                      shape: MaterialStatePropertyAll(CircleBorder()),
                      backgroundColor:
                          MaterialStatePropertyAll(AppColors.white)),
                )),
          ],
        ));
  }

  wentWrong() {
    return Expanded(
      child: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Something Went Wrong",
              style: GoogleFonts.montserrat(color: Colors.white)),
          const SizedBox(height: 10),
          TextButton(
              onPressed: () {
                setState(() {});
              },
              style: ButtonStyle(
                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                      side: const BorderSide(
                          color: AppColors.secondary, width: 1),
                      borderRadius: BorderRadius.circular(50))),
                  backgroundColor:
                      const MaterialStatePropertyAll(Colors.transparent),
                  surfaceTintColor:
                      const MaterialStatePropertyAll(Colors.transparent),
                  shadowColor:
                      const MaterialStatePropertyAll(Colors.transparent),
                  padding: const MaterialStatePropertyAll(
                      EdgeInsets.symmetric(vertical: 5, horizontal: 10))),
              child: Text(
                "Refresh",
                style: GoogleFonts.montserrat(
                    color: AppColors.secondary, fontWeight: FontWeight.bold),
              ))
        ],
      )),
    );
  }
}
