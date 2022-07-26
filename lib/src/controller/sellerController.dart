import 'dart:convert';

import 'package:billing_app/src/constaints/util/util.dart';
import 'package:billing_app/src/controller/tokenController.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../routes/routes.dart';
import '../model/sellerData.dart';

class SellerController extends GetxController{

  var seller=<SellerData>[].obs;
  var isLoading=true.obs;
  var tokenController=Get.find<TokenController>();
  var pageNumber=1.obs;
  var loadedCompleted=false.obs;


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getData();
  }

  void getData({String? name})async{
    try{
      Util().checkInternet();

      var data;
      var response;

      ///if search by seller name
      if(name!=null){

        isLoading(true);
        loadedCompleted(true);

        response=await http.get(Uri.parse(Util.baseUrl + Util.customer_search + name),headers: {
          "Accept": "application/json",
          "Authorization" : "Bearer ${tokenController.token}"
        });

        print(response.statusCode);
        print(response.body);
        data=jsonDecode(response.body.toString());

        if(data['message'].toString().contains('Unauthenticated')){
          Get.offAllNamed(RouteGenerator.login);
        }
        else{
          if(response.statusCode==200){
            seller.value=[];
            data=data['data'];
            if(data!=null){
              for(Map i in data){
                seller.add(SellerData.fromJson(i));
                seller.refresh();
              }
            }
            isLoading(false);
          }
          else{
            isLoading(false);
            throw Exception('No data found');
          }
        }


      }

      ///if search text is empty then we show all seller with pagination
      else{
        response=await http.get(Uri.parse(Util.baseUrl + Util.seller_index + "$pageNumber"),headers: {
          "Accept": "application/json",
          "Authorization" : "Bearer ${tokenController.token}"
        });

        print(response.statusCode);
        print(response.body);
        data=jsonDecode(response.body.toString());

        if(data['message'].toString().contains('Unauthenticated')){
          Get.offAllNamed(RouteGenerator.login);
        }
        else{
          if(response.statusCode==200){

            if(data['links']['next'] != null){
              loadedCompleted(false);
            }
            else{
              loadedCompleted(true);
            }

            data=data['data'];
            if(data!=null){
              for(Map i in data){
                seller.add(SellerData.fromJson(i));
                seller.refresh();
              }
            }
            isLoading(false);
          }
          else{
            isLoading(false);
            throw Exception('No data found');
          }
        }


      }

    }catch(e){
      isLoading(false);
      print(e);
    }


  }

  Future<String> addSeller(int countryCodeId, String name, String phone, String email, String address, String password, String confirmPassword)async{
    try{
      var map=Map<String,dynamic>();
      map['name']='${name}';
      map['country_code']='${countryCodeId}';
      map['mobile']='${phone}';
      if(email.isNotEmpty){
        map['email']='${email}';
      }
      map['address']='${address}';
      map['password']='${password}';
      map['password_confirmation']='${confirmPassword}';
      final response=await http.post(Uri.parse(Util.baseUrl + Util.seller_store),
          body: map,
          headers : {
            "Accept": "application/json",
            "Authorization" : "Bearer ${tokenController.token}"
          });
      var data=jsonDecode(response.body.toString());
      print(response.body);
      print(response.statusCode);
      if(response.statusCode==200){
        return data['message'];
      }
      else{
        return data['message'];
      }
    }catch(e){
      return 'Seller Added Failed';
    }
  }

  Future<String> updateSeller(String id, String name, String phone, String email, String address)async{
    try{
      var map=Map<String,dynamic>();
      map['name']='${name}';
      map['phone']='${phone}';
      if(email.isNotEmpty){
        map['email']='${email}';
      }
      map['address']='${address}';

      final response=await http.put(Uri.parse(Util.baseUrl + Util.customer_update),
          body: map,
          headers : {
            "Accept": "application/json",
            "Authorization" : "Bearer ${tokenController.token}"
          });

      var data=jsonDecode(response.body.toString());
      print(response.body);
      print(response.statusCode);


      if(response.statusCode==200){
        return 'Customer Edit Successful';
      }
      else{
        print(response.body);
        return data['message'];
      }
    }catch(e){
      print(e);
      return 'Customer Edit Failed';
    }
  }

  Future<String> changeSellerStatus(String id)async{
    try{
      final response=await http.post(Uri.parse(Util.baseUrl + Util.seller_changeStatus + id),
          headers : {
            "Accept": "application/json",
            "Authorization" : "Bearer ${tokenController.token}"
          });

      var data=jsonDecode(response.body.toString());
      print(response.body);
      print(response.statusCode);

      if(response.statusCode==200){
        return data['message'];
      }
      else{
        return data['message'];
      }
    }catch(e){
      return 'Failed to change status';
    }
  }

}