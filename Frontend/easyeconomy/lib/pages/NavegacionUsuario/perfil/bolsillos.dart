import 'package:easyeconomy/models/user_cubir.dart';
import 'package:easyeconomy/models/user_model.dart';
import 'package:easyeconomy/pages/NavegacionUsuario/perfil/ContainerBolsillos.dart';
import 'package:easyeconomy/pages/NavegacionUsuario/perfil/showModalBolsillos.dart';
import 'package:easyeconomy/service/apiBolsillos.dart';
import 'package:easyeconomy/service/apiSumary.dart';
import 'package:easyeconomy/service/apiTransacciones.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:snippet_coder_utils/hex_color.dart';

class BolsilloPage extends StatefulWidget {
  const BolsilloPage({super.key});

  @override
  State<BolsilloPage> createState() => _BolsilloPageState();
}

class _BolsilloPageState extends State<BolsilloPage> {
  UserModer? user;
  double TotalIn = 0;
  NumberFormat currencyFormat = NumberFormat.currency(symbol: '\$');

  @override
  void initState() {
    super.initState();
    user = context.read<UserCubit>().state;
    _TotalSaldo();
  }

  Future<void> _TotalSaldo() async {
    var _total = await TotalSaldo(user!);
    print(_total);

    setState(() {
      TotalIn = _total;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: HexColor('#B401FF'),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: 'Your',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        )),
                    TextSpan(
                        text: ' Wallet',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        )),
                  ]),
                ),
              ],
            )),
        body: Column(
          children: [
            Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.2,
                color: HexColor('#B401FF'),
                child: Center(
                  child: Card(
                    elevation: 4,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.2,
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 20.0, left: 24),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.account_balance_wallet,
                                  size: 50,
                                ),
                                Text(
                                  'Bolsillos',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 30,
                                    fontWeight: FontWeight.normal,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 24),
                            child: Row(
                              children: [
                                Text(
                                  currencyFormat.format(TotalIn),
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 24),
                            child: Row(
                              children: [
                                Container(
                                  height: 35,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: HexColor('#02C060'),
                                  ),
                                  child: TextButton(
                                      onPressed: () {
                                        Bolsillos(context, user, TotalIn);
                                      },
                                      child: Text(
                                        'Create you wallet   ',
                                        style: TextStyle(
                                          color: Colors.white,
                                            fontFamily: 'Poppins'),
                                      )),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.15,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/onda.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            ContainerBolsillos(),
          ],
        ));
  }
}
