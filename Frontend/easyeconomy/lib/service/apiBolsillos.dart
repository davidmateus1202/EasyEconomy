import 'package:easyeconomy/models/BolsillosModel.dart';
import 'package:easyeconomy/models/user_model.dart';
import 'package:easyeconomy/pages/NavegacionUsuario/perfil/bolsillos.dart';
import 'package:easyeconomy/pages/NavegacionUsuario/perfil/perfil.dart';
import 'package:easyeconomy/service/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class ApiBolsillos {
  Future<ListarBolsillos?> ObtenerBolsillos(UserModer user) async {
    var url = Uri.parse('${Api.BaseUrl}/bolsillo/listarbolsillos/');
    var response = await http.get(url, headers: {
      'Authorization': 'Token ${user.token}',
    });

    if (response.statusCode == 200){
      return ListarBolsillos.fromList(jsonDecode(response.body));

    }else{

    }
  }
}

class ListarBolsillos {
  List<BolsillosModel> bolsillos = [];
  ListarBolsillos({required this.bolsillos});
  factory ListarBolsillos.fromList(List list) {
    List<BolsillosModel> _bolsillos = [];
    for (var element in list) {
      _bolsillos.add(BolsillosModel.fromJson(element));
    }
    return ListarBolsillos(bolsillos: _bolsillos);
  }
}

CrearBolsillo(UserModer user, double saldo, String nombre_bolsillo,
    String descripcion, context) async {
  Map data = {
    'usuario': '${user.id}',
    'nombre_bolsillo': '$nombre_bolsillo',
    'descripcion': '$descripcion',
    'saldo': '$saldo',
  };

  var url = Uri.parse('${Api.BaseUrl}/bolsillo/crearbolsillo/');
  var response = await http.post(url, body: json.encode(data), headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Token ${user.token}',
  });

  if (response.statusCode == 200) {
    print('bolsillo creado ${response.body}');
    Navigator.pushReplacement(context,
        PageTransition(type: PageTransitionType.fade, child: BolsilloPage()));
  } else {
    print(response.body);
  }
}
