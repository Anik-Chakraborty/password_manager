import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:password_manager/components/LoadingDialog.dart';
import 'package:password_manager/components/Toast.dart';
import 'package:password_manager/models/PasswordModel.dart';
import 'package:password_manager/services/ApiService.dart';

class PasswordController extends GetxController{

  List<PasswordModel>? passwords;

  getMyPasswords({String? query}) async{
    try {
      String url = dotenv.get('myPasswords');

      if(query != null){
        url = "$url?search=$query";
      }

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


  getPasswordsByCategory({String? categoryId}) async{
    try {
      String url = dotenv.get('passUnderCategory');

      if(categoryId != null){
        url = "$url/$categoryId";
      }

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


  getPasswordsByGroup({String? groupId}) async{
    try {
      String url = dotenv.get('passUnderGroup');

      if(groupId != null){
        url = "$url/$groupId";
      }

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


  Future<String?> showPassword(String id) async{
    try {

      debugPrint(id);
      showLoadingDialog();

      String url = dotenv.get('showPassword');

      var response = await ApiService.postRequest(url, {"password_id" : id});

      Get.back();

      if (response[0] == ApiStatus.completed) {

        if(ApiService.handleStatus(response[1])){
          return null;
        }

        var data = jsonDecode(response[1].body);

        debugPrint(data.toString());

        if (data['success'] ?? false) {
          return data['data']['password'] ?? "";
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

  verifyPassword(String id) async{
    try {

      String url = dotenv.get('addToVerify');

      var response = await ApiService.postRequest(url, {"password_id" : id});


      if (response[0] == ApiStatus.completed) {

        if(ApiService.handleStatus(response[1])){
          return null;
        }

        var data = jsonDecode(response[1].body);

        debugPrint(data.toString());

        if (data['success'] ?? false) {
          return true;
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