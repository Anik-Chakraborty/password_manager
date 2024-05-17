import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:password_manager/components/LoadingWidget.dart';
import 'package:password_manager/configs/colors.dart';
import 'package:password_manager/configs/routes.dart';
import 'package:password_manager/controllers/CreatePassController.dart';
import 'package:password_manager/controllers/PasswordController.dart';
import 'package:password_manager/models/GroupModel.dart';
import 'package:password_manager/models/PasswordModel.dart';

class GroupWisePassword extends StatefulWidget {
  const GroupWisePassword({super.key});

  @override
  State<GroupWisePassword> createState() => _GroupWisePasswordState();
}

class _GroupWisePasswordState extends State<GroupWisePassword> {
  CreatePassController createPassController = Get.put(CreatePassController());
  PasswordController passwordController = Get.put(PasswordController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8),
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
                backgroundColor: MaterialStatePropertyAll(AppColors.white)),
          ),
        ),
        title: Text("Groups",
            style: GoogleFonts.merriweather(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.white)),
        actions: [
          IconButton(
            onPressed: () {
              Get.toNamed(AppRoutes.search);
            },
            icon: const Icon(Icons.search_rounded, color: AppColors.white),
          ),
          const SizedBox(width: 10)
        ],
        centerTitle: true,
        backgroundColor: AppColors.primary,
        surfaceTintColor: Colors.transparent,
      ),
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
                const SizedBox(height: 20),
                FutureBuilder(
                  future: createPassController.getGroups(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: LoadingWidget());
                    } else if (snapshot.connectionState ==
                        ConnectionState.done) {
                      List<GroupModel>? groups =
                      snapshot.data as List<GroupModel>?;

                      if (groups == null || groups.isEmpty) {
                        return noData();
                      }

                      return ListView.builder(
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Text(
                                      groups[index].groupName ?? "",
                                      style: GoogleFonts.merriweather(
                                          color: AppColors.white,
                                          fontSize: 20)),
                                ),
                                FutureBuilder(
                                  future:
                                  passwordController.getPasswordsByGroup(
                                      groupId:
                                      groups[index].id.toString()),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Container(
                                        height: 300,
                                        width: Get.width,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(10)),
                                      );
                                    } else if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      List<PasswordModel>? passwords =
                                      snapshot.data as List<PasswordModel>?;

                                      if (passwords == null ||
                                          passwords.isEmpty) {
                                        return noData();
                                      }

                                      return SizedBox(
                                        height: 300,
                                        child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (context, index) {
                                              return InkWell(
                                                onTap: () async {
                                                  var status =
                                                  await Get.toNamed(
                                                      AppRoutes.passDetail,
                                                      arguments:
                                                      passwords[index]);

                                                  if (status != null &&
                                                      status) {
                                                    setState(() {});
                                                  }
                                                },
                                                child: Container(
                                                  width: Get.width * 0.4,
                                                  padding:
                                                  const EdgeInsets.all(10),
                                                  margin: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 5,
                                                      vertical: 10),
                                                  decoration: BoxDecoration(
                                                      color: AppColors.secondary
                                                          .withOpacity(0.3),
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                    children: [
                                                      Container(
                                                        width:
                                                        (Get.width * 0.4) -
                                                            20,
                                                        height:
                                                        (Get.width * 0.4) -
                                                            40,
                                                        padding:
                                                        const EdgeInsets
                                                            .all(10),
                                                        alignment:
                                                        Alignment.center,
                                                        decoration: BoxDecoration(
                                                            color:
                                                            AppColors.white,
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                10)),
                                                        child: Column(
                                                          mainAxisSize:
                                                          MainAxisSize.min,
                                                          children: [
                                                            Icon(
                                                                (passwords[index]
                                                                    .passwordType ==
                                                                    "Individual")
                                                                    ? Icons
                                                                    .person
                                                                    : Icons
                                                                    .groups,
                                                                color: AppColors
                                                                    .primary,
                                                                size: 50),
                                                            Text(
                                                              passwords[index]
                                                                  .passwordType ??
                                                                  "",
                                                              style: GoogleFonts
                                                                  .montserrat(
                                                                  fontSize:
                                                                  12,
                                                                  color: AppColors
                                                                      .primary),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
                                                      Text(
                                                        passwords[index]
                                                            .title ??
                                                            "",
                                                        style: GoogleFonts
                                                            .montserrat(
                                                            color: AppColors
                                                                .white,
                                                            fontWeight:
                                                            FontWeight
                                                                .bold,
                                                            fontSize: 16),
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                      const SizedBox(height: 5),
                                                      Visibility(
                                                        visible: passwords[
                                                        index]
                                                            .passwordType ==
                                                            "Group",
                                                        child: Text(
                                                          "Group : ${passwords[index].group?.groupName ?? ""}",
                                                          style: GoogleFonts
                                                              .montserrat(
                                                              color: AppColors
                                                                  .white
                                                                  .withOpacity(
                                                                  0.5),
                                                              fontSize: 14),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 2),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            "📆",
                                                            style: GoogleFonts
                                                                .montserrat(
                                                                color: AppColors
                                                                    .white,
                                                                fontSize:
                                                                14),
                                                            maxLines: 2,
                                                            overflow:
                                                            TextOverflow
                                                                .ellipsis,
                                                          ),
                                                          const SizedBox(
                                                              width: 5),
                                                          Text(
                                                            DateFormat(
                                                                'MMM dd yyyy')
                                                                .format(DateTime.parse(
                                                                passwords[index]
                                                                    .createdAt ??
                                                                    "2024-01-18T23:58:24.000000Z")),
                                                            style: GoogleFonts
                                                                .montserrat(
                                                                color: AppColors
                                                                    .white
                                                                    .withOpacity(
                                                                    0.5),
                                                                fontSize:
                                                                14),
                                                            maxLines: 2,
                                                            overflow:
                                                            TextOverflow
                                                                .ellipsis,
                                                          )
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                            itemCount: passwords.length),
                                      );
                                    } else {
                                      return noData();
                                    }
                                  },
                                )
                              ],
                            );
                          },
                          itemCount: groups.length);
                    } else {
                      return noData();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  noData() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Data not found",
            style:
            GoogleFonts.montserrat(color: AppColors.primary, fontSize: 18)),
      ],
    );
  }
}
