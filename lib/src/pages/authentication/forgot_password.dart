import 'package:auto_size_text/auto_size_text.dart';
import 'package:billing_app/src/controller/authenticationController.dart';
import 'package:billing_app/src/services/closeDialog.dart';
import 'package:billing_app/src/widgets/customDialog.dart';
import 'package:billing_app/src/widgets/myButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/routes.dart';
import '../../constaints/colors/AppColors.dart';
import '../../model/countryCodeData.dart';
import '../../widgets/selectCountryCode.dart';
import 'otp_screen.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  final authenticationController = Get.put(AuthenticationController());
  TextEditingController phoneController=TextEditingController();
  final formKey=GlobalKey<FormState>();

  var countryCode='880';
  var countryCodeId=18;
  bool obscureValue=true;

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

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
        child: Form(
          key: formKey,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    //phone number textField here
                    SizedBox(height: size.height*0.005,),
                    buildTitle('Phone Number'),
                    buildPhone(size),

                    //send opt button is here
                    SizedBox(height: size.height*0.03,),
                    myButton(onTap: (){sendOtpMethod();}, buttonText: "Send OTP", paddingHorizontal: 0,),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTitle(String title){
    return Padding(
      padding: const EdgeInsets.only(top: 0, bottom: 8, left: 0, right: 0),
      child: Text(title, style: TextStyle(color: textColor2,),),
    );
  }

  Widget buildPhone(Size size){
    return TextFormField(
      validator: (value){
        if (value!.isEmpty) {
          return 'Phone Number required!';
        }
        else {
          return null;
        }
      },
      controller: phoneController,
      maxLines: 1,
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
    );
  }

  void sendOtpMethod()async{
    if (formKey.currentState!.validate()){
      customDialog();
      bool result = await authenticationController.forgetPassword(phoneController.text, countryCodeId.toString());
      closeDialog();

      if(result){
        Get.to(() => OtpScreen(
            mobileNumber: '${phoneController.text}',
            countryCode: '$countryCode',
            countryCodeId: '$countryCodeId',
            routeName: RouteGenerator.changePassword_whenForget));
      }
    }
  }

}
