import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:password_manager/components/LoadingDialog.dart';
import 'package:password_manager/components/Toast.dart';
import 'package:password_manager/configs/routes.dart';
import 'package:password_manager/models/CategoryModel.dart';
import 'package:password_manager/models/GroupModel.dart';
import 'package:password_manager/services/ApiService.dart';

class CreatePassController {
  getCategories() async {
    try {
      String url = dotenv.get('categories');

      var response = await ApiService.getRequest(url);

      if (response[0] == ApiStatus.completed) {
        if (ApiService.handleStatus(response[1])) {
          return null;
        }

        var data = jsonDecode(response[1].body);

        if (data['success']) {
          List<CategoryModel> categories = [];

          for (var x in data["data"]) {
            categories.add(CategoryModel.fromJson(x));
          }

          return categories;
        }
      }

      debugPrint(response[1].body.toString());
      return null;
    } catch (error) {
      debugPrint(error.toString());
      return null;
    }
  }

  getGroups() async {
    try {
      String url = dotenv.get('groups');

      var response = await ApiService.getRequest(url);

      if (response[0] == ApiStatus.completed) {
        if (ApiService.handleStatus(response[1])) {
          return null;
        }

        var data = jsonDecode(response[1].body);

        if (data['success']) {
          List<GroupModel> groups = [];

          for (var x in data["data"]) {
            groups.add(GroupModel.fromJson(x));
          }

          return groups;
        }
      }

      debugPrint(response[1].body.toString());
      return null;
    } catch (error) {
      debugPrint(error.toString());
      return null;
    }
  }

  createPassword(String title, String des, String pass, String type,
      String catId, String grpId) async {

    try {

      if(title.isEmpty){
        showToast("Enter Title", true);
        return false;
      }

      if(pass.isEmpty){
        showToast("Enter Password", true);
        return false;
      }

      showLoadingDialog();


      String url = dotenv.get('storePassword');

      Map body = {
        "title": title,
        "category_id": catId,
        "password_type": type,
        "encrypt_password": pass
      };

      if (type == "Group") {
        body["group_id"] = grpId;
      }

      if (des.isNotEmpty) {
        body["description"] = des;
      }


      var response = await ApiService.postRequest(url, body);

      Get.back();

      if (response[0] == ApiStatus.completed) {
        if (ApiService.handleStatus(response[1])) {
          return;
        }

        var data = jsonDecode(response[1].body);

        debugPrint(data.toString());

        if (data['success'] ?? false) {
          showToast("Saved", false);

          Get.back();

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


  updatePassInfo(int passwordId ,String title, String des, String type,
      String catId, String? grpId) async {

    try {

      if(title.isEmpty){
        showToast("Enter Title", true);
        return false;
      }


      showLoadingDialog();

      String url = dotenv.get('updatePassInfo');

      Map body = {
        "password_id" : passwordId,
        "title": title,
        "category_id": catId,
        "password_type": type,
      };

      if (type == "Group") {
        body["group_id"] = grpId;
      }

      if (des.isNotEmpty) {
        body["description"] = des;
      }


      var response = await ApiService.postRequest(url, body);

      Get.back();

      if (response[0] == ApiStatus.completed) {
        if (ApiService.handleStatus(response[1])) {
          return;
        }

        var data = jsonDecode(response[1].body);

        debugPrint(data.toString());

        if (data['success'] ?? false) {
          showToast("Updated", false);

          Get.offAllNamed(AppRoutes.nav);

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

  updatePass(int passwordId, String currentPass, String newPass, String confirmPass) async {

    try {

      if(currentPass.isEmpty){
        showToast("Enter current password", true);
        return false;
      }

      if(newPass.isEmpty){
        showToast("Enter new password", true);
        return false;
      }

      if(confirmPass.isEmpty){
        showToast("Enter confirm password", true);
        return false;
      }


      showLoadingDialog();

      String url = dotenv.get('changePass');

      Map body = {
        "current_password" : currentPass,
        "new_password": newPass,
        "confirm_password": confirmPass
      };



      var response = await ApiService.postRequest(url, body);

      Get.back();

      if (response[0] == ApiStatus.completed) {
        if (ApiService.handleStatus(response[1])) {
          return;
        }

        var data = jsonDecode(response[1].body);

        debugPrint(data.toString());

        if (data['status'] ?? false) {
          showToast("Updated", false);

          Get.offAllNamed(AppRoutes.nav);

          return true;
        }
        else{
          showToast(data['message'] ?? "Something went wrong", false);
          return false;
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
