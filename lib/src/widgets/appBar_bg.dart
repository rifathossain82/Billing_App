import 'package:flutter/material.dart';

import '../constaints/colors/AppColors.dart';

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