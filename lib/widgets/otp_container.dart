import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';

class OtpContainer extends StatelessWidget {
  String digit;
  OtpContainer({Key? key,required this.digit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return Container(
      height: size.width/10,
      width: size.width/10,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade500)

      ),
      child: Center(
          child: Text(
            digit,
            style: GoogleFonts.inter(
              fontSize: 22,
              fontWeight: FontWeight.w700
            ),
          )
      ),
    );
  }
}
