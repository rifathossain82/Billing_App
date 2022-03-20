import 'package:billing_app/pages/authentication/forgot_password.dart';
import 'package:billing_app/pages/authentication/login_screen.dart';
import 'package:billing_app/pages/authentication/otp_screen.dart';
import 'package:billing_app/pages/authentication/sign_up.dart';
import 'package:billing_app/pages/customeres.dart';
import 'package:billing_app/pages/mainpage.dart';
import 'package:billing_app/pages/product_screen.dart';
import 'package:billing_app/pages/sales_screen.dart';
import 'package:billing_app/pages/splash_screen/splash_screen.dart';
import 'package:billing_app/pages/supplier.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static const String splash = '/';
  static const String login = '/login';
  static const String signUp = '/signUp';
  static const String otpScreen = '/otpScreen';
  static const String forgotPassword = '/forgotPassword';
  static const String mainPage = '/mainPage';
  static const String product = '/product';
  static const String sales = '/sales';
  static const String customers = '/customers';
  static const String supplier = '/supplier';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case signUp:
        return MaterialPageRoute(builder: (_) => const SignUpScreen());
      case otpScreen:
        return MaterialPageRoute(builder: (_) => const OtpScreen());
      case forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPassword());
      case mainPage:
        return MaterialPageRoute(builder: (_) => const MainPage());
      case product:
        return MaterialPageRoute(builder: (_) => const ProductScreen());
      case sales:
        return MaterialPageRoute(builder: (_) => const SalesScreen());
      case customers:
        return MaterialPageRoute(builder: (_) => const Customers());
      case supplier:
        return MaterialPageRoute(builder: (_) => const Supplier());

      default:
        throw 'Route not found';
    }
  }
}