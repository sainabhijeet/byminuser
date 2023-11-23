import 'package:byminuser/screens/home.dart';
import 'package:byminuser/screens/main.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:toast/toast.dart';
import 'dart:async';
import '../Widgets/localization_strings.dart';
import '../custom/input_decorations.dart';
import '../custom/toast_component.dart';
import '../my_theme.dart';
import '../repositories/auth_repository.dart';
import 'login.dart';
import 'package:http/http.dart' as http;

class Otp extends StatefulWidget {
  String? mobile;

  Otp({Key? key, this.verify_by = "phone_no", this.mobile, this.user_id})
      : super(key: key);
  final String? verify_by;
  final int? user_id;

  @override
  _OtpState createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  //controllers
  TextEditingController _verificationCodeController = TextEditingController();
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  final List<TextEditingController> _controllers =
      List.generate(6, (index) => TextEditingController());

  String error = "";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /*Timer? time;
  bool enabled = false;
  int sec = 60;

  startTimerFun() {
    time = Timer.periodic(const Duration(seconds: 1), (second) {
      setState(() {
        if (sec == 0) {
          enabled = true;
          sec = 0;
        } else {
          sec -= 1;
        }
      });
    });
  }*/

  Timer? _timer;
  bool enabled = false;
  int _start = 30;

  void startTimer() {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
      _start = 30;
    }

    const oneSec = const Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (Timer timer) {
      if (_start == 0) {
        setState(() {
          if (_start == 0) {
            enabled = true;
            _start = 0;
          } else {
            _start -= 1;
          }
          // timer.cancel();
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  @override
  void initState() {
    //on Splash Screen hide statusbar
    // startTimerFun();
    startTimer();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
    super.initState();
  }

  @override
  void dispose() {
    if (_timer == 0) {
      _timer?.cancel();
    }
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    super.dispose();
  }

  onTapResend() async {
    /*var resendCodeResponse = await AuthRepository()
        .getResendCodeResponse(widget.user_id!, widget.verify_by.toString());

    if (resendCodeResponse.result == false) {
      ToastComponent.showDialog(resendCodeResponse.message.toString(), context,
          gravity: Toast.center, duration: Toast.lengthLong);
    } else {
      ToastComponent.showDialog(resendCodeResponse.message.toString(), context,
          gravity: Toast.center, duration: Toast.lengthLong);
    }*/
  }

  // Future<String> getSavedPhoneNumber() async {
  //   // SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String savedPhoneNumber = widget.mobile.toString() /* prefs.getString('phone_number')*/ ; // Provide a default value if the key is not found
  //   return savedPhoneNumber;
  // }

 /* Future<void> resendCode() async {
    final url = Uri.parse('https://bymin.com/api/v2/auth/login?phone_no=9521547257&action=resend&otp_type=signup');
    final response = await http.get(url);

    if (response.statusCode == 200) {
    } else {

    }
  }*/


  resendCode() async {
    var phone_no = widget.mobile;
    var action = "resend";
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
    }
  }


  void onPressConfirm() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var code = _verificationCodeController.text.toString();
    var savedPhoneNumber = await widget.mobile.toString() ; // Get the saved phone number

    var action = "verify";
    var otp_type = "signup";
    var otp_url = "?phone_no=$savedPhoneNumber&action=$action&otp_type=$otp_type&otp=$code";

    if (savedPhoneNumber.isEmpty) {
      ToastComponent.showDialog("Phone number not found in SharedPreferences", context,
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }

    if (code.isEmpty) {
      ToastComponent.showDialog("Enter verification code", context,
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }

    var confirmCodeResponse = await AuthRepository().getSignupResponse(otp_url);

    if (confirmCodeResponse.result == false) {
      ToastComponent.showDialog(confirmCodeResponse.message.toString(), context,
          gravity: Toast.center, duration: Toast.lengthLong);
    } else {
      ToastComponent.showDialog(confirmCodeResponse.message.toString(), context,
          gravity: Toast.center, duration: Toast.lengthLong);
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return Main();
      }));
    }
  }


  // onPressConfirm() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   var code = _verificationCodeController.text.toString();
  //   var phone_no = prefs.getString('phone_number');
  //   var action = "send";
  //   var otp_type = "signup";
  //   var otp_url = "phone_no=$phone_no&action=$action&otp_type=$otp_type&otp=$code";
  //
  //   var savedPhoneNumber = prefs.getString('phone_number');
  //
  //   if (savedPhoneNumber == null || savedPhoneNumber.isEmpty) {
  //     ToastComponent.showDialog("Phone number not found in SharedPreferences", context,
  //         gravity: Toast.center, duration: Toast.lengthLong);
  //     return;
  //   }
  //
  //   if (code == "") {
  //     ToastComponent.showDialog("Enter verification code", context,
  //         gravity: Toast.center, duration: Toast.lengthLong);
  //     return;
  //   }
  //
  //   var confirmCodeResponse = await AuthRepository().getSignupResponse(otp_url);
  //
  //   /*var confirmCodeResponse =
  //       await AuthRepository().getConfirmCodeResponse(widget.user_id!, code);
  //   */
  //
  //   if (confirmCodeResponse.result == false) {
  //     ToastComponent.showDialog(confirmCodeResponse.message.toString(), context,
  //         gravity: Toast.center, duration: Toast.lengthLong);
  //   } else {
  //     ToastComponent.showDialog(confirmCodeResponse.message.toString(), context,
  //         gravity: Toast.center, duration: Toast.lengthLong);
  //     Navigator.push(context, MaterialPageRoute(builder: (context) {
  //       return Login();
  //     }));
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    String _verify_by = widget.verify_by.toString(); //phone or email
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
                    LocalizationString.verify,
                    style: TextStyle(
                        color: MyTheme.accent_color,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                Text(
                  LocalizationString.getaccess,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          LocalizationString.pleenter,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              widget.mobile.toString(),
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Login()),
                                );
                              },
                              child: Text(
                                LocalizationString.change,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  /*Center(
                    child:
                    Text.rich(
                      TextSpan(
                        text: ' Please enter the OTP sent to ',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text:  widget.mobile.toString(),
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          TextSpan(
                            text:' change ',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.blue,
                              // decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) =>  Login()),
                                );
                              },
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),*/
                ),
                SizedBox(
                  height: _screen_height * 0.05,
                ),
                /*  Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Container(
                      width: _screen_width * (3 / 4),
                      child: _verify_by == "email"
                          ? Text(
                              "Please enter the OTP sent to "+widget.mobile.toString()+" change",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: MyTheme.dark_grey, fontSize: 14))
                          : Text(
                              "Enter the verification code that sent to your phone recently.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: MyTheme.dark_grey, fontSize: 14))),
                ),*/
                Container(
                  width: _screen_width * (3 / 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Form(
                              key: _formKey,
                              child: PinCodeTextField(
                                onTap: () {
                                  error = '';
                                  setState(() {});
                                },
                                keyboardType: TextInputType.phone,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Please Enter OTP";
                                  } else if (value!.isNotEmpty) {
                                    return null;
                                  }
                                },
                                controller: _verificationCodeController,
                                appContext: context,
                                length: 6,
                                onChanged: (value) {},
                                pinTheme: PinTheme(
                                  shape: PinCodeFieldShape.box,
                                  borderRadius: BorderRadius.circular(12),
                                  fieldHeight: 56,
                                  fieldWidth: 46,
                                  activeColor: Colors.grey,
                                  inactiveColor: Colors.black,
                                  selectedColor: Colors.blue,
                                  errorBorderColor: Colors.red,
                                ),
                                textStyle: TextStyle(color: Color(0XFF5F5F5F)),
                              ),
                            ),
                            /* Center(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: List.generate(
                                  6,
                                  (index) => SizedBox(
                                    width: 40,
                                    child: TextFormField(
                                      controller: _controllers[index],
                                      focusNode: _focusNodes[index],
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                      ),
                                      onChanged: (value) {
                                        if (value.isNotEmpty && index < 5) {
                                          _focusNodes[index].unfocus();
                                          _focusNodes[index + 1].requestFocus();
                                        } else if (value.isEmpty && index > 0) {
                                          _focusNodes[index].unfocus();
                                          _focusNodes[index - 1].requestFocus();
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),*/

                            /*Container(
                              height: 36,
                              child: TextField(
                                controller: _verificationCodeController,
                                autofocus: false,
                                decoration:
                                    InputDecorations.buildInputDecoration_1(
                                        hint_text: "A X B 4 J H"),
                              ),
                            ),*/
                          ],
                        ),
                      ),
                      SizedBox(
                        height: _screen_height * 0.05,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.grey.shade900,
                            minimumSize: Size(
                                _screen_width * 0.9, _screen_height * 0.06)),
                        child: Text(
                          LocalizationString.Verify,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            onPressConfirm();
                           /* ToastComponent.showDialog("OTP Verify", context,
                                gravity: Toast.bottom, duration: Toast.lengthLong);
                            Future.delayed(Duration(seconds: 3), () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Main()),
                              );
                            });*/

                          }

                          // dataSave();
                          // onPressedLogin();
                        },
                      ),

                      /*Padding(
                        padding: const EdgeInsets.only(top: 40.0),
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
                              "Confirm",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600),
                            ),
                            onPressed: () {
                              */ /*onPressConfirm();*/ /*
                            },
                          ),
                        ),
                      ),*/
                    ],
                  ),
                ),
                /*Column(
                  children: <Widget>[
                    Align(
                      child: enabled == true
                      ? ElevatedButton(
                        onPressed: () {
                          startTimer();
                          setState(() {
                            _start = 10;
                            enabled = false;
                          });
                        },
                        child: Text("Start"),
                      ) :

                    ),
                    Text("$_start")
                  ],
                ),*/

                Padding(
                  padding: const EdgeInsets.only(top: 100),
                  child: Container(
                    // color: const Color(0XFF5F5F5F),
                    child: RichText(
                      text: TextSpan(
                        text: LocalizationString.notRece,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                        children:  <TextSpan>[
                          enabled == true ? TextSpan(
                          text: LocalizationString.Recode,
                            style:
                            TextStyle(color: Colors.blue, fontSize: 16),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              startTimer();
                              setState(() {
                                _start = 30;
                                enabled = false;
                              });
                              await resendCode();
                            },
                        ) : TextSpan(
                            text: '00:$_start',
                            style: TextStyle(
                              color: Color(0XFF5F5F5F),
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    )
                    /*Align(
                      child: enabled == true
                          ?TextButton(
                        onPressed: () {
                          startTimer();
                          setState(() {
                            _start = 30;
                            enabled = false;
                          });
                        },
                        // onPressed:onClick,
                        child: const Text(
                          "Resend Code",
                          style:
                          TextStyle(color: Colors.blue, fontSize: 16),
                        ),
                      ): Text(
                              "Not received your code? 00: $_start",
                              style: TextStyle(
                                color: Color(0XFF5F5F5F),
                                fontSize: 16,
                              ),
                            )
                    ),*/
                  ),
                ),

                /*Padding(
                  padding: const EdgeInsets.only(top: 100),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Not received your code? '),
                      InkWell(
                        onTap: (){
                          // onTapResend();
                        },
                        child: Text("Resend Code",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: MyTheme.accent_color,
                                decoration: TextDecoration.underline,
                                fontSize: 13)),
                      ),
                    ],
                  ),
                ),*/
              ],
            )),
          )
        ],
      ),
    );
  }
}
