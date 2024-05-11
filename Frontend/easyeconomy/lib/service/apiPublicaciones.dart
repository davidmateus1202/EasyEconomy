import 'dart:convert';
import 'package:easyeconomy/models/PublicacionesModel.dart';
import 'package:easyeconomy/models/user_model.dart';
import 'package:easyeconomy/pages/NavegacionUsuario/feed/feed.dart';
import 'package:easyeconomy/service/api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiPublicaciones {
  Future<ListaPubliaciones?> ObtenerPublicaciones() async {
    var url = Uri.parse('${Api.BaseUrl}/publicacion/listarPublicaciones/');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      return ListaPubliaciones.fromList(jsonDecode(response.body));
    }
    return null;
  }
}

class ListaPubliaciones {
  List<PublicacionesModel> publicaciones = [];
  ListaPubliaciones({required this.publicaciones});
  factory ListaPubliaciones.fromList(List list) {
    List<PublicacionesModel> _publicaciones = [];
    for (var element in list) {
      _publicaciones.add(PublicacionesModel.fromJson(element));
    }
    return ListaPubliaciones(publicaciones: _publicaciones);
  }
}

CrearPublicaciones(UserModer user, String concepto, String imagen, context) async {
  Map data = {
    'usuario': '${user.id}',
    'contenido': concepto,
    'imagen': imagen,
  };

  var url = Uri.parse('${Api.BaseUrl}/publicacion/crearPublicacion/');

  var response = await http.post(url, body: data, headers: {
    'Authorization': 'Token ${user.token}',
  });

  if (response.statusCode == 200) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => FeedPage()),
        (route) => false);
  } else {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error de Registro'),
            content: Text('Error ocurrido: ${response.statusCode}'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Aceptar'),
              ),
            ],
          );
        });
  }
}
