import 'package:billing_app/constaints/colors/AppColors.dart';
import 'package:billing_app/constaints/strings/AppStrings.dart';
import 'package:billing_app/routes/routes.dart';
import 'package:billing_app/widgets/countryCodeDropDown.dart';
import 'package:billing_app/widgets/logo_name.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController phoneController=TextEditingController();
  TextEditingController passController=TextEditingController();

  var countryCode='+880';
  bool obscureValue=true;

  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Center(
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
              buildLoginButton(size),
              SizedBox(height: size.height*0.02,),
              InkWell(
                onTap: (){
                  Navigator.pushReplacementNamed(context, RouteGenerator.signUp);
                },
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Haven't any account?",
                        style: GoogleFonts.poppins(color: Colors.grey)
                      ),
                      TextSpan(
                          text: " Register",
                          style: GoogleFonts.poppins(color: myDeepOrange)
                      )
                    ]
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPhone(Size size){
    return SizedBox(
      width: size.width,
      height: size.height*0.12,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: TextField(
          controller: phoneController,
          maxLines: 1,
          maxLength: 10,
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

  Widget buildPassword(Size size){
    return SizedBox(
      width: size.width,
      height: size.height*0.09,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: TextField(
          controller: passController,
          maxLines: 1,
          keyboardType: TextInputType.visiblePassword,
          obscureText: obscureValue,
          decoration: InputDecoration(
            labelText: 'Password',
            border: OutlineInputBorder(),
            suffix: IconButton(
                onPressed: (){
                  setState(() {
                    obscureValue=!obscureValue;
                  });
                },
                icon: obscureValue?Icon(Icons.visibility_off): Icon(Icons.visibility))
          ),
        ),
      ),
    );
  }

  Widget buildLoginButton(Size size){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        width: size.width,
        height: size.height*0.08,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: myDeepOrange
        ),
        child: Center(
            child: Text(
              'LOGIN',
              style: GoogleFonts.poppins(fontSize: 22,color: myWhite),)),

      ),
    );
  }
}
