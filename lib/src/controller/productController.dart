import 'dart:convert';
import 'dart:typed_data';
import 'package:billing_app/src/constaints/util/util.dart';
import 'package:billing_app/src/controller/tokenController.dart';
import 'package:billing_app/src/model/productData.dart';
import 'package:billing_app/src/pages/product/add_product.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../routes/routes.dart';

class ProductController extends GetxController{

  var products=<ProductData>[].obs;
  var isLoading=true.obs;
  double totalStock=0.obs.toDouble();
  var tokenController=Get.find<TokenController>();
  var pageNumber=1.obs;
  var loadedCompleted=false.obs;


  @override
  void onInit() {
    // TODO: implement onInit
    getData();
    super.onInit();
  }

  void getData({String? name})async{
    try{
      var data;
      var response;

      Util().checkInternet();

      ///if search by name or qr code
      if(name!=null){
        isLoading(true);        //show loading indicator
        loadedCompleted(true);

        response=await http.get(Uri.parse(Util.baseUrl + Util.product_search + name),headers: {
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
            isLoading(false);
            totalStock=0;
            products.value=[];
            data=data['data'];
            print(response.statusCode);
            for(Map i in data){
              products.add(ProductData.fromJson(i));
              products.refresh();
            }
          }
          else{
            isLoading(false);
            throw Exception('No data found');
          }
        }

      }

      ///there is no searching text, then we load all product by pagination
      else{
        response=await http.get(Uri.parse(Util.baseUrl + Util.product_index + "${pageNumber}"),headers: {
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
            isLoading(false);

            if(data['links']['next'] != null){
              loadedCompleted(false);
            }
            else{
              loadedCompleted(true);
            }

            data=data['data'];
            print(response.statusCode);
            for(Map i in data){
              products.add(ProductData.fromJson(i));
              products.refresh();
            }
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

  Future<Map> getSingleProduct({String? productId})async{
    var data;
    var response;
    isLoading(true);

    Util().checkInternet();

    response=await http.get(Uri.parse(Util.baseUrl + Util.product_show + productId!),headers: {
      "Accept": "application/json",
      "Authorization" : "Bearer ${tokenController.token}"
    });

    print(response.statusCode);
    print(response.body);

    if(response.statusCode==200){
      data=jsonDecode(response.body.toString());
      data=data['data'];
      ProductData productData=data;
      print('qty is : ${productData.qty}');
      var product=data;

      isLoading(false);

      return product;
    }
    else{
      isLoading(false);
      throw Exception('No data found');
    }
  }

  Future<String> addProduct(
      String filepath,
      String productName,
      int categoryID,
      String brand,
      String code,
      //String purchasePrice,
      //String salesPrice,
      String manufacture,
      double tax,
      int supplierID,
      double quantity,
      String? isActive,
      List<StockModelToAddProduct> stockList,
      )
  async{
    try{

      var body=Map<String,String>();
      body['category_id']='${categoryID}';
      body['name']='${productName}';
      body['brand']='${brand}';
      body['code']='${code}';
      //body['purchase_price']='${purchasePrice}';
      //body['sale_price']='${salesPrice}';
      body['manufacture']='${manufacture}';
      body['tax']='${tax}';
      body['supplier_id']='${supplierID}';
      body['qty']='${quantity}';
      body['is_active']='${isActive}';
      for(int i=0; i<stockList.length; i++){
        body['stock[$i][unit]']='${stockList[i].unit}';
        body['stock[$i][conversion_rate]']='${stockList[i].conversionRate}';
        body['stock[$i][base_unit]']='${stockList[i].baseUnit}';
        body['stock[$i][is_base]']='${stockList[i].isBase}';
        body['stock[$i][price]']='${stockList[i].price}';
      }

      Map<String, String> headers = {
        "Accept": "application/json",
        'Content-Type': 'multipart/form-data',
        "Authorization" : "Bearer ${tokenController.token}"
      };

      var request;

      var url=Util.baseUrl + Util.product_store;

      if(filepath.isEmpty || filepath==''){
        request = http.MultipartRequest('POST', Uri.parse(url))
          ..fields.addAll(body)
          ..headers.addAll(headers);
      }
      else{
        request = http.MultipartRequest('POST', Uri.parse(url))
          ..fields.addAll(body)
          ..headers.addAll(headers)
          ..files.add(await http.MultipartFile.fromPath('avatar', filepath));
      }

      var response = await request.send();

      //to convert Unit8List to json
      var s=await response.stream.toBytes();
      print(s);
      Uint8List bytes = Uint8List.fromList(s);
      String string = String.fromCharCodes(bytes);
      var data=jsonDecode(string);
      print(data);
      print(response.stream.toString());
      print(response.statusCode);


      if(response.statusCode==200 || response.statusCode==201){
        return 'Product add successfully';
      }
      else{
        return 'Product add failed';
      }
    }catch(e){
      print(e);
      return 'Product add failed';
    }
  }

  Future<String> updateProduct(
      String id,
      String filepath,
      String oldImage,
      String productName,
      int categoryID,
      String brand,
      String code,
      //int purchasePrice,
      //int salesPrice,
      String manufacture,
      double tax,
      int supplierID,
      String productStatus,
      double quantity,
      List<ProductStock> stockList,
      )async{
    try{
      var body=Map<String,String>();
      body['category_id']='${categoryID}';
      body['name']='${productName}';
      body['brand']='${brand}';
      body['code']='${code}';
      //body['purchase_price']='${purchasePrice}';
      //body['sale_price']='${salesPrice}';
      body['manufacture']='${manufacture}';
      body['tax']='${tax}';
      body['supplier_id']='${supplierID}';
      body['is_active']='${productStatus}';
      body['qty']='${quantity}';
      for(int i=0; i<stockList.length; i++){
        body['stock[$i][id]']='${stockList[i].id}';
        body['stock[$i][product_id]']='${stockList[i].productId}';
        body['stock[$i][unit]']='${stockList[i].unit}';
        body['stock[$i][conversion_rate]']='${stockList[i].conversionRate}';
        body['stock[$i][base_unit]']='${stockList[i].baseUnit}';
        body['stock[$i][is_base]']='${stockList[i].isBase}';
        body['stock[$i][price]']='${stockList[i].price}';
      }
      body['_method']='PUT';

      Map<String, String> headers = {
        "Accept": "application/json",
        'Content-Type': 'multipart/form-data',
        "Authorization" : "Bearer ${tokenController.token}"
      };

      var request;

      var url=Util.baseUrl + Util.product_update;

      if(filepath.isNotEmpty || filepath!=''){
        request = http.MultipartRequest('POST', Uri.parse(url+id))
          ..fields.addAll(body)
          ..headers.addAll(headers)
          ..files.add(await http.MultipartFile.fromPath('avatar', filepath));
      }
      else{
        request = http.MultipartRequest('POST', Uri.parse(url+id))
          ..fields.addAll(body)
          ..fields.addIf(oldImage.isNotEmpty, 'avatar', oldImage)
          ..headers.addAll(headers);
      }

      var response = await request.send();

      //to convert Unit8List to json
      var s=await response.stream.toBytes();
      print(s);
      Uint8List bytes = Uint8List.fromList(s);
      String string = String.fromCharCodes(bytes);
      var data=jsonDecode(string);
      print(data);
      print(response.stream.toString());
      print(response.statusCode);

      //to add stock we need product id
      //int productId=data['data']['id'];

      //var result = await addStock(productId, baseUnit, conversionRate, quantity, unit);
     // print(result);

      if(response.statusCode==200 || response.statusCode==201){
        return 'Product update successfully';
      }
      else{
        return 'Product update failed';
      }
    }catch(e){
      print(e);
      return 'Product update failed';
    }
  }

  Future<String> deleteProduct(String id)async{
    try{
      final response=await http.delete(Uri.parse(Util.baseUrl + Util.product_delete + id),
          headers : {
            "Accept": "application/json",
            "Authorization" : "Bearer ${tokenController.token}"
          });
      print(response.body);
      print(response.statusCode);
      if(response.statusCode==200){
        return 'Product Deleted';
      }
      else{
        return 'Product Deletion Failed';
      }
    }catch(e){
      return 'Product Deletion Failed';
    }
  }

  Future<String> incrementStock(String id, String qty, List<ProductStock> stockList)async{
    try{
      var body=Map<String,dynamic>();
      body['qty']='${qty}';
      for(int i=0; i<stockList.length; i++){
        body['stock[$i][id]']='${stockList[i].id}';
        body['stock[$i][product_id]']='${stockList[i].productId}';
        body['stock[$i][price]']='${stockList[i].price}';
      }

      final response=await http.post(Uri.parse(Util.baseUrl + Util.increment_product_stock + id),
          body: body,
          headers : {
            "Accept": "application/json",
            "Authorization" : "Bearer ${tokenController.token}"
          });

      var data=jsonDecode(response.body.toString());
      print(response.body);
      print(response.statusCode);


      if(response.statusCode==200){
        return 'Add stock successful';
      }
      else{
        print(response.body);
        return data['message'];
      }
    }catch(e){
      print(e);
      return 'Add stock failed';
    }
  }
}