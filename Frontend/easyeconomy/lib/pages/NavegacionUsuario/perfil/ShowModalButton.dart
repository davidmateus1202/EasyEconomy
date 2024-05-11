import 'package:easyeconomy/models/user_model.dart';
import 'package:easyeconomy/service/apiSumary.dart';
import 'package:easyeconomy/service/apiTransacciones.dart';
import 'package:easyeconomy/pages/NavegacionUsuario/perfil/perfil.dart';
import 'package:easyeconomy/widget/AlertDialog.dart';
import 'package:easyeconomy/widget/TextFrom.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:snippet_coder_utils/hex_color.dart';

Future Movimientos(
    BuildContext context, String title, int op, UserModer? user) {
  // varibles para los campos de texto
  TextEditingController Movimiento = TextEditingController();
  TextEditingController concepto = TextEditingController();
  final _formKey = GlobalKey<FormFieldState>();
  final _formKey2 = GlobalKey<FormFieldState>();

  return showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          height: MediaQuery.of(context).size.height * 0.6,
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  'Registra tu ${title}',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 15),
              Container(
                  width: MediaQuery.of(context).size.width * 0.90,
                  child: TextformFieldMovimientos(context, Movimiento, 'Valor',
                      Icons.monetization_on, _formKey, TextInputType.number)),
              SizedBox(height: 15),
              Container(
                  width: MediaQuery.of(context).size.width * 0.90,
                  child: TextformFieldMovimientos(context, concepto, 'Concepto',
                      Icons.monetization_on, _formKey2, TextInputType.text)),
              SizedBox(height: 15),
              Container(
                  width: MediaQuery.of(context).size.width * 0.90,
                  child: ElevatedButton(
                      onPressed: () async {
                        if (op == 1) {
                          double valor = double.parse(Movimiento.text.trim());
                          await CrearTransaccion(
                              user!, 'ingreso', valor, concepto.text, context);
                          Navigator.pushReplacement(
                              context,
                              PageTransition(
                                  type: PageTransitionType.fade,
                                  child: ProfilePage()));
                        } else {
                          double valor = double.parse(Movimiento.text.trim());
                          double Total = await TotalSaldo(user);
                          print(Total);

                          if (_formKey.currentState!.validate() &&
                              _formKey2.currentState!.validate() &&
                              valor <= Total) {
                            print('entro');
                            await CrearTransaccion(
                                user!, 'egreso', valor, concepto.text, context);
                            Navigator.pushReplacement(
                                context,
                                PageTransition(
                                    type: PageTransitionType.fade,
                                    child: ProfilePage()));
                          } else {
                            ShowDialogs.showAlertDialog(context, 'Insufficient balance', 'You do not have enough balance to complete this operation');
                          }
                        }
                      },
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width * 0.70,
                        decoration: BoxDecoration(
                          color: HexColor('5C10C7'),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            'Registrar',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ))),
              SizedBox(height: 15),
            ],
          ),
        ),
      );
    },
  );
}
