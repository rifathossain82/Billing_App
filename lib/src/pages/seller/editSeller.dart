import 'package:billing_app/src/model/sellerData.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

import '../../constaints/colors/AppColors.dart';
import '../../controller/sellerController.dart';
import '../../model/countryCodeData.dart';
import '../../widgets/customDialog.dart';
import '../../widgets/customScrollBehavior/myBehavior.dart';
import '../../widgets/myButton.dart';
import '../../widgets/selectCountryCode.dart';
import '../../widgets/showToastMessage.dart';

class EditSeller extends StatefulWidget {
  EditSeller({Key? key, required this.sellerData}) : super(key: key);

  SellerData sellerData;

  @override
  State<EditSeller> createState() => _EditSellerState();
}

class _EditSellerState extends State<EditSeller> {

  TextEditingController nameController=TextEditingController();
  TextEditingController phoneController=TextEditingController();
  TextEditingController emailController=TextEditingController();
  TextEditingController addressController=TextEditingController();
  bool status=false;    //as we change status by switch so that we need bool type variable

  var countryCode='880';

  final sellerController=Get.put(SellerController());

  @override
  void dispose() {
    // TODO: implement dispose
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    nameController.text=widget.sellerData.name.toString();
    phoneController.text=widget.sellerData.phone.toString();
    emailController.text=widget.sellerData.email ?? '';
    addressController.text=widget.sellerData.address ?? '';
    if(widget.sellerData.isActive.toString().contains('1')){
      status=true;
    }
    else{
      status=false;
    }

    countryCode=widget.sellerData.countryCode.toString();

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.editSeller,),
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
                buildTitle(AppLocalizations.of(context)!.sellerName),
                buildName(size),

                // buildTitle(AppLocalizations.of(context)!.phoneNumber),
                // buildPhone(size),

                buildTitle(AppLocalizations.of(context)!.emailAddress),
                buildEmail(size),

                buildTitle(AppLocalizations.of(context)!.address),
                buildAddress(size),

                buildTitle(AppLocalizations.of(context)!.status),
                buildStatus(size),

                SizedBox(height: size.height*0.05,),
                myButton(
                    onTap: (){
                      updateSeller();
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

  void updateSeller()async{
    if(nameController.text.isEmpty){
      showToastMessage('Seller Name is required!');
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

      // var result= await customerController.updateCustomer(widget.customer.id.toString(), nameController.text.toString(), phoneController.text.toString(), emailController.text.toString(), addressController.text.toString(), customer_status);
      //
      // //close loader
      // closeDialog();
      //
      // showToastMessage(result);
      //
      // if(result=='Customer Edit Successful'){
      //
      //   ///to update customer screen
      //   RefreshSeller().refresh();
      //
      //   var changes=SellerData(name: nameController.text, phone: phoneController.text, email: emailController.text, address: addressController.text, isActive: customer_status);
      //   Get.back(result: changes);
      // }
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

  //we don't need this right now as we don't update seller phone number
  Widget buildPhone(Size size){
    return SizedBox(
      width: size.width,
      height: size.height*0.08,
      child: TextField(
        controller: phoneController,
        maxLines: 1,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: "1*********",
          prefixIcon: GestureDetector(
            onTap: ()async{
              CountryCodeData result = await SelectCountryCode(size, context);
              print(result.countryCode);
              if(result.id != null){
                setState(() {
                  countryCode=result.countryCode!;
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
