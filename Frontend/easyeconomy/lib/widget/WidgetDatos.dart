import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:snippet_coder_utils/hex_color.dart';

class WidgetPantalla extends StatelessWidget {
  const WidgetPantalla({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 100,
          ),
          Lottie.asset('assets/json/logo_4.json',
              width: 250, height: 250, fit: BoxFit.fill),
          RichText(
              text: TextSpan(children: [
            TextSpan(
              text: 'Welcome ',
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: HexColor('5C10C7')),
            ),
            TextSpan(
              text: 'To',
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 45,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            )
          ])),
          SizedBox(height: 15),
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Text(
              'Record your transaction to generate your report',
              textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
