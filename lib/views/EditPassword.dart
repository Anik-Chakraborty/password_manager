import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:password_manager/components/LoadingWidget.dart';
import 'package:password_manager/components/ShowQR.dart';
import 'package:password_manager/components/TextInputWidget.dart';
import 'package:password_manager/components/Toast.dart';
import 'package:password_manager/components/WarningDialog.dart';
import 'package:password_manager/components/check2FA.dart';
import 'package:password_manager/configs/colors.dart';
import 'package:password_manager/controllers/AuthController.dart';
import 'package:password_manager/controllers/CreatePassController.dart';
import 'package:password_manager/controllers/PasswordController.dart';
import 'package:password_manager/controllers/UserController.dart';
import 'package:password_manager/models/CategoryModel.dart';
import 'package:password_manager/models/GroupModel.dart';
import 'package:password_manager/models/PasswordModel.dart';
import 'package:password_manager/models/UserProfileModel.dart';

class EditPasswordScreen extends StatefulWidget {
  const EditPasswordScreen({super.key});

  @override
  State<EditPasswordScreen> createState() => _EditPasswordScreenState();
}

class _EditPasswordScreenState extends State<EditPasswordScreen>
    with TickerProviderStateMixin {
  late TabController tabController;

  int? selectedCat;
  int? selectedGrp;

  CreatePassController createPassController = CreatePassController();
  AuthController authController = Get.put(AuthController());
  UserController userController = Get.put(UserController());


  String selectedTyp = "Individual";

  PasswordModel? password;

  List<CategoryModel>? categories;
  List<GroupModel>? groups;

  PasswordController passwordController = PasswordController();

  TextEditingController titleCnt = TextEditingController();
  TextEditingController desCnt = TextEditingController();


  TextEditingController currentPassCnt = TextEditingController();
  TextEditingController newPassCnt = TextEditingController();
  TextEditingController confirmPassCnt = TextEditingController();



  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this, initialIndex: 0);

    password = Get.arguments;

    try {
      selectedTyp = password?.passwordType ?? "";
      titleCnt.text = password?.title ?? "";
      desCnt.text = password?.description ?? "";
      selectedCat = int.parse(password!.categoryId!);
      selectedGrp = int.parse(password!.groupId!);
    } catch (error) {
      debugPrint("Edit Pass Init Error");
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.offWhite,
        appBar: AppBar(
          title: Text("Edit Password",
              style: GoogleFonts.montserrat(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black)),
          bottom: tabBar(),
          centerTitle: false,
          backgroundColor: AppColors.offWhite,
          surfaceTintColor: Colors.transparent,
        ),
      body:
          Padding(
            padding:
                const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
            child: Column(
              children: [
                Container(
                  height: Get.height * 0.8,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10)),
                  child: TabBarView(
                    controller: tabController,
                    children: [editPassDetailLayout(), editPassLayout()],
                  ),
                ),
              ],
            ),
          ),
    );
  }

  tabBar() {
    return PreferredSize(
      preferredSize: const Size(double.infinity, 50),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: AppColors.blue.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12)
        ),
        child: TabBar(
            controller: tabController,
            unselectedLabelStyle: GoogleFonts.montserrat(
                fontSize: 16, color: Colors.black),
            labelStyle: GoogleFonts.montserrat(
                fontSize: 16,
                color: AppColors.white),
            indicatorColor: AppColors.white,
            indicator: const BoxDecoration(
              color: AppColors.blue,
              borderRadius: BorderRadius.all(Radius.circular(10))
            ),
            dividerColor: Colors.transparent,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorPadding: const EdgeInsets.symmetric(vertical: 5),
            tabs: const [
              Tab(
                text: "Edit Details",
              ),
              Tab(
                text: "Edit Password",
              )
            ]),
      ),
    );
  }

  editPassLayout() {
    return ListView(
      children: [
        txtTitle("Current Password"),
        TextInputWidget(
          controller: currentPassCnt,
          hintText: "Enter current password",
          isObscureText: true,
          keyboardType: TextInputType.text,
          readOnly: false,
        ),
        const SizedBox(height: 20),
        txtTitle("New Password"),
        TextInputWidget(
          controller: newPassCnt,
          hintText: "Enter new password",
          isObscureText: true,
          keyboardType: TextInputType.text,
          readOnly: false,
        ),
        const SizedBox(height: 20),
        txtTitle("Confirm Password"),
        TextInputWidget(
          controller: confirmPassCnt,
          hintText: "Enter confirm password",
          isObscureText: true,
          keyboardType: TextInputType.text,
          readOnly: false,
        ),

        const SizedBox(height: 30),
        ElevatedButton(
            onPressed: () async{

              if(password == null){
                return;
              }

              bool status = await showWarningDialog();

              if(status == false){
                return;
              }

              bool isVerified = false;

              UserProfileModel? user = await userController.getUserProfile();

              if (user?.isAuthenticator != "1") {
                //google authenticator is not enable
                var qr =
                await authController.showAuthenticatorQR();

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
              }
              else if(user?.isAuthenticator == "1"){
                isVerified = true;
              }

              if (isVerified) {
                createPassController.updatePass(
                    password!.id!,
                    currentPassCnt.text,
                    newPassCnt.text,
                    confirmPassCnt.text);
              }

              },
            style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                backgroundColor: AppColors.blue,
                shadowColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                )),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Update Password",
                  style: GoogleFonts.montserrat(
                      color: AppColors.white,
                      fontSize: 20),
                ),
                const Icon(FontAwesomeIcons.solidPaperPlane, color: AppColors.white)
              ],
            )),
      ],
    );
  }

  editPassDetailLayout() {
    return ListView(
      shrinkWrap: true,
      children: [
        TextInputWidget(
          controller: titleCnt,
          hintText: "Enter Title",
          isObscureText: false,
          keyboardType: TextInputType.text,
          readOnly: false,
        ),
        const SizedBox(height: 20),
        des(),
        const SizedBox(height: 20),
        txtTitle("Select Category"),
        const SizedBox(height: 5),
        categories != null && categories!.isNotEmpty
            ? sltCategory()
            : FutureBuilder(
                future: createPassController.getCategories(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: LoadingWidget());
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    categories = snapshot.data as List<CategoryModel>?;

                    if (categories == null || categories!.isEmpty) {
                      return noData();
                    }

                    selectedCat ??= categories![0].id;

                    return sltCategory();
                  } else {
                    return noData();
                  }
                },
              ),
        const SizedBox(height: 20),
        txtTitle("Select Type"),
        const SizedBox(height: 5),
        sltType(),
        const SizedBox(height: 20),
        Visibility(
            visible: selectedTyp != "Individual",
            child: txtTitle("Select Group")),
        const SizedBox(height: 5),
        groups != null && groups!.isNotEmpty
            ? Visibility(
                visible: selectedTyp != "Individual", child: sltGroup())
            : Visibility(
                visible: selectedTyp != "Individual",
                child: FutureBuilder(
                  future: createPassController.getGroups(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: LoadingWidget());
                    } else if (snapshot.connectionState ==
                        ConnectionState.done) {
                      groups = snapshot.data as List<GroupModel>?;

                      if (categories == null || categories!.isEmpty) {
                        return noData();
                      }

                      selectedGrp = groups![0].id;

                      return sltGroup();
                    } else {
                      return noData();
                    }
                  },
                ),
              ),
        const SizedBox(height: 30),
        ElevatedButton(
            onPressed: () async{
              if(password == null){
                return;
              }

              bool status = await showWarningDialog();

              if(status == false){
                return;
              }

              bool isVerified = false;

              UserProfileModel? user = await userController.getUserProfile();

              if (user?.isAuthenticator != "1") {
                //google authenticator is not enable
                var qr =
                await authController.showAuthenticatorQR();

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
              }
              else if(user?.isAuthenticator == "1"){
                isVerified = true;
              }

              if (isVerified) {
                createPassController.updatePassInfo(
                    password!.id!,
                    titleCnt.text,
                    desCnt.text,
                    selectedTyp,
                    selectedCat.toString(),
                    selectedGrp.toString());
              }

            },
            style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                backgroundColor: AppColors.blue,
                shadowColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                )),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Update Details",
                  style: GoogleFonts.montserrat(
                      color: AppColors.white,
                      fontSize: 20),
                ),
                const Icon(FontAwesomeIcons.solidPaperPlane, color: AppColors.white)
              ],
            )),
      ],
    );
  }

  des() {
    return ClayContainer(
      color: AppColors.offWhite,
      borderRadius: 5,
      child: TextFormField(
          controller: desCnt,
          minLines: 4,
          maxLines: 6,
          style: GoogleFonts.montserrat(
            fontSize: 16,
            color: AppColors.blue,
          ),
          decoration: InputDecoration(
              hintText: "Enter Description",
              hintStyle: GoogleFonts.montserrat(
                color: Colors.grey,
                fontSize: 16,
              ),
              border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.circular(10)),
              focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.blue, width: 1),
                  borderRadius: BorderRadius.circular(10)),
              contentPadding: const EdgeInsets.only(
                  top: 15, bottom: 0, left: 10, right: 10))),
    );
  }

  txtTitle(String title) {
    return Text(title,
        style: GoogleFonts.montserrat(color: AppColors.black, fontSize: 16));
  }

  sltCategory() {
    return SizedBox(
      height: 100,
      child: Center(
        child: ListView.builder(
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedCat = categories![index].id;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: ClayContainer(
                    width: 100,
                    borderRadius: 10,
                    color: AppColors.offWhite,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Text(categories![index].categoryName ?? "",
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.montserrat(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.blue)),
                        if (categories![index].id == selectedCat) ...[
                          Positioned(
                              top: 0,
                              right: 0,
                              child: Checkbox(
                                value: true,
                                onChanged: (value) {},
                                activeColor: AppColors.blue,
                                checkColor: AppColors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(3)),
                              ))
                        ]
                      ],
                    ),
                  ),
                ),
              );
            },
            itemCount: categories?.length ?? 0,
            scrollDirection: Axis.horizontal),
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

  sltType() {
    return SizedBox(
      height: 100,
      child: Center(
        child: ListView(scrollDirection: Axis.horizontal, children: [
          GestureDetector(
            onTap: () {
              setState(() {
                selectedTyp = "Individual";
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: ClayContainer(
                width: 100,
                color: AppColors.offWhite,
                borderRadius: 10,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Text("Individual",
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.montserrat(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.blue)),
                    if (selectedTyp == "Individual") ...[
                      Positioned(
                          top: 0,
                          right: 0,
                          child: Checkbox(
                            value: true,
                            onChanged: (value) {},
                            activeColor: AppColors.blue,
                            checkColor: AppColors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(3)),
                          ))
                    ]
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                selectedTyp = "Group";
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: ClayContainer(
                width: 100,
                color: AppColors.offWhite,
                borderRadius: 10,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Text("Group",
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.montserrat(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.blue)),
                    if (selectedTyp == "Group") ...[
                      Positioned(
                          top: 0,
                          right: 0,
                          child: Checkbox(
                            value: true,
                            onChanged: (value) {},
                            activeColor: AppColors.blue,
                            checkColor: AppColors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(3)),
                          ))
                    ]
                  ],
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  sltGroup() {
    return SizedBox(
      height: 100,
      child: Center(
        child: ListView.builder(
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedGrp = groups![index].id;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: ClayContainer(
                    width: 100,
                    color: AppColors.offWhite,
                    borderRadius: 10,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Text(groups![index].groupName ?? "",
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.montserrat(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.blue)),
                        if (groups![index].id == selectedGrp) ...[
                          Positioned(
                              top: 0,
                              right: 0,
                              child: Checkbox(
                                value: true,
                                onChanged: (value) {},
                                activeColor: AppColors.blue,
                                checkColor: AppColors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(3)),
                              ))
                        ]
                      ],
                    ),
                  ),
                ),
              );
            },
            itemCount: groups?.length ?? 0,
            scrollDirection: Axis.horizontal),
      ),
    );
  }
}
