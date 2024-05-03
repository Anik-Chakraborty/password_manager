import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
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
  AuthController authController = Get.put(AuthController());

  PasswordController passwordController = PasswordController();

  List<PasswordModel>? passwords;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: IconButton(
        onPressed: () async{
          await Get.toNamed(AppRoutes.createPass);
          setState(() {
            passwords = null;
          });
        },
        icon: const Icon(Icons.add, size: 40, color: AppColors.secondary),
        style: const ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(AppColors.white),
          shape: MaterialStatePropertyAll(
            CircleBorder()
          )
        ),
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
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: AppColors.white,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          Get.toNamed(AppRoutes.profile);
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(width: 10),
                            const Icon(
                              FontAwesomeIcons.user,
                              color: AppColors.primary,
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Text("User Name",
                                style: GoogleFonts.merriweather(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary)),
                          ],
                        ),
                      ),
                      const Expanded(child: SizedBox()),
                      IconButton(
                          onPressed: () {
                            authController.logout();
                          },
                          icon: const Icon(
                            Icons.logout,
                            color: AppColors.primary,
                            size: 20,
                          ))
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text("Passwords",
                      style: GoogleFonts.merriweather(
                          color: AppColors.white, fontSize: 20)),
                ),
                const SizedBox(height: 5),
                passwords != null && passwords!.isNotEmpty ?
                    passwordCards() :
                FutureBuilder(
                  future: passwordController.getMyPasswords(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Expanded(
                          child: Center(child: LoadingWidget()));
                    } else if (snapshot.connectionState ==
                        ConnectionState.done) {
                      passwords = snapshot.data as List<PasswordModel>?;

                      if (passwords == null || passwords!.isEmpty) {
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


  passwordCards(){
    return Expanded(
      child: ListView.builder(
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () async{
                var status = await Get.toNamed(AppRoutes.passDetail, arguments: passwords![index]);

                if(status!=null && status){
                  setState(() {
                    passwords = null;
                  });
                }

              },
              child: Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 5),
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
                          borderRadius:
                          BorderRadius.circular(10)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                              (passwords![index].passwordType ==
                                  "Individual")
                                  ? Icons.person
                                  : Icons.groups,
                              color: AppColors.primary,
                              size: 50),
                          Text(
                            passwords![index].passwordType ??
                                "",
                            style: GoogleFonts.montserrat(
                                fontSize: 12,
                                color: AppColors.primary),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        mainAxisAlignment:
                        MainAxisAlignment.start,
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                            passwords![index].title ?? "",
                            style: GoogleFonts.montserrat(
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "Category : ${passwords![index].category?.categoryName ?? ""}",
                            style: GoogleFonts.montserrat(
                                color: AppColors.white
                                    .withOpacity(0.5),
                                fontSize: 14),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Visibility(
                            visible: passwords![index]
                                .passwordType ==
                                "Group",
                            child: Text(
                              "Group : ${passwords![index].group?.groupName ?? ""}",
                              style: GoogleFonts.montserrat(
                                  color: AppColors.white
                                      .withOpacity(0.5),
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
                                    color: AppColors.white,
                                    fontSize: 14),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(width: 5),
                              Text(DateFormat('MMM dd yyyy').format(DateTime.parse( passwords![index].createdAt!)),
                                style: GoogleFonts.montserrat(
                                    color: AppColors.white
                                        .withOpacity(0.5),
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
          itemCount: passwords?.length ?? 0),
    );
  }

}
