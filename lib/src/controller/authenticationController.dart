import 'dart:convert';
import 'dart:convert' show utf8;
import 'dart:typed_data';
import 'package:billing_app/routes/routes.dart';
import 'package:billing_app/src/constaints/util/util.dart';
import 'package:billing_app/src/controller/tokenController.dart';
import 'package:billing_app/src/model/userModel.dart';
import 'package:billing_app/src/widgets/showToastMessage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationController extends GetxController{
  //var isLoading=true.obs;
  final tokenController=Get.put(TokenController());
  var user=<UserData>[].obs;

  set_Token_Otp_InLocale(var token, var otp)async{
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    prefs.setString('token', '$token');
    prefs.setString('otp', '$otp');

    //test purpose
    Fluttertoast.showToast(
      msg: "${otp}",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.blueGrey,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  clearLocalData()async{
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('cartList');
    prefs.clear();
  }

  Future<String?> login(int countryCode_id, String mobile, String password)async{
    try{

      var map=Map<String,dynamic>();
      map['country_code']='${countryCode_id}';
      map['mobile']='${mobile}';
      map['password']='${password}';
      map['password_confirmation']='${password}';

      final response=await http.post(Uri.parse(Util.baseUrl+Util.login),body: map, headers : {"Accept": "application/json"});
      var data=jsonDecode(response.body.toString());

      print(response.statusCode);
      print(response.body.toString());

      if(response.statusCode==200){
        data=data['data'];
        var token = data['token'];
        var otp = data['otp'];
        print(token);
        print(otp);
        set_Token_Otp_InLocale(token, otp);

        //set token in controller to use later in other controller
        await tokenController.setToken(token);
        return 'Success';
      }
      else{
        return data['message'];
      }
    }
    catch(e){
      print(e);
      return 'Login Failed';
    }
  }

  Future<String?> register(int countryCodeId, String name, String email, String mobile, String password)async{
    try{

      var map=Map<String,dynamic>();
      map['name']='${name}';
      map['email']='${email}';
      map['country_code']='${countryCodeId}';
      map['mobile']='${mobile}';
      map['password']='${password}';
      map['password_confirmation']='${password}';
      final response=await http.post(Uri.parse(Util.baseUrl+Util.register),body: map, headers : {"Accept": "application/json"});
      var data=jsonDecode(response.body);

      print(response.statusCode);
      print(response.body);

      if(response.statusCode==200 || response.statusCode==201){
        data=data['data'];
        var token = data['token'];
        var otp = data['otp'];
        print(token);
        print(otp);
        set_Token_Otp_InLocale(token, otp);

        //set token in controller to use later in other controller
        await tokenController.setToken(token);
        return 'Success';
      }
      else{
        return 'Register Failed';
      }
    }catch(e){
      print(e);
      return 'Register Failed';
    }
  }

  Future<String?> logout()async{
    try{

      final response=await http.post(Uri.parse(Util.baseUrl+Util.logout),headers : {
            "Accept": "application/json",
            "Authorization" : "Bearer ${tokenController.token}"
          });
      var data=jsonDecode(response.body);
      print(response.statusCode);
      print(data);

      if(data['message'].toString().contains('Unauthenticated')){
        return 'Unauthenticated';
      }
      else{
        if(response.statusCode==200){
          await tokenController.setToken('');
          clearLocalData();

          return 'Logout Successful';
        }
        else{
          return 'Logout Failed';
        }
      }
    }catch(e){
      return 'Logout Failed';
    }
  }

  Future<String?> updateUser(String name, String email, String filepath)async{
    try{

      var body=Map<String,String>();
      body['name']='${name}';
      body['email']='${email}';

      Map<String, String> headers = {
        "Accept": "application/json",
        'Content-Type': 'multipart/form-data',
        "Authorization" : "Bearer ${tokenController.token}"
      };

      var request;

      if(filepath.isNotEmpty || filepath!=''){
        request = http.MultipartRequest('POST', Uri.parse(Util.baseUrl+Util.updateProfile))
          ..fields.addAll(body)
          ..headers.addAll(headers)
          ..files.add(await http.MultipartFile.fromPath('avatar', filepath));
      }
      else{
        request = http.MultipartRequest('POST', Uri.parse(Util.baseUrl+Util.updateProfile))
          ..fields.addAll(body)
          ..headers.addAll(headers);
      }

      var response = await request.send();

      //to convert Unit8List to json
      var s=await response.stream.toBytes();
      Uint8List bytes = Uint8List.fromList(s);
      String string = String.fromCharCodes(bytes);
      var data=jsonDecode(string);
      print(data['data']);

      print(response.statusCode);

      if(response.statusCode==200){
        return 'Profile updated successfully';
      }
      else{
        return 'Profile updated failed';
      }
    }catch(e){
      print(e);
      return 'Profile updated failed';
    }
  }

  Future<String?> updateCompanyInfo(String name, String email, String address, String filepath)async{
    try{

      var body=Map<String,String>();
      body['title']='${name}';
      body['email']='${email}';
      body['address']='${address}';

      Map<String, String> headers = {
        "Accept": "application/json",
        'Content-Type': 'multipart/form-data',
        "Authorization" : "Bearer ${tokenController.token}"
      };

      var request;

      if(filepath.isNotEmpty || filepath!=''){
        request = http.MultipartRequest('POST', Uri.parse(Util.baseUrl + Util.updateCompany))
          ..fields.addAll(body)
          ..headers.addAll(headers)
          ..files.add(await http.MultipartFile.fromPath('avatar', filepath));
      }
      else{
        request = http.MultipartRequest('POST', Uri.parse(Util.baseUrl + Util.updateCompany))
          ..fields.addAll(body)
          ..headers.addAll(headers);
      }

      var response = await request.send();

      print(response.statusCode);

      if(response.statusCode==200){
        return 'Updated successfully';
      }
      else{
        return 'Updated failed';
      }
    }catch(e){
      print(e);
      return 'Updated failed';
    }
  }

  Future<String?> changeUserPassword_fromSettings(String oldPassword, String newPassword, String newRePassword)async{
    try{

      var map=Map<String,dynamic>();
      map['old_password']='${oldPassword}';
      map['password']='${newPassword}';
      map['password_confirmation']='${newRePassword}';
      final response=await http.post(Uri.parse(Util.baseUrl+Util.changePassword),
          body: map,
          headers : {
            "Accept": "application/json",
            "Authorization" : "Bearer ${tokenController.token}"
          }
      );
      var data=jsonDecode(response.body);
      print(response.statusCode);
      print(response.body);
      if(response.statusCode==200){
        return data['message'];
      }
      else{
        return data['message'];
      }
    }catch(e){
      return 'Failed to change password';
    }
  }

  Future<String?> changeUserPassword_WhenForget(String newPassword, String newRePassword, String mobile, String countryCodeId)async{
    try{

      var map=Map<String,dynamic>();
      map['password']='${newPassword}';
      map['password_confirmation']='${newRePassword}';
      map['mobile']='${mobile}';
      map['country_code']='${countryCodeId}';
      final response=await http.post(Uri.parse(Util.baseUrl + Util.changePassword_whenForgot),
          body: map,
          headers : {
            "Accept": "application/json",
          }
      );
      var data=jsonDecode(response.body);
      print(response.statusCode);
      print(response.body);
      if(response.statusCode==200){
        return data['message'];
      }
      else{
        return data['message'];
      }
    }catch(e){
      return 'Failed to change password';
    }
  }


  Future<String?> showUser()async{
    try{
      final response=await http.get(
          Uri.parse(Util.baseUrl+Util.showUser),
          headers : {
            "Accept": "application/json",
            "Authorization" : "Bearer ${tokenController.token}"
          });

      var data=jsonDecode(response.body.toString());

      print(response.statusCode);
      print(response.body.toString());

      if(data['message'].toString().contains('Unauthenticated')){
        return 'Unauthenticated';
      }
      else{
        if(response.statusCode==200){
          user.value=[];
          data=data['data'];
          user.add(UserData.fromJson(data));
          print('success');
          return 'Success';
        }
        else{
          return 'Failed';
        }
      }
    }
    catch(e){
      print(e);
      Get.offNamed(RouteGenerator.login);
      return 'Failed';
    }
  }

  Future<bool> forgetPassword(String mobile, String countryCode)async{
    try{
      var map=Map<String,dynamic>();
      map['mobile']='${mobile}';
      map['country_code']='${countryCode}';
      final response=await http.post(Uri.parse(Util.baseUrl + Util.forgotPassword),
          body: map,
          headers : {
            "Accept": "application/json",
          }
      );
      var data=jsonDecode(response.body);
      print(response.statusCode);
      print(response.body);
      if(response.statusCode==200){
        setOTP(data['otp']);
        print(data['otp']);
        return true;
      }
      else{
        showToastMessage(data['message']);
        return false;
      }
    }
    catch(e){
      print(e);
      showToastMessage('Failed to send OTP.');
      return false;
    }
  }

  setOTP(var otp)async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('otp', '$otp');
  }

}