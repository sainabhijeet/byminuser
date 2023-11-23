import 'package:byminuser/screens/password_forget.dart';
import 'package:byminuser/screens/registration.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:toast/toast.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:google_sign_in/google_sign_in.dart';

import '../Widgets/localization_strings.dart';
import '../addon_config.dart';
import '../app_config.dart';
import '../custom/input_decorations.dart';
import '../custom/intl_phone_input.dart';
import '../custom/toast_component.dart';
import '../helpers/auth_helper.dart';
import '../my_theme.dart';
import '../repositories/auth_repository.dart';
import '../social_config.dart';
import 'main.dart';
import 'otp.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String _login_by = "email"; //phone or email
  String initialCountry = 'US';
  PhoneNumber phoneCode = PhoneNumber(isoCode: 'US', dialCode: "+1");
  String _phone = "";

  //controllers
 /* TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();*/

  TextEditingController _entermobileController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool hasError = false;

  @override
  void initState() {
    //on Splash Screen hide statusbar
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
    super.initState();
  }

  @override
  void dispose() {
    //before going to other screen show statusbar
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    super.dispose();
  }

  void printSavedPhoneNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String savedPhoneNumber = prefs.getString('phone_number') ?? ''; // Provide a default value if the key is not found

    print('Saved Phone Number: $savedPhoneNumber');
  }

  onPressSignUp() async {
    var phone_no = _entermobileController.text.toString();
    var action = "send";
   /* var otp_type = "signup";*/
    var signup_url = "?phone_no=$phone_no&action=$action";

    if (phone_no == "") {
      ToastComponent.showDialog("Enter your name", context,
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }

    var signupResponse = await AuthRepository().getSignupResponse(signup_url);

    if (signupResponse.result == false) {
      ToastComponent.showDialog(signupResponse.message.toString(), context,
          gravity: Toast.center, duration: Toast.lengthLong);
    } else {
    /*  ToastComponent.showDialog(signupResponse.message.toString(), context,
          gravity: Toast.center, duration: Toast.lengthLong);*/
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return Otp(mobile: _entermobileController.text);
        /*verify_by: _register_by,
          user_id: signupResponse.user_id,
        );*/
      }));
    }
  }

  /* Future<void> dataSave() async {
    var param = {
      "email": _emailController.text.toString(),
      "password": _passwordController.text.toString(),
    };
    print(param.toString());
    try {
      var response = await http.post(
          Uri.parse("https://bymin.com/api/v2/auth/login"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(param));
      print('Abhijeet New'+response.body.toString());
      moveToFillOtp();
    } catch (e) {
      print(e);
    }
  }

  moveToFillOtp() async{
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>
          Main()),
    );
  }*/

  // onPressedLogin() async {
  //   var email = _entermobileController.text.toString();
  //   var password = _passwordController.text.toString();
  //
  //   if (_login_by == 'email' && email == "") {
  //     ToastComponent.showDialog("Enter email", context,
  //         gravity: Toast.center, duration: Toast.lengthLong);
  //     // return;
  //   } else if (_login_by == 'phone' && _phone == "") {
  //     ToastComponent.showDialog("Enter phone number", context,
  //         gravity: Toast.center, duration: Toast.lengthLong);
  //     // return;
  //   } else if (password == "") {
  //     ToastComponent.showDialog("Enter password", context,
  //         gravity: Toast.center, duration: Toast.lengthLong);
  //     // return;
  //   }
  //
  //   var loginResponse = await AuthRepository()
  //       .getLoginResponse(_login_by == 'email' ? email : _phone, password);
  //
  //   if (loginResponse.result == false) {
  //     ToastComponent.showDialog(loginResponse.message.toString(), context,
  //         gravity: Toast.center, duration: Toast.lengthLong);
  //   } else {
  //     ToastComponent.showDialog(loginResponse.message.toString(), context,
  //         gravity: Toast.center, duration: Toast.lengthLong);
  //     AuthHelper().setUserData(loginResponse);
  //     Navigator.push(context, MaterialPageRoute(builder: (context) {
  //       return Main();
  //     }));
  //   }
  //   // } catch (e) {
  //   //   print('07');
  //   //   print(e);
  //     ToastComponent.showToast(message: 'asddd', isSuccess: true);
  //     // ToastComponent.showDialog("An error occurred: $e", context,
  //     //     gravity: Toast.center, duration: Toast.lengthLong);
  //   //   print('08');
  //   // }
  // }

  /*onPressedLogin() async {
    var email = _emailController.text.toString();
    var password = _passwordController.text.toString();

    if (_login_by == 'email' && email == "") {
      ToastComponent.showDialog("Enter email", context,
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    } else if (_login_by == 'phone' && _phone == "") {
      ToastComponent.showDialog("Enter phone number", context,
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    } else if (password == "") {
      ToastComponent.showDialog("Enter password", context,
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }

    var loginResponse = await AuthRepository()
        .getLoginResponse(_login_by == 'email' ? email : _phone, password);

    if (loginResponse.result == false) {
      ToastComponent.showDialog(loginResponse.message.toString(), context,
          gravity: Toast.center, duration: Toast.lengthLong);
    } else {
      ToastComponent.showDialog(loginResponse.message.toString(), context,
          gravity: Toast.center, duration: Toast.lengthLong);
      AuthHelper().setUserData(loginResponse);
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return Main();
      }));
    }
  }*/

  /* onPressedFacebookLogin() async {
    // final facebookLogin = FacebookLogin();
    // final facebookLoginResult = await facebookLogin.logIn(['email']);

    print(facebookLoginResult.accessToken);
    print(facebookLoginResult.accessToken.token);
    print(facebookLoginResult.accessToken.expires);
    print(facebookLoginResult.accessToken.permissions);
    print(facebookLoginResult.accessToken.userId);
    print(facebookLoginResult.accessToken.isValid());

    print(facebookLoginResult.errorMessage);
    print(facebookLoginResult.status);

    // final token = facebookLoginResult.accessToken.token;

    /// for profile details also use the below code
    final graphResponse = await http.get(Uri.parse(
        'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=$token'));
    final profile = json.decode(graphResponse.body);
    //print(profile);
    from profile you will get the below params
    {
     "name": "Iiro Krankka",
     "first_name": "Iiro",
     "last_name": "Krankka",
     "email": "iiro.krankka\u0040gmail.com",
     "id": "<user id here>"
    }

    var loginResponse = await AuthRepository().getSocialLoginResponse(
        profile['name'], profile['email'], profile['id'].toString());

    if (loginResponse.result == false) {
      ToastComponent.showDialog(loginResponse.message.toString(), context,
          gravity: Toast.center, duration: Toast.lengthLong);
    } else {
      ToastComponent.showDialog(loginResponse.message.toString(), context,
          gravity: Toast.center, duration: Toast.lengthLong);
      AuthHelper().setUserData(loginResponse);
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return Main();
      }));
    }
  }*/

/*  onPressedGoogleLogin() async {
    GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        // you can add extras if you require
      ],
    );

    _googleSignIn.signIn().then((GoogleSignInAccount acc) async {
          GoogleSignInAuthentication auth = await acc.authentication;
          print(acc.id);
          print(acc.email);
          print(acc.displayName);
          print(acc.photoUrl);

          acc.authentication.then((GoogleSignInAuthentication auth) async {
            print(auth.idToken);
            print(auth.accessToken);

            //---------------------------------------------------
            var loginResponse = await AuthRepository().getSocialLoginResponse(
                acc.displayName.toString(),
                acc.email,
                auth.accessToken.toString());

            if (loginResponse.result == false) {
              ToastComponent.showDialog(
                  loginResponse.message.toString(), context,
                  gravity: Toast.center, duration: Toast.lengthLong);
            } else {
              ToastComponent.showDialog(
                  loginResponse.message.toString(), context,
                  gravity: Toast.center, duration: Toast.lengthLong);
              AuthHelper().setUserData(loginResponse);
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return Main();
              }));
            }

            //-----------------------------------
          });
        } as FutureOr Function(GoogleSignInAccount? value));
  }*/

  @override
  Widget build(BuildContext context) {
    final _screen_height = MediaQuery.of(context).size.height;
    final _screen_width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          /* Container(
            width: _screen_width * (3 / 4),
            child: Image.asset(
                "assets/splash_login_registration_background_image.png"),
          ),*/
          Container(
            margin: EdgeInsets.only(top: 100),
            width: double.infinity,
            child: SingleChildScrollView(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 40.0, bottom: 15),
                  child: Container(
                    width: 75,
                    height: 75,
                    child:
                        Image.asset('assets/login_registration_form_logo.png'),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Text(
                      "Login here! ",
                      style: TextStyle(
                          color: MyTheme.accent_color,
                          fontSize: 22,
                          fontWeight: FontWeight.w600),
                    )),
                Text(
                  "Sign in with your mobile number"
                  "\nto access your account"
                  "\ninformation.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
                SizedBox(
                  height: _screen_height * 0.05,
                ),
                Container(
                  width: _screen_width * (3 / 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Text(
                          LocalizationString.enter,
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(
                        height: _screen_height * 0.01,
                      ),
                      // if (_login_by == "email")
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 70,
                              child: Form(
                                key: _formKey,
                                child: TextFormField(
                                  maxLength: 10,
                                  keyboardType: TextInputType.phone,
                                  controller: _entermobileController,
                                  autofocus: false,
                                  decoration: InputDecoration(
                                    counterText: "",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(8))
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.red),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.red),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter a phone number';
                                    } else if (value.length != 10) {
                                      return 'Phone number must be 10 digits long';
                                    }
                                    return null; // Return null if the input is valid
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              height: _screen_height * 0.01,
                            ),
                            Text.rich(
                              TextSpan(
                                text: LocalizationString.by,
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: LocalizationString.terms,
                                    style: TextStyle(
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                  TextSpan(
                                    text: LocalizationString.and,
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  TextSpan(
                                    text: LocalizationString.privacy,
                                    style: TextStyle(
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.left,
                            ),

                            /*Text(
                                "By continuing, you agree to Buymin's  Terms of Use  and  Privacy Policy.",
                                style: TextStyle(
                                    color: MyTheme.accent_color,
                                    fontStyle: FontStyle.italic,
                                    // decoration:
                                    // TextDecoration.underline
                                ),
                              ),*/
                          ],
                        ),
                      ),
                      /*  else
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                height: 36,
                                child: CustomInternationalPhoneNumberInput(
                                  onInputChanged: (PhoneNumber number) {
                                    print(number.phoneNumber);
                                    setState(() {
                                      _phone = number.phoneNumber.toString();
                                    });
                                  },
                                  onInputValidated: (bool value) {
                                    print(value);
                                  },
                                  selectorConfig: SelectorConfig(
                                    selectorType: PhoneInputSelectorType.DIALOG,
                                  ),
                                  ignoreBlank: false,
                                  autoValidateMode: AutovalidateMode.disabled,
                                  selectorTextStyle:
                                      TextStyle(color: MyTheme.font_grey),
                                  textStyle:
                                      TextStyle(color: MyTheme.font_grey),
                                  initialValue: phoneCode,
                                  textFieldController: _phoneNumberController,
                                  formatInput: true,
                                  keyboardType: TextInputType.numberWithOptions(
                                      signed: true, decimal: true),
                                  inputDecoration: InputDecorations
                                      .buildInputDecoration_phone(
                                          hint_text: "01710 333 558"),
                                  onSaved: (PhoneNumber number) {
                                    print('On Saved: $number');
                                  },
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _login_by = "email";
                                  });
                                },
                                child: Text(
                                  "or, Login with an email",
                                  style: TextStyle(
                                      color: MyTheme.accent_color,
                                      fontStyle: FontStyle.italic,
                                      decoration: TextDecoration.underline),
                                ),
                              )
                            ],
                          ),
                        ),*/
                      /* Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Text(
                          "Password",
                          style: TextStyle(
                              color: MyTheme.accent_color,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              height: 36,
                              child: TextField(
                                controller: _passwordController,
                                autofocus: false,
                                obscureText: true,
                                enableSuggestions: false,
                                autocorrect: false,
                                decoration:
                                    InputDecorations.buildInputDecoration_1(
                                        hint_text: "• • • • • • • •"),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return PasswordForget();
                                }));
                              },
                              child: Text(
                                "Forgot Password?",
                                style: TextStyle(
                                    color: MyTheme.accent_color,
                                    fontStyle: FontStyle.italic,
                                    decoration: TextDecoration.underline),
                              ),
                            )
                          ],
                        ),
                      ),*/
                      // Padding(
                      //   padding: const EdgeInsets.only(top: 30.0),
                      //   child: Container(
                      //     height: 45,
                      //     decoration: BoxDecoration(
                      //         border: Border.all(
                      //             color: MyTheme.textfield_grey, width: 1),
                      //         borderRadius: const BorderRadius.all(
                      //             Radius.circular(12.0))),
                      //     child:

                      SizedBox(
                        height: _screen_height * 0.05,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.grey.shade900,
                            minimumSize: Size(
                                _screen_width * 0.9, _screen_height * 0.06)),
                        child: Text(
                          LocalizationString.OTP,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            onPressSignUp();
                            /*Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Otp(mobile: _entermobileController.text)),
                            );*/
                           /* ToastComponent.showDialog("Login Successful", context,
                                gravity: Toast.bottom, duration: Toast.lengthLong);
                            Future.delayed(Duration(seconds: 3), () {

                            });*/
                          }
                          // dataSave();
                          // onPressedLogin();
                        },

                        /* onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            ToastComponent.showDialog("Login Successful", context,
                                gravity: Toast.center, duration: Toast.lengthLong);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Otp(mobile: _entermobileController.text)),
                            );
                          }

                          // dataSave();
                          // onPressedLogin();
                        },*/
                      ),
                      //   ),
                      // ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Center(
                          child: Text.rich(
                            TextSpan(
                              text: LocalizationString.newto,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text:LocalizationString.account,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.blue,
                                    // decoration: TextDecoration.underline,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Registration()),
                                      );
                                      print('Create an account tapped');
                                    },
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      /*Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Container(
                          height: 45,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: MyTheme.textfield_grey, width: 1),
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(12.0))),
                          child: ElevatedButton(
                            // minWidth: MediaQuery.of(context).size.width,
                            // //height: 50,
                            // color: MyTheme.accent_color,
                            // shape: RoundedRectangleBorder(
                            //     borderRadius: const BorderRadius.all(
                            //         Radius.circular(12.0))),
                            child: Text(
                              "Sign up",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600),
                            ),
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return Registration();
                              }));
                            },
                          ),
                        ),
                      ),
                      Visibility(
                        visible: SocialConfig.allow_google_login ||
                            SocialConfig.allow_facebook_login,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Center(
                              child: Text(
                            "Login with",
                            style: TextStyle(
                                color: MyTheme.medium_grey, fontSize: 14),
                          )),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30.0),
                        child: Center(
                          child: Container(
                            width: 120,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Visibility(
                                  visible: SocialConfig.allow_google_login,
                                  child: InkWell(
                                    onTap: () {
                                      onPressedGoogleLogin();
                                    },
                                    child: Container(
                                      width: 28,
                                      child:
                                          Image.asset("assets/google_logo.png"),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: SocialConfig.allow_facebook_login,
                                  child: InkWell(
                                    onTap: () {
                                      // onPressedFacebookLogin();
                                    },
                                    child: Container(
                                      width: 28,
                                      child: Image.asset(
                                          "assets/facebook_logo.png"),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: false,
                                  child: InkWell(
                                    onTap: () {
                                      // onPressedTwitterLogin();
                                    },
                                    child: Container(
                                      width: 28,
                                      child: Image.asset(
                                          "assets/twitter_logo.png"),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),*/
                    ],
                  ),
                )
              ],
            )),
          )
        ],
      ),
    );
  }
}
