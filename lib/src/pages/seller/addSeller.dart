import 'package:billing_app/src/controller/sellerController.dart';
import 'package:billing_app/src/pages/seller/seller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

import '../../constaints/colors/AppColors.dart';
import '../../model/countryCodeData.dart';
import '../../services/closeDialog.dart';
import '../../widgets/customDialog.dart';
import '../../widgets/customScrollBehavior/myBehavior.dart';
import '../../widgets/myButton.dart';
import '../../widgets/selectCountryCode.dart';
import '../../widgets/showToastMessage.dart';

class AddSeller extends StatefulWidget {
  const AddSeller({Key? key}) : super(key: key);

  @override
  State<AddSeller> createState() => _AddSellerState();
}

class _AddSellerState extends State<AddSeller> {

  final formKey=GlobalKey<FormState>();
  TextEditingController nameController=TextEditingController();
  TextEditingController phoneController=TextEditingController();
  TextEditingController emailController=TextEditingController();
  TextEditingController addressController=TextEditingController();
  TextEditingController passController=TextEditingController();
  TextEditingController confirmPassController=TextEditingController();

  final sellerController=Get.put(SellerController());

  var countryCode='880';
  var countryCodeId=18;

  late FocusNode nameFocusNode;
  late FocusNode phoneFocusNode;
  late FocusNode emailFocusNode;
  late FocusNode addressFocusNode;
  late FocusNode passFocusNode;
  late FocusNode confirmPassFocusNode;

  bool obscureValue1=true;
  bool obscureValue2=true;

  @override
  void initState() {
    nameFocusNode=FocusNode();
    phoneFocusNode=FocusNode();
    emailFocusNode=FocusNode();
    addressFocusNode=FocusNode();
    passFocusNode=FocusNode();
    confirmPassFocusNode=FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    addressController.dispose();
    passController.dispose();
    confirmPassController.dispose();

    nameFocusNode.dispose();
    phoneFocusNode.dispose();
    emailFocusNode.dispose();
    addressFocusNode.dispose();
    passFocusNode.dispose();
    confirmPassFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.addNewSeller,),
        centerTitle: true,
        elevation: 0,
        foregroundColor: myblack,
        backgroundColor: myWhite,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width*0.02),
          child: ScrollConfiguration(
            behavior: MyBehavior(),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    //seller name textField here
                    SizedBox(height: size.height*0.02,),
                    buildTitle(AppLocalizations.of(context)!.sellerName),
                    buildName(size),

                    //phone number textFiled here
                    SizedBox(height: size.height*0.005,),
                    buildTitle(AppLocalizations.of(context)!.phoneNumber),
                    buildPhone(size),

                    //email address textFiled here
                    SizedBox(height: size.height*0.005,),
                    buildTitle(AppLocalizations.of(context)!.emailAddress+" ("+AppLocalizations.of(context)!.optional+") "),
                    buildEmail(size),

                    //street address textFiled here
                    SizedBox(height: size.height*0.005,),
                    buildTitle(AppLocalizations.of(context)!.address+" ("+AppLocalizations.of(context)!.optional+") "),
                    buildAddress(size),

                    //password textField here
                    SizedBox(height: size.height*0.005,),
                    buildTitle(AppLocalizations.of(context)!.password),
                    buildPassword(size),

                    //re-password textFiled here
                    SizedBox(height: size.height*0.005,),
                    buildTitle(AppLocalizations.of(context)!.re_password),
                    buildConfirmPassword(size),

                    //save button here
                    SizedBox(height: size.height*0.05,),
                    myButton(
                      onTap: (){
                        addSeller();
                      },
                      buttonText: AppLocalizations.of(context)!.save,
                      paddingHorizontal: 16,
                    ),
                    SizedBox(height: size.height*0.02,),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void addSeller()async{
    if(formKey.currentState!.validate()){

      //to show a loader
      customDialog();

      //var Seller=Seller();
      var result= await sellerController.addSeller(countryCodeId, nameController.text.toString(), phoneController.text.toString(), emailController.text.toString(), addressController.text.toString(), passController.text.toString(), confirmPassController.text.toString());

      //to close loader
      closeDialog();

      showToastMessage(result);

      //supplier.supplierController.getData();
      if(result.contains('Seller added successfully')){
        RefreshSeller().refresh();
        Get.back();
      }

    }
  }

  Widget buildTitle(String title){
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 8, left: 18, right: 8),
      child: Text(title, style: TextStyle(color: textColor2,),),
    );
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
          hintText: 'xyz',
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
              padding: EdgeInsets.only(left: 12, right: 12),
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
          addressFocusNode.requestFocus();
        },
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          hintText: 'xyz@gmail.com',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget buildAddress(Size size){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextFormField(
        controller: addressController,
        maxLines: 1,
        focusNode: addressFocusNode,
        onEditingComplete: (){
          passFocusNode.requestFocus();
        },
        keyboardType: TextInputType.streetAddress,
        decoration: InputDecoration(
          hintText: 'GEC Circle, Chittagong',
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
            return 'Re-Password required!';
          }
          else if (value.length<6) {
            return 'Re-Password must be 6 characters!';
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
