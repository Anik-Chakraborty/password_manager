import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:password_manager/controllers/AuthController.dart';
import 'package:password_manager/controllers/UserController.dart';
import 'package:password_manager/models/UserModel.dart';

enum ApiStatus { error, completed }

class ApiService {

  static UserController userCtrl = UserController();

  static addBaseURL(String url) {
    return '${dotenv.get('baseURL')}$url';
  }

  static getHeader(){

    UserModel userModel = userCtrl.getUserDetails();

    Map header = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };

    if(userModel.token != null && userModel.token!.isNotEmpty){
      header["Authorization"] = "Bearer ${userModel.token}";
    }

    return header;
  }

  static getRequest(String url) async {
    try {

      url = addBaseURL(url);
      http.Response response = await http.get(
        Uri.parse(url),
        headers: getHeader(),
      );
      return [ApiStatus.completed, response];
    } catch (error) {
      debugPrint(error.toString());
      return [ApiStatus.error, []];
    }
  }

  static postRequest(String url, Map data) async {
    try {
      url = addBaseURL(url);

      String body = json.encode(data);
      http.Response response = await http.post(
        Uri.parse(url),
        body: body,
        headers: getHeader(),
      );
      return [ApiStatus.completed, response];
    } catch (error) {
      debugPrint(error.toString());
      return [ApiStatus.error, []];
    }
  }

  static handleStatus (http.Response response){

    if(response.statusCode == 401){
      AuthController authController = Get.put(AuthController());
      authController.logout();
      return true;
    }

    return false;
  }

}
