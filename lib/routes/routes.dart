import 'package:billing_app/pages/addCustomer.dart';
import 'package:billing_app/pages/addSupplier.dart';
import 'package:billing_app/pages/add_product.dart';
import 'package:billing_app/pages/authentication/forgot_password.dart';
import 'package:billing_app/pages/authentication/login_screen.dart';
import 'package:billing_app/pages/authentication/otp_screen.dart';
import 'package:billing_app/pages/authentication/sign_up.dart';
import 'package:billing_app/pages/customeres.dart';
import 'package:billing_app/pages/invoice.dart';
import 'package:billing_app/pages/mainpage.dart';
import 'package:billing_app/pages/product_screen.dart';
import 'package:billing_app/pages/updateProfilePage.dart';
import 'package:billing_app/pages/public_vendors.dart';
import 'package:billing_app/pages/purchase.dart';
import 'package:billing_app/pages/sales_screen.dart';
import 'package:billing_app/pages/splash_screen/splash_screen.dart';
import 'package:billing_app/pages/stock.dart';
import 'package:billing_app/pages/supplier.dart';
import 'package:flutter/material.dart';

import '../profilePage.dart';

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
  static const String purchase = '/purchase';
  static const String stock = '/stock';
  static const String invoice = '/invoice';
  static const String publicVendors = '/publicVendors';
  static const String addProduct = '/addProduct';
  static const String addCustomer = '/addCustomer';
  static const String addSupplier = '/addSupplier';
  static const String profilePage = '/profilePage';
  static const String updateProfilePage = '/updateProfilePage';

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
      case purchase:
        return MaterialPageRoute(builder: (_) => const Purchase());
      case stock:
        return MaterialPageRoute(builder: (_) => const Stock());
      case invoice:
        return MaterialPageRoute(builder: (_) => const Invoice());
      case publicVendors:
        return MaterialPageRoute(builder: (_) => const PublicVendors());
      case addProduct:
        return MaterialPageRoute(builder: (_) => const AddProduct());
      case addCustomer:
        return MaterialPageRoute(builder: (_) => const AddCustomer());
      case addSupplier:
        return MaterialPageRoute(builder: (_) => const AddSupplier());
      case profilePage:
        return MaterialPageRoute(builder: (_) => const ProfilePage());
      case updateProfilePage:
        return MaterialPageRoute(builder: (_) => const UpdateProfilePage());

      default:
        throw 'Route not found';
    }
  }
}