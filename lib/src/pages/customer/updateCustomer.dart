import 'package:billing_app/src/controller/customerController.dart';
import 'package:billing_app/src/pages/customer/customeres.dart';
import 'package:billing_app/src/services/closeDialog.dart';
import 'package:billing_app/src/widgets/customDialog.dart';
import 'package:billing_app/src/widgets/showToastMessage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

import '../../constaints/colors/AppColors.dart';
import '../../model/customerData.dart';
import '../../widgets/customScrollBehavior/myBehavior.dart';
import '../../widgets/myButton.dart';

class UpdateCustomer extends StatefulWidget {
  UpdateCustomer({Key? key, required this.customer}) : super(key: key);
  CustomerData customer;

  @override
  State<UpdateCustomer> createState() => _UpdateCustomerState();
}

class _UpdateCustomerState extends State<UpdateCustomer> {

  TextEditingController nameController=TextEditingController();
  TextEditingController phoneController=TextEditingController();
  TextEditingController emailController=TextEditingController();
  TextEditingController addressController=TextEditingController();
  bool status=false;    //as we change status by switch so that we need bool type variable

  final customerController=Get.put(CustomerController());

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
    nameController.text=widget.customer.name.toString();
    phoneController.text=widget.customer.phone.toString();
    print(widget.customer.email);
    emailController.text=widget.customer.email.toString()!='null' ? widget.customer.email.toString() : '';
    addressController.text=widget.customer.address.toString()!='null' ? widget.customer.address.toString() : '';
    if(widget.customer.is_active.toString().contains('1')){
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
        title: Text(AppLocalizations.of(context)!.editCustomer,),
        centerTitle: true,
        elevation: 0,
        foregroundColor: myblack,
        backgroundColor: myWhite,
      ),
      body: ScrollConfiguration(
        behavior: MyBehavior(),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: size.height*0.01,),
                buildTitle(AppLocalizations.of(context)!.customerName),
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
                      updateCustomer();
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

  void updateCustomer()async{
    if(nameController.text.isEmpty){
      showToastMessage('Customer Name is required!');
    }
    else if(phoneController.text.isEmpty){
      showToastMessage('Phone number is required!');
    }
    // else if(phoneController.text.length != numberSize){
    //   showToastMessage('Incorrect Phone Number!');
    // }
    else{

      var customer_status=status? '1' : '0';

      //show a loader
      customDialog();

      var result= await customerController.updateCustomer(widget.customer.id.toString(), nameController.text.toString(), phoneController.text.toString(), emailController.text.toString(), addressController.text.toString(), customer_status);

      //close loader
      closeDialog();

      showToastMessage(result);

      if(result.toString().contains('Customer updated successfully!')){

        ///to update customer screen
        RefreshCustomer().refresh();

        var changes=CustomerData(name: nameController.text, phone: phoneController.text, email: emailController.text, address: addressController.text.toString(), is_active: customer_status);
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
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: "01*********",
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
