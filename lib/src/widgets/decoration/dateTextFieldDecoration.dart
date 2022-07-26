import 'package:billing_app/src/constaints/colors/AppColors.dart';
import 'package:flutter/material.dart';

InputDecoration dateTextFieldDecoration(String labelName){
  return InputDecoration(
      labelText: labelName,
      labelStyle: TextStyle(color: textColor2),
      floatingLabelAlignment: FloatingLabelAlignment.center,
      prefixIcon: Icon(Icons.calendar_month_outlined, size: 20, color: textColor2),
      contentPadding: EdgeInsets.zero,
      enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black38)
      ),
      focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black38)
      )
  );
}

