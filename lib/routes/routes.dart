import 'package:billing_app/src/pages/aboutApp/aboutApp.dart';
import 'package:billing_app/src/pages/category/productCategory.dart';
import 'package:billing_app/src/pages/changePassword/changePassword.dart';
import 'package:billing_app/src/pages/changePassword/changePassword_WhenForget.dart';
import 'package:billing_app/src/pages/due/dueDetails.dart';
import 'package:billing_app/src/pages/help/help.dart';
import 'package:billing_app/src/pages/notifications/notifications.dart';
import 'package:billing_app/src/pages/product/detailsProduct.dart';
import 'package:billing_app/src/pages/report_an_issue/reportAnIssueScreen.dart';
import 'package:billing_app/src/pages/supplier/selectSupplierScreen.dart';
import 'package:billing_app/src/pages/product/updateProduct.dart';
import 'package:billing_app/src/pages/product/updateProductStock.dart';
import 'package:billing_app/src/pages/seller/addSeller.dart';
import 'package:billing_app/src/pages/seller/seller.dart';
import 'package:billing_app/src/pages/seller/sellerHistory.dart';
import 'package:get/get.dart';

import '../src/pages/authentication/forgot_password.dart';
import '../src/pages/authentication/login_screen.dart';
import '../src/pages/authentication/otp_screen.dart';
import '../src/pages/authentication/sign_up.dart';
import '../src/pages/cart/cart_screen.dart';
import '../src/pages/customer/select_customer_screen.dart';
import '../src/pages/customer/addCustomer.dart';
import '../src/pages/customer/customeres.dart';
import '../src/pages/due/due.dart';
import '../src/pages/invoice/invoicePage.dart';
import '../src/pages/invoice/invoiceSettings.dart';
import '../src/pages/mainPage/mainpage.dart';
import '../src/pages/product/add_product.dart';
import '../src/pages/product/product_screen.dart';
import '../src/pages/profile/profilePage.dart';
import '../src/pages/profile/updateProfilePage.dart';
import '../src/pages/sales/sales_screen.dart';
import '../src/pages/splash_screen/splash_screen.dart';
import '../src/pages/stock/stock.dart';
import '../src/pages/supplier/addSupplier.dart';
import '../src/pages/supplier/supplier.dart';

class RouteGenerator {
  static const String splash = '/';
  static const String login = '/login';
  static const String signUp = '/signUp';
  static const String forgotPassword = '/forgotPassword';
  static const String mainPage = '/mainPage';
  static const String product = '/product';
  static const String sales = '/sales';
  static const String customers = '/customers';
  static const String supplier = '/supplier';
  static const String due = '/due';
  static const String stock = '/stock';
  static const String invoice = '/invoice';
  static const String seller = '/seller';
  static const String addProduct = '/addProduct';
  static const String addCustomer = '/addCustomer';
  static const String addSupplier = '/addSupplier';
  static const String profilePage = '/profilePage';
  static const String updateProfilePage = '/updateProfilePage';
  static const String cartScreen = '/cartScreen';
  static const String selectCustomer = '/selectCustomer';
  static const String detailsProduct = '/detailsProduct';
  static const String updateProduct = '/updateProduct';
  static const String notifications = '/notifications';
  static const String aboutApp = '/aboutApp';
  static const String sellerHistory = '/sellerHistory';
  static const String selectSupplier = '/selectSupplier';
  static const String updateStock = '/updateStock';
  static const String dueDetails = '/dueDetails';
  static const String help = '/help';
  static const String addSeller = '/addSeller';
  static const String productCategory = '/productCategory';
  static const String invoiceSettings = '/invoiceSettings';
  static const String changePassword = '/changePassword';
  static const String changePassword_whenForget = '/changePassword_whenForget';
  static const String reportAnIssue = '/reportAnIssue';

  static final routes=[
    GetPage(name: RouteGenerator.splash, page: ()=> SplashScreen()),
    GetPage(name: RouteGenerator.login, page: ()=> LoginScreen()),
    GetPage(name: RouteGenerator.signUp, page: ()=> SignUpScreen()),
    GetPage(name: RouteGenerator.forgotPassword, page: ()=> ForgotPassword()),
    GetPage(name: RouteGenerator.mainPage, page: ()=> MainPage()),
    GetPage(name: RouteGenerator.product, page: ()=> ProductScreen()),
    GetPage(name: RouteGenerator.sales, page: ()=> SalesScreen()),
    GetPage(name: RouteGenerator.customers, page: ()=> Customers()),
    GetPage(name: RouteGenerator.supplier, page: ()=> Supplier()),
    GetPage(name: RouteGenerator.due, page: ()=> Due()),
    GetPage(name: RouteGenerator.stock, page: ()=> Stock()),
    GetPage(name: RouteGenerator.invoice, page: ()=> InvoicePage()),
    GetPage(name: RouteGenerator.seller, page: ()=> Seller()),
    GetPage(name: RouteGenerator.addProduct, page: ()=> AddProduct()),
    GetPage(name: RouteGenerator.addCustomer, page: ()=> AddCustomer()),
    GetPage(name: RouteGenerator.addSupplier, page: ()=> AddSupplier()),
    GetPage(name: RouteGenerator.profilePage, page: ()=> ProfilePage()),
    GetPage(name: RouteGenerator.updateProfilePage, page: ()=> UpdateProfilePage()),
    GetPage(name: RouteGenerator.cartScreen, page: ()=> CartScreen()),
    GetPage(name: RouteGenerator.selectCustomer, page: ()=> SelectCustomer()),
    GetPage(name: RouteGenerator.detailsProduct, page: ()=> DetailsProduct()),
    GetPage(name: RouteGenerator.updateProduct, page: ()=> UpdateProduct()),
    GetPage(name: RouteGenerator.notifications, page: ()=> Notifications()),
    GetPage(name: RouteGenerator.aboutApp, page: ()=> AboutApp()),
    GetPage(name: RouteGenerator.sellerHistory, page: ()=> SellerHistory()),
    GetPage(name: RouteGenerator.selectSupplier, page: ()=> SelectSupplier()),
    GetPage(name: RouteGenerator.updateStock, page: ()=> UpdateProductStock()),
    GetPage(name: RouteGenerator.dueDetails, page: ()=> DueDetails()),
    GetPage(name: RouteGenerator.help, page: ()=> Help()),
    GetPage(name: RouteGenerator.addSeller, page: ()=> AddSeller()),
    GetPage(name: RouteGenerator.productCategory, page: ()=> ProductCategory()),
    GetPage(name: RouteGenerator.invoiceSettings, page: ()=> InvoiceSettings()),
    GetPage(name: RouteGenerator.changePassword, page: ()=> ChangePassword()),
    GetPage(name: RouteGenerator.changePassword_whenForget, page: ()=> ChangePassword_WhenForget()),
    GetPage(name: RouteGenerator.reportAnIssue, page: ()=> ReportAnIssueScreen()),
  ];

}