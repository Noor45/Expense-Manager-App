import 'package:expense_wallet/utils/colors.dart';
import 'package:flutter/material.dart';

import 'fonts.dart';


class StyleRefer {
  static var kTextFieldDecoration = InputDecoration(
    counterText: '',
    labelStyle: const TextStyle(color: Color(0xff212b36)),
    contentPadding: const EdgeInsets.only(left: 15),
    hintStyle: TextStyle(fontSize: 12, color: ColorRefer.kLabelColor),
    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black45, width: 1.0),
      borderRadius: BorderRadius.all(Radius.circular(25.0)),
    ),
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black45, width: 2.0),
      borderRadius: BorderRadius.all(Radius.circular(25.0)),
    ),
    errorBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red, width: 2.0),
      borderRadius: BorderRadius.all(Radius.circular(25.0)),
    ),
    focusedErrorBorder: const OutlineInputBorder(
      borderSide: BorderSide(color:  Colors.black45, width: 2.0),
      borderRadius: BorderRadius.all(Radius.circular(25.0)),
    ),
  );
  static TextStyle kCheckBoxTextStyle =
  TextStyle(fontFamily: FontRefer.OpenSans, fontSize: 13.5);
}

