import 'dart:ffi';
import 'dart:math';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Util{

  //main url of domain
  static String baseUrl="https://inv.webpointbd.com/api/";

  //authentication
  static String register="register";
  static String login="login";
  static String logout="logout";
  static String showUser="user/profile";
  static String updateProfile="user/update";
  static String updateCompany="company/update/info";
  static String changePassword="user/update/password";
  static String changePassword_whenForgot="forget_password_change";
  static String forgotPassword="forget_password";

  //country code
  static String countryCode_index = 'country-code';
  static String countryCode_search = 'country-search/';

  //category
  static String category_index="categoryfilter/";
  static String category_store="category";
  static String category_show="category/";
  static String category_update="category/";
  static String category_delete="category/";
  static String category_restore="category/restore/";
  static String category_search="search/category/";

  //supplier
  static String supplier_index="supplier?page=";
  static String supplier_store="supplier";
  static String supplier_show="supplier/";
  static String supplier_update="supplier/";
  static String supplier_delete="supplier/";
  static String supplier_search="search/supplier/";

  //customer
  static String customer_index="customer?page=";
  static String customer_store="customer";
  static String customer_show="customer/";
  static String customer_update="customer/";
  static String customer_delete="customer/";
  static String customer_search="search/customer/";

  //product
  static String product_index="product?page=";
  static String product_store="product";
  static String product_show="product/";
  static String product_update="product/";
  static String product_delete="product/";
  static String product_search="search/product/";
  static String increment_product_stock="increment/product/stock/";

  //invoice
  static String invoice_index="invoice?page=";
  static String invoice_store="invoice";
  static String invoice_search="invoice/search/";
  static String invoice_search_date="invoice/search-date/";

  //seller
  static String seller_index="seller?page=";
  static String seller_store="seller";
  static String seller_update="seller/update";
  static String seller_changeStatus="seller/status/";

  //summery
  static String dashboard_summery="dashboard";

  //issue Report
  static String issue_report="message";









  //-----------------to get random color----------------------------
  static Color randomColor() {
    return Color(Random().nextInt(0xffffffff));
  }

  static Color randomOpaqueColor() {
    return Color(Random().nextInt(0xffffffff)).withAlpha(0xff);
  }


  //----------------------this are use for invoice making------------------------

  static formatPrice(double price) => '${price.toStringAsFixed(2)}';
  static formatDate(DateTime date) => DateFormat.yMd().format(date);


  //----------------------------appbar ---------------------------------------
  ///PreferredSize of appbar
  double preferredHeight=70;


  //---------------------------assets------------------------------

  String logo='assets/icons/bill.png';
  String phoneNumber='01875-004610';
  String email='info@webpointbd.com';
  String webLink='https://webpointbd.com/';
  String loading_gif='assets/icons/loading.gif';



  //----------------------------to hide keyboard programmatically----------------------

  static hideKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  Future<bool> checkInternet()async{
    var result = await Connectivity().checkConnectivity();
    if(result == ConnectivityResult.none){
      print("No internet connection");
      Get.snackbar(
        'No internet connection',
        'Please, Check your internet connection!',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
    else{
      print("Internet connection is available");
      return true;
    }
  }
}