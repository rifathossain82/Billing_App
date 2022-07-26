import 'dart:async';
import 'package:billing_app/src/constaints/util/util.dart';
import 'package:billing_app/src/controller/authenticationController.dart';
import 'package:billing_app/src/controller/tokenController.dart';
import 'package:billing_app/src/services/closeDialog.dart';
import 'package:billing_app/src/widgets/customDialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../l10n/l10n.dart';
import '../../../routes/routes.dart';
import '../../constaints/strings/AppStrings.dart';
import '../../controller/currencyController.dart';
import '../../provider/localProvider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin{

  var language;
  var currency;
  var token;

  final tokenController=Get.put(TokenController());
  final authenticationController=Get.put(AuthenticationController());
  final currencyController=Get.put(CurrencyController());

  //to fetch previous language, currency, token from local storage
  void getLanguage_Currency_Token() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    setState(() {
      language=sharedPreferences.getString('language');     //fetch language
      currency=sharedPreferences.getString('currency');     //fetch currency
      token=sharedPreferences.getString('token');           //fetch token
    });

    print('Language : $language');
    print('Currency : $currency');
    print('Token : $token');

    if(currency!=null){
      await currencyController.setCurrency(currency);
    }

    //if I get a language the i set it in locale provider
    if(language!=null){
      final provider=Provider.of<LocalProvider>(context,listen: false);

      print(L10n.all.length);
      for(int i=0; i<L10n.all.length;i++){
        if(L10n.all[i].toString().contains(language)){
          provider.setLocale(L10n.all[i]);
        }
        print(i);
        print(L10n.all[i]);
      }

    }

  }

  @override
  void initState() {
    getLanguage_Currency_Token();

    Timer(const Duration(seconds: 5), ()async{
      if(token != null){

        var hasInternet = await Util().checkInternet();
        if(hasInternet){

          //show a loader
          customDialog();

          print('hi');
          await tokenController.setToken(token);
          var result = await authenticationController.showUser();     //to load user data in controller

          //to close the loader
          closeDialog();

          if(!result.toString().contains('Unauthenticated')){
            //if all is well then go to main page
            Get.offAllNamed(RouteGenerator.mainPage);
          }
          else{
            Get.offNamed(RouteGenerator.login);
          }
        }
        else{
          Get.offNamed(RouteGenerator.login);
        }

      }
      else{
        print("Tai");
        Get.offNamed(RouteGenerator.login);
      }
    });

    super.initState();



  }

  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(Util().logo,height: size.width*0.3, width: size.width*0.3,),
              SizedBox(height: size.height*0.08,),
              Text(
                splashBottomText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              Text(
                appVersion,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}