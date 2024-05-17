import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:password_manager/components/WarningDialog.dart';
import 'package:password_manager/configs/colors.dart';
import 'package:password_manager/configs/routes.dart';
import 'package:password_manager/controllers/PasswordController.dart';
import 'package:password_manager/models/PasswordModel.dart';

class PasswordDetailScreen extends StatefulWidget {
  const PasswordDetailScreen({super.key});

  @override
  State<PasswordDetailScreen> createState() => _PasswordDetailScreenState();
}

class _PasswordDetailScreenState extends State<PasswordDetailScreen> {
  PasswordModel? password;

  PasswordController passwordController = PasswordController();

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
                    "Password Detail",
                    style: GoogleFonts.montserrat(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                  const SizedBox(height: 40),
                  Container(
                    constraints: BoxConstraints(maxHeight: Get.height * 0.7),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        txtTitle("Title"),
                        const SizedBox(height: 5),
                        data(password?.title ?? ""),
                        const SizedBox(height: 20),
                        txtTitle("Type"),
                        const SizedBox(height: 5),
                        data(password?.passwordType ?? ""),
                        const SizedBox(height: 20),
                        txtTitle("Category"),
                        const SizedBox(height: 5),
                        data(password?.category?.categoryName ?? ""),
                        const SizedBox(height: 20),
                        Visibility(
                            visible: password?.passwordType == "Group",
                            child: txtTitle("Group")),
                        Visibility(
                            visible: password?.passwordType == "Group",
                            child: const SizedBox(height: 5)),
                        Visibility(
                            visible: password?.passwordType == "Group",
                            child: data(password?.group?.groupName ?? "")),
                        Visibility(
                            visible: password?.passwordType == "Group",
                            child: const SizedBox(height: 20)),
                        Visibility(
                            visible: password?.description != null &&
                                password?.description != "",
                            child: txtTitle("Description")),
                        Visibility(
                            visible: password?.description != null &&
                                password?.description != "",
                            child: const SizedBox(height: 5)),
                        Visibility(
                            visible: password?.description != null &&
                                password?.description != "",
                            child: data(password?.description ?? "")),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Positioned(
                top: 20,
                left: 20,
                child: IconButton(
                  onPressed: () {
                    // Get.back();
                    Get.toNamed(AppRoutes.nav);
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
            Positioned(
                top: 20,
                right: 20,
                child: IconButton(
                  onPressed: () async {
                    bool allow = await showWarningDialog();

                    if (allow) {
                      passwordController.deletePassword((password?.id ?? "").toString());
                    }
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: AppColors.secondary,
                  ),
                  style: const ButtonStyle(
                    shape: MaterialStatePropertyAll(CircleBorder()),
                  ),
                )),
            Positioned(
                bottom: 20,
                child: SizedBox(
                  width: Get.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                              Get.toNamed(AppRoutes.uptPass, arguments: password);
                          },
                          style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 10),
                              backgroundColor: AppColors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              )),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.edit,
                                  size: 30, color: AppColors.primary),
                              const SizedBox(width: 10),
                              Text(
                                "Edit",
                                style: GoogleFonts.montserrat(
                                    color: AppColors.primary,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: 7),
                            ],
                          )),
                      ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 10),
                              backgroundColor: AppColors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              )),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.visibility,
                                  size: 30, color: AppColors.white),
                              const SizedBox(width: 10),
                              Text(
                                "Show Password",
                                style: GoogleFonts.montserrat(
                                    color: AppColors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: 3),
                            ],
                          )),
                    ],
                  ),
                ))
          ],
        ));
  }

  txtTitle(String title) {
    return Text(title,
        style: GoogleFonts.montserrat(
            color: AppColors.white.withOpacity(0.5), fontSize: 16));
  }

  data(String title) {
    return SizedBox(
      width: Get.width - 20,
      child: Text(title,
          overflow: TextOverflow.ellipsis,
          maxLines: null,
          style: GoogleFonts.montserrat(color: AppColors.white, fontSize: 20)),
    );
  }
}
