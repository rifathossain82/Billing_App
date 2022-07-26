import 'package:flutter/cupertino.dart';

Widget myText(String text, TextStyle style, Color color){
  return Text(
    text,
    style: style.copyWith(color: color)
  );
}