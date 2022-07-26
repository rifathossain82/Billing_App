import 'package:billing_app/routes/routes.dart';
import 'package:billing_app/src/controller/authenticationController.dart';
import 'package:billing_app/src/services/closeDialog.dart';
import 'package:billing_app/src/widgets/confirmationDialog.dart';
import 'package:billing_app/src/widgets/customScrollBehavior/myBehavior.dart';
import 'package:billing_app/src/widgets/myButton.dart';
import 'package:billing_app/src/widgets/showToastMessage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constaints/colors/AppColors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../widgets/customDialog.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {

  TextEditingController currentPassController=TextEditingController();
  TextEditingController passController=TextEditingController();
  TextEditingController rePassController=TextEditingController();
  final formKey=GlobalKey<FormState>();
  final authenticationController=Get.put(AuthenticationController());

  late FocusNode passFocusNode;
  late FocusNode rePassFocusNode;

  bool obscureValue1=true;
  bool obscureValue2=true;
  bool obscureValue3=true;

  @override
  void initState() {
    passFocusNode=FocusNode();
    rePassFocusNode=FocusNode();
    super.initState();
  }


  @override
  void dispose() {
    passController.dispose();
    rePassController.dispose();

    passFocusNode.dispose();
    rePassFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return Scaffold(
      //backgroundColor: myWhite.withOpacity(0.95),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.changePassword,),
        foregroundColor: myblack,
        elevation: 0,
        centerTitle: true,
        backgroundColor: myWhite,
      ),
      body: ScrollConfiguration(
        behavior: MyBehavior(),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: size.height*0.05,),

                //enter old password text
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    AppLocalizations.of(context)!.enter_your_old_pass,
                    style: TextStyle(
                      color: textColor2,
                    ),
                  ),
                ),
                SizedBox(height: size.height*0.01,),

                buildCurrentPassword(size),

                //forget password
                SizedBox(height: size.height*0.02,),
                GestureDetector(
                  onTap: (){
                    Get.toNamed(RouteGenerator.forgotPassword);
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(AppLocalizations.of(context)!.forgetYourPassword,)
                    ),
                  ),
                ),

                //enter new password text
                SizedBox(height: size.height*0.03,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                      AppLocalizations.of(context)!.enter_your_new_pass,
                    style: TextStyle(
                      color: textColor2,
                    ),
                  ),
                ),
                SizedBox(height: size.height*0.01,),

                buildPassword(size),
                SizedBox(height: size.height*0.03,),

                buildRePassword(size),
                SizedBox(height: size.height*0.05,),

                myButton(
                  onTap: ()async{
                    if(formKey.currentState!.validate()){
                      var result = await confirmationDialog(
                          context: context,
                          title: AppLocalizations.of(context)!.changeAlertMsg,
                          negativeActionText: AppLocalizations.of(context)!.no,
                          positiveActionText: AppLocalizations.of(context)!.yes);

                      if(result == true){
                        changePassword();
                      }
                    }
                  },
                  buttonText: AppLocalizations.of(context)!.save, paddingHorizontal: 16
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void changePassword()async{
    //to show a loader
    customDialog();
    var result= await authenticationController.changeUserPassword_fromSettings(currentPassController.text, passController.text, rePassController.text);

    //to close loader
    closeDialog();

    showToastMessage(result.toString());
    if(result!.contains('Password Updated Successfully!')){
      Get.offNamed(RouteGenerator.login);
    }
  }

  Widget buildCurrentPassword(Size size){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return AppLocalizations.of(context)!.passwordRequired;
          }
          else if (value.length<8) {
            return 'Password must be 8 characters!';
          }
          else {
            return null;
          }
        },
        controller: currentPassController,
        maxLines: 1,
        onEditingComplete: (){
          passFocusNode.requestFocus();
        },
        keyboardType: TextInputType.visiblePassword,
        obscureText: obscureValue1,
        decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.old_password,
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

  Widget buildPassword(Size size){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return AppLocalizations.of(context)!.passwordRequired;
          }
          else if (value.length<8) {
            return AppLocalizations.of(context)!.passwordCharacterError;
          }
          else if(rePassController.text.toString() != value){
            return AppLocalizations.of(context)!.passwordDoNotMatch;
          }
          else {
            return null;
          }
        },
        controller: passController,
        maxLines: 1,
        focusNode: passFocusNode,
        onEditingComplete: (){
          rePassFocusNode.requestFocus();
        },
        keyboardType: TextInputType.visiblePassword,
        obscureText: obscureValue2,
        decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.password,
            border: OutlineInputBorder(),
            suffixIcon: IconButton(
                onPressed: (){
                  setState(() {
                    obscureValue2=!obscureValue2;
                  });
                },
                icon: obscureValue2?Icon(Icons.visibility_off): Icon(Icons.visibility))
        ),
      ),
    );
  }

  Widget buildRePassword(Size size){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return AppLocalizations.of(context)!.rePasswordRequired;
          }
          else if (value.length<8) {
            return AppLocalizations.of(context)!.rePasswordCharacterError;
          }
          else if(passController.text.toString() != value){
            return AppLocalizations.of(context)!.passwordDoNotMatch;
          }
          else {
            return null;
          }
        },
        controller: rePassController,
        maxLines: 1,
        focusNode: rePassFocusNode,
        keyboardType: TextInputType.visiblePassword,
        obscureText: obscureValue3,
        decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.re_password,
            border: OutlineInputBorder(),
            suffixIcon: IconButton(
              onPressed: (){
                setState(() {
                  obscureValue3=!obscureValue3;
                });
              },
              icon: obscureValue3?Icon(Icons.visibility_off,): Icon(Icons.visibility),
            )
        ),
      ),
    );
  }
}
