import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:password_manager/components/LoadingDialog.dart';
import 'package:password_manager/components/Toast.dart';
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

}
