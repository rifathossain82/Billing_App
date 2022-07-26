import 'dart:convert';
import 'package:billing_app/src/constaints/util/util.dart';
import 'package:billing_app/src/controller/tokenController.dart';
import 'package:billing_app/src/model/salesData.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class SalesController extends GetxController{

  var tokenController=Get.find<TokenController>();
  var isSales = false.obs;

  Future<String> addSale(SalesData salesData)async{
      try{
        print(salesData);
        final response=await http.post(Uri.parse(Util.baseUrl + Util.invoice_store),
            body: json.encode(salesData.toJson()),
            headers : {
              "Accept": "application/json",
              "content-type": "application/json",
              "Authorization" : "Bearer ${tokenController.token}"
            });

        var data=jsonDecode(response.body.toString());
        print(response.body);
        print(response.statusCode);
        if(response.statusCode==200){
          isSales(true);
          return data['invoice_no']; //return invoice number
        }
        else{
          return data['message'];
        }
      }catch(e){
        print(e);
        return 'Sale Failed';
      }
    }


}