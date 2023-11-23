import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:toast/toast.dart';
import 'package:flutter/material.dart';

import '../my_theme.dart';

class ToastComponent {
  static showToast({required String message, required bool isSuccess}) {
    Get.snackbar(
        isSuccess == true
            ? 'Success'
            : 'error',
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: isSuccess == true
            ? Colors.green
            : Colors.red,
        icon: Icon(Icons.error, color: Color(0xFF9E9E9E)));
  }
  static showDialog(String msg, BuildContext context, {int duration = 0, int gravity = 0}) {
    final toastContext = ToastContext();
    toastContext.init(context);
    Toast.show(
      msg,
      duration: duration != 0 ? duration : Toast.lengthLong,
      gravity: gravity != 0 ? gravity : Toast.bottom,
      backgroundColor: Colors.lightGreen,
      webTexColor: MyTheme.font_grey,
     /* border: Border(
        top: BorderSide(
          color: Color.fromRGBO(203, 209, 209, 1),
        ),
        bottom: BorderSide(
          color: Color.fromRGBO(203, 209, 209, 1),
        ),
        right: BorderSide(
          color: Color.fromRGBO(203, 209, 209, 1),
        ),
        left: BorderSide(
          color: Color.fromRGBO(203, 209, 209, 1),
        ),
      ),*/
      backgroundRadius: 6,
    );
  }
}





/*class ToastComponent {
  static showDialog(String msg, context, {duration = 0, gravity = 0}) {
    Toast.show(
      msg,
      textStyle: context,
      duration: duration != 0 ? duration : Toast.lengthLong,
      gravity: gravity != 0 ? gravity : Toast.bottom,
        backgroundColor:
        Color.fromRGBO(239, 239, 239, .9),
        webTexColor: MyTheme.font_grey,
        border: Border(
            top: BorderSide(
              color: Color.fromRGBO(203, 209, 209, 1),
            ),bottom:BorderSide(
          color: Color.fromRGBO(203, 209, 209, 1),
        ),right: BorderSide(
          color: Color.fromRGBO(203, 209, 209, 1),
        ),left: BorderSide(
          color: Color.fromRGBO(203, 209, 209, 1),
        )),
        backgroundRadius: 6
    );
  }
}*/
