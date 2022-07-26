import 'package:billing_app/src/constaints/util/util.dart';
import 'package:billing_app/src/services/createCall.dart';
import 'package:billing_app/src/services/createEmail.dart';
import 'package:billing_app/src/services/createSMS.dart';
import 'package:billing_app/src/services/launch_url.dart';
import 'package:billing_app/src/widgets/customScrollBehavior/myBehavior.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../constaints/colors/AppColors.dart';

class AboutApp extends StatelessWidget {
  const AboutApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: myWhite.withOpacity(0.95),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.aboutApp,),
        foregroundColor: myblack,
        elevation: 0,
        //centerTitle: true,
        backgroundColor: myWhite,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ScrollConfiguration(
          behavior: MyBehavior(),
          child: ListView(
            children: [

              SizedBox(height: size.height*0.05,),

              buildLogoName(),

              //SizedBox(height: size.height*0.03,),

              //buildMissionSection(),

              SizedBox(height: size.height*0.05,),

              buildDescription(),

              SizedBox(height: size.height*0.1,),

              buildContactUs(size),

              SizedBox(height: size.height*0.2,),

              buildAllRightsSection(size),

            ],
          ),
        ),
      ),
    );
  }

  Widget buildLogoName(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(Util().logo,height: 70,width: 70,fit: BoxFit.fitWidth,),
        SizedBox(height: 8,),
        Text('Billing App',style: TextStyle(fontSize: 22,fontWeight: FontWeight.w700),),
        Text('Version 1.0.0',style: TextStyle(fontSize: 12,fontWeight: FontWeight.w400),),
      ],
    );
  }

  Widget buildMissionSection(){
    return RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
            text: 'We started with two mission:\n',style: TextStyle(color: Colors.black,fontSize: 16),
            children:[
              TextSpan(text: '1. Share rooms, earn money.\n',style: TextStyle(color: Colors.black.withOpacity(0.8),fontSize: 13)),
              TextSpan(text: '2. Find rooms, safe zones',style: TextStyle(color: Colors.black.withOpacity(0.8),fontSize: 13)),
            ]
        )
    );
  }

  Widget buildDescription(){
    return Column(
      children: [
        Text('Mobile POS is an efficient and cost-effective alternative. This is one of the most popular methods since it allows you to use your mobile phone as a payment and returns system for your customers. All you need is an app and a card reader. It is convenient when you need to close a sale quickly.',style: TextStyle(fontSize: 14),),
        SizedBox(height: 8,),
        Text('Finally, we want to give you the opportunity to be financially profitable and to transform your business digitally.'),
      ],
    );
  }

  Widget buildContactUs(Size size){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('Contact Us',style: TextStyle(fontSize: 22,fontWeight: FontWeight.w700),),
        SizedBox(height: size.height*0.02,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: (){
                createCall(Util().phoneNumber);
              },
              icon: Icon(Icons.phone, color: textColor2,)
            ),
            IconButton(
                onPressed: (){
                  createSMS(Util().phoneNumber);
                },
                icon: Icon(Icons.message_outlined, color: textColor2,)
            ),
            IconButton(
                onPressed: (){
                  createEmail(Util().email);
                },
                icon: Icon(Icons.email_outlined, color: textColor2,)
            ),
            IconButton(
                onPressed: (){
                  launch_url(Util().webLink);
                },
                icon: Icon(Icons.language_outlined, color: textColor2,)
            ),
          ],
        )
      ],
    );
  }

  Widget buildAllRightsSection(Size size){
    return  Column(
      children: [
        Divider(),
        SizedBox(
          height: size.height*0.05,
          child: Center(
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  text: 'All Rights Reserved By  ',
                  style: TextStyle(color: Colors.grey),
                  children: [
                    TextSpan(
                        text: Util().email,
                        style: TextStyle(
                            color: Colors.red, fontStyle: FontStyle.italic)
                    )
                  ]
              ),
            ),
          ),
        )
      ],
    );
  }
}
