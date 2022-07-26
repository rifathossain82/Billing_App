import 'package:billing_app/src/constaints/colors/AppColors.dart';
import 'package:billing_app/src/controller/authenticationController.dart';
import 'package:billing_app/src/services/launch_url.dart';
import 'package:billing_app/src/widgets/customScrollBehavior/myBehavior.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/routes.dart';
import 'NavigationDrawerHeader.dart';
import 'NavigationDrawerItem.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NavigationDrawer extends StatefulWidget {
  NavigationDrawer({Key? key}) : super(key: key);

  @override
  State<NavigationDrawer> createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {
  final authenticationController=Get.find<AuthenticationController>();

  var imgUrl;
  var userName;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    imgUrl=authenticationController.user[0].company!.avatar;
    userName=authenticationController.user[0].company!.name;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Builder(
        builder: (context) {
          return Column(
            children: [
              Expanded(
                child: ScrollConfiguration(
                  behavior: MyBehavior(),
                  child: ListView(
                    children: [
                      NavigationDrawerHeader(imageUrl: imgUrl!, name: userName!),
                      SizedBox(height: MediaQuery.of(context).size.height*0.03,),
                      NavigationDrawerItem(
                          Icons.category,
                          AppLocalizations.of(context)!.productCategory,
                              (){
                            Navigator.pop(context);
                            Get.toNamed(RouteGenerator.productCategory);
                          }
                      ),
                      NavigationDrawerItem(
                          Icons.shopping_cart,
                          AppLocalizations.of(context)!.cart,
                          (){
                            Navigator.pop(context);
                            Get.toNamed(RouteGenerator.cartScreen);
                          }
                      ),
                      NavigationDrawerItem(
                          Icons.account_circle,
                          AppLocalizations.of(context)!.profile,
                          (){
                            Navigator.pop(context);
                            Get.toNamed(RouteGenerator.profilePage);
                          }
                      ),
                      NavigationDrawerItem(
                          Icons.feedback_outlined,
                          AppLocalizations.of(context)!.feedback,
                          (){
                            Navigator.pop(context);
                            launch_url('https://webpointbd.com/');
                          }
                      ),
                      NavigationDrawerItem(
                          Icons.info,
                          AppLocalizations.of(context)!.aboutApp,
                          (){
                            Navigator.pop(context);
                            Get.toNamed(RouteGenerator.aboutApp);
                          }
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height*0.03,),
                    ],
                  ),
                ),
              ),
              buildFooter(),
              SizedBox(height: MediaQuery.of(context).size.height*0.02,),
            ],
          );
        }
      ),
    );
  }

  Widget buildFooter(){
    return Column(
      children: [
        Text('Web Point Ltd.', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,color: textColor2),),
        Text('info@webpointbd.com', style: TextStyle(fontSize: 12, color: textColor2),),
      ],
    );
  }
}
