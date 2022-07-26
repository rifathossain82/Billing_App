import 'dart:convert';

import 'package:billing_app/src/constaints/util/util.dart';
import 'package:billing_app/src/controller/tokenController.dart';
import 'package:billing_app/src/widgets/showToastMessage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;


class ReportIssueController extends GetxController{

  var tokenController=Get.find<TokenController>();

  Future<bool> submitIssue(String subject, String issue)async{
    try{
      var map=Map<String,dynamic>();
      map['subject']='${subject}';
      map['body']='${issue}';

      final response=await http.post(Uri.parse(Util.baseUrl + Util.issue_report),
          body: map,
          headers : {
            "Accept": "application/json",
            "Authorization" : "Bearer ${tokenController.token}"
          });

      var data=jsonDecode(response.body.toString());
      print(response.body);
      print(response.statusCode);
      showToastMessage(data['message']);
      if(response.statusCode==200){
        return true;
      }
      else{
        return false;
      }
    }catch(e){
      return false;
    }
  }

}