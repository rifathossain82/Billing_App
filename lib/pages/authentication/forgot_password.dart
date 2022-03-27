import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constaints/colors/AppColors.dart';
import '../../constaints/strings/AppStrings.dart';
import '../../widgets/myDropDown.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  TextEditingController phoneController=TextEditingController();

  var countryCode='+880';
  bool obscureValue=true;

  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: myWhite,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          children: [
            SizedBox(height: size.height*0.03,),
            Align(
                alignment: Alignment.center,
                child: AutoSizeText(
                  'Please enter your phone number below to receive your OTP number.',
                  style: TextStyle(color: Colors.grey.shade500),
                  textAlign: TextAlign.center,
                )
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildPhone(size),
                  SizedBox(height: size.height*0.03,),
                  buildSendOTPButton(size),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPhone(Size size){
    return SizedBox(
      width: size.width,
      height: size.height*0.12,
      child: TextField(
        controller: phoneController,
        maxLines: 1,
        maxLength: 10,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: 'Phone Number',
          prefix: myDropDown(countryCodeList, countryCode, (val){
            setState((){ //
              countryCode=val;
            });
          }),
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget buildSendOTPButton(Size size){
    return Container(
      width: size.width,
      height: size.height*0.08,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: mainColor
      ),
      child: Center(
          child: Text(
            'Send OTP',
            style: GoogleFonts.poppins(fontSize: 18,color: myWhite),)),

    );
  }
}
