import 'package:flutter/material.dart';

class CustomBadge extends StatelessWidget {
  Color? bgColor;
  Color? textColor;
  double right;
  double top;
  String value;
  Widget child;

  CustomBadge({Key? key, this.bgColor, this.textColor, required this.right, required this.top, required this.value, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return value.toString() == '0'?
    child  ///if value == 0 then show only the widget
        :
    Stack(
      alignment: Alignment.center,
      children: [
        child,
        Positioned(
          right: right,
          top: top,
          child: Container(
            padding: const EdgeInsets.all(2.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: bgColor ?? Colors.red,
            ),
            constraints: const BoxConstraints(
              minWidth: 16,
              minHeight: 16,
            ),
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                color: bgColor ?? Colors.white,
              ),
            ),
          ),
        )
      ],
    );
  }
}
