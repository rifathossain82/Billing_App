import 'package:billing_app/src/constaints/util/util.dart';
import 'package:flutter/material.dart';

InputDecoration searchTextFieldDecoration(String hintTxt, TextEditingController controller){
  return InputDecoration(
      hintText: hintTxt,
      prefixIcon: Icon(Icons.search),
      suffixIconConstraints: const BoxConstraints(
        minWidth: 2,
        minHeight: 2,
      ),
      suffix: Builder(
        builder: (context) {
          return GestureDetector(
            onTap: (){
              controller.text='';
              Util.hideKeyboard(context);
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 8),
              child: Icon(Icons.close, size: 14,),
            )
          );
        }
      ),
      fillColor: Colors.white,
      filled: true,
      contentPadding: EdgeInsets.zero,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide:
          BorderSide(color: Colors.transparent, width: 0)
      ),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide:
          BorderSide(color: Colors.transparent, width: 0)
      ),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide:
          BorderSide(color: Colors.transparent, width: 0)
      )
  );
}

