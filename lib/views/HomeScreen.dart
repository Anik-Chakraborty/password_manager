import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:password_manager/components/Drawer.dart';
import 'package:password_manager/components/LoadingWidget.dart';
import 'package:password_manager/configs/colors.dart';
import 'package:password_manager/configs/routes.dart';
import 'package:password_manager/controllers/AuthController.dart';
import 'package:password_manager/controllers/PasswordController.dart';
import 'package:password_manager/models/PasswordModel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  AuthController authController = Get.put(AuthController());

  PasswordController passwordController = PasswordController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Passwords",
            style: GoogleFonts.merriweather(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.white)),
        leading: IconButton(
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          icon: const Icon(Icons.menu, color: AppColors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.toNamed(AppRoutes.search);
            },
            icon: const Icon(Icons.search_rounded, color: AppColors.white),
          ),
          const SizedBox(width: 5),
          IconButton(
              onPressed: () async {
                await Get.toNamed(AppRoutes.createPass);
                setState(() {
                  passwordController.passwords = null;
                });
              },
              icon: const Icon(Icons.add, color: AppColors.white)),
          const SizedBox(width: 10)
        ],
        centerTitle: true,
        backgroundColor: AppColors.primary,
        surfaceTintColor: Colors.transparent,
      ),
      drawer: const SideDrawer(),
      backgroundColor: AppColors.primary,
      body: Stack(
        children: [
          Center(
            child: Icon(FontAwesomeIcons.key,
                color: AppColors.white.withOpacity(0.1), size: 100),
          ),
          Container(
            height: Get.height,
            padding: const EdgeInsets.all(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                passwordController.passwords != null &&
                        passwordController.passwords!.isNotEmpty
                    ? passwordCards()
                    : FutureBuilder(
                        future: passwordController.getMyPasswords(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Expanded(
                                child: Center(child: LoadingWidget()));
                          } else if (snapshot.connectionState ==
                              ConnectionState.done) {
                            passwordController.passwords =
                                snapshot.data as List<PasswordModel>?;

                            if (passwordController.passwords == null ||
                                passwordController.passwords!.isEmpty) {
                              return Text("Data not found",
                                  style: GoogleFonts.montserrat(
                                      color: AppColors.white, fontSize: 18));
                            }

                            return passwordCards();
                          } else {
                            return Text("Data not found",
                                style: GoogleFonts.montserrat(
                                    color: AppColors.white, fontSize: 18));
                          }
                        },
                      )
              ],
            ),
          ),
        ],
      ),
    );
  }

  passwordCards() {
    return Expanded(
      child: ListView.builder(
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () async {
                var status = await Get.toNamed(AppRoutes.passDetail,
                    arguments: passwordController.passwords![index]);

                if (status != null && status) {
                  setState(() {
                    passwordController.passwords = null;
                  });
                }
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    color: AppColors.secondary.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: Get.width * 0.25,
                      padding: const EdgeInsets.all(10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                              (passwordController
                                          .passwords![index].passwordType ==
                                      "Individual")
                                  ? Icons.person
                                  : Icons.groups,
                              color: AppColors.primary,
                              size: 50),
                          Text(
                            passwordController.passwords![index].passwordType ??
                                "",
                            style: GoogleFonts.montserrat(
                                fontSize: 12, color: AppColors.primary),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            passwordController.passwords![index].title ?? "",
                            style: GoogleFonts.montserrat(
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "Category : ${passwordController.passwords![index].category?.categoryName ?? ""}",
                            style: GoogleFonts.montserrat(
                                color: AppColors.white.withOpacity(0.5),
                                fontSize: 14),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Visibility(
                            visible: passwordController
                                    .passwords![index].passwordType ==
                                "Group",
                            child: Text(
                              "Group : ${passwordController.passwords![index].group?.groupName ?? ""}",
                              style: GoogleFonts.montserrat(
                                  color: AppColors.white.withOpacity(0.5),
                                  fontSize: 14),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Text(
                                "📆",
                                style: GoogleFonts.montserrat(
                                    color: AppColors.white, fontSize: 14),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                DateFormat('MMM dd yyyy').format(DateTime.parse(
                                    passwordController
                                        .passwords![index].createdAt!)),
                                style: GoogleFonts.montserrat(
                                    color: AppColors.white.withOpacity(0.5),
                                    fontSize: 14),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              )
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
          itemCount: passwordController.passwords?.length ?? 0),
    );
  }
}
