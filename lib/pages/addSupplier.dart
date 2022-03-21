import 'package:billing_app/constaints/colors/AppColors.dart';
import 'package:flutter/material.dart';

import '../constaints/strings/AppStrings.dart';
import '../widgets/countryCodeDropDown.dart';

class AddSupplier extends StatefulWidget {
  const AddSupplier({Key? key}) : super(key: key);

  @override
  State<AddSupplier> createState() => _AddSupplierState();
}

class _AddSupplierState extends State<AddSupplier> {

  TextEditingController nameController=TextEditingController();
  TextEditingController phoneController=TextEditingController();
  TextEditingController emailController=TextEditingController();
  TextEditingController locationController=TextEditingController();

  var countryCode='+880';

  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Add New Supplier'),
        centerTitle: true,
        elevation: 0,
        foregroundColor: myblack,
        backgroundColor: myWhite,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildName(size),
          SizedBox(height: size.height*0.03,),
          buildPhone(size),
          SizedBox(height: size.height*0.03,),
          buildEmail(size),
          SizedBox(height: size.height*0.03,),
          buildAddress(size),
          SizedBox(height: size.height*0.05,),
          buildButton(size),
        ],
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
            labelText: 'Supplier Name',
            border: OutlineInputBorder(),
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

  Widget buildAddress(Size size){
    return SizedBox(
      width: size.width,
      height: size.height*0.08,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: TextField(
          controller: locationController,
          maxLines: 1,
          keyboardType: TextInputType.name,
          decoration: InputDecoration(
            labelText: 'Address',
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }

  Widget buildButton(Size size){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        height: size.height*0.08,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: myDeepOrange,
        ),
        child: Text('Save',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,color: myWhite),),
      ),
    );
  }
}
