import 'package:flutter/material.dart';

import '../constaints/colors/AppColors.dart';

Widget buildTitle(String title){
  return Padding(
    padding: const EdgeInsets.only(top: 20, bottom: 8, left: 16, right: 8),
    child: Text(title, style: TextStyle(color: textColor2,),),
  );
}