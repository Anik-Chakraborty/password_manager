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
import 'package:password_manager/models/PasswordModel.dart';

class AllPasswordScreen extends StatefulWidget {
  const AllPasswordScreen({super.key});

  @override
  State<AllPasswordScreen> createState() => _AllPasswordScreenState();
}

class _AllPasswordScreenState extends State<AllPasswordScreen> {
  PasswordController passwordController = Get.put(PasswordController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Passwords",
            style: GoogleFonts.montserrat(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.black)),
        centerTitle: false,
        backgroundColor: AppColors.offWhite,
        surfaceTintColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () {
              Get.toNamed(AppRoutes.search);
            },
            style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(AppColors.blue),
                shape: MaterialStatePropertyAll(CircleBorder())),
            icon: const Icon(Icons.search_rounded, color: AppColors.white),
          ),
          const SizedBox(width: 10)
        ],
      ),
      backgroundColor: AppColors.offWhite,
      body: RefreshIndicator(
        onRefresh: () async => setState(() {passwordController.passwords = null;}),
        child: Container(
          padding: const EdgeInsets.all(5),
          child: passwordController.passwords != null &&
              passwordController.passwords!.isNotEmpty
              ? passwordCards()
              : FutureBuilder(
            future: passwordController.getMyPasswords(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Expanded(
                    child: Center(child: LoadingWidget()));
              } else if (snapshot.connectionState == ConnectionState.done) {
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
      ),
    );
  }

  passwordCards() {
    return AnimationLimiter(
      child: GridView.builder(
          itemBuilder: (context, index) {
            return AnimationConfiguration.staggeredGrid(
                position: index,
                columnCount: 2,
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
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(10),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                      (passwordController.passwords![index]
                                                  .passwordType ==
                                              "Individual")
                                          ? Icons.person
                                          : Icons.groups,
                                      color: AppColors.white,
                                      size: 50),
                                  Text(
                                    passwordController
                                            .passwords![index].passwordType ??
                                        "",
                                    style: GoogleFonts.montserrat(
                                        fontSize: 12, color: AppColors.white),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      passwordController
                                              .passwords![index].title ??
                                          "",
                                      style: GoogleFonts.montserrat(
                                          color: AppColors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const Expanded(child: SizedBox(height: 5)),
                                    Text(
                                      "Category : ${passwordController.passwords![index].category?.categoryName ?? ""}",
                                      style: GoogleFonts.montserrat(
                                          color: Colors.grey, fontSize: 14),
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
                                            color: Colors.grey, fontSize: 14),
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
                                              color: AppColors.blue,
                                              fontSize: 14),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          DateFormat('MMM dd yyyy').format(
                                              DateTime.parse(passwordController
                                                  .passwords![index]
                                                  .createdAt!)),
                                          style: GoogleFonts.montserrat(
                                              color: Colors.grey, fontSize: 14),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ));
          },
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: Get.width * 0.6,
              crossAxisSpacing: 15,
              mainAxisSpacing: 10),
          itemCount: passwordController.passwords?.length ?? 0),
    );
  }
}
