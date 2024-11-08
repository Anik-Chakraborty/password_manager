import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:password_manager/components/LoadingWidget.dart';
import 'package:password_manager/components/NoDataWidget.dart';
import 'package:password_manager/configs/colors.dart';
import 'package:password_manager/configs/routes.dart';
import 'package:password_manager/controllers/PasswordController.dart';
import 'package:password_manager/controllers/UserController.dart';
import 'package:password_manager/models/PasswordModel.dart';
import 'package:password_manager/models/UserModel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PasswordController passwordController = Get.put(PasswordController());

  String name = "Anik";

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
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.offWhite,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => setState(() {
            passwordController.passwords = null;
          }),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: Get.height * 0.35,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  decoration: const BoxDecoration(
                      color: AppColors.offSecondary,
                      boxShadow: [
                        BoxShadow(
                            blurStyle: BlurStyle.outer,
                            color: Colors.white10,
                            spreadRadius: 5)
                      ],
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20))),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          GestureDetector(onTap: (){
                            Get.toNamed(AppRoutes.profile);
                          }, child: Container(
                            padding: const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(
                                    color: AppColors.white, width: 0)),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  alignment: Alignment.center,
                                  decoration: const BoxDecoration(
                                      color: AppColors.white,
                                      shape: BoxShape.circle),
                                  child: const Icon(Icons.person,
                                      color: AppColors.blue, size: 25),
                                ),
                                const SizedBox(width: 10),
                                Container(
                                  constraints:
                                  BoxConstraints(maxWidth: Get.width * 0.5),
                                  child: Text(name,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.montserrat(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                )
                              ],
                            ),
                          )),
                          const Expanded(child: SizedBox()),
                          IconButton(
                            onPressed: () {
                              Get.toNamed(AppRoutes.createPass);
                            },
                            style: const ButtonStyle(
                                backgroundColor:
                                    MaterialStatePropertyAll(AppColors.blue),
                                shape:
                                    MaterialStatePropertyAll(CircleBorder())),
                            icon: const Icon(BootstrapIcons.shield_fill_plus,
                                color: AppColors.white),
                          ),
                          const SizedBox(width: 10),
                          IconButton(
                            onPressed: () {
                              Get.toNamed(AppRoutes.search);
                            },
                            style: const ButtonStyle(
                                backgroundColor:
                                    MaterialStatePropertyAll(AppColors.blue),
                                shape:
                                    MaterialStatePropertyAll(CircleBorder())),
                            icon: const Icon(Icons.search_rounded,
                                color: AppColors.white),
                          ),
                        ],
                      ),
                      const Expanded(child: SizedBox()),
                      title("Manage"),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          manageItem("Category", Icons.dashboard_sharp, AppRoutes.categories),
                          manageItem("Group", Icons.groups, AppRoutes.groups)
                        ],
                      )
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: title("Passwords"),
                ),
                Container(
                  padding: const EdgeInsets.all(5),
                  child: passwordController.passwords != null &&
                          passwordController.passwords!.isNotEmpty
                      ? passwordCards()
                      : FutureBuilder(
                          future: passwordController.getMyPasswords(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(child: LoadingWidget());
                            } else if (snapshot.connectionState ==
                                ConnectionState.done) {
                              passwordController.passwords =
                                  snapshot.data as List<PasswordModel>?;

                              if (passwordController.passwords == null ||
                                  passwordController.passwords!.isEmpty) {
                                return NoDataWidget(
                                  onTap: () {
                                    setState(() {});
                                  },
                                );
                              }

                              return passwordCards();
                            } else {
                              return NoDataWidget(
                                onTap: () {
                                  setState(() {});
                                },
                              );
                            }
                          },
                        ),
                ),
                const SizedBox(height: 40)
              ],
            ),
          ),
        ),
      ),
    );
  }

  passwordCards() {
    return AnimationLimiter(
      child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return AnimationConfiguration.staggeredList(
                position: index,
                child: SlideAnimation(
                  duration: const Duration(seconds: 1),
                  child: FadeInAnimation(
                    duration: const Duration(seconds: 1),
                    child: GestureDetector(
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
                            color: AppColors.white,
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
                                      (passwordController.passwords![index].passwordType == "Individual")
                                          ? Icons.person
                                          : Icons.groups,
                                      color: AppColors.blue,
                                      size: 50),
                                  Text(
                                    passwordController.passwords![index].passwordType ?? "",
                                    style: GoogleFonts.montserrat(
                                        fontSize: 12, color: AppColors.black),
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
                                        color: AppColors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    "Category : ${passwordController.passwords![index].category?.categoryName ?? ""}",
                                    style: GoogleFonts.montserrat(
                                        color: AppColors.black,
                                        fontSize: 14),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Visibility(
                                    visible: passwordController.passwords![index].passwordType == "Group",
                                    child: Text(
                                      "Group : ${passwordController.passwords![index].group?.groupName ?? ""}",
                                      style: GoogleFonts.montserrat(
                                          color: AppColors.black,
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
                                            color: AppColors.black, fontSize: 14),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        DateFormat('MMM dd yyyy').format(DateTime.parse(
                                            passwordController.passwords![index].createdAt!)),
                                        style: GoogleFonts.montserrat(
                                            color: AppColors.black.withOpacity(0.5),
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
                    ),
                  ),
                ));
          },
          itemCount: passwordController.passwords?.length ?? 0),
    );
  }

  manageItem(String title, IconData icon, String page) {
    return GestureDetector(
      onTap: (){
        Get.toNamed(page);
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        width: Get.width * 0.32,
        decoration: BoxDecoration(
            color: AppColors.white, borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.offSecondary,
              ),
              child: Icon(icon, color: AppColors.secondary, size: 25),
            ),
            const SizedBox(height: 8),
            Text(title,
                style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black)),
          ],
        ),
      ),
    );
  }

  title(String title){
    return Text(title,
        style: GoogleFonts.montserrat(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.black));
  }

}
