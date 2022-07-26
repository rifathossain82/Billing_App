//I use this model to save and load my product data which included with Add sale and cart screen

import 'package:billing_app/src/model/productData.dart';



class CartData{
  int? id;
  String? name;
  String? brand;
  String? code;
  String? avatar;
  String? tax;
  String? totalStock;
  String? price;
  String? selectedUnit;
  int? salesQuantity;
  int? maxQuantity;
  List<ProductStock>? stockList;


  CartData(
      this.id,
      this.name,
      this.brand,
      this.code,
      this.avatar,
      this.tax,
      this.totalStock,
      this.price,
      this.selectedUnit,
      this.salesQuantity,
      this.maxQuantity,
      this.stockList,
      );

  CartData.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    name = json['name'];
    brand = json['brand'];
    code = json['code'];
    avatar = json['avatar'];
    tax = json['tax'];
    totalStock = json['qty'];
    price = json['price'];
    selectedUnit = json['selected_unit'];
    salesQuantity = json['sales_quantity'];
    maxQuantity = json['max_quantity'];
    if (json['stock'] != null) {
      stockList = <ProductStock>[];
      json['stock'].forEach((v) {
        stockList!.add(new ProductStock.fromJson(v));
      });
    }
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['brand'] = this.brand;
    data['code'] = this.code;
    data['avatar'] = this.avatar;
    data['tax'] = this.tax;
    data['qty'] = this.totalStock;
    data['price'] = this.price;
    data['selected_unit'] = this.selectedUnit;
    data['sales_quantity'] = this.salesQuantity;
    data['max_quantity'] = this.maxQuantity;
    data['stock'] = this.stockList;
    return data;
  }
}