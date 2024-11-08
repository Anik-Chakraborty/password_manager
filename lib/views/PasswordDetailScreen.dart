import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:password_manager/components/ShowQR.dart';
import 'package:password_manager/components/Toast.dart';
import 'package:password_manager/components/WarningDialog.dart';
import 'package:password_manager/components/check2FA.dart';
import 'package:password_manager/components/showPassword.dart';
import 'package:password_manager/configs/colors.dart';
import 'package:password_manager/configs/routes.dart';
import 'package:password_manager/controllers/AuthController.dart';
import 'package:password_manager/controllers/PasswordController.dart';
import 'package:password_manager/controllers/UserController.dart';
import 'package:password_manager/models/PasswordModel.dart';
import 'package:password_manager/models/UserProfileModel.dart';

class PasswordDetailScreen extends StatefulWidget {
  const PasswordDetailScreen({super.key});

  @override
  State<PasswordDetailScreen> createState() => _PasswordDetailScreenState();
}

class _PasswordDetailScreenState extends State<PasswordDetailScreen> {
  PasswordModel? password;

  PasswordController passwordController = Get.put(PasswordController());
  AuthController authController = Get.put(AuthController());
  UserController userController = Get.put(UserController());

  @override
  void initState() {
    password = Get.arguments;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          title: Text("Password Detail",
              style: GoogleFonts.montserrat(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black)),
          centerTitle: false,
          backgroundColor: AppColors.white,
          surfaceTintColor: Colors.transparent,
          actions: [
            IconButton(
              onPressed: () async {
                Get.toNamed(AppRoutes.uptPass, arguments: password);
              },
              icon: const Icon(
                FontAwesomeIcons.penToSquare,
                color: AppColors.black,
              ),
            )
          ],
        ),
        body: Column(
          children: [
            Container(
              height: Get.height * 0.3,
              width: double.infinity,
              alignment: Alignment.topCenter,
              decoration: const BoxDecoration(color: Colors.white),
              child: AnimationConfiguration.synchronized(
                child: SlideAnimation(
                    duration: const Duration(seconds: 1),
                    child: FadeInAnimation(
                        duration: const Duration(seconds: 1),
                        child: Image.asset(
                          "assets/images/lock.png",
                        ))),
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 40, horizontal: 15),
                    margin: const EdgeInsets.only(top: 20),
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        color: AppColors.offWhite,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40))),
                    child: ListView(
                      children: [
                        txtdata(password?.title ?? "", 20, true),
                        Visibility(
                            visible: password?.description != null &&
                                password?.description != "",
                            child: const SizedBox(height: 10)),
                        Visibility(
                            visible: password?.description != null &&
                                password?.description != "",
                            child: txtdata(
                                password?.description ?? "", 16, false)),
                        const SizedBox(height: 20),
                        typeCard(),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            otherCard(CupertinoIcons.bookmark_fill, "Category",
                                password?.category?.categoryName ?? ""),
                            if (password?.group != null) ...[
                              const SizedBox(width: 10),
                              otherCard(Icons.groups, "Group",
                                  password?.group?.groupName ?? ""),
                            ]
                          ],
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        AnimationConfiguration.synchronized(
                          child: FadeInAnimation(
                            duration: const Duration(seconds: 1),
                            child: ScaleAnimation(
                              duration: const Duration(seconds: 1),
                              child: ElevatedButton(
                                  onPressed: () async {
                                    bool isVerified = false;

                                    UserProfileModel? user =
                                        await userController.getUserProfile();

                                    if (user?.isAuthenticator != "1") {
                                      //google authenticator is not enable
                                      var qr = await authController
                                          .showAuthenticatorQR();

                                      if (qr == null) {
                                        showToast("Something went wrong", true);
                                        return;
                                      }

                                      if (context.mounted) {
                                        bool state = await showQr(qr);

                                        if (state) {
                                          isVerified = await check2FA();
                                        }
                                      }
                                    } else if (user?.isAuthenticator == "1") {
                                      isVerified = true;
                                    }

                                    if (isVerified) {
                                      String? encPass =
                                          await passwordController.showPassword(
                                              (password?.id ?? 0).toString());

                                      if (encPass != null) {
                                        passwordController.verifyPassword(
                                            (password?.id ?? 0).toString());

                                        showPassword(encPass);
                                      }
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.blue,
                                      surfaceTintColor: Colors.transparent,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15, horizontal: 15),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30))),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(FontAwesomeIcons.eye,
                                          color: AppColors.white, size: 20),
                                      const SizedBox(width: 10),
                                      Text(
                                        "Show Password",
                                        style: GoogleFonts.montserrat(
                                            color: AppColors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  )),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        AnimationConfiguration.synchronized(
                          child: FadeInAnimation(
                            duration: const Duration(seconds: 1),
                            child: ScaleAnimation(
                              duration: const Duration(seconds: 1),
                              child: IconButton(
                                  onPressed: () async {
                                    bool allow = await showWarningDialog();

                                    if (allow) {
                                      passwordController.deletePassword(
                                          (password?.id ?? "").toString());
                                    }
                                  },
                                  style: const ButtonStyle(
                                      backgroundColor: MaterialStatePropertyAll(
                                          AppColors.blue),
                                      padding: MaterialStatePropertyAll(
                                          EdgeInsets.all(12)),
                                      shape: MaterialStatePropertyAll(
                                          CircleBorder())),
                                  icon: const Icon(FontAwesomeIcons.trash,
                                      color: Colors.white, size: 16)),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ));
  }

  txtTitle(String title) {
    return Text(title,
        style: GoogleFonts.montserrat(color: Colors.grey, fontSize: 16));
  }

  txtdata(String title, double fontSize, bool bold) {
    return Text(title,
        overflow: TextOverflow.ellipsis,
        maxLines: null,
        style: GoogleFonts.montserrat(
            color: AppColors.black,
            fontSize: fontSize,
            fontWeight: bold ? FontWeight.bold : FontWeight.normal));
  }

  typeCard() {
    return Container(
      padding: const EdgeInsets.all(10),
      width: Get.width - 30,
      decoration: BoxDecoration(
          color: AppColors.white, borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: AppColors.blue.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10)),
            child: const Icon(BootstrapIcons.type,
                color: AppColors.blue, size: 25),
          ),
          const SizedBox(width: 10),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              txtdata("Password Type", 16, true),
              const SizedBox(height: 10),
              txtdata(password?.passwordType ?? "", 20, false),
            ],
          )
        ],
      ),
    );
  }

  otherCard(IconData icon, String label, String data) {
    return Container(
      padding: const EdgeInsets.all(10),
      width: Get.width * 0.44,
      decoration: BoxDecoration(
          color: AppColors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: AppColors.blue.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: AppColors.blue, size: 25),
          ),
          const SizedBox(height: 10),
          txtdata(label, 16, true),
          const SizedBox(height: 5),
          txtdata(data, 20, false)
        ],
      ),
    );
  }
}
