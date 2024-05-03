import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:password_manager/components/LoadingDialog.dart';
import 'package:password_manager/components/Toast.dart';
import 'package:password_manager/models/PasswordModel.dart';
import 'package:password_manager/services/ApiService.dart';

class PasswordController{
  getMyPasswords() async{
    try {
      String url = dotenv.get('myPasswords');

      var response = await ApiService.getRequest(url);

      if (response[0] == ApiStatus.completed) {

        if(ApiService.handleStatus(response[1])){
          return null;
        }

        var data = jsonDecode(response[1].body);

        debugPrint(data.toString());

        if (data['success'] ?? false) {

          List<PasswordModel> passwords = [];

          for(var x in data['data']){
            passwords.add(PasswordModel.fromJson(x));
          }

          return passwords;
        }

      }

      debugPrint(response[1].body.toString());
      return null;

    } catch (error) {
      showToast("Something went wrong", true);
      debugPrint(error.toString());
      return null;
    }
  }


  deletePassword(String id) async{
    try {

      showLoadingDialog();

      String url = dotenv.get('delPass') + id;

      var response = await ApiService.getRequest(url);

      Get.back();

      if (response[0] == ApiStatus.completed) {

        if(ApiService.handleStatus(response[1])){
          return null;
        }

        var data = jsonDecode(response[1].body);

        debugPrint(data.toString());

        if (data['success'] ?? false) {
          Get.back(result: true);
        }

      }

      debugPrint(response[1].body.toString());
      return null;

    } catch (error) {
      showToast("Something went wrong", true);
      debugPrint(error.toString());
      return null;
    }
  }


}