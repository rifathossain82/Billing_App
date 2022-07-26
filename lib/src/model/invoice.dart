//I use this model to generate invoice pdf file

import 'package:billing_app/src/model/supplierData.dart';
import 'package:billing_app/src/model/userModel.dart';

import 'customerData.dart';

class Invoice {
  final InvoiceInfo info;
  final Seller seller;
  final CustomerData customerData;
  final List<InvoiceItem> items;

  const Invoice({
    required this.info,
    required this.seller,
    required this.customerData,
    required this.items,
  });
}

class InvoiceInfo {
  final String businessName;
  final String email;
  final String countryCode;
  final String mobile;
  final String address;
  final DateTime date;
  final String number;
  final double discount;

  const InvoiceInfo({
    required this.businessName,
    required this.email,
    required this.countryCode,
    required this.mobile,
    required this.address,
    required this.date,
    required this.number,
    required this.discount,
  });
}

class Seller{
  final String? id;
  final String? name;
  final String? countryCode;
  final String? phone;
  final String? email;
  final String? address;

  Seller({this.id, this.name, this.countryCode, this.phone, this.email, this.address});
}

class InvoiceItem {
  int? product_id;
  String? productName;
  String? qty;
  String? unit;
  double? unitPrice;
  String? discount;
  double? vat;
  double? tax;
  double? total;

  InvoiceItem(
      {
      this.product_id,
      this.productName,
      this.qty,
      this.unit,
      this.unitPrice,
      this.discount,
      this.vat,
      this.tax,
      this.total});
}