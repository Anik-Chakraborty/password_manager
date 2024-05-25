import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:password_manager/models/AddedRecordModel.dart';
import 'package:password_manager/models/ChangeRecordModel.dart';
import 'package:password_manager/models/VerifyRecordModel.dart';
import 'package:password_manager/services/ApiService.dart';

class RecordController extends GetxController{

  AddedRecordModel? addedRecords;
  VerifyRecordModel? verifyRecords;

  ChangeRecordModel? changeRecords;

  Future getAddedRecords() async{
    try {
      String url = dotenv.get('getAddedRecord');

      var response = await ApiService.getRequest(url);

      if (response[0] == ApiStatus.completed) {

        if(ApiService.handleStatus(response[1])){
          return null;
        }

        var data = jsonDecode(response[1].body);

        if (data['success']) {

          addedRecords = AddedRecordModel.fromJson(data);

          return addedRecords;
        }

      }

      debugPrint(response[1].body.toString());
      return null;

    } catch (error) {
      debugPrint(error.toString());
      return null;
    }
  }


  Future getVerifyRecords() async{
    try {
      String url = dotenv.get('getVerifyRecord');

      var response = await ApiService.getRequest(url);

      if (response[0] == ApiStatus.completed) {

        if(ApiService.handleStatus(response[1])){
          return null;
        }

        var data = jsonDecode(response[1].body);

        if (data['success']) {

          verifyRecords = VerifyRecordModel.fromJson(data);

          return verifyRecords;
        }

      }

      debugPrint(response[1].body.toString());
      return null;

    } catch (error) {
      debugPrint(error.toString());
      return null;
    }
  }


  Future getChangeRecords() async{
    try {
      String url = dotenv.get('getChangeRecord');

      var response = await ApiService.getRequest(url);

      if (response[0] == ApiStatus.completed) {

        if(ApiService.handleStatus(response[1])){
          return null;
        }

        var data = jsonDecode(response[1].body);

        if (data['success']) {

          changeRecords = ChangeRecordModel.fromJson(data);

          return changeRecords;
        }

      }

      debugPrint(response[1].body.toString());
      return null;

    } catch (error) {
      debugPrint(error.toString());
      return null;
    }
  }


}