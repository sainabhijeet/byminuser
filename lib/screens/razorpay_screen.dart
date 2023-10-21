import 'package:byminuser/screens/wallet.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'dart:io';
import 'dart:convert';

import 'package:webview_flutter/webview_flutter.dart';

import '../app_config.dart';
import '../custom/toast_component.dart';
import '../helpers/shared_value_helper.dart';
import '../my_theme.dart';
import '../repositories/payment_repository.dart';
import 'order_list.dart';


class RazorpayScreen extends StatefulWidget {
  int owner_id;
  double amount;
  String payment_type;
  String payment_method_key;

  RazorpayScreen(
      {Key? key,
      this.owner_id = 0,
      this.amount = 0.00,
      this.payment_type = "",
      this.payment_method_key = ""})
      : super(key: key);

  @override
  _RazorpayScreenState createState() => _RazorpayScreenState();
}

class _RazorpayScreenState extends State<RazorpayScreen> {
  int _order_id = 0;
  bool _order_init = false;

  late WebViewController _webViewController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();



    if (widget.payment_type == "cart_payment") {
      createOrder();
    }
  }

  createOrder() async {
    var orderCreateResponse = await PaymentRepository()
        .getOrderCreateResponse(widget.owner_id, widget.payment_method_key);

    if (orderCreateResponse.result == false) {
      ToastComponent.showDialog(orderCreateResponse.message.toString(), context,
          gravity: Toast.center, duration: Toast.lengthLong);
      Navigator.of(context).pop();
      return;
    }

    _order_id = orderCreateResponse.order_id!;
    _order_init = true;
    setState(() {});

    print("-----------");
    print(_order_id);
    print(user_id.$);
    print(widget.amount);
    print(widget.payment_method_key);
    print(widget.payment_type);
    print("-----------");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(context),
      body: buildBody(),
    );
  }

  void getData() {
    var payment_details = '';
    _webViewController
        .runJavaScriptReturningResult("document.body.innerText")
        .then((data) {
      var decodedJSON = jsonDecode(data.toString());
      Map<String, dynamic> responseJSON = jsonDecode(decodedJSON);
      //print(data.toString());
      if (responseJSON["result"] == false) {
        Toast.show(responseJSON["message"], textStyle: context,
            duration: Toast.lengthLong, gravity: Toast.center);
        Navigator.pop(context);
      } else if (responseJSON["result"] == true) {
        payment_details = responseJSON['payment_details'];
        onPaymentSuccess(payment_details);
      }
    });
  }

  onPaymentSuccess(payment_details) async{
    print("b");

    var razorpayPaymentSuccessResponse = await PaymentRepository().getRazorpayPaymentSuccessResponse(widget.payment_type, widget.amount,_order_id, payment_details);

    if(razorpayPaymentSuccessResponse.result == false ){
      print("c");
      Toast.show(razorpayPaymentSuccessResponse.message.toString(), textStyle: context,
          duration: Toast.lengthLong, gravity: Toast.center);
      Navigator.pop(context);
      return;
    }

    Toast.show(razorpayPaymentSuccessResponse.message.toString(), textStyle: context,
        duration: Toast.lengthLong, gravity: Toast.center);
    if (widget.payment_type == "cart_payment") {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return OrderList(from_checkout: true);
      }));
    } else if (widget.payment_type == "wallet_payment") {
      print("d");
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return Wallet(from_recharge: true);
      }));
    }


  }


  buildBody() {

    String initial_url =
        "${AppConfig.BASE_URL}/razorpay/pay-with-razorpay?payment_type=${widget.payment_type}&order_id=${_order_id}&amount=${widget.amount}&user_id=${user_id.$}";

    //print("init url");
    //print(initial_url);

    if (_order_init == false &&
        _order_id == 0 &&
        widget.payment_type == "cart_payment") {
      return Container(
        child: Center(
          child: Text("Creating order ..."),
        ),
      );
    } else {
      return SizedBox.expand(
        /*child: Container(
          child: WebView(
            debuggingEnabled: false,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (controller) {
              _webViewController = controller;
              _webViewController.loadUrl(initial_url);
            },
            onWebResourceError: (error) {},
            onPageFinished: (page) {
              print(page.toString());
                getData();
            },
          ),
        ),*/
      );
    }
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      leading: Builder(
        builder: (context) => IconButton(
          icon: Icon(Icons.arrow_back, color: MyTheme.dark_grey),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      title: Text(
        "Pay with Razorpay",
        style: TextStyle(fontSize: 16, color: MyTheme.accent_color),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }
}
