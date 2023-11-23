import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:toast/toast.dart';

import '../Widgets/localization_strings.dart';
import '../addon_config.dart';
import '../app_config.dart';
import '../custom/input_decorations.dart';
import '../custom/intl_phone_input.dart';
import '../custom/toast_component.dart';
import '../my_theme.dart';
import '../repositories/auth_repository.dart';
import 'login.dart';
import 'otp.dart';

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  String _register_by = "email"; //phone or email
  String initialCountry = 'US';
  PhoneNumber phoneCode = PhoneNumber(isoCode: 'US', dialCode: "+1");

  String _phone = "";

  //controllers
  TextEditingController _phoneController = TextEditingController();
  /*TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _passwordConfirmController = TextEditingController();
*/
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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

  /* onPressSignUp() async {
    try {
      var name = _nameController.text.toString();
      var email = _emailController.text.toString();
      var password = _passwordController.text.toString();
      var password_confirm = _passwordConfirmController.text.toString();

      if (name == "") {
        throw Exception("Enter your name");
      } else if (_register_by == 'email' && email == "") {
        throw Exception("Enter email");
      } else if (_register_by == 'phone' && _phone == "") {
        throw Exception("Enter phone number");
      } else if (password == "") {
        throw Exception("Enter password");
      } else if (password_confirm == "") {
        throw Exception("Confirm your password");
      } else if (password.length < 6) {
        throw Exception("Password must contain at least 6 characters");
      } else if (password != password_confirm) {
        throw Exception("Passwords do not match");
      }

      var signupResponse = await AuthRepository().getSignupResponse(
          name,
          _register_by == 'email' ? email : _phone,
          password,
          password_confirm,
          _register_by);

      if (signupResponse.result == false) {
        throw Exception(signupResponse.message.toString());
      } else {
        ToastComponent.showDialog(signupResponse.message.toString(), context,
            gravity: Toast.center, duration: Toast.lengthLong);
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return Otp(
            verify_by: _register_by,
            user_id: signupResponse.user_id,
          );
        }));
      }
    } catch (e) {
      // Handle exceptions here
      ToastComponent.showDialog(e.toString(), context,
          gravity: Toast.center, duration: Toast.lengthLong);
    }
  }*/

  // Save the phone number in shared preferences
  void printSavedPhoneNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String savedPhoneNumber = prefs.getString('phone_number') ?? ''; // Provide a default value if the key is not found

    print('Saved Phone Number: $savedPhoneNumber');
  }

  onPressSignUp() async {
    var phone_no = _phoneController.text.toString();
    var action = "send";
    var otp_type = "signup";
    var signup_url = "?phone_no=$phone_no&action=$action&otp_type=$otp_type";

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
      /*ToastComponent.showDialog(signupResponse.message.toString(), context,
          gravity: Toast.center, duration: Toast.lengthLong);*/
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return Otp(mobile: _phoneController.text);
          /*verify_by: _register_by,
          user_id: signupResponse.user_id,
        );*/
      }));
    }
  }

 /* // onPressSignUp() async {
  //
  //   var phone_no = _phoneController.text.toString();
  //   var action = "send";
  //   var otp_type = "signup";
  //   var signup_url = "?phone_no=$phone_no&action=$action&otp_type=$otp_type";
  //
  //   if (phone_no == "") {
  //     ToastComponent.showDialog("Enter your name", context,
  //         gravity: Toast.center, duration: Toast.lengthLong);
  //     return;
  //   }
  //
  //   var signupResponse = await AuthRepository().getSignupResponse(
  //     signup_url
  //
  //   );
  //
  //   if (signupResponse.result == false) {
  //     ToastComponent.showDialog(signupResponse.message.toString(), context,
  //         gravity: Toast.center, duration: Toast.lengthLong);
  //   } else {
  //     ToastComponent.showDialog(signupResponse.message.toString(), context,
  //         gravity: Toast.center, duration: Toast.lengthLong);
  //     Navigator.push(context, MaterialPageRoute(builder: (context) {
  //       return Otp(
  //         verify_by: _register_by,
  //         user_id: signupResponse.user_id,
  //       );
  //     }));
  //   }
  // }*/


  // onPressSignUp() async {
  //   var phone_no = _phoneController.text.toString();
  //  /* var email = _emailController.text.toString();
  //   var password = _passwordController.text.toString();
  //   var password_confirm = _passwordConfirmController.text.toString();*/
  //
  //   if (phone_no == "") {
  //     ToastComponent.showDialog("Enter your name", context,
  //         gravity: Toast.center, duration: Toast.lengthLong);
  //     return;
  //   } /*else if (_register_by == 'email' && email == "") {
  //     ToastComponent.showDialog("Enter email", context,
  //         gravity: Toast.center, duration: Toast.lengthLong);
  //     return;
  //   } else if (_register_by == 'phone' && _phone == "") {
  //     ToastComponent.showDialog("Enter phone number", context,
  //         gravity: Toast.center, duration: Toast.lengthLong);
  //     return;
  //   } else if (password == "") {
  //     ToastComponent.showDialog("Enter password", context,
  //         gravity: Toast.center, duration: Toast.lengthLong);
  //     return;
  //   } else if (password_confirm == "") {
  //     ToastComponent.showDialog("Confirm your password", context,
  //         gravity: Toast.center, duration: Toast.lengthLong);
  //     return;
  //   } else if (password.length < 6) {
  //     ToastComponent.showDialog(
  //         "Password must contain atleast 6 characters", context,
  //         gravity: Toast.center, duration: Toast.lengthLong);
  //     return;
  //   } else if (password != password_confirm) {
  //     ToastComponent.showDialog("Passwords do not match", context,
  //         gravity: Toast.center, duration: Toast.lengthLong);*/
  //     return;
  //   }
  //
  //   var signupResponse = await AuthRepository().getSignupResponse(
  //       phone_no,
  //       action,
  //       otp_type,
  //     /*  _register_by == 'email' ? email : _phone,
  //       password,
  //       password_confirm,
  //       _register_by*/);
  //
  //   if (signupResponse.result == false) {
  //     ToastComponent.showDialog(signupResponse.message.toString(), context,
  //         gravity: Toast.center, duration: Toast.lengthLong);
  //   } else {
  //     ToastComponent.showDialog(signupResponse.message.toString(), context,
  //         gravity: Toast.center, duration: Toast.lengthLong);
  //     Navigator.push(context, MaterialPageRoute(builder: (context) {
  //       return Otp(
  //         verify_by: _register_by,
  //         user_id: signupResponse.user_id,
  //       );
  //     }));
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final _screen_height = MediaQuery.of(context).size.height;
    final _screen_width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          /*Container(
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
                    LocalizationString.here,
                    style: TextStyle(
                        color: MyTheme.accent_color,
                        fontSize: 22,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                Text(
                  LocalizationString.celebrate,
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
                          LocalizationString.enternum,
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(
                        height: _screen_height * 0.01,
                      ),
                      /*  if (_register_by == "email")*/
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              height: 70,
                              child: Form(
                                key: _formKey,
                                child: TextFormField(
                                  maxLength: 10,
                                  keyboardType: TextInputType.phone,
                                  controller: _phoneController,
                                  autofocus: false,
                                  decoration: InputDecoration(
                                    counterText: "",
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8))),
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
                                text:LocalizationString.bycontin,
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
                            /* AddonConfig.otp_addon_installed
                                  ? GestureDetector(
                                      onTap: () {
                                       */ /* setState(() {
                                          _register_by = "phone";
                                        });*/ /*
                                      },
                                      child: Text(
                                        "or, Register with a phone number",
                                        style: TextStyle(
                                            color: MyTheme.accent_color,
                                            fontStyle: FontStyle.italic,
                                            decoration:
                                                TextDecoration.underline),
                                      ),
                                    )
                                  : Container()*/
                          ],
                        ),
                      ),
                      /* else
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
                                      _phone = number.phoneNumber!;
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
                                  initialValue: phoneCode,
                                  textFieldController: _phoneNumberController,
                                  formatInput: true,
                                  keyboardType: TextInputType.numberWithOptions(
                                      signed: true, decimal: true),
                                  inputDecoration: InputDecorations
                                      .buildInputDecoration_phone(
                                          hint_text: "01710 333 558"),
                                  onSaved: (PhoneNumber number) {
                                    //print('On Saved: $number');
                                  },
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _register_by = "email";
                                  });
                                },
                                child: Text(
                                  "or, Register with an email",
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
                      ),*/
                      /*Padding(
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
                            Text(
                              "Password must be at least 6 character",
                              style: TextStyle(
                                  color: MyTheme.textfield_grey,
                                  fontStyle: FontStyle.italic),
                            )
                          ],
                        ),
                      ),*/
                      /*Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Text(
                          "Retype Password",
                          style: TextStyle(
                              color: MyTheme.accent_color,
                              fontWeight: FontWeight.w600),
                        ),
                      ),*/
                      /*Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Container(
                          height: 36,
                          child: TextField(
                            controller: _passwordConfirmController,
                            autofocus: false,
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                            decoration: InputDecorations.buildInputDecoration_1(
                                hint_text: "• • • • • • • •"),
                          ),
                        ),
                      ),*/
                      /*Padding(
                        padding: const EdgeInsets.only(top: 30.0),
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
                              "Sign Up",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600),
                            ),
                            onPressed: () {
                              onPressSignUp();
                            },
                          ),
                        ),
                      ),*/
                      SizedBox(
                        height: _screen_height * 0.05,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.grey.shade900,
                            minimumSize: Size(
                                _screen_width * 0.9, _screen_height * 0.06)),
                        child: Text(
                          LocalizationString.cont,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,

                              fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            printSavedPhoneNumber();
                            onPressSignUp();
                            /*Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Otp(mobile: _phoneController.text)),
                            );*/
                           /* ToastComponent.showDialog("Register "
                                "Successful", context,
                                gravity: Toast.bottom, duration: Toast.lengthLong);
                            Future.delayed(Duration(seconds: 3), () {

                            });*/
                          }

                          // dataSave();
                          // onPressedLogin();
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Center(
                          child: Text.rich(
                            TextSpan(
                              text: LocalizationString.exist,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: LocalizationString.login,
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
                                            builder: (context) => Login()),
                                      );
                                    },
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      /* Padding(
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
                            // color: MyTheme.golden,
                            // shape: RoundedRectangleBorder(
                            //     borderRadius: const BorderRadius.all(
                            //         Radius.circular(12.0))),
                            child: Text(
                              "Log in",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600),
                            ),
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return Login();
                              }));
                            },
                          ),
                        ),
                      )*/
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
