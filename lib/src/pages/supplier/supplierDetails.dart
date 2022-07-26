import 'package:billing_app/src/controller/supplierController.dart';
import 'package:billing_app/src/model/supplierData.dart';
import 'package:billing_app/src/pages/supplier/editSupplier.dart';
import 'package:billing_app/src/pages/supplier/supplier.dart';
import 'package:billing_app/src/services/closeDialog.dart';
import 'package:billing_app/src/widgets/customDialog.dart';
import 'package:billing_app/src/widgets/showToastMessage.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import '../../constaints/colors/AppColors.dart';
import '../../services/createCall.dart';
import '../../services/createEmail.dart';
import '../../services/createSMS.dart';
import '../../widgets/confirmationDialog.dart';
import '../../widgets/customScrollBehavior/myBehavior.dart';

class SupplierDetails extends StatefulWidget {
  SupplierDetails({Key? key, required this.data}) : super(key: key);
  SupplierData data;

  @override
  State<SupplierDetails> createState() => _SupplierDetailsState();
}

class _SupplierDetailsState extends State<SupplierDetails> {

  final supplierController=Get.put(SupplierController());

  var name;
  var phone;
  var email;
  var address;
  var status;

  _setData(SupplierData data){
    if(!mounted)return;
    setState(() {
      name=data.name;
      phone=data.phone;

      //set email
      if(data.email.toString().isEmpty || data.email==null){
        email='Not set';
      }
      else{
        email=data.email.toString();
      }

      //set address
      if(data.address.toString().isEmpty || data.address==null){
        address='Not set';
      }
      else{
        address=data.address.toString();
      }

      //set status
      if(data.is_active.toString().contains('1')){
        status='Active';
      }
      else{
        status='Inactive';
      }

    });
  }

  @override
  void initState() {
    _setData(widget.data);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return Scaffold(
      //backgroundColor: myWhite.withOpacity(0.95),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.supplier,),
        centerTitle: true,
        elevation: 0,
        foregroundColor: myblack,
        backgroundColor: myWhite,
        actions: [
          IconButton(
              onPressed: ()async{
                var result= await Get.to(()=>EditSupplier(data: widget.data,));
                if(result!=null){
                  _setData(result);
                }
              },
              icon: Icon(Icons.edit, color: textColor2,)
          ),
          SizedBox(width: 8,),
          IconButton(
              onPressed: ()async{
                var result = await confirmationDialog(context: context,
                    title: AppLocalizations.of(context)!.deleteMsg2,
                    negativeActionText: AppLocalizations.of(context)!.no,
                    positiveActionText: AppLocalizations.of(context)!.yes);

                if(result==true){
                  deleteSupplier();
                }
              },
              icon: Icon(Icons.delete, color: textColor2,)
          ),
          SizedBox(width: 8,),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ScrollConfiguration(
          behavior: MyBehavior(),
          child: ListView(
            children: [
              buildTitle(AppLocalizations.of(context)!.supplierName),
              buildContainer('$name', size),
              buildTitle(AppLocalizations.of(context)!.phoneNumber),
              buildContainer('$phone', size),
              buildTitle(AppLocalizations.of(context)!.emailAddress),
              buildContainer('$email', size),
              buildTitle(AppLocalizations.of(context)!.address),
              buildContainer('$address', size),
              buildTitle(AppLocalizations.of(context)!.status),
              buildContainer('$status', size),

              SizedBox(height: size.height*0.1,),
              buildPhoneSmsEmail(size),
            ],
          ),
        ),
      ),
    );
  }

  void deleteSupplier()async{

    //to show a loader
    customDialog();

    var result= await supplierController.deleteData(widget.data.id.toString());

    //close loader
    closeDialog();

    showToastMessage(result);

    //to refresh supplier list after deleted any customer
    RefreshSupplier().refresh();
    Get.back();
  }

  Widget buildTitle(String title){
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 8, left: 0, right: 8),
      child: Text(title, style: TextStyle(color: textColor2),),
    );
  }

  Widget buildContainer(String text, Size size){
    return Container(
      height: size.height*0.08,
      width: size.width,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        //color: textColor2.withOpacity(0.05),
        border: Border.all(color: textColor3),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(text, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
    );
  }

  Widget buildPhoneSmsEmail(Size size){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: (){
            createCall(phone);
          },
          borderRadius: BorderRadius.circular(100),
          child: Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: textColor2.withOpacity(0.1),
            ),
            child: Icon(Icons.phone,color: textColor2, size: size.height*0.032,),
          ),
        ),
        SizedBox(width: 16,),
        InkWell(
          onTap: (){
            createSMS(phone);
          },
          borderRadius: BorderRadius.circular(100),
          child: Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: textColor2.withOpacity(0.1),
            ),
            child: Icon(Icons.message,color: textColor2, size: size.height*0.032,),
          ),
        ),
        //show space and email button if there is an email otherwise ignore widget
        widget.data.email.toString().contains("null")?
        Container()
            :
        SizedBox(width: 16,),

        widget.data.email.toString().contains("null")?
        Container()
            :
        InkWell(
          onTap: (){
            createEmail('$email');
          },
          borderRadius: BorderRadius.circular(100),
          child: Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: textColor2.withOpacity(0.1),
            ),
            child: Icon(Icons.email_outlined,color: textColor2, size: size.height*0.032),
          ),
        ),
      ],
    );
  }
}
