import 'dart:convert';

import 'package:billing_app/src/constaints/util/util.dart';
import 'package:billing_app/src/controller/tokenController.dart';
import 'package:billing_app/src/model/dashboardDataModel.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../routes/routes.dart';

class DashboardController extends GetxController {

  var dashboardData = <DashboardDataModel>[].obs;
  var isLoading = true.obs;
  var tokenController=Get.find<TokenController>();


  @override
  void onInit() {
    getData();
    super.onInit();
  }

  void getData() async {
    try {
      var data;
      isLoading(true);
      Util().checkInternet();

      var response = await http.get(Uri.parse(
          Util.baseUrl + Util.dashboard_summery),
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer ${tokenController.token}"
          });

      print(response.statusCode);
      print(response.body);
      data = jsonDecode(response.body.toString());

      if (data['message'].toString().contains('Unauthenticated')) {
        Get.offAllNamed(RouteGenerator.login);
      }
      else {
        if (response.statusCode == 200) {
          data = data['data'];
          dashboardData.add(DashboardDataModel.fromJson(data));
          isLoading(false);
        }
        else {
          isLoading(false);
          throw Exception('No data found');
        }
      }
    } catch (e) {
      isLoading(false);
      print(e);
    }
  }

}