import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'package:password_manager/components/Toast.dart';
import 'package:password_manager/models/OccupationModel.dart';
import 'package:password_manager/models/UserModel.dart';
import 'package:password_manager/models/UserProfileModel.dart';
import 'package:password_manager/services/ApiService.dart';

class UserController{

  final box = GetStorage();


  //store in local storage
  storeUserDetails({String? email, String? role, String? token, int? id}) async{
    await box.write("email", email);
    await box.write("role", role);
    await box.write("token", token);
    await box.write("id", id);
  }

  //get data from local storage
  UserModel getUserDetails(){

    UserModel user = UserModel();

    user.email = box.read("email");
    user.name = box.read("role");
    user.token = box.read("token");
    user.id = box.read("id");

    return user;

  }


  //clear local storage
  clearUserDetails() async{
    await box.remove("email");
    await box.remove("role");
    await box.remove("token");
    await box.remove("id");
  }


  //get data from api
  getUserProfile() async{

    try {
      String url = dotenv.get('userDetail');

      var response = await ApiService.getRequest(url);

      if (response[0] == ApiStatus.completed) {

        if(ApiService.handleStatus(response[1])){
          return null;
        }

        var data = jsonDecode(response[1].body);

        if (data['success']) {
          UserProfileModel user = UserProfileModel.fromJson(data["data"]);

          user.occupationList =  await getOccupationList(user);

          return user;
        }

      }

      debugPrint(response[1].body.toString());
      return null;

    } catch (error) {
      debugPrint(error.toString());
      return null;
    }
  }


  getOccupationList(UserProfileModel user) async{
    try {
      String url = dotenv.get('occupationList');

      var response = await ApiService.getRequest(url);

      if (response[0] == ApiStatus.completed) {

        if(ApiService.handleStatus(response[1])){
          return null;
        }

        var data = jsonDecode(response[1].body);

        if (data['success']) {

          OccupationModel occupationModel = OccupationModel.fromJson(data);

          return occupationModel;
        }

      }

      debugPrint(response[1].body.toString());
      return null;

    } catch (error) {
      debugPrint(error.toString());
      return null;
    }
  }


  updateUserProfile(String name, String email, String phone, String gender, String address, String zip, String nid, String fb, String twt, String lnk, String instr, String occupation) async{

    try {
      String url = dotenv.get('updateUserInfo');

      Map body = {
        "name" : name,
        "email" : email,
        "phone" : phone,
        "gender" : gender,
        "address" : address,
        "zip_code" : zip,
        "nid_passport_no" : nid,
        "facebook_profile_url" : fb,
        "twitter_profile_url" : twt,
        "linkedin_profile_url" : lnk,
        "instagram_profile_url" : instr,
        "occupation_id" : occupation,
        "status" : "Active"
      };

      var response = await ApiService.postRequest(url, body);

      if (response[0] == ApiStatus.completed) {

        if(ApiService.handleStatus(response[1])){
          return;
        }

        var data = jsonDecode(response[1].body);

        debugPrint(data.toString());

        if (data['status'] ?? false) {

          UserModel user = getUserDetails();

          storeUserDetails(email: email, role: name, id: user.id, token: user.token);
          showToast("Updated Successfully", false);

          return true;
        }

      }

      showToast("Something went wrong", true);
      debugPrint(response[1].body.toString());
      return false;

    } catch (error) {
      showToast("Something went wrong", true);
      debugPrint(error.toString());
      return false;
    }
  }

}