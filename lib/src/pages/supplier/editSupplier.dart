import 'package:billing_app/src/controller/supplierController.dart';
import 'package:billing_app/src/model/supplierData.dart';
import 'package:billing_app/src/pages/supplier/supplier.dart';
import 'package:billing_app/src/services/closeDialog.dart';
import 'package:billing_app/src/widgets/customDialog.dart';
import 'package:billing_app/src/widgets/showToastMessage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

import '../../constaints/colors/AppColors.dart';
import '../../widgets/customScrollBehavior/myBehavior.dart';
import '../../widgets/myButton.dart';

class EditSupplier extends StatefulWidget {
  EditSupplier({Key? key, required this.data}) : super(key: key);
  SupplierData data;

  @override
  State<EditSupplier> createState() => _EditSupplierState();
}

class _EditSupplierState extends State<EditSupplier> {

  TextEditingController nameController=TextEditingController();
  TextEditingController phoneController=TextEditingController();
  TextEditingController emailController=TextEditingController();
  TextEditingController addressController=TextEditingController();
  final supplierController=Get.put(SupplierController());

  //supplier status. //as we change status by switch so that we need bool type variable
  var status=false;

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    nameController.text=widget.data.name.toString();
    phoneController.text=widget.data.phone.toString();
    emailController.text=widget.data.email.toString()!='null' ? widget.data.email.toString() : '';
    addressController.text=widget.data.address.toString()!='null' ? widget.data.address.toString() : '';
    if(widget.data.is_active.toString().contains('1')){
      status=true;
    }
    else{
      status=false;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.editSupplier,),
        centerTitle: true,
        elevation: 0,
        foregroundColor: myblack,
        backgroundColor: myWhite,
      ),
      body: ScrollConfiguration(
        behavior: MyBehavior(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView(
            children: [

              SizedBox(height: size.height*0.01,),
              buildTitle(AppLocalizations.of(context)!.supplierName),
              buildName(size),

              buildTitle(AppLocalizations.of(context)!.phoneNumber),
              buildPhone(size),

              buildTitle(AppLocalizations.of(context)!.emailAddress),
              buildEmail(size),

              buildTitle(AppLocalizations.of(context)!.address),
              buildAddress(size),

              buildTitle(AppLocalizations.of(context)!.status),
              buildStatus(size),

              SizedBox(height: size.height*0.05,),
              myButton(
                  onTap: (){
                    updateSupplier();
                  },
                  buttonText: AppLocalizations.of(context)!.save,
                  paddingHorizontal: 0
              ),
            ],
          ),
        ),
      ),
    );
  }

  void updateSupplier()async{
    if(nameController.text.isEmpty){
      showToastMessage('Supplier Name is required!');
    }
    else if(phoneController.text.isEmpty){
      showToastMessage('Phone number is required!');
    }
    // else if(phoneController.text.length != numberSize){
    //   showToastMessage('Incorrect Phone Number!');
    // }
    else{

      //to show a loader
      customDialog();

      //to pass supplier status to update
      var supplier_status= status ? "1" : "0";

      var result= await supplierController.updateSupplier(widget.data.id.toString(), nameController.text.toString(), phoneController.text.toString(), emailController.text.toString(), addressController.text.toString(), supplier_status);

      //to close loader
      closeDialog();

      showToastMessage(result);

      if(result.toString().contains('Supplier updated successfully!')){
        ///to refresh after update any supplier
        RefreshSupplier().refresh();

        var changes=SupplierData(name: nameController.text, phone: phoneController.text, email: emailController.text, address: addressController.text, is_active: supplier_status);
        Get.back(result: changes);
      }

    }
  }

  Widget buildTitle(String title){
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 8, left: 0, right: 8),
      child: Text(title, style: TextStyle(color: textColor2,),),
    );
  }

  Widget buildName(Size size){
    return SizedBox(
      width: size.width,
      height: size.height*0.08,
      child: TextField(
        controller: nameController,
        maxLines: 1,
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
          hintText: 'xyz',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget buildPhone(Size size){
    return SizedBox(
      width: size.width,
      height: size.height*0.08,
      child: TextField(
        controller: phoneController,
        maxLines: 1,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          hintText: '01*********',
          // prefix: myDropDown(codeList, countryCode, (val){
          //   setState((){ //
          //     countryCode=val;
          //
          //     _getNumberSize(countryCode);
          //   });
          // }),
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget buildEmail(Size size){
    return SizedBox(
      width: size.width,
      height: size.height*0.08,
      child: TextField(
        controller: emailController,
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          hintText: AppLocalizations.of(context)!.optional,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget buildAddress(Size size){
    return SizedBox(
      width: size.width,
      height: size.height*0.08,
      child: TextField(
        controller: addressController,
        maxLines: 1,
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
          hintText: AppLocalizations.of(context)!.optional,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget buildStatus(Size size){
    return Container(
      width: size.width,
      height: size.height*0.08,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: textColor2.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('${status? "Active" : "Inactive"}'),
          Switch(
            value: status,
            onChanged: (bool value) {
              setState(() {
                status=value;
              });
            },
          ),
        ],
      ),
    );
  }
}
