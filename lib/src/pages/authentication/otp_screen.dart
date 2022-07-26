import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:billing_app/src/services/closeDialog.dart';
import 'package:billing_app/src/widgets/mySnackBar.dart';
import 'package:billing_app/src/widgets/showToastMessage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../routes/routes.dart';
import '../../constaints/colors/AppColors.dart';
import '../../widgets/customDialog.dart';
import '../../widgets/myButton.dart';

class OtpScreen extends StatefulWidget {
  OtpScreen({Key? key,
    required this.mobileNumber,
    required this.countryCode,
    required this.countryCodeId,
    required this.routeName}) : super(key: key);

  String mobileNumber;
  String countryCode;
  String countryCodeId;
  String routeName;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {


  TextEditingController digit1=TextEditingController();
  TextEditingController digit2=TextEditingController();
  TextEditingController digit3=TextEditingController();
  TextEditingController digit4=TextEditingController();
  // TextEditingController digit5=TextEditingController();
  // TextEditingController digit6=TextEditingController();

  int seconds=120;
  late Timer _timer;

  @override
  void initState(){
    setTimer();
    super.initState();
  }

  void setTimer(){
    _timer=Timer.periodic(Duration(seconds: 1), (timer) {
      if(seconds==0){
        setState(() {
          timer.cancel();
          print('Time out');
        });
      }
      else{
        setState(() {
          seconds--;
        });
      }
    });
  }

  @override
  void dispose() {
    digit1.dispose();
    digit2.dispose();
    digit3.dispose();
    digit4.dispose();
    //digit5.dispose();
    //digit6.dispose();

    _timer.cancel();
    super.dispose();
  }

  String showTime(int seconds){
    var minute = (seconds ~/ 60).toString().padLeft(2, '0');
    var second = (seconds % 60).toString().padLeft(2, '0');

    return '$minute : $second';
  }

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

            //header text here
            SizedBox(height: size.height*0.02,),
            Align(
              alignment: Alignment.center,
              child: AutoSizeText(
                'Check your phone number. The code is already gone to ${widget.countryCode}${widget.mobileNumber}',
                style: TextStyle(color: Colors.grey.shade500),
                textAlign: TextAlign.center,
              )
            ),

            //otp textField, timer text and verify button here
            Expanded(
              flex: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  buildOtpSection(size),
                  SizedBox(height: size.height*0.03,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: TextStyle(color: myblack),
                          children: [
                            TextSpan(
                              text: 'Code send in ',
                              style: TextStyle(fontSize: 15)
                            ),
                            TextSpan(
                                text: '${showTime(seconds)}',
                                style: TextStyle(fontSize: 15)
                            ),
                          ]
                        ),
                      ),
                      if (seconds==0) GestureDetector(
                        onTap: (){
                          setState(() {
                            _timer.cancel();
                            seconds=120;
                            setTimer();
                          });
                        },
                        child: Text(
                            ' Resend code',
                            style: TextStyle(fontSize: 15,color: mainColor)
                        ),
                      )
                      else Container()
                    ],
                  ),
                  SizedBox(height: size.height*0.05,),

                  myButton(
                    onTap: (){
                      verifyUser();
                      //exit(0);
                    },
                    buttonText: 'Verify',
                    paddingHorizontal: 0,
                  ),
                ],
              ),
            ),

            //number pad here
            Expanded(
              flex: 4,
              child: buildNumberPad(size)
            ),
            SizedBox(height: size.height*0.02,),
          ],
        ),
      ),
    );
  }

  Future<String> fetchOTP_fromLocale()async{
    var otp;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    setState(() {
      otp=sharedPreferences.getString('otp');     //fetch language
    });

    return otp.toString();
  }

  void verifyUser()async{
    var otpNumber;
    if(digit1.text.isEmpty){
      showToastMessage('Please, Enter the full OTP.');
    }
    else if(digit2.text.isEmpty){
      showToastMessage('Please, Enter the full OTP.');
    }
    else if(digit3.text.isEmpty){
      showToastMessage('Please, Enter the full OTP.');
    }
    else if(digit4.text.isEmpty){
      showToastMessage('Please, Enter the full OTP.');
    }
    else{
      otpNumber = '${digit1.text}${digit2.text}${digit3.text}${digit4.text}';
      print(otpNumber);
      final userOTP = await fetchOTP_fromLocale();
      print('User otp: $userOTP');

      if(otpNumber == userOTP){
        print('Opt Match');
        _timer.cancel();
        customDialog();
        await Future.delayed(Duration(seconds: 2));
        closeDialog();

        if(widget.routeName == RouteGenerator.changePassword_whenForget){
          Get.toNamed(
              widget.routeName,
              arguments: {
                'mobileNumber' : '${widget.mobileNumber}',
                'countryCodeId' : '${widget.countryCodeId}',
              }
          );
        }
        else{
          Get.offAllNamed(widget.routeName);
        }
      }
      else{
        mySnackBar(msg: 'Incorrect OTP', context: context);
        print('Otp did not match');
      }
    }
  }

  Widget buildOtpSection(Size size){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        buildOtpTextField(digit1, size),
        buildOtpTextField(digit2, size),
        buildOtpTextField(digit3, size),
        buildOtpTextField(digit4, size),
        //buildOtpTextField(digit5, size),
        //buildOtpTextField(digit6, size),
      ],
    );
  }

  Widget buildOtpTextField(TextEditingController controller, Size size){
    return Container(
      height: size.width/8,
      width: size.width/8,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade500)

      ),
      child: Center(
          child: TextField(
            readOnly: true,
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
            controller: controller,
            inputFormatters: [
              LengthLimitingTextInputFormatter(1),
              FilteringTextInputFormatter.digitsOnly
            ],
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero
            ),
          )
      ),
    );
  }

  Widget buildNumberPad(Size size){
    return Container(
      width: size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: mainColor.withOpacity(0.1)
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
              Expanded(child: buildSingleNumberPad(size, '7')),
              Expanded(child: buildSingleNumberPad(size, '8')),
              Expanded(child: buildSingleNumberPad(size, '9')),
            ],
          ),
          Row(
            children: [
              Expanded(child: Center()),
              Expanded(child: buildSingleNumberPad(size, '0')),
              Expanded(
                  child: IconButton(
                      onPressed: (){
                        setState(() {
                          // if(digit6.text.isNotEmpty){
                          //   digit6.clear();
                          // }
                          // else if(digit5.text.isNotEmpty){
                          //   digit5.clear();
                          // }
                          //else
                          if(digit4.text.isNotEmpty){
                            digit4.clear();
                          }
                          else if(digit3.text.isNotEmpty){
                            digit3.clear();
                          }
                          else if(digit2.text.isNotEmpty){
                            digit2.clear();
                          }
                          else if(digit1.text.isNotEmpty){
                            digit1.clear();
                          }
                          else{

                          }
                        });
                      },
                      icon: Icon(Icons.backspace_outlined)
                  )
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildSingleNumberPad(Size size, String number){
    return InkWell(
      onTap: (){
        setState(() {
          if(digit1.text.isEmpty){
            digit1.text=number;
          }
          else if(digit2.text.isEmpty){
            digit2.text=number;
          }
          else if(digit3.text.isEmpty){
            digit3.text=number;
          }
          else if(digit4.text.isEmpty){
            digit4.text=number;
          }
          // else if(digit5.text.isEmpty){
          //   digit5.text=number;
          // }
          // else if(digit6.text.isEmpty){
          //   digit6.text=number;
          // }
          else{

          }
        });
      },
      borderRadius: BorderRadius.circular(100),
      child: Container(
        height: size.height/12,
        width: size.width/8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16)
        ),
        child: Center(
            child: Text(
              number,
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w400
              ),
            )
        ),
      ),
    );
  }
}
