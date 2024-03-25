import 'dart:convert';

import 'package:easyeconomy/models/TransaccionModel.dart';
import 'package:easyeconomy/models/user_model.dart';
import 'package:easyeconomy/pages/NavegacionUsuario/perfil/perfil.dart';
import 'package:easyeconomy/service/api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


// REALIZAR OPERACIONES SOBRE LAS TRANSACCIONES

CrearTransaccion(UserModer user, String tipo, double monto, String descripcion,
    context) async {
  Map data = {
    'usuario': '${user.id}',
    'tipo': tipo,
    'monto': '$monto',
    'descripcion': descripcion,
  };
  var url = Uri.parse('${Api.BaseUrl}/transaccion/crearTransaccion/');

  var response = await http.post(url, body: data, headers: {
    'Authorization': 'Token ${user.token}',
  });

  if (response.statusCode == 200) {
    Navigator.of(context)
        .pop(MaterialPageRoute(builder: (context) => ProfilePage()));
    return 'Transaccion realizada con exito';
  } else {
    var errorMessage = 'Error ocurrido: ${response.statusCode}';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error de Registro'),
          content: Text(errorMessage),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }
  var json = jsonDecode(response.body);
  print(json);
}


