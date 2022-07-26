import 'package:get/get.dart';

class TokenController extends GetxController{
  var token=''.obs;

  setToken(String _token){
    token.value=_token;
  }
}