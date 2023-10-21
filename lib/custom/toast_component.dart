import 'package:toast/toast.dart';
import 'package:flutter/material.dart';

import '../my_theme.dart';
class ToastComponent {
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
}
