import 'package:auto_size_text/auto_size_text.dart';
import 'package:billing_app/src/widgets/customScrollBehavior/myBehavior.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../routes/routes.dart';
import '../../constaints/colors/AppColors.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.notifications,),
        foregroundColor: myblack,
        elevation: 0,
        centerTitle: true,
        backgroundColor: myWhite,
      ),
      body: ScrollConfiguration(
        behavior: MyBehavior(),
        child: ListView.builder(
          itemCount: 15,
          itemBuilder: (context, index){
            return buildNotificationWidget(size);
          },
        ),
      ),
    );
  }

  Widget buildNotificationWidget(Size size){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          SizedBox(height: size.height*0.03,),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: mainColor.withOpacity(0.2),
                ),
                child: Icon(Icons.notifications_outlined,color: mainColor,),
              ),
              SizedBox(width: size.width*0.04,),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: AutoSizeText(
                            'Package Alarm',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: textColor1),
                          ),
                        ),
                        SizedBox(width: size.width*0.07,),
                        Text('15 June, 2022',style: TextStyle(color: textColor2),),
                      ],
                    ),
                    SizedBox(height: size.height*0.012,),
                    AutoSizeText(
                      'In publishing and graphic design, Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document.',
                      style: TextStyle(fontSize: 15, color: textColor2),
                    ),
                  ],
                ),
              ),

            ],
          ),
          SizedBox(height: size.height*0.03,),
          Divider(color: textColor2, height: 1,),
          SizedBox(height: size.height*0.04,),
        ],
      ),
    );
  }
}
