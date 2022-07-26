
import 'package:billing_app/routes/routes.dart';
import 'package:billing_app/src/widgets/customBadge.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share/share.dart';

import '../constaints/colors/AppColors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

var myAppBar=AppBar(
  backgroundColor: myWhite,
  foregroundColor: mainColor,
  leading: Padding(
    padding: const EdgeInsets.only(left: 15,top: 8, bottom: 8),
    child: Builder(
      builder: (context) {
        return InkWell(
          onTap:(){
            Scaffold.of(context).openDrawer();
          },
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: mainColor.withOpacity(0.2),
            ),
            child: Icon(Icons.menu_outlined,color: mainColor,),
          ),
        );
      }
    ),
  ),
  title: Builder(
    builder: (context) {
      return Text(AppLocalizations.of(context)!.appName);
    }
  ),
  elevation: 0,
  actions: [
    Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Builder(
        builder: (context) {
          return InkWell(
            onTap:(){
              Get.toNamed(RouteGenerator.notifications);
            },
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: mainColor.withOpacity(0.2),
              ),
              child: CustomBadge(
                value: '5',
                right: 2,
                top: 2,
                child: Icon(Icons.notifications_outlined,color: mainColor,),
              ),
            ),
          );
        }
      ),
    ),
    SizedBox(width: 16,),
    Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: (){
          Share.share('https://play.google.com/store/apps/details?id=com.example.room_sharing',subject: 'Share this app with your friends.');
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: mainColor.withOpacity(0.2),
          ),
          child: Icon(Icons.share,color: mainColor,),
        ),
      ),
    ),
    SizedBox(width: 16,),
  ],
);