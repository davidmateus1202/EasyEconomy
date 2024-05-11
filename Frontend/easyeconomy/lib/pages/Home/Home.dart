import 'dart:convert';

import 'package:easyeconomy/Chat/ChatPage.dart';
import 'package:easyeconomy/Utils/Utils.dart';
import 'package:easyeconomy/models/user_cubir.dart';
import 'package:easyeconomy/models/user_model.dart';
import 'package:easyeconomy/pages/Home/BarGraph.dart';
import 'package:easyeconomy/service/ApiHome.dart';
import 'package:easyeconomy/service/api.dart';
import 'package:easyeconomy/service/apiSumary.dart';
import 'package:easyeconomy/widget/WidgetDatos.dart';
import 'package:http/http.dart' as http;
import 'package:easyeconomy/themas/thema.dart';
import 'package:easyeconomy/widget/drawerHome.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:snippet_coder_utils/hex_color.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  UserModer? user;
  double sumary = 0;
  double saldo = 0;
  double PorcentajeSano = 0;
  double PorcentajeAceptable = 0;

  @override
  void initState() {
    super.initState();
    user = context.read<UserCubit>().state;
    _TotalSaldo();
    _totalingresos();
  }

  Future<void> _totalingresos() async {
    var _total = await TotalIngreso(user!);

    setState(() {
      sumary = _total;
      PorcentajeSano = sumary * 0.2;
      print('porcentaje sano $PorcentajeSano');
      PorcentajeAceptable = sumary * 0.10;
      print('porcentaje aceptable $PorcentajeAceptable');
    });
  }

  Future<void> _TotalSaldo() async {
    var _total = await TotalSaldo(user!);
    print(_total);

    setState(() {
      saldo = _total;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<CambioTema>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: PorcentajeSano < saldo
            ? HexColor('20E945')
            : saldo <= PorcentajeSano && saldo >= PorcentajeAceptable
                ? HexColor('e9d520')
                : HexColor('#a21212'),
        title: Text(
          'Home',
          style: Utils().styleTextTitele(),
        ),
        actions: [
          theme.getTheme() == ThemeData.light()
              ? Padding(
                  padding: const EdgeInsets.only(right: 24),
                  child: IconButton(
                    onPressed: () {
                      theme.setThema(ThemeData.dark());
                    },
                    icon: const Icon(Icons.sunny),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(right: 24),
                  child: IconButton(
                    onPressed: () {
                      theme.setThema(ThemeData.light());
                    },
                    icon: const Icon(Icons.dark_mode),
                  ),
                )
        ],
      ),
      drawer: DrawerHome(),
      body: sumary == 0.0
          ? Column(
              children: [
                Container(
                  height: 100,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: HexColor('5C10C7'),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(120),
                        bottomRight: Radius.circular(120),
                      )),
                  child: Column(
                    children: [
                      Lottie.asset('assets/json/settings.json',
                          height: 100, width: 140, fit: BoxFit.fill),
                    ],
                  ),
                ),
                WidgetPantalla(),
              ],
            )
          : Column(
              children: [
                Container(
                  height: 100,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: PorcentajeSano < saldo
                          ? HexColor('20E945')
                          : saldo <= PorcentajeSano &&
                                  saldo >= PorcentajeAceptable
                              ? HexColor('#e9d520')
                              : HexColor('#a21212'),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(120),
                        bottomRight: Radius.circular(120),
                      )),
                  child: Column(
                    children: [
                      Lottie.asset('assets/json/settings.json',
                          height: 100, width: 140, fit: BoxFit.fill),
                    ],
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(top: 20, left: 12, right: 12),
                    child: Container(
                      height: MediaQuery.of(context).size.height / 2.5,
                      width: MediaQuery.of(context).size.width,
                      child: BarGraph(),
                    )),
                ContainerSemaforo(),
              ],
            ),
    );
  }

  Widget ContainerSemaforo() {
    return Expanded(
        child: Card(
      elevation: 16,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(36), topRight: Radius.circular(36)),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                    padding: EdgeInsets.only(left: 24, top: 24),
                    child: Text(
                      'Financial statements',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    )),
              ],
            ),
            PorcentajeSano < saldo
                ? Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 12, right: 36),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(36),
                                topRight: Radius.circular(36)),
                          ),
                          color: HexColor('4DDB53'),
                          elevation: 16,
                          child: Container(
                            width: MediaQuery.of(context).size.width / 4,
                            height: 150,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 36),
                              child: Center(
                                child: Column(
                                  children: [
                                    Lottie.asset('assets/json/good.json',
                                        height: 60,
                                        width: 60,
                                        fit: BoxFit.fill),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Text('Good Status',
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: HexColor('4DDB53'),
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold)),
                          Container(
                              width: 220,
                              child: Text(
                                'You are in shape, keep it up and you will achieve your dreams!',
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.normal,
                                    fontSize: 12),
                              )),
                        ],
                      ),
                    ],
                  )
                : saldo <= PorcentajeSano && saldo >= PorcentajeAceptable
                    ? Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 12, right: 36),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(36),
                                    topRight: Radius.circular(36)),
                              ),
                              color: HexColor('e9d520'),
                              elevation: 16,
                              child: Container(
                                width: MediaQuery.of(context).size.width / 4,
                                height: 150,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 36, ),
                                  child: Center(
                                    child: Column(
                                      children: [
                                        Lottie.asset('assets/json/good.json',
                                            height: 60,
                                            width: 60,
                                            fit: BoxFit.fill),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Column(
                            children: [
                              Text('Nothing bad',
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      color: HexColor('e9d520'),
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold)),
                              Container(
                                  width: 220,
                                  child: Text(
                                    'Not bad, although you have to improve if you want to reach the best state of your finances, ask BOB how to do it!',
                                    textAlign: TextAlign.justify,
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.normal,
                                        fontSize: 12),
                                  )),
                            ],
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 12, right: 36),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(36),
                                    topRight: Radius.circular(36)),
                              ),
                              color: HexColor('#a21212'),
                              elevation: 16,
                              child: Container(
                                width: MediaQuery.of(context).size.width / 4,
                                height: 150,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 36),
                                  child: Center(
                                    child: Column(
                                      children: [
                                        Lottie.asset('assets/json/cancel.json',
                                            height: 60,
                                            width: 60,
                                            fit: BoxFit.fill),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Column(
                            children: [
                              Text('Bad Status',
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      color: HexColor('#a21212'),
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold)),
                              Container(
                                  width: 220,
                                  child: Text(
                                    'Your expenses exceed your savings, ask BOB how to improve your financial status?',
                                    textAlign: TextAlign.justify,
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.normal,
                                        fontSize: 12),
                                  )),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                width: 220,
                                height: 40,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        PageTransition(
                                            child: ChatFrom(),
                                            type: PageTransitionType
                                                .rightToLeftWithFade));
                                  },
                                  child: Text(
                                    'Ask Bob',
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.normal,
                                        fontSize: 12),
                                  ),
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            HexColor('#a21212')),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      )
          ],
        ),
      ),
    ));
  }
}
