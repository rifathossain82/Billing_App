import 'package:billing_app/src/constaints/colors/AppColors.dart';
import 'package:billing_app/src/constaints/util/util.dart';
import 'package:flutter/material.dart';

import '../constaints/strings/AppStrings.dart';

class LogoName extends StatelessWidget {
  const LogoName({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(Util().logo,height: size.width*0.15, width: size.width*0.15,),
        SizedBox(width: size.width*0.03,),
        Text(
          appName,
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w700,
            shadows: [
              Shadow(
                offset: Offset(0.00, 3.00),
                color: myblack.withOpacity(0.16),
                blurRadius: 6
              )
            ]
          ),
        ),
      ],
    );
  }
}
