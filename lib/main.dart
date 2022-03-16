import 'package:billing_app/constaints/strings/AppStrings.dart';
import 'package:billing_app/routes/routes.dart';
import 'package:flutter/material.dart';

void main(){
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appName,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white
      ),
      initialRoute: RouteGenerator.forgotPassword,
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
