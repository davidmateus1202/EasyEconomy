import 'package:easyeconomy/models/BolsillosModel.dart';
import 'package:easyeconomy/models/user_cubir.dart';
import 'package:easyeconomy/models/user_model.dart';
import 'package:easyeconomy/service/api.dart';
import 'package:easyeconomy/service/apiBolsillos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:snippet_coder_utils/hex_color.dart';

class ContainerBolsillos extends StatefulWidget {
  const ContainerBolsillos({super.key});

  @override
  State<ContainerBolsillos> createState() => _ContainerBolsillosState();
}

class _ContainerBolsillosState extends State<ContainerBolsillos> {
  double firstItemPosition = 0;
  UserModer? user;
  NumberFormat currencyFormat = NumberFormat.currency(symbol: '\$');

  @override
  void initState() {
    super.initState();
    user = context.read<UserCubit>().state;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder<ListarBolsillos?>(
        future: ApiBolsillos().ObtenerBolsillos(user!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            List<BolsillosModel> bolsillos = snapshot.data!.bolsillos;
            return Padding(
              padding: const EdgeInsets.all(15),
              child: ListWheelScrollView(
                physics: FixedExtentScrollPhysics(),
                itemExtent: 250,
                children: bolsillos.map((bolsillo) {
                  return Card(
                      elevation: 4,
                      shadowColor: Colors.white,
                      color: Colors.white,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 36, left: 24, right: 10),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.account_balance_wallet,
                                    color: HexColor('#B401FF'),
                                    size: 60,
                                  ),
                                  Text(
                                    bolsillo.nombreBolsillo.toString(),
                                    maxLines: null,
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: HexColor('#B401FF')),
                                  ),
                                  Expanded(child: Container()),
                                  Text(
                                    currencyFormat.format(bolsillo.saldo),
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 15,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 24, right: 24),
                              child: Row(
                                children: [
                                  Flexible(
                                      child: Text(
                                    bolsillo.descripcion.toString(),
                                    maxLines: null,
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 15,
                                        color: Colors.black),
                                  )),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ));
                }).toList(),
              ),
            );
          } else if (snapshot.hasError) {
            return Text('Error');
          } else {
            return Text('No hay publicaciones');
          }
        },
      ),
    );
  }
}
