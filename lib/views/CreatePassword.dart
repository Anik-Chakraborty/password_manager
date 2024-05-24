import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:password_manager/components/LoadingWidget.dart';
import 'package:password_manager/components/TextInputWidget.dart';
import 'package:password_manager/configs/colors.dart';
import 'package:password_manager/controllers/CreatePassController.dart';
import 'package:password_manager/models/CategoryModel.dart';
import 'package:password_manager/models/GroupModel.dart';

class CreatePassword extends StatefulWidget {
  const CreatePassword({super.key});

  @override
  State<CreatePassword> createState() => _CreatePasswordState();
}

class _CreatePasswordState extends State<CreatePassword> {
  List<CategoryModel>? categories;

  List<GroupModel>? groups;

  int? selectedCat;
  int? selectedGrp;

  String selectedTyp = "Individual";

  CreatePassController createPassController = CreatePassController();

  TextEditingController titleCnt = TextEditingController();

  TextEditingController passCnt = TextEditingController();

  TextEditingController desCnt = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.primary,
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: 25, left: 10, right: 10, bottom: 10),
              child: Column(
                children: [
                  Text(
                    "Add Password",
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
                      color: AppColors.white,
                    ),
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        TextInputWidget(
                            controller: titleCnt,
                            hintText: "Enter Title",
                            isObscureText: false,
                            keyboardType: TextInputType.text),
                        const SizedBox(height: 20),
                        TextInputWidget(
                            controller: passCnt,
                            hintText: "Enter Password",
                            isObscureText: false,
                            keyboardType: TextInputType.text),
                        const SizedBox(height: 20),
                        txtTitle("Select Category"),
                        const SizedBox(height: 5),
                        categories != null && categories!.isNotEmpty
                            ? sltCategory()
                            : FutureBuilder(
                                future: createPassController.getCategories(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(child: LoadingWidget());
                                  } else if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    categories =
                                        snapshot.data as List<CategoryModel>?;

                                    if (categories == null ||
                                        categories!.isEmpty) {
                                      return noData();
                                    }

                                    selectedCat = categories![0].id;

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
                                visible: selectedTyp != "Individual",
                                child: sltGroup())
                            : Visibility(
                                visible: selectedTyp != "Individual",
                                child: FutureBuilder(
                                  future: createPassController.getGroups(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                          child: LoadingWidget());
                                    } else if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      groups =
                                          snapshot.data as List<GroupModel>?;

                                      if (categories == null ||
                                          categories!.isEmpty) {
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
                        Visibility(
                            visible: selectedTyp != "Individual",
                            child: const SizedBox(height: 10)),
                        des(),
                        const SizedBox(height: 20),
                        ElevatedButton(
                            onPressed: () {
                              createPassController.createPassword(
                                  titleCnt.text,
                                  desCnt.text,
                                  passCnt.text,
                                  selectedTyp,
                                  selectedCat.toString(),
                                  selectedGrp.toString());
                            },
                            style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                backgroundColor: AppColors.secondary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                )),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Save",
                                  style: GoogleFonts.montserrat(
                                      color: AppColors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            )),
                        const SizedBox(height: 10),
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
                    Get.back();
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: AppColors.primary,
                  ),
                  style: const ButtonStyle(
                      shape: MaterialStatePropertyAll(CircleBorder()),
                      backgroundColor:
                          MaterialStatePropertyAll(AppColors.white)),
                ))
          ],
        ));
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
                      color: selectedTyp != "Group"
                          ? AppColors.primary
                          : Colors.transparent)),
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

  txtTitle(String title) {
    return Text(title,
        style:
            GoogleFonts.montserrat(color: AppColors.secondary, fontSize: 16));
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
}
