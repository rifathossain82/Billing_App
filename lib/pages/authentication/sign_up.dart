import 'package:billing_app/routes/routes.dart';
import 'package:billing_app/widgets/logo_name.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constaints/colors/AppColors.dart';
import '../../constaints/strings/AppStrings.dart';
import '../../widgets/countryCodeDropDown.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController nameController=TextEditingController();
  TextEditingController phoneController=TextEditingController();
  TextEditingController emailController=TextEditingController();
  TextEditingController passController=TextEditingController();
  TextEditingController confirmPassController=TextEditingController();

  var countryCode='+880';
  bool obscureValue1=true;
  bool obscureValue2=true;

  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              LogoName(),
              SizedBox(height: size.height*0.05,),
              buildName(size),
              SizedBox(height: size.height*0.03,),
              buildPhone(size),
              SizedBox(height: size.height*0.03,),
              buildEmail(size),
              SizedBox(height: size.height*0.03,),
              buildPassword(size),
              SizedBox(height: size.height*0.03,),
              buildConfirmPassword(size),
              SizedBox(height: size.height*0.05,),
              buildRegisterButton(size),
              SizedBox(height: size.height*0.02,),
              InkWell(
                onTap: (){
                  Navigator.pushReplacementNamed(context, RouteGenerator.login);
                },
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                child: RichText(
                  text: TextSpan(
                      children: [
                        TextSpan(
                            text: "Already have an account?",
                            style: GoogleFonts.poppins(color: Colors.grey)
                        ),
                        TextSpan(
                            text: " Log In",
                            style: GoogleFonts.poppins(color: myDeepOrange)
                        )
                      ]
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildName(Size size){
    return SizedBox(
      width: size.width,
      height: size.height*0.08,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: TextField(
          controller: nameController,
          maxLines: 1,
          keyboardType: TextInputType.name,
          decoration: InputDecoration(
              labelText: 'Company & Business Name',
              border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }

  Widget buildPhone(Size size){
    return SizedBox(
      width: size.width,
      height: size.height*0.08,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: TextField(
          controller: phoneController,
          maxLines: 1,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Phone Number',
            prefix: CountryCodeDropDown(countryCodeList, countryCode, (val){
              setState((){ //
                countryCode=val;
              });
            }),
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }

  Widget buildEmail(Size size){
    return SizedBox(
      width: size.width,
      height: size.height*0.08,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: TextField(
          controller: emailController,
          maxLines: 1,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'Email Address',
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }

  Widget buildPassword(Size size){
    return SizedBox(
      width: size.width,
      height: size.height*0.08,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: TextField(
          controller: passController,
          maxLines: 1,
          keyboardType: TextInputType.visiblePassword,
          obscureText: obscureValue1,
          decoration: InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
              suffix: IconButton(
                  onPressed: (){
                    setState(() {
                      obscureValue1=!obscureValue1;
                    });
                  },
                  icon: obscureValue1?Icon(Icons.visibility_off): Icon(Icons.visibility))
          ),
        ),
      ),
    );
  }

  Widget buildConfirmPassword(Size size){
    return SizedBox(
      width: size.width,
      height: size.height*0.08,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: TextField(
          controller: confirmPassController,
          maxLines: 1,
          keyboardType: TextInputType.visiblePassword,
          obscureText: obscureValue2,
          decoration: InputDecoration(
              labelText: 'Confirm Password',
              border: OutlineInputBorder(),
              suffix: IconButton(
                  onPressed: (){
                    setState(() {
                      obscureValue2=!obscureValue2;
                    });
                  },
                  icon: obscureValue2?Icon(Icons.visibility_off,): Icon(Icons.visibility),
              )
          ),
        ),
      ),
    );
  }

  Widget buildRegisterButton(Size size){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        width: size.width,
        height: size.height*0.08,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: myDeepOrange
        ),
        child: InkWell(
          onTap: (){
            Navigator.pushNamed(context, RouteGenerator.otpScreen);
          },
          child: Center(
              child: Text(
                'REGISTER',
                style: GoogleFonts.poppins(fontSize: 22,color: myWhite),)),
        ),

      ),
    );
  }
}
