import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:clay_containers/widgets/clay_container.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:motion_tab_bar/MotionTabBarController.dart';
import 'package:password_manager/components/WarningDialog.dart';
import 'package:password_manager/configs/colors.dart';
import 'package:password_manager/configs/routes.dart';
import 'package:password_manager/controllers/AuthController.dart';
import 'package:password_manager/controllers/UserController.dart';
import 'package:password_manager/models/UserModel.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key, required this.tabController});

  final MotionTabBarController? tabController;

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  AuthController authController = Get.put(AuthController());

  String name = "Anik", email = "example@gmail.com";

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    UserModel userModel = UserController().getUserDetails();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        name = userModel.name ?? "Anik";
        email = userModel.email ?? "example@gmail.com";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Setting",
            style: GoogleFonts.montserrat(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.black)),
        centerTitle: false,
        backgroundColor: AppColors.offWhite,
        surfaceTintColor: Colors.transparent,
      ),
      backgroundColor: AppColors.offWhite,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Hero(
              tag: "user-profile",
              child: Center(
                  child: Stack(
                fit: StackFit.loose,
                alignment: AlignmentDirectional.bottomEnd,
                children: [
                  ClayContainer(
                    color: AppColors.offWhite,
                    height: Get.width * 0.4,
                    width: Get.width * 0.4,
                    borderRadius: 100,
                    child: Center(
                      child: Material(
                        color: Colors.transparent,
                        child: Text(name.substring(0, 1),
                            style: GoogleFonts.montserrat(
                                color: Colors.black,
                                fontSize: 80,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    width: 50,
                    height: 50,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: AppColors.blue),
                    child: const Icon(BootstrapIcons.shield_fill,
                        color: AppColors.white, size: 25),
                  )
                ],
              ),
                ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(30),
            width: double.infinity,
            height: Get.height * 0.55,
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: AppColors.black.withOpacity(0.009),
                      spreadRadius: 10,
                      blurStyle: BlurStyle.outer)
                ],
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40)),
                gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: AlignmentDirectional.bottomCenter,
                    colors: [AppColors.white, AppColors.offWhite])),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: Text(name,
                      style: GoogleFonts.montserrat(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.black)),
                  contentPadding: EdgeInsets.zero,
                  subtitle: Text(email,
                      style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey)),
                  trailing: IconButton(
                    onPressed: () {
                      Get.toNamed(AppRoutes.profile);
                    },
                    icon: const Icon(
                      FontAwesomeIcons.penToSquare,
                      color: AppColors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                item("Add Password", BootstrapIcons.shield_fill_plus, () {
                  Get.toNamed(AppRoutes.createPass);
                }),
                divider(),
                item("Authenticator", BootstrapIcons.google, () {
                  Get.toNamed(AppRoutes.authenticator);
                }),
                divider(),
                item("Records", BootstrapIcons.hourglass_top, () {
                  Get.toNamed(AppRoutes.records);
                }),
                divider(),
                item("Logout", FontAwesomeIcons.arrowRightFromBracket,
                    () async {
                  bool status = await showWarningDialog();

                  if (status) {
                    authController.logout();
                  }
                }),
              ],
            ),
          )
        ],
      ),
    );
  }

  item(String title, IconData leading, var onTap) {
    return ListTile(
      onTap: onTap,
      leading: Icon(leading, color: AppColors.blue),
      title: Text(title,
          style: GoogleFonts.montserrat(fontSize: 20, color: AppColors.black)),
      contentPadding: EdgeInsets.zero,
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
    );
  }

  divider() {
    return Divider(color: Colors.grey.withOpacity(0.3));
  }
}
