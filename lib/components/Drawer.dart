import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:password_manager/configs/colors.dart';
import 'package:password_manager/configs/routes.dart';
import 'package:password_manager/controllers/UserController.dart';
import 'package:password_manager/models/UserModel.dart';

class SideDrawer extends StatefulWidget{
  const SideDrawer({super.key});

  @override
  State<SideDrawer> createState() => _SideDrawerState();
}

class _SideDrawerState extends State<SideDrawer> {

  UserModel? user;

  UserController userCtrl = UserController();

  item(String title, IconData icon, String route){
    return  InkWell(
      onTap: () {
        Get.toNamed(route);
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.secondary, size: 20),
            const SizedBox(width: 15),
            Text(title,
                style: GoogleFonts.montserrat(
                    color: AppColors.secondary, fontSize: 20)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
      return Drawer(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero
        ),
        width: Get.width * 0.7,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 10),
          child: Column(
             children: [
               Container(
                 margin: const EdgeInsets.only(bottom: 20),
                 padding: const EdgeInsets.all(30),
                 decoration: const BoxDecoration(
                   shape: BoxShape.circle,
                   color: AppColors.secondary
                 ),
                 alignment: Alignment.center,
                 child: const Icon(FontAwesomeIcons.user, color: AppColors.white, size: 40),
               ),

               Text("~ ${user?.name ?? ""}  ",style: GoogleFonts.montserrat(fontSize: 20, color: AppColors.secondary, fontWeight: FontWeight.bold),),
               const SizedBox(height: 30),
               item("Category", FontAwesomeIcons.layerGroup, AppRoutes.categories),
               item("Group", FontAwesomeIcons.userGroup, AppRoutes.groups),
               item("Authenticator", FontAwesomeIcons.google, AppRoutes.authenticator),
               item("Records", FontAwesomeIcons.clockRotateLeft, AppRoutes.records)
             ],
          ),
        ),

    );
  }

  @override
  void initState() {

    getUserData();

    super.initState();
  }

  getUserData() async{
    user = await userCtrl.getUserDetails();
    setState(() {});
  }

}