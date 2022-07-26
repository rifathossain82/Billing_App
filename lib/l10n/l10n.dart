import 'package:flutter/cupertino.dart';

class L10n{
  static final all=[
    const Locale('en'),
    const Locale('bn'),
    const Locale('hi'),
    const Locale('ar'),
    const Locale('ms'),
    const Locale('pt'),
  ];


  static String getFlag(String code){
    switch(code){
      case 'en':
        return '🇺🇸';
      case 'bn':
        return '🇧🇩';
      case 'hi':
        return '🇮🇳';
      case 'ar':
        return '🇦🇪';
      case 'ms':
        return '🇲🇾';
      case 'pt':
        return '🇵🇹';
      default:
        return '🇺🇸';
    }
  }
}