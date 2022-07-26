import 'package:flutter/material.dart';
import '../../constaints/colors/AppColors.dart';

Widget NavigationDrawerItem(IconData icon,String text,GestureTapCallback onTap){
  return ListTile(
    title: Row(
      children: [
        Icon(icon, color: textColor2,),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(text, style: TextStyle(color: textColor1),),
        ),
      ],
    ),
    onTap: onTap,
  );
}