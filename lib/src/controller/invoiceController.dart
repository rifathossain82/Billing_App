import 'dart:convert';

import 'package:billing_app/src/constaints/util/util.dart';
import 'package:billing_app/src/controller/tokenController.dart';
import 'package:billing_app/src/model/DateModel.dart';
import 'package:billing_app/src/model/invoiceData.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../routes/routes.dart';

class InvoiceController extends GetxController{

  var invoices=<InvoiceData>[].obs;
  var isLoading=true.obs;
  var tokenController=Get.find<TokenController>();
  var pageNumber=1.obs;
  var loadedCompleted=false.obs;


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getData(dateModel: DateModel());   //dateModel is show error that's why I initial a empty DateModel
  }

  void getData({String? invNumber, String? customerId, DateModel? dateModel})async{
    try{
      Util().checkInternet();

      var response;
      if(dateModel==null){
        dateModel=DateModel();
      }

      if(invNumber!=null){
        isLoading(true);
        loadedCompleted(true);

        print('Search by invNumber');
        response=await http.get(Uri.parse(Util.baseUrl + Util.invoice_search + invNumber),headers: {
          "Accept": "application/json",
          "Authorization" : "Bearer ${tokenController.token}"
        });

        searchByFilter(response);

      }
      else if(customerId!=null && dateModel.startDate==null){
        isLoading(true);
        loadedCompleted(true);

        print('Search by only customer id');
        response=await http.post(Uri.parse(Util.baseUrl + Util.invoice_search_date + customerId),headers: {
          "Accept": "application/json",
          "Authorization" : "Bearer ${tokenController.token}"
        });

        searchByFilter(response);

      }
      else if(dateModel.startDate!=null && customerId==null){
        isLoading(true);
        loadedCompleted(true);

        print(dateModel.startDate);
        print(dateModel.endDate);
        print('Search by only date');

        var map=Map<String,dynamic>();
        map['start']='${dateModel.startDate}';
        map['end']='${dateModel.endDate}';
        response=await http.post(
            Uri.parse(Util.baseUrl + Util.invoice_search_date),
            body: map,
            headers: {
              "Accept": "application/json",
              "Authorization" : "Bearer ${tokenController.token}"
            });

        searchByFilter(response);

      }
      else if(dateModel.startDate!=null && customerId!=null){
        isLoading(true);
        loadedCompleted(true);

        print(dateModel.startDate);
        print(dateModel.endDate);
        print('Search by date and customer');

        var map=Map<String,dynamic>();
        map['start']='${dateModel.startDate}';
        map['end']='${dateModel.endDate}';
        response=await http.post(
            Uri.parse(Util.baseUrl + Util.invoice_search_date +customerId),
            body: map,
            headers: {
              "Accept": "application/json",
              "Authorization" : "Bearer ${tokenController.token}"
            });

        searchByFilter(response);

      }
      else{
        print('Search all');

        response=await http.get(Uri.parse(Util.baseUrl + Util.invoice_index + "$pageNumber"),headers: {
          "Accept": "application/json",
          "Authorization" : "Bearer ${tokenController.token}"
        });

        searchAll(response);

      }
    }catch(e){
      isLoading(false);
      print(e);
    }
  }

  void searchByFilter(var response){
    print(response.statusCode);
    //print(response.body);
    var data=jsonDecode(response.body.toString());

    if(data['message'].toString().contains('Unauthenticated')){
      Get.offAllNamed(RouteGenerator.login);
    }
    else{
      if(response.statusCode==200){
        invoices.value=[];
        data=data['data'];
        if(data!=null){
          for(Map i in data){
            invoices.add(InvoiceData.fromJson(i));
            invoices.refresh();
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

  void searchAll(var response){
    print(response.statusCode);
    //print(response.body);
    var data=jsonDecode(response.body.toString());

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
            invoices.add(InvoiceData.fromJson(i));
            invoices.refresh();
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

}