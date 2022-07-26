
import 'package:flutter/material.dart';

import '../constaints/colors/AppColors.dart';

class myButton extends StatelessWidget {
  myButton({
    Key? key,
    required this.onTap,
    required this.buttonText,
    required this.paddingHorizontal,
    this.fontSize,
    this.fontWeight,
    this.textColor,
    this.bgColor
  }) : super(key: key);

  VoidCallback onTap;
  String buttonText;
  double paddingHorizontal;
  double? fontSize;
  FontWeight? fontWeight;
  Color? textColor;
  Color? bgColor;

  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
        child: Container(
          width: size.width,
          height: size.height*0.07,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: bgColor==null?mainColor:bgColor
          ),
          child: Center(
              child: Text(
                buttonText,
                style: TextStyle(
                    fontSize: fontSize==null?16:fontSize,
                    fontWeight: fontWeight==null?FontWeight.w500:fontWeight,
                    color: textColor==null?myWhite:textColor,
                ),
              )
          ),

        ),
      ),
    );
  }
}