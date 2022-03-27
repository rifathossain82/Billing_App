import 'package:billing_app/constaints/colors/AppColors.dart';
import 'package:flutter/material.dart';

Widget AppBar_bg(){
  return Container(
    decoration: BoxDecoration(
      // ignore: prefer_const_constructors
        gradient: LinearGradient(
            colors: [
              mainColor,
              mainColor,
            ],
            begin: Alignment.bottomRight,
            end: Alignment.topLeft
        )
    ),
  );
}