import 'dart:convert';
import 'package:billing_app/src/constaints/util/util.dart';
import 'package:billing_app/src/model/countryCodeData.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class CountryCodeController extends GetxController{
  var countryCode=<CountryCodeData>[].obs;
  var isLoading=true.obs;

  void getData({String? name})async{
    try{
      Util().checkInternet();

      var data;
      var response;
      isLoading(true);

      if(name!=null){
        response=await http.get(Uri.parse(Util.baseUrl + Util.countryCode_search + "${name.toString()}"),headers: {
          "Accept": "application/json",
        });
      }
      else{
        response=await http.get(Uri.parse(Util.baseUrl + Util.countryCode_index),headers: {
          "Accept": "application/json",
        });
      }

      print(response.body);
      print(response.statusCode);
      data=jsonDecode(response.body.toString());

      if(response.statusCode==200){
        countryCode.value=[];
        data=data['data'];
        if(data!=null){
          for(Map i in data){
            countryCode.add(CountryCodeData.fromJson(i));
            countryCode.refresh();
          }
        }
        isLoading(false);
      }
      else{
        isLoading(false);
        throw Exception('No data found');
      }
    }catch(e){
      isLoading(false);
      print(e);
    }

  }

}