import 'package:billing_app/src/constaints/util/util.dart';
import 'package:billing_app/src/controller/authenticationController.dart';
import 'package:billing_app/src/model/countryCodeData.dart';
import 'package:billing_app/src/services/closeDialog.dart';
import 'package:billing_app/src/widgets/customDialog.dart';
import 'package:billing_app/src/widgets/mySnackBar.dart';
import 'package:billing_app/src/widgets/selectCountryCode.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/routes.dart';
import '../../constaints/colors/AppColors.dart';
import '../../widgets/logo_name.dart';
import '../../widgets/myButton.dart';

import '../../widgets/titleTextField.dart';
import 'otp_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController phoneController=TextEditingController();
  TextEditingController passController=TextEditingController();
  final formKey=GlobalKey<FormState>();
  final authenticationController=Get.put(AuthenticationController());

  var countryCode='880';
  var countryCodeId=18;

  bool obscureValue=true;

  late FocusNode phoneFocusNode;
  late FocusNode passwordFocusNode;

  @override
  void initState() {
    phoneFocusNode=FocusNode();
    passwordFocusNode=FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    phoneController.dispose();
    passController.dispose();
    phoneFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width*0.02),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  //logo and app name is here
                  SizedBox(height: size.height*0.1,),
                  LogoName(),

                  //phone number textField here
                  SizedBox(height: size.height*0.05,),
                  buildTitle('Phone Number'),
                  buildPhone(size),

                  //password TextField here
                  SizedBox(height: size.height*0.005,),
                  buildTitle('Password'),
                  buildPassword(size),

                  //forgot password text here
                  SizedBox(height: size.height*0.02,),
                  GestureDetector(
                    onTap: (){
                      Get.toNamed(RouteGenerator.forgotPassword);
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: Text('Forgot your password?')
                      ),
                    ),
                  ),

                  //login button here
                  SizedBox(height: size.height*0.05,),
                  myButton(
                    onTap: (){
                      loginMethod();
                    },
                    buttonText: 'LOGIN',
                    paddingHorizontal: 16,
                  ),

                  //register text here
                  SizedBox(height: size.height*0.02,),
                  InkWell(
                    onTap: (){
                      Get.offNamed(RouteGenerator.signUp);
                    },
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: RichText(
                        text: TextSpan(
                            children: [
                              TextSpan(
                                  text: "Haven't any account?",
                                  style: TextStyle(color: Colors.grey)
                              ),
                              TextSpan(
                                  text: " Register",
                                  style: TextStyle(color: mainColor)
                              )
                            ]
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildPhone(Size size){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextFormField(
        validator: (value){
          if (value!.isEmpty) {
            return 'Phone Number required!';
          }
          // else if (value.length!=numberSize ) {
          //   return 'Incorrect Phone Number!';
          // }
          else {
            return null;
          }
        },
        controller: phoneController,
        maxLines: 1,
        focusNode: phoneFocusNode,
        onEditingComplete: (){
          passwordFocusNode.requestFocus();
        },
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: '1*********',
          prefixIcon: GestureDetector(
            onTap: ()async{
              CountryCodeData result = await SelectCountryCode(size, context);
              print(result.countryCode);
              if(result.id != null){
                setState(() {
                  countryCode=result.countryCode!;
                  countryCodeId=result.id!;
                });
              }
            },
            child: Container(
              padding: EdgeInsets.only(left: 12, right: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('$countryCode'),
                  SizedBox(width: 4,),
                  Icon(Icons.arrow_drop_down, color: Colors.black.withOpacity(0.8),),
                ],
              ),
            ),
          ),
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget buildPassword(Size size){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return 'Password required!';
          }
          else if (value.length<8) {
            return 'Password must be 8 characters!';
          }
          else {
            return null;
          }
        },
        controller: passController,
        maxLines: 1,
        focusNode: passwordFocusNode,
        keyboardType: TextInputType.visiblePassword,
        obscureText: obscureValue,
        decoration: InputDecoration(
            hintText: '********',
            border: OutlineInputBorder(),
            suffixIcon: IconButton(
                onPressed: (){
                  setState(() {
                    obscureValue=!obscureValue;
                  });
                },
                icon: obscureValue?Icon(Icons.visibility_off): Icon(Icons.visibility))
        ),
      ),
    );
  }

  void loginMethod()async{
    var hasInternet = await Util().checkInternet();

    if(hasInternet){
      if (formKey.currentState!.validate()) {

        //show a loader
        customDialog();

        var result= await authenticationController.login(countryCodeId, phoneController.text, passController.text);

        //close the loader
        closeDialog();

        if(result.toString().contains('Success')){
          mySnackBar(msg: '${'Login Success'}', context: context, bgColor: mainColor, duration: Duration(seconds: 1));
          await authenticationController.showUser();  ///to load user data
          Get.to(() => OtpScreen(
              mobileNumber: '${phoneController.text}',
              countryCode: '$countryCode',
              countryCodeId: '$countryCodeId',
              routeName: RouteGenerator.mainPage));
        }
        else{
          //showToastMessage('${result}');
          mySnackBar(msg: '${result}', context: context, bgColor: mainColor, duration: Duration(seconds: 1));
        }
      }
    }
  }
}


/*
  Widget buildPhone(Size size){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextFormField(
        validator: (value){
          if (value!.isEmpty) {
            return 'Phone Number required!';
          }
          // else if (value.length!=numberSize ) {
          //   return 'Incorrect Phone Number!';
          // }
          else {
            return null;
          }
        },
        controller: phoneController,
        maxLines: 1,
        focusNode: phoneFocusNode,
        onEditingComplete: (){
          passwordFocusNode.requestFocus();
        },
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: '1*********',
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 12),
            child: myDropDown(codeList, countryCode, (val){
              setState((){ //
                countryCode=val;
                phoneFocusNode.requestFocus();

                _getNumberSize(countryCode);
              });
            }),
          ),
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
 */


/*
import 'dart:convert';

import 'package:billing_app/src/controller/authenticationController.dart';
import 'package:billing_app/src/controller/tokenController.dart';
import 'package:billing_app/src/widgets/myDropDown.dart';
import 'package:billing_app/src/widgets/mySnackBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../routes/routes.dart';
import '../../constaints/colors/AppColors.dart';
import '../../constaints/strings/AppStrings.dart';
import '../../model/userModel.dart';
import '../../widgets/logo_name.dart';
import '../../widgets/myButton.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController countryCodeController=TextEditingController();
  TextEditingController phoneController=TextEditingController();
  TextEditingController passController=TextEditingController();
  final formKey=GlobalKey<FormState>();
  final authenticationController=Get.put(AuthenticationController());

  var countryCode='+880';
  bool obscureValue=true;
  bool textEditHasFocus = false;

  late FocusNode countryCodeFocusNode;
  late FocusNode phoneFocusNode;
  late FocusNode passwordFocusNode;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    countryCodeFocusNode=FocusNode();
    phoneFocusNode=FocusNode();
    passwordFocusNode=FocusNode();


    countryCodeFocusNode.addListener(() {
      setState(() {
        textEditHasFocus = countryCodeFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    // countryCodeController.dispose();
    // phoneController.dispose();
    // passController.dispose();
    //
    // countryCodeController.dispose();
    // phoneFocusNode.dispose();
    // passwordFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width*0.02),
        child: Center(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                LogoName(),
                SizedBox(height: size.height*0.05,),
                buildPhone(size),
                SizedBox(height: size.height*0.03,),
                buildPassword(size),
                SizedBox(height: size.height*0.02,),
                GestureDetector(
                  onTap: (){
                    Get.toNamed(RouteGenerator.forgotPassword);
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Align(
                        alignment: Alignment.centerRight,
                        child: Text('Forget Passwrod')
                    ),
                  ),
                ),
                SizedBox(height: size.height*0.05,),
                myButton(
                  onTap: (){
                    loginMethod();
                  },
                  buttonText: 'LOGIN',
                  paddingHorizontal: 16,
                ),
                SizedBox(height: size.height*0.02,),
                InkWell(
                  onTap: (){
                    Get.offNamed(RouteGenerator.signUp);
                  },
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(
                                text: "Haven't any account?",
                                style: TextStyle(color: Colors.grey)
                            ),
                            TextSpan(
                                text: " Register",
                                style: TextStyle(color: mainColor)
                            )
                          ]
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCountryCode(Size size){
    return Padding(
      padding: EdgeInsets.only(left: 16),
      child: Container(
        height: size.height*0.08,
        padding: EdgeInsets.all(16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: textColor2)
        ),
        child: Text('+880'),
      ),
    );
  }

  Widget buildPhone(Size size){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextField(
        controller: phoneController,
        maxLines: 1,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: 'Phone Number',
          floatingLabelAlignment: FloatingLabelAlignment.start,
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 12),
            child: myDropDown(countryCodeList, countryCode, (val){
              setState((){ //
                countryCode=val;
                phoneFocusNode.requestFocus();
              });
            }),
          ),
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget buildPassword(Size size){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return 'Password required!';
          }
          else if (value.length<6) {
            return 'Password must be 6 characters!';
          }
          else {
            return null;
          }
        },
        controller: passController,
        maxLines: 1,
        focusNode: passwordFocusNode,
        keyboardType: TextInputType.visiblePassword,
        obscureText: obscureValue,
        decoration: InputDecoration(
            labelText: 'Password',
            border: OutlineInputBorder(),
            suffixIcon: IconButton(
                onPressed: (){
                  setState(() {
                    obscureValue=!obscureValue;
                  });
                },
                icon: obscureValue?Icon(Icons.visibility_off): Icon(Icons.visibility))
        ),
      ),
    );
  }

  void loginMethod()async{
    if (formKey.currentState!.validate()) {
      var result= await authenticationController.login(phoneController.text, passController.text);
      if(result=='Success'){
        Get.offAllNamed(RouteGenerator.mainPage);
      }
      else{
        //showToastMessage('${result}');
        mySnackBar(msg: '${result}', context: context, bgColor: Colors.red);
      }
    }
  }
}

 */
