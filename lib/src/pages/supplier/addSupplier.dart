import 'package:billing_app/src/controller/supplierController.dart';
import 'package:billing_app/src/services/closeDialog.dart';
import 'package:billing_app/src/widgets/customDialog.dart';
import 'package:billing_app/src/widgets/customScrollBehavior/myBehavior.dart';
import 'package:billing_app/src/widgets/showToastMessage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constaints/colors/AppColors.dart';
import '../../widgets/myButton.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddSupplier extends StatefulWidget {
  const AddSupplier({Key? key}) : super(key: key);

  @override
  State<AddSupplier> createState() => _AddSupplierState();
}

class _AddSupplierState extends State<AddSupplier> {

  TextEditingController nameController=TextEditingController();
  TextEditingController phoneController=TextEditingController();
  TextEditingController emailController=TextEditingController();
  TextEditingController addressController=TextEditingController();
  final supplierController=Get.put(SupplierController());

  late FocusNode nameFocusNode;
  late FocusNode phoneFocusNode;
  late FocusNode emailFocusNode;
  late FocusNode addressFocusNode;

  @override
  void initState() {
    nameFocusNode=FocusNode();
    phoneFocusNode=FocusNode();
    emailFocusNode=FocusNode();
    addressFocusNode=FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    addressController.dispose();

    nameFocusNode.dispose();
    phoneFocusNode.dispose();
    emailFocusNode.dispose();
    addressFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.addNewSupplierTitle,),
        centerTitle: true,
        elevation: 0,
        foregroundColor: myblack,
        backgroundColor: myWhite,
      ),
      body: ScrollConfiguration(
        behavior: MyBehavior(),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //customer name textField here
                SizedBox(height: size.height*0.05,),
                buildTitle(AppLocalizations.of(context)!.supplierName,),
                buildName(size),

                //phone number textField here
                SizedBox(height: size.height*0.005,),
                buildTitle(AppLocalizations.of(context)!.phoneNumber),
                buildPhone(size),

                //email address textField here
                SizedBox(height: size.height*0.005,),
                buildTitle(AppLocalizations.of(context)!.emailAddress+" ("+AppLocalizations.of(context)!.optional+") "),
                buildEmail(size),

                //address textField here
                SizedBox(height: size.height*0.005,),
                buildTitle(AppLocalizations.of(context)!.address),
                buildAddress(size),

                SizedBox(height: size.height*0.05,),
                myButton(
                    onTap: (){
                      addSupplier();
                    },
                    buttonText: AppLocalizations.of(context)!.save,
                    paddingHorizontal: 0
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void addSupplier()async{
    if(nameController.text.isEmpty){
      showToastMessage('Supplier Name is required!');
      nameFocusNode.requestFocus();
    }
    else if(phoneController.text.isEmpty){
      showToastMessage('Phone number is required!');
      phoneFocusNode.requestFocus();
    }
    // else if(phoneController.text.length != numberSize){
    //   showToastMessage('Incorrect Phone Number!');
    //   phoneFocusNode.requestFocus();
    // }
    else{

      //to show a loader
      customDialog();

      var result= await supplierController.addSupplier(nameController.text.toString(), phoneController.text.toString(), emailController.text.toString(), addressController.text.toString());

      //to close loader
      closeDialog();

      showToastMessage(result);

      if(result=='Supplier Added'){
        Get.back(result: 1);
      }
    }
  }

  Widget buildTitle(String title){
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 8, left: 4, right: 8),
      child: Text(title, style: TextStyle(color: textColor2,),),
    );
  }

  Widget buildName(Size size){
    return TextField(
      controller: nameController,
      maxLines: 1,
      focusNode: nameFocusNode,
      onSubmitted: (val){
        phoneFocusNode.requestFocus();
      },
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        hintText: 'xyz',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget buildPhone(Size size){
    return TextField(
      controller: phoneController,
      maxLines: 1,
      focusNode: phoneFocusNode,
      onSubmitted: (val){
        emailFocusNode.requestFocus();
      },
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        hintText: '01*********',
        // prefixIcon: Padding(
        //   padding: const EdgeInsets.only(left: 12),
        //   child: myDropDown(codeList, countryCode, (val){
        //     setState((){ //
        //       countryCode=val;
        //       phoneFocusNode.requestFocus();
        //
        //       _getNumberSize(countryCode);
        //     });
        //   }),
        // ),
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget buildEmail(Size size){
    return TextField(
      controller: emailController,
      maxLines: 1,
      focusNode: emailFocusNode,
      onSubmitted: (val){
        addressFocusNode.requestFocus();
      },
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: 'xyz@gmail.com',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget buildAddress(Size size){
    return TextField(
      controller: addressController,
      maxLines: 1,
      focusNode: addressFocusNode,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        hintText: 'Dhaka, Bangladesh',
        border: OutlineInputBorder(),
      ),
    );
  }
}
