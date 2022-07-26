import 'package:get/get.dart';

class CurrencyController extends GetxController{
  var currency='TK'.obs;

  setCurrency(String _currency){
    currency.value=_currency;
  }
}