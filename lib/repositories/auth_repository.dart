import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'dart:convert';

import '../app_config.dart';
import '../data_model/confirm_code_response.dart';
import '../data_model/login_response.dart';
import '../data_model/logout_response.dart';
import '../data_model/password_confirm_response.dart';
import '../data_model/password_forget_response.dart';
import '../data_model/resend_code_response.dart';
import '../data_model/signup_response.dart';
import '../data_model/user_by_token.dart';
import '../helpers/shared_value_helper.dart';

class AuthRepository {

  Future<LoginResponse> getLoginResponse(
      @required String email, @required String password) async {
    try {
      print("${AppConfig.BASE_URL}/auth/login");
      final response = await http.post(Uri.parse("${AppConfig.BASE_URL}/auth/login"),
          headers: {"Content-type": "application/json", "Accept": "application/json"},
          body: jsonEncode({"email": email, "password": password,"identity_matrix": AppConfig.purchase_code}));
      print(jsonEncode({"email": email, "password": password,"identity_matrix": AppConfig.purchase_code}));
      print(response.statusCode);
      print('Abhijeet ' + response.body.toString());

      if (response.statusCode == 200) {
        // If the response is successful, return the LoginResponse
        return LoginResponse.fromJson(json.decode(response.body.toString()));
      } else {
        // If the response is not successful, handle the error and return an error Future
        throw Exception('Failed to fetch login response: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exceptions and return an error Future
      print(e);
      throw Exception('An error occurred: $e');
    }
  }


  /*Future<LoginResponse> getLoginResponse(
      @required String email, @required String password) async {
    // var post_body = jsonEncode({"email": "${email}", "password": "$password","identity_matrix": AppConfig.purchase_code});
   // print(post_body.toString());
  try{
    print("${AppConfig.BASE_URL}/auth/login");
    final response = await http.post(Uri.parse("${AppConfig.BASE_URL}/auth/login"),
        headers: {"Content-type": "application/json", "Accept": "application/json"},
        body: jsonEncode({"email": email, "password": password,"identity_matrix": AppConfig.purchase_code}));
    print(jsonEncode({"email": email, "password": password,"identity_matrix": AppConfig.purchase_code}));
    print( response.statusCode);
    print('Abhijeet '+response.body.toString());
    return LoginResponse.fromJson(json.decode(response.body.toString()));
  }catch(e){
    print(e);
  }
  }*/
  Future<LoginResponse> getSocialLoginResponse(
  @required String name ,@required String email, @required String provider) async {
    var post_body = jsonEncode({"name": "${name}", "email": "${email}", "provider": "$provider"});
    final response = await http.post(Uri.parse("${AppConfig.BASE_URL}/auth/social-login"),
        headers: {"Content-Type": "application/json"}, body: post_body);
    print('BBBBBBBBB response.body.toString()');
    return LoginResponse.fromJson(json.decode(response.body));
  }

  Future<LogoutResponse> getLogoutResponse() async {
    final response = await http.get(Uri.parse(
      "${AppConfig.BASE_URL}/auth/logout"),
      headers: {
        "Authorization": "Bearer ${access_token.$}"
      },
    );

    print(response.body);

    return logoutResponseFromJson(response.body);
  }

  Future<SignupResponse> getSignupResponse(
      signup_url
      ) async {
    /*var post_body = jsonEncode({
      "name": "$name",
      "email_or_phone": "${email_or_phone}",
      "password": "$password",
      "password_confirmation": "${passowrd_confirmation}",
      "register_by": "$register_by"
    });*/
    var url= AppConfig.SIGNIN_SIGNUP+signup_url;
   // print(post_body.toString());
    print("Print Url For Signup URL BY Abhijeet :- $url");

    final response = await http.get(Uri.parse(url));
    print("Print Response For Signup API BY Abhijeet:-" +response.body.toString());
    /*await http.post(Uri.parse("${AppConfig.BASE_URL}/auth/signup"),
        headers: {"Content-Type": "application/json"}, body: post_body);*/

    return signupResponseFromJson(response.body);
  }

/*  Future<ResendCodeResponse> getResendCodeResponse(
      @required int user_id, @required String verify_by) async {
    var post_body =
        jsonEncode({"user_id": "$user_id", "register_by": "$verify_by"});

    final response = await http.post(Uri.parse("${AppConfig.BASE_URL}/auth/resend_code"),
        headers: {"Content-Type": "application/json"}, body: post_body);

    return resendCodeResponseFromJson(response.body);
  }*/

  Future<ConfirmCodeResponse> getConfirmCodeResponse(
      @required int user_id, @required String verification_code) async {
    var post_body = jsonEncode(
        {"user_id": "$user_id", "verification_code": "$verification_code"});

    final response = await http.post(Uri.parse("${AppConfig.BASE_URL}/auth/confirm_code"),
        headers: {"Content-Type": "application/json"}, body: post_body);

    return confirmCodeResponseFromJson(response.body);
  }

  /*Future<PasswordForgetResponse> getPasswordForgetResponse(
      @required String email_or_phone, @required String send_code_by) async {
    var post_body = jsonEncode(
        {"email_or_phone": "$email_or_phone", "send_code_by": "$send_code_by"});

    final response = await http.post(Uri.parse(
        "${AppConfig.BASE_URL}/auth/password/forget_request"),
        headers: {"Content-Type": "application/json"},
        body: post_body);

    //print(response.body.toString());

    return passwordForgetResponseFromJson(response.body);
  }

  Future<PasswordConfirmResponse> getPasswordConfirmResponse(
      @required String verification_code, @required String password) async {
    var post_body = jsonEncode(
        {"verification_code": "$verification_code", "password": "$password"});

    final response = await http.post(Uri.parse(
        "${AppConfig.BASE_URL}/auth/password/confirm_reset"),
        headers: {"Content-Type": "application/json"},
        body: post_body);

    return passwordConfirmResponseFromJson(response.body);
  }

  Future<ResendCodeResponse> getPasswordResendCodeResponse(
      @required String email_or_code, @required String verify_by) async {
    var post_body = jsonEncode(
        {"email_or_code": "$email_or_code", "verify_by": "$verify_by"});

    final response = await http.post(Uri.parse(
        "${AppConfig.BASE_URL}/auth/password/resend_code"),
        headers: {"Content-Type": "application/json"},
        body: post_body);

    return resendCodeResponseFromJson(response.body);
  }
*/
  Future<UserByTokenResponse> getUserByTokenResponse() async {
    var post_body = jsonEncode({"access_token": "${access_token.$}"});

    final response = await http.post(Uri.parse(
        "${AppConfig.BASE_URL}/get-user-by-access_token"),
        headers: {"Content-Type": "application/json"},
        body: post_body);

    return userByTokenResponseFromJson(response.body);
  }
}
