import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Top_logo_register extends StatefulWidget {
  const Top_logo_register({super.key});

  @override
  State<Top_logo_register> createState() => _Top_logo_registerState();
}

class _Top_logo_registerState extends State<Top_logo_register> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.30,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(80),
                bottomRight: Radius.circular(80),
              ),
            ),
            child: Container(
              width: double.infinity,
              child: Center(child: _logo_top()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _logo_top() {
    return Lottie.asset('assets/json/logo_4.json',
        width: 250, height: 250, fit: BoxFit.fill);
  }
}
