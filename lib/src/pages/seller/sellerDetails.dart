import 'package:billing_app/src/pages/seller/seller.dart';
import 'package:billing_app/src/services/closeDialog.dart';
import 'package:billing_app/src/widgets/customDialog.dart';
import 'package:billing_app/src/widgets/showToastMessage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constaints/colors/AppColors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../controller/sellerController.dart';
import '../../model/sellerData.dart';
import '../../services/createCall.dart';
import '../../services/createEmail.dart';
import '../../services/createSMS.dart';
import '../../widgets/confirmationDialog.dart';
import '../../widgets/customScrollBehavior/myBehavior.dart';

class SellerDetails extends StatefulWidget {
  SellerDetails({Key? key, required this.sellerData}) : super(key: key);

  SellerData sellerData;

  @override
  State<SellerDetails> createState() => _SellerDetailsState();
}

class _SellerDetailsState extends State<SellerDetails> {

  var name;
  var phone;
  var email;
  var address;
  var status;

  final sellerController=Get.put(SellerController());

  _setData(SellerData data){
    if(!mounted)return;
    setState(() {
      name=data.name;
      phone='${data.countryCode}${data.phone}';
      email=data.email?? 'Not Set';
      address=data.address ?? 'Not Set';

      //set status
      if(data.isActive.toString().contains('1')){
        status='Active';
      }
      else{
        status='Inactive';
      }

    });
  }

  @override
  void initState() {
    _setData(widget.sellerData);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return Scaffold(
      //backgroundColor: myWhite.withOpacity(0.95),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.seller,),
        //centerTitle: true,
        elevation: 0,
        foregroundColor: myblack,
        backgroundColor: myWhite,
        actions: [
          // IconButton(
          //     onPressed: (){
          //       Get.to(()=>EditSeller(sellerData: widget.sellerData,));
          //     },
          //     icon: Icon(Icons.edit, color: textColor2,)
          // ),
          // SizedBox(width: 8,),
          // IconButton(
          //     onPressed: (){},
          //     icon: Icon(Icons.delete, color: textColor2,)
          // ),
          // SizedBox(width: 8,),
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 4, right: 8),
            child: InkWell(
              onTap: ()async{
                var result = await confirmationDialog(context: context,
                    title: AppLocalizations.of(context)!.changeAlertMsg,
                    negativeActionText: AppLocalizations.of(context)!.no,
                    positiveActionText: AppLocalizations.of(context)!.yes);

                if(result==true){
                  changeSellerStatus();
                }
              },
              borderRadius: BorderRadius.circular(4),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  //color: status.toString().contains('Active') ? failedColor : successColor,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    AppLocalizations.of(context)!.changeStatus,
                    style: TextStyle(color: status.toString().contains('Active') ? successColor : failedColor,),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: ScrollConfiguration(
          behavior: MyBehavior(),
          child: ListView(
            children: [
              buildTitle(AppLocalizations.of(context)!.sellerName),
              buildContainer(name, size),
              buildTitle(AppLocalizations.of(context)!.phoneNumber),
              buildContainer(phone, size),
              buildTitle(AppLocalizations.of(context)!.emailAddress),
              buildContainer(email, size),
              buildTitle(AppLocalizations.of(context)!.address),
              buildContainer(address, size),
              buildTitle(AppLocalizations.of(context)!.status),
              buildContainer(status, size),

              SizedBox(height: size.height*0.05,),
              buildPhoneSmsEmail(size),
            ],
          ),
        ),
      ),
    );
  }

  void changeSellerStatus()async{
    //show a loader
    customDialog();

    var result = await sellerController.changeSellerStatus(widget.sellerData.id.toString());

    //close loader
    closeDialog();

    showToastMessage(result);

    if(result.toString().contains('Status has been changed')){
      //refresh seller page
      RefreshSeller().refresh();

      //swap status
      setState(() {
        if(status.toString().contains('Active')){
          status='Inactive';
        }
        else{
          status='Active';
        }
      });
    }
  }

  Widget buildTitle(String title){
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 8, left: 8, right: 8),
      child: Text(title, style: TextStyle(color: textColor2,),),
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
            createCall('$phone');
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
            createSMS('$phone');
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
        widget.sellerData.email.toString().contains("null")?
        Container()
            :
        SizedBox(width: 16,),

        widget.sellerData.email.toString().contains("null")?
        Container()
            :
        InkWell(
          onTap: (){
            createEmail('${widget.sellerData.email}');
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
