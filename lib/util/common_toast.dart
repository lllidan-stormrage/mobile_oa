import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastUtils {
  static void showError(String errorMsg) {
    Fluttertoast.showToast(
      msg: errorMsg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      timeInSecForIosWeb: 1,
      fontSize: 15,
    );
  }
}