import 'dart:convert';

import 'package:billing_app/src/constaints/util/util.dart';
import 'package:billing_app/src/controller/tokenController.dart';
import 'package:get/get.dart';

import '../../routes/routes.dart';
import '../model/supplierData.dart';
import 'package:http/http.dart' as http;

class SupplierController extends GetxController{

  var supplier=<SupplierData>[].obs;
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
      var data;
      var response;

      Util().checkInternet();

      //to search supplier
      if(name!=null){
        isLoading(true);
        loadedCompleted(true);

        response=await http.get(Uri.parse(Util.baseUrl + Util.supplier_search + name),headers: {
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
            supplier.value=[];
            data=data['data'];
            if(data!=null){
              for(Map i in data){
                supplier.add(SupplierData.fromJson(i));
                supplier.refresh();
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

      //to show all supplier, and with pagination
      else{
        response=await http.get(Uri.parse(Util.baseUrl + Util.supplier_index + "$pageNumber"),headers: {
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
                supplier.add(SupplierData.fromJson(i));
                supplier.refresh();
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

  Future<String> addSupplier(String name, String phone, String email, String address)async{
    try{
      var map=Map<String,dynamic>();
      map['name']='${name}';
      map['phone']='${phone}';
      if(email.isNotEmpty){
        map['email']='${email}';
      }
      map['address']='${address}';
      final response=await http.post(Uri.parse(Util.baseUrl + Util.supplier_store),
          body: map,
          headers : {
            "Accept": "application/json",
            "Authorization" : "Bearer ${tokenController.token}"
          });
      //print(response.body);
      var data=jsonDecode(response.body.toString());
      print(response.statusCode);
      if(response.statusCode==200){
        return 'Supplier Added';
      }
      else{
        return data['message'];
      }
    }catch(e){
      print(e);
      return 'Supplier Added Failed';
    }
  }

  Future<String> updateSupplier(String id, String name, String phone, String email, String address, String status)async{
    try{
      var map=Map<String,dynamic>();
      map['name']='${name}';
      map['phone']='${phone}';
      if(email.isNotEmpty){
        map['email']='${email}';
      }
      map['address']='${address}';
      map['is_active']='${status}';
      final response=await http.put(Uri.parse(Util.baseUrl + Util.supplier_update + id),
          body: map,
          headers : {
            "Accept": "application/json",
            "Authorization" : "Bearer ${tokenController.token}"
          });
      var data=jsonDecode(response.body);
      if(response.statusCode==200){
        print(data['message']);
        return data['message'];
      }
      else{
        return data['message'];
      }
    }catch(e){
      return 'Supplier Edit Failed';
    }
  }

  Future<String> deleteData(String id)async{
    try{
      final response=await http.delete(Uri.parse(Util.baseUrl + Util.supplier_delete + id),
          headers : {
            "Accept": "application/json",
            "Authorization" : "Bearer ${tokenController.token}"
          });
      var data=jsonDecode(response.body);
      print(response.statusCode);
      if(response.statusCode==200){
        return 'Supplier Deleted';
      }
      else{
        return data['message'];
      }
    }catch(e){
      return 'Supplier Deletion Failed';
    }
  }
}