import 'dart:ui';
import 'package:flutter/material.dart';


class myAlertDialog extends StatelessWidget {

  String title;
  String content;
  String nameButton1;
  String nameButton2;
  VoidCallback voidCallback;

  myAlertDialog(this.title, this.content, this.nameButton1, this.nameButton2, this.voidCallback);
  TextStyle textStyle = TextStyle (color: Colors.black);

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child:  AlertDialog(
          title: Text(title,style: textStyle,),
          content: Text(content, style: textStyle,),
          actions: <Widget>[
            TextButton(
              child: Text(nameButton1),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(nameButton2),
              onPressed: () {
                voidCallback();
              },
            ),
          ],
        )
    );
  }
}