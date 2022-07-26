import 'package:flutter/material.dart';

class ShowNoItem extends StatelessWidget {
  ShowNoItem({Key? key, this.iconData, this.imagePath, required this.title}) : super(key: key);

  IconData? iconData;
  String? imagePath;
  String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        iconData != null ?
        Icon(iconData, color: Colors.grey, size: 100,)
            :
        imagePath != null ? Image.asset('$imagePath', height: 100, width: 100, fit: BoxFit.cover,)
            :
        Container(),

        Text(title,style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Colors.grey),),
      ],
    );
  }
}
