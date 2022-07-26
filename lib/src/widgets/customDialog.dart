import 'package:flutter/material.dart';
import 'package:get/get.dart';

void customDialog(){
  Get.defaultDialog(
      title: '',
      content: Image.asset('assets/icons/loading.gif'),
      backgroundColor: Colors.white,
      //contentPadding: EdgeInsets.only(top: 50),
      barrierDismissible: false,
      // cancel: TextButton(
      //     onPressed: (){
      //       //Get.close(0);
      //       //Get.back();
      //     },
      //     child: Text('Cancel')
      // ),
      //
  );
}