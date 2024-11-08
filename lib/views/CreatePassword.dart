import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:password_manager/components/LoadingWidget.dart';
import 'package:password_manager/components/TextInputWidget.dart';
import 'package:password_manager/configs/colors.dart';
import 'package:password_manager/controllers/CreatePassController.dart';
import 'package:password_manager/models/CategoryModel.dart';
import 'package:password_manager/models/GroupModel.dart';
import 'package:password_strength_checker/password_strength_checker.dart';

class CreatePassword extends StatefulWidget {
  const CreatePassword({super.key});

  @override
  State<CreatePassword> createState() => _CreatePasswordState();
}

class _CreatePasswordState extends State<CreatePassword> {
  final passNotifier = ValueNotifier<PasswordStrength?>(null);

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
  void initState() {
    passCnt.addListener(() {
      passNotifier.value =
          PasswordStrength.calculate(text: passCnt.text.trim());
      var x = passNotifier.value;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.offWhite,
        appBar: AppBar(
          title: Text("Add Password",
              style: GoogleFonts.montserrat(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black)),
          centerTitle: false,
          backgroundColor: AppColors.offWhite,
          surfaceTintColor: Colors.transparent,
        ),
        body: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            // color: AppColors.white,
          ),
          child: ListView(
            shrinkWrap: true,
            children: [
              TextInputWidget(
                  controller: titleCnt,
                  hintText: "Enter Title",
                  suffixIcon: FontAwesomeIcons.heading,
                  isObscureText: false,
                  keyboardType: TextInputType.text),
              const SizedBox(height: 20),
              TextInputWidget(
                  controller: passCnt,
                  hintText: "Enter Password",
                  suffixIcon: FontAwesomeIcons.key,
                  isObscureText: false,
                  keyboardType: TextInputType.text),
              const SizedBox(height: 5),
              PasswordStrengthChecker(
                strength: passNotifier,
                configuration: const PasswordStrengthCheckerConfiguration(
                    hasBorder: false, height: 10),
              ),
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
                          categories = snapshot.data as List<CategoryModel>?;

                          if (categories == null || categories!.isEmpty) {
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
                      visible: selectedTyp != "Individual", child: sltGroup())
                  : Visibility(
                      visible: selectedTyp != "Individual",
                      child: FutureBuilder(
                        future: createPassController.getGroups(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
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
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      backgroundColor: AppColors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
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
        ));
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

  txtTitle(String title) {
    return Text(title,
        style: GoogleFonts.montserrat(color: AppColors.black, fontSize: 16));
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
}
