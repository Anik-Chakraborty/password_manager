import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:password_manager/components/LoadingDialog.dart';
import 'package:password_manager/components/Toast.dart';
import 'package:password_manager/configs/routes.dart';
import 'package:password_manager/configs/validators.dart';
import 'package:password_manager/controllers/UserController.dart';
import 'package:password_manager/services/ApiService.dart';

class AuthController extends GetxController {
  RxBool loadingState = false.obs;

  UserController userCtrl = UserController();

  updateLoadingState(bool state) {
    loadingState.value = state;
  }

  Future<bool> login(String email, String password) async {

    await userCtrl.clearUserDetails();

    String? isEmailValidated = Validate.email(email);
    if (isEmailValidated != null) {
      showToast(isEmailValidated, false);
      return false;
    }

    String? isPasswordValidated = Validate.password(password);
    if (isPasswordValidated != null) {
      showToast(isPasswordValidated, true);
      return false;
    }

    Map body = {"email": email, "password": password};

    try {
      String url = dotenv.get('login');

      var response = await ApiService.postRequest(url, body);

      if (response[0] == ApiStatus.completed) {
        var data = jsonDecode(response[1].body);
        debugPrint(data.toString());
        if (data['success']) {
          showToast('Login Successful', false);

          await userCtrl.storeUserDetails(
              email: data['data']['email'],
              id: data['data']['id'],
              token: data['data']['token'],
              role: data['data']['name']);

          return true;
        }
        debugPrint(data.toString());
        showToast('Invalid Data', true);
        return false;
      } else {
        return false;
      }
    } catch (error) {
      debugPrint(error.toString());
      return false;
    }
  }

  logout() async {
    showLoadingDialog();
    try {
      String url = dotenv.get('logout');
      await ApiService.postRequest(url, {});
    } catch (error) {
      debugPrint(error.toString());
    }
    Get.back();
    await userCtrl.clearUserDetails();
    Get.offAllNamed(AppRoutes.logIn);
  }
}
