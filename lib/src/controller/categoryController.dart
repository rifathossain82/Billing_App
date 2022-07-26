import 'dart:convert';

import 'package:billing_app/src/constaints/util/util.dart';
import 'package:billing_app/src/controller/tokenController.dart';
import 'package:billing_app/src/model/categoryModel.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../routes/routes.dart';

class CategoryController extends GetxController{
  var category=<CategoryModel>[].obs;
  var isLoading=true.obs;
  var tokenController=Get.find<TokenController>();

  @override
  void onInit() {
    getData(type: 'active');
    super.onInit();
  }

  void getData({String? type, String? name})async{
    try{
      Util().checkInternet();

      var data;
      var response;
      isLoading(true);

      if(name!=null){
        response=await http.get(Uri.parse(Util.baseUrl + Util.category_search+type.toString()+"/${name.toString()}"),headers: {
          "Accept": "application/json",
          "Authorization" : "Bearer ${tokenController.token}"
        });
      }
      else{
        response=await http.get(Uri.parse(Util.baseUrl + Util.category_index+type.toString()),headers: {
          "Accept": "application/json",
          "Authorization" : "Bearer ${tokenController.token}"
        });
      }

      print(response.body);
      print(response.statusCode);
      data=jsonDecode(response.body.toString());

      if(data['message'].toString().contains('Unauthenticated')){
        Get.offAllNamed(RouteGenerator.login);
      }
      else{
        if(response.statusCode==200){
          category.value=[];
          data=data['data'];
          if(data!=null){
            for(Map i in data){
              category.add(CategoryModel.fromJson(i));
              category.refresh();
            }
          }
          isLoading(false);
        }
        else{
          isLoading(false);
          throw Exception('No data found');
        }
      }
    }catch(e){
      isLoading(false);
      print(e);
    }

  }

  Future<String> addCategory(String name)async{
    try{
      var map=Map<String,dynamic>();
      map['name']='${name}';
      final response=await http.post(Uri.parse(Util.baseUrl+Util.category_store),
          body: map,
          headers : {
            "Accept": "application/json",
            "Authorization" : "Bearer ${tokenController.token}"
          });

      var data=jsonDecode(response.body);
      if(response.statusCode==200){
        return 'Category Added';
      }
      else{
        return data['message'];
      }
    }catch(e){
      return 'Category Added Failed';
    }
  }

  Future<String> updateCategory(String id, String name, int status)async{
    try{
      var map=Map<String,dynamic>();
      map['name']='${name}';
      map['is_active']='${status.toString()}';
      final response=await http.put(Uri.parse(Util.baseUrl+Util.category_update+id),
          body: map,
          headers : {
            "Accept": "application/json",
            "Authorization" : "Bearer ${tokenController.token}"
          });
      print(response.statusCode);
      print(response.body);
      var data=jsonDecode(response.body);
      if(response.statusCode==200){
        return 'Category Edit Successful';
      }
      else{
        return data['message'];
      }
    }catch(e){
      return 'Category Edit Failed';
    }
  }

  Future<String> deleteCategory(String id)async{
    try{
      final response=await http.delete(Uri.parse(Util.baseUrl+Util.category_delete+id),
          headers : {
            "Accept": "application/json",
            "Authorization" : "Bearer ${tokenController.token}"
          });

      var data=jsonDecode(response.body);

      if(response.statusCode==200){
        return 'Category Deleted';
      }
      else{
        return data['message'];
      }
    }catch(e){
      return 'Category Deleted Failed';
    }
  }

  Future<String> restoreCategory(String id)async{
    try{
      final response=await http.post(Uri.parse(Util.baseUrl+Util.category_restore+id),
          headers : {
            "Accept": "application/json",
            "Authorization" : "Bearer ${tokenController.token}"
          });

      var data=jsonDecode(response.body);

      if(response.statusCode==200){
        return 'Category Restored';
      }
      else{
        return data['message'];
      }
    }catch(e){
      return 'Category Restored Failed';
    }
  }
}