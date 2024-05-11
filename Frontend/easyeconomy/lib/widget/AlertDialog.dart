import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/hex_color.dart';

class ShowDialogs {
  static void showAlertDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title, style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, color: HexColor('B401FF')),),
          content: Text(message, style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.normal)),
          actions: <Widget>[
            ElevatedButton(onPressed: () {Navigator.of(context).pop();}, child: Text('OK', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, color: HexColor('8E32BE'))),
            ),
          ],
        );
      },
    );
  }
}