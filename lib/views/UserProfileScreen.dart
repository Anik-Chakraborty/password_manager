import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:password_manager/components/LoadingDialog.dart';
import 'package:password_manager/components/LoadingWidget.dart';
import 'package:password_manager/components/TextInputWidget.dart';
import 'package:password_manager/configs/colors.dart';
import 'package:password_manager/controllers/UserController.dart';
import 'package:password_manager/models/UserProfileModel.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  UserController userController = UserController();

  UserProfileModel? user;

  int sltOccupation = -1;

  TextEditingController nameTxtCnt = TextEditingController(text: "Anik");
  TextEditingController emailTxtCnt = TextEditingController();
  TextEditingController genderTxtCnt = TextEditingController();
  TextEditingController phnTxtCnt = TextEditingController();
  TextEditingController addTxtCnt = TextEditingController();
  TextEditingController nidTxtCnt = TextEditingController();
  TextEditingController fbTxtCnt = TextEditingController();
  TextEditingController twtTxtCnt = TextEditingController();
  TextEditingController lnkTxtCnt = TextEditingController();
  TextEditingController instrTxtCnt = TextEditingController();
  TextEditingController zipTxtCnt = TextEditingController();

  bool allowEdit = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text("Edit Profile",
            style: GoogleFonts.montserrat(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.black)),
        centerTitle: false,
        backgroundColor: AppColors.offWhite,
        surfaceTintColor: Colors.transparent,
        actions: [TextButton(
          onPressed: () async {
            setState(() {
              allowEdit = false;
            });
            showLoadingDialog();
            await userController.updateUserProfile(
                nameTxtCnt.text,
                emailTxtCnt.text,
                phnTxtCnt.text,
                genderTxtCnt.text,
                addTxtCnt.text,
                zipTxtCnt.text,
                nidTxtCnt.text,
                fbTxtCnt.text,
                twtTxtCnt.text,
                lnkTxtCnt.text,
                instrTxtCnt.text,
                sltOccupation.toString());
            setState(() {
              user = null;
            });
            Get.back();
          },
          style: btnStyle(Colors.transparent),
          child: Text("Save ",
              style: GoogleFonts.montserrat(
                  color: AppColors.black,
                  fontSize: 16)),
        )],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Hero(
              tag: "user-profile",
              child: Container(
                  height: Get.height * 0.3,
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 20),
                  alignment: Alignment.topCenter,
                  decoration:
                      const BoxDecoration(color: AppColors.offWhite, boxShadow: [
                    BoxShadow(
                        blurStyle: BlurStyle.inner,
                        color: Colors.black12,
                        spreadRadius: 5,
                        blurRadius: 10)
                  ]),
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
                            child: Text(nameTxtCnt.text.substring(0, 1),
                                style: GoogleFonts.montserrat(
                                    color: Colors.black,
                                    fontSize: 80,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        width: 40,
                        height: 40,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: AppColors.blue),
                        child: const Icon(BootstrapIcons.shield_fill,
                            color: AppColors.white, size: 20),
                      )
                    ],
                  )),
            ),
            user != null
                ? userInfo()
                : FutureBuilder(
                    future: userController.getUserProfile(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container(
                            alignment: Alignment.center,
                            height: Get.height * 0.6,
                            child: const LoadingWidget());
                      } else if (snapshot.connectionState ==
                          ConnectionState.done) {
                        user = snapshot.data as UserProfileModel?;

                        if (user == null) {
                          return Container(
                            alignment: Alignment.center,
                            height: Get.height * 0.6,
                            child: Text("Data not found",
                                style: GoogleFonts.montserrat(
                                    color: AppColors.white, fontSize: 18)),
                          );
                        }

                        sltOccupation =
                            int.parse(user?.userinfo?.occupationId ?? "-1");

                        return userInfo();
                      } else {
                        return Container(
                          alignment: Alignment.center,
                          height: Get.height * 0.6,
                          child: Text("Data not found",
                              style: GoogleFonts.montserrat(
                                  color: AppColors.white, fontSize: 18)),
                        );
                      }
                    },
                  )
          ],
        ),
      ),
    );
  }

  labelText(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: GoogleFonts.montserrat(
            color: Colors.grey, fontSize: 14, fontWeight: FontWeight.bold),
      ),
    );
  }

  userInfo() {
    nameTxtCnt.text = user?.name ?? "";
    emailTxtCnt.text = user?.email ?? "";
    phnTxtCnt.text = user?.userinfo?.phone ?? "";
    genderTxtCnt.text = user?.userinfo?.gender ?? "";
    addTxtCnt.text = user?.userinfo?.address ?? "";
    nidTxtCnt.text = user?.userinfo?.nidPassportNo ?? "";
    fbTxtCnt.text = user?.userinfo?.facebookProfileUrl ?? "";
    twtTxtCnt.text = user?.userinfo?.twitterProfileUrl ?? "";
    lnkTxtCnt.text = user?.userinfo?.linkedinProfileUrl ?? "";
    instrTxtCnt.text = user?.userinfo?.instagramProfileUrl ?? "";
    zipTxtCnt.text = user?.userinfo?.zipCode ?? "";

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          labelText("Username"),
          TextInputWidget(
            controller: nameTxtCnt,
            hintText: "",
            isObscureText: false,
            keyboardType: TextInputType.text,
            suffixIcon: BootstrapIcons.person_fill,
          ),
          const SizedBox(height: 20),
          labelText("Email"),
          TextInputWidget(
            controller: emailTxtCnt,
            hintText: "",
            isObscureText: false,
            keyboardType: TextInputType.text,
            suffixIcon: BootstrapIcons.envelope_at_fill,
          ),
          const SizedBox(height: 20),
          labelText("Phone"),
          TextInputWidget(
            controller: phnTxtCnt,
            hintText: "",
            isObscureText: false,
            keyboardType: TextInputType.text,
            inputFormatter: [FilteringTextInputFormatter.digitsOnly],
            suffixIcon: BootstrapIcons.telephone_fill,
          ),
          const SizedBox(height: 20),
          labelText("Gender"),
          TextInputWidget(
            controller: genderTxtCnt,
            hintText: "",
            isObscureText: false,
            keyboardType: TextInputType.text,
            suffixIcon: Icons.man_4,
          ),
          const SizedBox(height: 20),
          labelText("Address"),
          TextInputWidget(
            controller: addTxtCnt,
            hintText: "",
            isObscureText: false,
            keyboardType: TextInputType.text,
            suffixIcon: FontAwesomeIcons.locationArrow,
          ),
          const SizedBox(height: 20),
          labelText("Zipcode"),
          TextInputWidget(
            controller: zipTxtCnt,
            hintText: "",
            isObscureText: false,
            keyboardType: TextInputType.text,
            inputFormatter: [FilteringTextInputFormatter.digitsOnly],
            suffixIcon: BootstrapIcons.pin_angle_fill,
          ),
          const SizedBox(height: 20),
          labelText("NID"),
          TextInputWidget(
            controller: nidTxtCnt,
            hintText: "",
            isObscureText: false,
            keyboardType: TextInputType.text,
            suffixIcon: BootstrapIcons.person_badge_fill,
          ),
          const SizedBox(height: 20),
          labelText("Facebook"),
          TextInputWidget(
              controller: fbTxtCnt,
              hintText: "",
              isObscureText: false,
              keyboardType: TextInputType.text,
              suffixIcon: BootstrapIcons.facebook),
          const SizedBox(height: 20),
          labelText("Twitter (X)"),
          TextInputWidget(
            controller: twtTxtCnt,
            hintText: "",
            isObscureText: false,
            keyboardType: TextInputType.text,
            suffixIcon: BootstrapIcons.twitter_x,
          ),
          const SizedBox(height: 20),
          labelText("LinkedIn"),
          TextInputWidget(
            controller: lnkTxtCnt,
            hintText: "",
            isObscureText: false,
            keyboardType: TextInputType.text,
            suffixIcon: BootstrapIcons.linkedin,
          ),
          const SizedBox(height: 20),
          labelText("Instagram"),
          TextInputWidget(
            controller: instrTxtCnt,
            hintText: "",
            isObscureText: false,
            keyboardType: TextInputType.text,
            suffixIcon: BootstrapIcons.instagram,
          ),
          const SizedBox(height: 20),
          labelText("Occupation"),
          const SizedBox(height: 5),
          SizedBox(
            height: 100,
            child: Center(
              child: ListView.builder(
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          sltOccupation =
                              user?.occupationList?.data?[index].id ?? -1;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                        child: ClayContainer(
                          width: 100,
                          borderRadius: 10,
                          color: AppColors.offWhite,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Text(
                                  user?.occupationList?.data?[index]
                                          .occupationName ??
                                      "",
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.montserrat(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.blue)),
                              if (user!.occupationList!.data![index].id ==
                                  sltOccupation) ...[
                                Positioned(
                                    top: 0,
                                    right: 0,
                                    child: Checkbox(
                                      value: true,
                                      onChanged: (value) {},
                                      activeColor: AppColors.blue,
                                      checkColor: AppColors.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(3)),
                                    ))
                              ]
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: user?.occupationList?.data?.length ?? 0,
                  scrollDirection: Axis.horizontal),
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  btnStyle(Color bg) {
    return ButtonStyle(
      padding:
          const MaterialStatePropertyAll(EdgeInsets.symmetric(vertical: 20)),
      backgroundColor: MaterialStatePropertyAll(bg),
      shape: MaterialStatePropertyAll(RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40),
      )),
    );
  }
}
