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

class ChangePassword_WhenForget extends StatefulWidget {
  const ChangePassword_WhenForget({Key? key}) : super(key: key);

  @override
  State<ChangePassword_WhenForget> createState() => _ChangePassword_WhenForgetState();
}

class _ChangePassword_WhenForgetState extends State<ChangePassword_WhenForget> {

  TextEditingController passController=TextEditingController();
  TextEditingController rePassController=TextEditingController();
  final formKey=GlobalKey<FormState>();
  final authenticationController=Get.put(AuthenticationController());

  var mobileNumber;
  var countryCodeId;

  late FocusNode passFocusNode;
  late FocusNode rePassFocusNode;

  bool obscureValue2=true;
  bool obscureValue3=true;

  @override
  void initState() {
    passFocusNode=FocusNode();
    rePassFocusNode=FocusNode();

    var data = Get.arguments;
    mobileNumber = data['mobileNumber'];
    countryCodeId = data['countryCodeId'];

    print(mobileNumber);
    print(countryCodeId);

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

                //enter new password text
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
                  onTap: (){
                    if(formKey.currentState!.validate()){
                      changePassword();
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
    var result= await authenticationController.changeUserPassword_WhenForget(
        passController.text,
        rePassController.text,
        mobileNumber,
        countryCodeId);

    //to close loader
    closeDialog();

    showToastMessage(result.toString());
    if(result!.contains('Password Updated Successfully!')){
      Get.offAllNamed(RouteGenerator.login);
    }
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
          else if(rePassController.text.toString() != value){
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
            return 'Re-Password required!';
          }
          else if (value.length<8) {
            return 'Re-Password must be 8 characters!';
          }
          else if(passController.text.toString() != value){
            return 'Passwords do not match!!';
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
