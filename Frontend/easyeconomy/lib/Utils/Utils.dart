
import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/hex_color.dart';

class Utils {

  TextStyle styleTextTitele() {
    return TextStyle(
      fontFamily: 'Poppins',
      color: Colors.white,
      fontSize: 25,
      fontWeight: FontWeight.bold);
  }

  TextStyle styleTextSubTitle() {
    return TextStyle(
      fontFamily: 'Poppins',
      fontSize: 15,
      color: HexColor('5C10C7'),
      fontWeight: FontWeight.bold);
  }

  TextStyle styleTextNormal() {
    return TextStyle(
      fontFamily: 'Poppins',
      fontSize: 12,
      color: HexColor('5C10C7'),
      fontWeight: FontWeight.normal);
  }

}
