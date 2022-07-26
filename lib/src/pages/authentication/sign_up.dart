import 'package:billing_app/src/constaints/util/util.dart';
import 'package:billing_app/src/pages/authentication/otp_screen.dart';
import 'package:billing_app/src/services/closeDialog.dart';
import 'package:billing_app/src/widgets/customDialog.dart';
import 'package:billing_app/src/widgets/customScrollBehavior/myBehavior.dart';
import 'package:billing_app/src/widgets/myButton.dart';
import 'package:billing_app/src/widgets/titleTextField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/routes.dart';
import '../../constaints/colors/AppColors.dart';
import '../../controller/authenticationController.dart';
import '../../model/countryCodeData.dart';
import '../../widgets/logo_name.dart';
import '../../widgets/mySnackBar.dart';
import '../../widgets/selectCountryCode.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  final authenticationController=Get.put(AuthenticationController());
  final formKey=GlobalKey<FormState>();

  TextEditingController nameController=TextEditingController();
  TextEditingController phoneController=TextEditingController();
  TextEditingController emailController=TextEditingController();
  TextEditingController passController=TextEditingController();
  TextEditingController confirmPassController=TextEditingController();

  late FocusNode nameFocusNode;
  late FocusNode phoneFocusNode;
  late FocusNode emailFocusNode;
  late FocusNode passFocusNode;
  late FocusNode confirmPassFocusNode;

  var countryCode='880';
  var countryCodeId=18;

  bool obscureValue1=true;
  bool obscureValue2=true;

  @override
  void initState() {
    nameFocusNode=FocusNode();
    phoneFocusNode=FocusNode();
    emailFocusNode=FocusNode();
    passFocusNode=FocusNode();
    confirmPassFocusNode=FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passController.dispose();
    confirmPassController.dispose();

    nameFocusNode.dispose();
    phoneFocusNode.dispose();
    emailFocusNode.dispose();
    passFocusNode.dispose();
    confirmPassFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Form(
          key: formKey,
          child: ScrollConfiguration(
            behavior: MyBehavior(),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [

                  //logo and app name here
                  SizedBox(height: size.height*0.05,),
                  LogoName(),

                  //company or business name textField here
                  SizedBox(height: size.height*0.03,),
                  buildTitle('Company or Business Name'),
                  buildName(size),

                  //phone number textField here
                  SizedBox(height: size.height*0.005,),
                  buildTitle('Phone Number'),
                  buildPhone(size),

                  //email address textField here
                  SizedBox(height: size.height*0.005,),
                  buildTitle('Email Address (optional)'),
                  buildEmail(size),

                  //password textField here
                  SizedBox(height: size.height*0.005,),
                  buildTitle('Password'),
                  buildPassword(size),

                  //confirm password textField here
                  SizedBox(height: size.height*0.005,),
                  buildTitle('Confirm Password'),
                  buildConfirmPassword(size),


                  //register button here
                  SizedBox(height: size.height*0.05,),
                  myButton(
                      onTap: (){
                        userRegister();
                      },
                      buttonText: 'REGISTER',
                      paddingHorizontal: 16,
                  ),


                  //login text here to go login page
                  SizedBox(height: size.height*0.02,),
                  InkWell(
                    onTap: (){
                      Get.offNamed(RouteGenerator.login);
                    },
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                            children: [
                              TextSpan(
                                  text: "Already have an account?",
                                  style: TextStyle(color: Colors.grey)
                              ),
                              TextSpan(
                                  text: " Log In",
                                  style: TextStyle(color: mainColor)
                              )
                            ]
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: size.height*0.01,),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void userRegister()async{
    var hasInternet = await Util().checkInternet();
    if(hasInternet){
      if(formKey.currentState!.validate()){

        //show a loader
        customDialog();

        var result=await authenticationController.register(countryCodeId, nameController.text, emailController.text, phoneController.text, passController.text);

        //close the loader
        closeDialog();

        if(result!.contains('Success')){
          mySnackBar(msg: 'Register Success', context: context, bgColor: mainColor, duration: Duration(seconds: 1));
          await authenticationController.showUser();   //to load user data
          Get.to(() => OtpScreen(
              mobileNumber: '${phoneController.text}',
              countryCode: '$countryCode',
              countryCodeId: '$countryCodeId',
              routeName: RouteGenerator.mainPage));
        }
        else{
          mySnackBar(msg: '${result}', context: context, bgColor: mainColor, duration: Duration(seconds: 1));
        }
      }
    }
  }

  Widget buildName(Size size){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextFormField(
        validator: (value){
          if (value!.isEmpty) {
            return 'Name required!';
          }
          else {
            return null;
          }
        },
        controller: nameController,
        maxLines: 1,
        focusNode: nameFocusNode,
        onEditingComplete: (){
          phoneFocusNode.requestFocus();
        },
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
          hintText: 'xyz shop',
          border: OutlineInputBorder(),
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
          else {
            return null;
          }
        },
        controller: phoneController,
        maxLines: 1,
        focusNode: phoneFocusNode,
        onEditingComplete: (){
          emailFocusNode.requestFocus();
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

  Widget buildEmail(Size size){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextFormField(
        controller: emailController,
        maxLines: 1,
        focusNode: emailFocusNode,
        onEditingComplete: (){
          passFocusNode.requestFocus();
        },
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          hintText: 'xyz@gmail.com',
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
          else if(confirmPassController.text.toString() != value){
            return 'Passwords do not match!!';
          }
          else {
            return null;
          }
        },
        controller: passController,
        maxLines: 1,
        focusNode: passFocusNode,
        onEditingComplete: (){
          confirmPassFocusNode.requestFocus();
        },
        keyboardType: TextInputType.visiblePassword,
        obscureText: obscureValue1,
        decoration: InputDecoration(
            hintText: '********',
            border: OutlineInputBorder(),
            suffixIcon: IconButton(
                onPressed: (){
                  setState(() {
                    obscureValue1=!obscureValue1;
                  });
                },
                icon: obscureValue1?Icon(Icons.visibility_off): Icon(Icons.visibility))
        ),
      ),
    );
  }

  Widget buildConfirmPassword(Size size){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return 'Confirm Password required!';
          }
          else if (value.length<8) {
            return 'Confirm Password must be 8 characters!';
          }
          else if(passController.text.toString() != value){
            return 'Passwords do not match!!';
          }
          else {
            return null;
          }
        },
        controller: confirmPassController,
        maxLines: 1,
        focusNode: confirmPassFocusNode,
        keyboardType: TextInputType.visiblePassword,
        obscureText: obscureValue2,
        decoration: InputDecoration(
            hintText: '********',
            border: OutlineInputBorder(),
            suffixIcon: IconButton(
                onPressed: (){
                  setState(() {
                    obscureValue2=!obscureValue2;
                  });
                },
                icon: obscureValue2?Icon(Icons.visibility_off,): Icon(Icons.visibility),
            )
        ),
      ),
    );
  }
}
