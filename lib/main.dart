import 'package:billing_app/routes/routes.dart';
import 'package:billing_app/src/constaints/colors/AppColors.dart';
import 'package:billing_app/src/constaints/strings/AppStrings.dart';
import 'package:billing_app/src/controller/authenticationController.dart';
import 'package:billing_app/src/controller/currencyController.dart';
import 'package:billing_app/src/controller/tokenController.dart';
import 'package:billing_app/src/provider/localProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'l10n/l10n.dart';

void main(){
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(AuthenticationController());
  Get.put(TokenController());
  Get.put(CurrencyController());
  runApp(const MyApp());

  // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
  //     statusBarColor: mainColor,
  //
  //   // Status bar brightness (optional)
  //   statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
  //   statusBarBrightness: Brightness.light, // For iOS (dark icons)

  // ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context)=>LocalProvider(),
      builder: (context,child){
        final provider=Provider.of<LocalProvider>(context);
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: appName,
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.white,
            primarySwatch: colorCustom,
            primaryColor: mainColor,
            progressIndicatorTheme: ProgressIndicatorThemeData(color: mainColor),
            fontFamily: 'inter',
            unselectedWidgetColor: Colors.black54,
            appBarTheme: const AppBarTheme(
                foregroundColor: Colors.white
            ),
          ),
          initialRoute: RouteGenerator.splash,
          getPages: RouteGenerator.routes,
          supportedLocales: L10n.all,
          locale: provider.locale ,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            //GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
        );
      },
    );
  }
}
