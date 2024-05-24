import 'package:easyeconomy/models/BolsillosModel.dart';
import 'package:easyeconomy/models/user_model.dart';
import 'package:easyeconomy/service/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiBolsillos {
  Future<ListarBolsillos?> ObtenerGastos(UserModer user) async {
    var url = Uri.parse('${Api.BaseUrl}/transaccion/getGastosFijos/');
    var response = await http.get(url, headers: {
      'Authorization': 'Token ${user.token}',
    });

    if (response.statusCode == 200) {
      return ListarBolsillos.fromList(jsonDecode(response.body));
    } else {}
  }
}

class ListarBolsillos {
  List<GastosFijos> bolsillos = [];
  ListarBolsillos({required this.bolsillos});
  factory ListarBolsillos.fromList(List list) {
    List<GastosFijos> _bolsillos = [];
    for (var element in list) {
      _bolsillos.add(GastosFijos.fromJson(element));
    }
    return ListarBolsillos(bolsillos: _bolsillos);
  }
}

Future getEstados(UserModer user) async {
  var url =
      Uri.parse('${Api.BaseUrl}/transaccion/obtenerTotalIngresos/${user.id}/');
  var response = await http.get(url, headers: {
    'Authorization': 'Token ${user.token}',
  });

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    return null;
  }
}

Future getExpense(UserModer user) async {
  double Expense = 0;
  var url = Uri.parse('${Api.BaseUrl}/transaccion/getExpese/${user.id}/');
  var response = await http.get(url, headers: {
    'Authorization': 'Token ${user.token}',
  });

  if (response.statusCode == 200) {
    Map<String, dynamic> json = jsonDecode(response.body);
    Expense = json['total'];
    print(Expense);
    return Expense;
  }
}
