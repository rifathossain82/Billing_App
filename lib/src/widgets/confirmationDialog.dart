
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<bool?> confirmationDialog(
    {required BuildContext context,
    required String title,
    required String negativeActionText,
    required String positiveActionText}){
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          actions: [
            TextButton(
                onPressed: () {
                  Get.back(result: false);
                },
                child: Text(negativeActionText)
            ),
            TextButton(
                onPressed: () {
                  Get.back(result: true);
                },
                child: Text(positiveActionText)
            )
          ],
        );
      });
}