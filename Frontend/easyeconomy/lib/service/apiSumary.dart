import 'dart:convert';

import 'package:easyeconomy/models/user_model.dart';
import 'package:easyeconomy/service/ApiHome.dart';
import 'package:easyeconomy/service/api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<dynamic> TotalSaldo(user) async {
  double total;
  var url = Uri.parse('${Api.BaseUrl}/sumary/total_saldo/');
  var response = await http.get(url, headers: {
    'Authorization': 'Token ${user.token}',
  });
  print(response.body);
  if (response.statusCode == 200) {
    Map<String, dynamic> json = jsonDecode(response.body);

    total = json['saldo'];
    print(total);
    return total;
  } else {
    return total = 0;
  }
}

Future<dynamic> TotalIngreso(user) async {
  double total;
  var url = Uri.parse('${Api.BaseUrl}/sumary/total/');
  var response = await http.get(url, headers: {
    'Authorization': 'Token ${user.token}',
  });
  print(response.body);

  if (response.statusCode == 200) {
    Map<String, dynamic> json = jsonDecode(response.body);

    total = json['total_ingresos'];
    print(total);
    return total;
  } else {
    return total = 0;
  }
}
