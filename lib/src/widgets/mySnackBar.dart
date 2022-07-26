import 'package:flutter/material.dart';

void mySnackBar(
    {required String msg, required BuildContext context, Color? bgColor, Color? textColor, Duration? duration}){
  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: bgColor,
        duration: duration == null ? Duration(seconds: 1) : duration,
        content: Text(msg, style: TextStyle(color: textColor),),
      ),
  );
}
