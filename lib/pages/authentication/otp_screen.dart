import 'package:auto_size_text/auto_size_text.dart';
import 'package:billing_app/constaints/colors/AppColors.dart';
import 'package:billing_app/widgets/otp_container.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({Key? key}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Verification Phone'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: myWhite,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          children: [
            SizedBox(height: size.height*0.02,),
            Align(
              alignment: Alignment.center,
              child: AutoSizeText(
                'Check your phone number. The code is already gone.',
                style: TextStyle(color: Colors.grey.shade500),
                textAlign: TextAlign.center,
              )
            ),
            Expanded(
              flex: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  buildOtpSection(),
                  SizedBox(height: size.height*0.03,),
                  RichText(
                    text: TextSpan(
                      style: GoogleFonts.inter(color: myblack),
                      children: [
                        TextSpan(
                          text: 'Code send in ',
                          style: TextStyle(fontSize: 15)
                        ),
                        TextSpan(
                            text: '0:30',
                            style: TextStyle(fontSize: 15)
                        ),
                        TextSpan(
                            text: ' Resend code',
                            style: TextStyle(fontSize: 15,color: myDeepOrange)
                        )
                      ]
                    ),
                  ),
                  SizedBox(height: size.height*0.05,),
                  buildVerifyButton(size),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: buildNumberPad(size)
            ),
            SizedBox(height: size.height*0.02,),
          ],
        ),
      ),
    );
  }

  Widget buildOtpSection(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        OtpContainer(digit: '2'),
        OtpContainer(digit: '4'),
        OtpContainer(digit: '4'),
        OtpContainer(digit: '0'),
        OtpContainer(digit: '1'),
        OtpContainer(digit: '2'),
      ],
    );
  }

  Widget buildVerifyButton(Size size){
    return Container(
      width: size.width,
      height: size.height*0.08,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: myDeepOrange
      ),
      child: Center(
          child: Text(
            'Verify',
            style: GoogleFonts.poppins(fontSize: 22,color: myWhite),)),

    );
  }

  Widget buildNumberPad(Size size){
    return Container(
      width: size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: myDeepOrange.withOpacity(0.1)
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            children: [
              Expanded(child: buildSingleNumberPad(size, '1')),
              Expanded(child: buildSingleNumberPad(size, '2')),
              Expanded(child: buildSingleNumberPad(size, '3')),
            ],
          ),
          Row(
            children: [
              Expanded(child: buildSingleNumberPad(size, '4')),
              Expanded(child: buildSingleNumberPad(size, '5')),
              Expanded(child: buildSingleNumberPad(size, '6')),
            ],
          ),
          Row(
            children: [
              Expanded(child: Center()),
              Expanded(child: buildSingleNumberPad(size, '0')),
              Expanded(child: IconButton(onPressed: (){}, icon: Icon(Icons.backspace_outlined))),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildSingleNumberPad(Size size, String number){
    return Container(
      height: size.height/12,
      width: size.width/8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16)
      ),
      child: Center(
          child: Text(
            number,
            style: GoogleFonts.inter(
                fontSize: 35,
                fontWeight: FontWeight.w400
            ),
          )
      ),
    );
  }
}
