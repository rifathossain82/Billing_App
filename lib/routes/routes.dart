import 'package:billing_app/pages/authentication/forgot_password.dart';
import 'package:billing_app/pages/authentication/login_screen.dart';
import 'package:billing_app/pages/authentication/otp_screen.dart';
import 'package:billing_app/pages/authentication/sign_up.dart';
import 'package:billing_app/pages/splash_screen/splash_screen.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static const String splash = '/';
  static const String login = '/login';
  static const String signUp = '/signUp';
  static const String otpScreen = '/otpScreen';
  static const String forgotPassword = '/forgotPassword';

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

      default:
        throw 'Route not found';
    }
  }
}