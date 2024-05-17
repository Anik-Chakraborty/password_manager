import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:password_manager/components/LoadingWidget.dart';
import 'package:password_manager/components/TextInputWidget.dart';
import 'package:password_manager/components/WarningDialog.dart';
import 'package:password_manager/configs/colors.dart';
import 'package:password_manager/controllers/CreatePassController.dart';
import 'package:password_manager/controllers/PasswordController.dart';
import 'package:password_manager/models/CategoryModel.dart';
import 'package:password_manager/models/GroupModel.dart';
import 'package:password_manager/models/PasswordModel.dart';

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
      backgroundColor: AppColors.primary,
      body: Stack(
        children: [
          Center(
            child: Icon(FontAwesomeIcons.key,
                color: AppColors.white.withOpacity(0.1), size: 100),
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 25, left: 10, right: 10, bottom: 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Edit Password",
                      style: GoogleFonts.montserrat(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                tabBar(),
                const SizedBox(height: 20),
                Container(
                  height: Get.height * 0.8,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: TabBarView(
                    controller: tabController,
                    children: [editPassDetailLayout(), editPassLayout()],
                  ),
                ),
              ],
            ),
          ),
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
              )),
        ],
      ),
    );
  }

  tabBar() {
    return TabBar(
        controller: tabController,
        unselectedLabelStyle: GoogleFonts.montserrat(
            fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.white),
        labelStyle: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.primary),
        indicatorColor: AppColors.white,
        indicator: const BoxDecoration(
          color: AppColors.white,
        ),
        dividerColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.tab,
        tabs: const [
          Tab(
            text: "Edit Details",
          ),
          Tab(
            text: "Edit Password",
          )
        ]);
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

              createPassController.updatePassInfo(
                  password!.id!,
                  titleCnt.text,
                  desCnt.text,
                  selectedTyp,
                  selectedCat.toString(),
                  selectedGrp.toString());
            },
            style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                backgroundColor: AppColors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                )),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Update Password",
                  style: GoogleFonts.montserrat(
                      color: AppColors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
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


              createPassController.updatePassInfo(
                  password!.id!,
                  titleCnt.text,
                  desCnt.text,
                  selectedTyp,
                  selectedCat.toString(),
                  selectedGrp.toString());
            },
            style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                backgroundColor: AppColors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                )),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Update Details",
                  style: GoogleFonts.montserrat(
                      color: AppColors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
              ],
            )),
      ],
    );
  }

  des() {
    return TextFormField(
        controller: desCnt,
        minLines: 4,
        maxLines: 6,
        style: GoogleFonts.montserrat(
          fontSize: 16,
          color: AppColors.primary,
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
                borderSide:
                    const BorderSide(color: AppColors.secondary, width: 1),
                borderRadius: BorderRadius.circular(10)),
            contentPadding: const EdgeInsets.only(
                top: 15, bottom: 0, left: 10, right: 10)));
  }

  txtTitle(String title) {
    return Text(title,
        style:
            GoogleFonts.montserrat(color: AppColors.secondary, fontSize: 16));
  }

  sltCategory() {
    return SizedBox(
      height: 100,
      child: Center(
        child: ListView.builder(
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  setState(() {
                    selectedCat = categories![index].id;
                  });
                },
                child: Container(
                  width: 100,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                      color: categories![index].id == selectedCat
                          ? AppColors.primary
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          width: 1,
                          color: categories![index].id != selectedCat
                              ? AppColors.primary
                              : Colors.transparent)),
                  child: Text(categories![index].categoryName ?? "",
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: categories![index].id == selectedCat
                              ? AppColors.white
                              : AppColors.primary)),
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
          InkWell(
            onTap: () {
              setState(() {
                selectedTyp = "Individual";
              });
            },
            child: Container(
              width: 100,
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                  color: selectedTyp == "Individual"
                      ? AppColors.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      width: 1,
                      color: selectedTyp != "Individual"
                          ? AppColors.primary
                          : Colors.transparent)),
              child: Text("Individual",
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.montserrat(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: selectedTyp == "Individual"
                          ? AppColors.white
                          : AppColors.primary)),
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                selectedTyp = "Group";
              });
            },
            child: Container(
              width: 100,
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                  color: selectedTyp == "Group"
                      ? AppColors.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      width: 1,
                      color: selectedTyp == "Group"
                          ? AppColors.white
                          : AppColors.primary)),
              child: Text("Group",
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.montserrat(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: selectedTyp == "Group"
                          ? AppColors.white
                          : AppColors.primary)),
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
              return InkWell(
                onTap: () {
                  setState(() {
                    selectedGrp = groups![index].id;
                  });
                },
                child: Container(
                  width: 100,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                      color: groups![index].id == selectedGrp
                          ? AppColors.primary
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          width: 1,
                          color: groups![index].id != selectedGrp
                              ? AppColors.primary
                              : Colors.transparent)),
                  child: Text(groups![index].groupName ?? "",
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: groups![index].id == selectedGrp
                              ? AppColors.white
                              : AppColors.primary)),
                ),
              );
            },
            itemCount: categories?.length ?? 0,
            scrollDirection: Axis.horizontal),
      ),
    );
  }
}
