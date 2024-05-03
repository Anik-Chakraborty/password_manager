import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:password_manager/components/LoadingWidget.dart';

showLoadingDialog() {

  Get.dialog(
  AlertDialog(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: const LoadingWidget())
          ],
        ),
      ),
    barrierDismissible: false,
  );

}
