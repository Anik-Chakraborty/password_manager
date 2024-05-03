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

  TextEditingController nameTxtCnt = TextEditingController();
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
      backgroundColor: AppColors.primary,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Visibility(
        visible: allowEdit,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: Get.width * 0.4,
              child: TextButton(
                onPressed: () async{
                  setState(() {
                    allowEdit = false;
                  });
                  showLoadingDialog();
                  await userController.updateUserProfile(
                    nameTxtCnt.text, emailTxtCnt.text, phnTxtCnt.text, genderTxtCnt.text, addTxtCnt.text, zipTxtCnt.text, nidTxtCnt.text, fbTxtCnt.text, twtTxtCnt.text, lnkTxtCnt.text, instrTxtCnt.text, sltOccupation.toString()
                  );
                  Get.back();
                  },
                style: btnStyle(AppColors.green),
                child: Text("Save",
                    style: GoogleFonts.montserrat(
                        color: AppColors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
              ),
            ),
            SizedBox(
              width: Get.width * 0.4,
              child: TextButton(
                onPressed: () {
                  setState(() {
                    allowEdit = false;
                    sltOccupation = int.parse(user?.userinfo?.occupationId ?? "-1");
                  });
                },
                style: btnStyle(AppColors.secondary),
                child: Text("Cancel",
                    style: GoogleFonts.montserrat(
                        color: AppColors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
      body: Stack(
        children: [
          SizedBox(
            height: Get.height,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 30, bottom: 10),
                  padding: const EdgeInsets.all(20),
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                      color: AppColors.white, shape: BoxShape.circle),
                  child: const Icon(FontAwesomeIcons.user,
                      color: AppColors.primary, size: 40),
                ),
                user != null
                    ? userInfo()
                    : FutureBuilder(
                        future: userController.getUserProfile(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Expanded(
                                child: Center(child: LoadingWidget()));
                          } else if (snapshot.connectionState ==
                              ConnectionState.done) {
                            user = snapshot.data as UserProfileModel?;

                            if (user == null) {
                              return Text("Data not found",
                                  style: GoogleFonts.montserrat(
                                      color: AppColors.white, fontSize: 18));
                            }

                            sltOccupation =
                                int.parse(user?.userinfo?.occupationId ?? "-1");

                            return userInfo();
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
          Positioned(
              top: 20,
              right: 20,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        allowEdit = !allowEdit;
                      });
                    },
                    icon: Icon(
                      Icons.edit,
                      color: allowEdit ? AppColors.primary : AppColors.white,
                    ),
                    style: ButtonStyle(
                        shape: const MaterialStatePropertyAll(CircleBorder()),
                        backgroundColor: MaterialStatePropertyAll(
                            allowEdit ? AppColors.white : Colors.transparent)),
                  )
                ],
              )),
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
                    backgroundColor: MaterialStatePropertyAll(AppColors.white)),
              ))
        ],
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

    return Expanded(
        child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
          color: AppColors.white, borderRadius: BorderRadius.circular(10)),
      child: Stack(
        children: [
          Center(
            child: Icon(FontAwesomeIcons.key,
                color: AppColors.primary.withOpacity(0.05), size: 100),
          ),
          ListView(
            shrinkWrap: true,
            children: [
              const SizedBox(height: 5),
              TextInputWidget(
                controller: nameTxtCnt,
                hintText: "",
                isObscureText: false,
                keyboardType: TextInputType.text,
                labelText: "Name",
                readOnly: !allowEdit,
              ),
              const SizedBox(height: 20),
              TextInputWidget(
                  controller: emailTxtCnt,
                  hintText: "",
                  isObscureText: false,
                  keyboardType: TextInputType.text,
                  labelText: "Email",
                  readOnly: !allowEdit),
              const SizedBox(height: 20),
              TextInputWidget(
                  controller: phnTxtCnt,
                  hintText: "",
                  isObscureText: false,
                  keyboardType: TextInputType.text,
                  inputFormatter: [
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  labelText: "Phone",
                  readOnly: !allowEdit),
              const SizedBox(height: 20),
              TextInputWidget(
                  controller: genderTxtCnt,
                  hintText: "",
                  isObscureText: false,
                  keyboardType: TextInputType.text,
                  labelText: "Gender",
                  readOnly: !allowEdit),
              const SizedBox(height: 20),
              TextInputWidget(
                  controller: addTxtCnt,
                  hintText: "",
                  isObscureText: false,
                  keyboardType: TextInputType.text,
                  labelText: "Address",
                  readOnly: !allowEdit),
              const SizedBox(height: 20),
              TextInputWidget(
                  controller: zipTxtCnt,
                  hintText: "",
                  isObscureText: false,
                  keyboardType: TextInputType.text,
                  inputFormatter: [
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  labelText: "Zip Code",
                  readOnly: !allowEdit),
              const SizedBox(height: 20),
              TextInputWidget(
                  controller: nidTxtCnt,
                  hintText: "",
                  isObscureText: false,
                  keyboardType: TextInputType.text,
                  labelText: "NID / Password",
                  readOnly: !allowEdit),
              const SizedBox(height: 20),
              TextInputWidget(
                  controller: fbTxtCnt,
                  hintText: "",
                  isObscureText: false,
                  keyboardType: TextInputType.text,
                  labelText: "Facebook",
                  readOnly: !allowEdit),
              const SizedBox(height: 20),
              TextInputWidget(
                  controller: twtTxtCnt,
                  hintText: "",
                  isObscureText: false,
                  keyboardType: TextInputType.text,
                  labelText: "Twitter (X)",
                  readOnly: !allowEdit),
              const SizedBox(height: 20),
              TextInputWidget(
                  controller: lnkTxtCnt,
                  hintText: "",
                  isObscureText: false,
                  keyboardType: TextInputType.text,
                  labelText: "LinkedIn",
                  readOnly: !allowEdit),
              const SizedBox(height: 20),
              TextInputWidget(
                  controller: instrTxtCnt,
                  hintText: "",
                  isObscureText: false,
                  keyboardType: TextInputType.text,
                  labelText: "Instagram",
                  readOnly: !allowEdit),
              const SizedBox(height: 20),
              Text("Occupation", style: GoogleFonts.montserrat(
                color: AppColors.secondary, fontSize: 16
              )),
              const SizedBox(height: 5),
              SizedBox(
                height: 100,
                child: Center(
                  child: ListView.builder(
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            if(allowEdit){
                              setState(() {
                                sltOccupation = user?.occupationList?.data?[index].id ?? -1;
                              });
                            }
                          },
                          child: Container(
                            width: 100,
                            alignment: Alignment.center,
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                                color: user!.occupationList!.data![index].id ==
                                        sltOccupation
                                    ? AppColors.primary
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    width: 1,
                                    color: user!.occupationList!.data![index].id !=
                                            sltOccupation
                                        ? AppColors.primary
                                        : Colors.transparent)),
                            child: Text(
                                user?.occupationList?.data?[index].occupationName ??
                                    "",
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.montserrat(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: user!.occupationList!.data![index].id ==
                                            sltOccupation
                                        ? AppColors.white
                                        : AppColors.primary)),
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
        ],
      ),
    ));
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
