import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
        Image.asset('assets/logo.png',height: size.width*0.1, width: size.width*0.1,),
        SizedBox(width: size.width*0.03,),
        Text(appName,style: GoogleFonts.poppins(fontSize: 25,fontWeight: FontWeight.w700),),
      ],
    );
  }
}
