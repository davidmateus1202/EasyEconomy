import 'dart:convert';

import 'package:easyeconomy/models/TransaccionModel.dart';
import 'package:easyeconomy/models/user_model.dart';
import 'package:easyeconomy/pages/NavegacionUsuario/perfil.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const endpoint = 'http://10.13.129.146:8000/transaccion/';

// REALIZAR OPERACIONES SOBRE LAS TRANSACCIONES

CrearTransaccion(UserModer user, String tipo, double monto, String descripcion,
    context) async {
  Map data = {
    'usuario': '${user.id}',
    'tipo': tipo,
    'monto': '$monto',
    'descripcion': descripcion,
  };
  var url = Uri.parse('${endpoint}crearTransaccion/');

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

Future<List<TransaccionesModel>?> getTransacciones(UserModer user) async {
  List<TransaccionesModel> transacciones = [];
  var url = Uri.parse('${endpoint}getTransacciones/');
  var response = await http.get(url, headers: {
    'Authorization': 'Token ${user.token}',
  });
  var jsons = jsonDecode(response.body);
  if (response.statusCode == 200) {
    for (var json in jsons) {
      transacciones.add(TransaccionesModel.fromJson(json));
    }
  }
  print(transacciones);
  return transacciones;
}
