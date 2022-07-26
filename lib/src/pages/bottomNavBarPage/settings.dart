import 'package:billing_app/src/constaints/colors/AppColors.dart';
import 'package:billing_app/src/constaints/strings/AppStrings.dart';
import 'package:billing_app/src/controller/authenticationController.dart';
import 'package:billing_app/src/model/userModel.dart';
import 'package:billing_app/src/pages/authentication/otp_screen.dart';
import 'package:billing_app/src/pages/changePassword/changePassword.dart';
import 'package:billing_app/src/pages/privacy_policies/privacy_policies.dart';
import 'package:billing_app/src/widgets/confirmationDialog.dart';
import 'package:billing_app/src/widgets/customDialog.dart';
import 'package:billing_app/src/widgets/customScrollBehavior/myBehavior.dart';
import 'package:billing_app/src/widgets/showToastMessage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../l10n/l10n.dart';
import '../../../routes/routes.dart';
import '../../controller/currencyController.dart';
import '../../controller/sellerController.dart';
import '../../provider/localProvider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../services/closeDialog.dart';
import '../../widgets/mySnackBar.dart';
import '../terms_conditions/terms_condition.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  TextEditingController currencyController=TextEditingController();
  final authenticationController=Get.put(AuthenticationController());
  final currencyController_=Get.put(CurrencyController());

  final currency=Get.find<CurrencyController>().currency.value;
  var language_value;

  late FocusNode currencyFocusNode;

  var user = UserData();
  var isSeller=false;
  var sellerId;

  List<String> languageCodes=[
    'en',
    'bn',
    'hi',
    'ar',
    'ms',
    'pt',
  ];

  @override
  void initState() {
    currencyFocusNode=FocusNode();

    //set initial language english
    language_value=languageCodes[0];

    //find user type
    user=Get.find<AuthenticationController>().user[0];
    sellerId=user.id;
    if(user.userType.toString().contains('seller')){
      setState(() {
        isSeller=true;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    language_value=Localizations.localeOf(context).toString();
    return Scaffold(
      body: ScrollConfiguration(
        behavior: MyBehavior(),
        child: ListView(
          children: [

            ///account section
            SizedBox(height: size.height*0.03,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 8),
              child: Text(AppLocalizations.of(context)!.account, style: TextStyle(fontSize: 14, color: textColor2),),
            ),
            ListTile(
              onTap: (){
                Get.toNamed(RouteGenerator.profilePage);
              },
              leading: Icon(Icons.account_circle_outlined,),
              title: Text(AppLocalizations.of(context)!.accountInfo),
              trailing: Icon(Icons.arrow_forward_ios_sharp,size: 16,),
            ),
            ListTile(
              onTap: (){
                Get.to(() => ChangePassword());
              },
              leading: Icon(Icons.lock_outline,),
              title: Text(AppLocalizations.of(context)!.changePassword),
              trailing: Icon(Icons.arrow_forward_ios_sharp,size: 16,),
            ),
            ListTile(
              onTap: ()async{
                var result= await confirmationDialog(
                  context: context,
                  title: AppLocalizations.of(context)!.doYouWantToLogout,
                  negativeActionText: AppLocalizations.of(context)!.no,
                  positiveActionText: AppLocalizations.of(context)!.yes,
                );

                if(result==true){
                  logoutMethod();
                }
              },
              leading: Icon(Icons.logout_outlined),
              title: Text(AppLocalizations.of(context)!.logout),
              trailing: Icon(Icons.arrow_forward_ios_sharp,size: 16,),
            ),
            isSeller ?
            ListTile(
              onTap: (){
                changeSellerStatus();
              },
              leading: Icon(CupertinoIcons.delete),
              title: Text(AppLocalizations.of(context)!.inactiveAccount),
              trailing: Icon(Icons.arrow_forward_ios_sharp,size: 16,),
            )
                :
            Container(),



            ///common section
            SizedBox(height: size.height*0.03,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 8),
              child: Text(AppLocalizations.of(context)!.common, style: TextStyle(fontSize: 14, color: textColor2),),
            ),
            ListTile(
              onTap: (){
                buildBottomSheet(size);
              },
              leading: Icon(Icons.language_outlined),
              title: Text(AppLocalizations.of(context)!.languageTitle),
              subtitle: Text(AppLocalizations.of(context)!.language,),
              trailing: Icon(Icons.arrow_forward_ios_sharp,size: 16,),
            ),
            ListTile(
              onTap: (){
                currencyDialog(context);
              },
              leading: Icon(Icons.currency_exchange_outlined),
              title: Text(AppLocalizations.of(context)!.currency),
              subtitle: Text(currency,),
              trailing: Icon(Icons.arrow_forward_ios_sharp,size: 16,),
            ),


            ///others section
            SizedBox(height: size.height*0.03,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 8),
              child: Text(AppLocalizations.of(context)!.others, style: TextStyle(fontSize: 14, color: textColor2),),
            ),
            ListTile(
              onTap: (){
                Get.to(PrivacyPoliciesPage());
              },
              leading: Icon(Icons.policy_outlined),
              title: Text(AppLocalizations.of(context)!.policies),
              trailing: Icon(Icons.arrow_forward_ios_sharp,size: 16,),
            ),
            ListTile(
              onTap: (){
                Get.to(TermsConditionsPage());
              },
              leading: Icon(Icons.warning_outlined),
              title: Text(AppLocalizations.of(context)!.terms_conditions),
              trailing: Icon(Icons.arrow_forward_ios_sharp,size: 16,),
            ),
            ListTile(
              onTap: (){
                Get.toNamed(RouteGenerator.help);
              },
              leading: Icon(Icons.help_outline),
              title: Text(AppLocalizations.of(context)!.help),
              trailing: Icon(Icons.arrow_forward_ios_sharp,size: 16,),
            ),
            ListTile(
              onTap: (){
                Get.toNamed(RouteGenerator.reportAnIssue);
              },
              leading: Icon(Icons.report),
              title: Text('Report an issue'),
              trailing: Icon(Icons.arrow_forward_ios_sharp,size: 16,),
            ),
          ],
        ),
      ),
    );
  }

  logoutMethod()async{
    //show a loader
    customDialog();

    var result=await authenticationController.logout();
    saveLanguage();

    //to close loader
    closeDialog();

    mySnackBar(msg: '${result}', context: context, bgColor: mainColor, duration: Duration(seconds: 1));

    if(result!.contains('Logout Successful') || result.contains('Unauthenticated')){
      Get.offAllNamed(RouteGenerator.login);
    }
  }

  void changeSellerStatus()async{

    var sellerController=Get.put(SellerController());

    //show a loader
    customDialog();

    var id=sellerId-1;

    var result = await sellerController.changeSellerStatus(id.toString());

    //close loader
    closeDialog();

    showToastMessage(result);

    if(result.toString().contains('Status has been changed')){
      //refresh seller page
      Get.offAllNamed(RouteGenerator.login);
    }
  }

  //to save or set your currency
  void currencyDialog(BuildContext context){
    currencyFocusNode.requestFocus();
    currencyController.text=Get.find<CurrencyController>().currency.value.toString();
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return StatefulBuilder(
            builder: (BuildContext context, void Function(void Function()) setState){
              return AlertDialog(
                title: Text(AppLocalizations.of(context)!.setYourCurrency,),
                content: SizedBox(
                  height: MediaQuery.of(context).size.height*0.2,
                  child: TextField(
                    controller: currencyController,
                    maxLines: 1,
                    focusNode: currencyFocusNode,
                    onSubmitted: (val){
                      setState((){
                        print(val);
                        currencyController.text=val;
                      });
                    },
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.currency,
                      hintText: 'TK or ৳',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      child: Text(AppLocalizations.of(context)!.cancel)
                  ),
                  TextButton(
                      onPressed: ()async{
                        if(currencyController.text.isNotEmpty){

                          await currencyController_.setCurrency(currencyController.text.toString());  //set currency in getx controller
                          setCurrency(currencyController.text.toString());             //set currency in locale device

                        }
                        else{
                          showToastMessage('Currency can\'t empty!');
                        }

                        //to close dialog
                        Navigator.pop(context);
                      },
                      child: Text(AppLocalizations.of(context)!.ok)
                  ),
                ],
              );
            },
          );
        });
  }

  //save locally
  void setCurrency(String currency)async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('currency', currency);
  }

  //to save current language
  void saveLanguage()async{
    final provider=Provider.of<LocalProvider>(context,listen: false);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('language', provider.locale.toString());

    print(provider.locale.toString());
  }

  Future buildBottomSheet(Size size){
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))
      ),
      builder: (context){
        return buildLanguageRadio(size);
      },
    );
  }

  Widget buildLanguageRadio(Size size){
    return Container(
      alignment: Alignment.center,
      height: size.height*0.45,
      padding: EdgeInsets.only(top: size.height*0.03),
      child: ScrollConfiguration(
        behavior: MyBehavior(),
        child: ListView.builder(
          itemCount: language.length,
          itemBuilder: (context, index){
            return RadioListTile(
              visualDensity: const VisualDensity(vertical: -2),
              title: Text(language[index]),
              value: languageCodes[index],
              groupValue: language_value,
              onChanged: (val){
                setState(() {
                  language_value=val.toString();
                  final provider=Provider.of<LocalProvider>(context,listen: false);
                  provider.setLocale(L10n.all[index]);
                  setLocale(L10n.all[index].toString());
                });

                Navigator.pop(context);
              },
            );
          },
        ),
      ),
    );
  }

  void setLocale(String locale)async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('language', locale);
  }

}
