import 'package:easyeconomy/models/user_model.dart';
import 'package:easyeconomy/service/apiBolsillos.dart';
import 'package:easyeconomy/service/apiTransacciones.dart';
import 'package:easyeconomy/pages/NavegacionUsuario/perfil/perfil.dart';
import 'package:easyeconomy/widget/AlertDialog.dart';
import 'package:easyeconomy/widget/TextFrom.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:snippet_coder_utils/hex_color.dart';

Future Bolsillos(BuildContext context, UserModer? user, double Total) {
  // varibles para los campos de texto
  TextEditingController Movimiento = TextEditingController();
  TextEditingController nombre = TextEditingController();
  TextEditingController descripcion = TextEditingController();

  final _formKeyMovimiento = GlobalKey<FormFieldState>();
  final _formKeyNombre = GlobalKey<FormFieldState>();
  final _formKeydescripcion = GlobalKey<FormFieldState>();

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
                  'Crea un nuevo bolsillo',
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
                  child: TextformFieldMovimientos(
                      context,
                      Movimiento,
                      'Valor',
                      Icons.monetization_on,
                      _formKeyMovimiento,
                      TextInputType.number)),
              SizedBox(height: 15),
              Container(
                  width: MediaQuery.of(context).size.width * 0.90,
                  child: TextformFieldMovimientos(
                      context,
                      nombre,
                      'Nombre del bolsillo',
                      Icons.wallet,
                      _formKeyNombre,
                      TextInputType.text)),
              SizedBox(height: 15),
              Container(
                  width: MediaQuery.of(context).size.width * 0.90,
                  child: TextformFieldMovimientos(
                      context,
                      descripcion,
                      'Descripcion',
                      Icons.edit,
                      _formKeydescripcion,
                      TextInputType.text)),
              SizedBox(height: 15),
              Container(
                  width: MediaQuery.of(context).size.width * 0.90,
                  child: ElevatedButton(
                      onPressed: () async {
                        double valor = double.parse(Movimiento.text.trim());
                        if (_formKeydescripcion.currentState!.validate() &&
                            _formKeyMovimiento.currentState!.validate() &&
                            _formKeyNombre.currentState!.validate() && Total >= valor ) {
                          await await CrearBolsillo(user!, valor, nombre.text,
                              descripcion.text, context);
                        }else {
                          ShowDialogs.showAlertDialog(context, 'Insufficient balance', 'You do not have enough balance to complete this operation');
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
