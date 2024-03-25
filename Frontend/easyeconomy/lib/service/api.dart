import 'dart:convert';
import 'package:easyeconomy/models/user_model.dart';
import 'package:easyeconomy/pages/loginPage.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:http/http.dart' as http;

// clase para manejar las peticiones a la api

class Api {
  static String BaseUrl = "http://192.168.20.3:8000";
}

// metodo para registrar un usuario

Future<void> registrarUsuario(String username, String email, String password1,
    String password2, BuildContext context) async {
  Map<String, String> data = {
    'username': username,
    'email': email,
    'password1': password1,
    'password2': password2,
  };

  var url = Uri.parse('${Api.BaseUrl}/user/registration/');
  var res = await http.post(url, body: data);
  print(res.body);
  print(res.statusCode);

  if (res.statusCode == 204) {
    // Registro exitoso, podrías mostrar una alerta o redirigir al usuario a otra pantalla.
    // ignore: use_build_context_synchronously
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Registro Exitoso'),
          content: Text('¡Tu cuenta ha sido creada con éxito!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const Login_Page()));
              },
              child: Text('Aceptar'),
            ),
          ],
        );
      },
    );
  } else {
    // Hubo un error durante el registro, muestra un mensaje de error al usuario.
    var json = jsonDecode(res.body);
    String errorMessage = '';
    if (json.containsKey("username")) {
      errorMessage = json['username'][0];
    } else {
      errorMessage = 'Error ocurrido: ${res.statusCode}';
    }
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
}

// metodo para loguear al usuario y obtener el token

Future<dynamic> userApi(String name, String password) async {
  Map<String, String> body = {
    'username': name,
    'password': password,
  };

  var url = Uri.parse('${Api.BaseUrl}/user/auth/login/');
  var response = await http.post(url, body: body);

  print(response.body);
  print(response.statusCode);

  if (response.statusCode == 200) {
    Map<String, dynamic> json = jsonDecode(response.body);
    String? token = json['key'];
    if (token != null) {
      var box = await Hive.openBox('userData');
      box.put('token', token);
      UserModer? user = await getUser(token);
      return user;
    } else {
      return 'Token not found in response';
    }
  } else {
    Map<String, dynamic> json = jsonDecode(response.body);
    if (json.containsKey("username")) {
      return json['username'][0];
    } else {
      return 'Error occurred: ${response.statusCode}';
    }
  }
}

// obtener todos los usuarios de la base de datos

Future<UserModer?> getUser(String token) async {
  var url = Uri.parse('${Api.BaseUrl}/user/auth/user/');
  var res = await http.get(url, headers: {
    'Authorization': 'Token ${token}',
  });

  if (res.statusCode == 200) {
    var json = jsonDecode(res.body);
    UserModer user = UserModer.fromJson(json);
    user.token = token;
    return user;
  } else {
    return null;
  }
}

//logout de ususarios

Future<void> logout(String token) async {
  var url = Uri.parse('${Api.BaseUrl}/user/auth/logout/');
  var response = await http.post(url, headers: {
    'Authorization': 'Token ${token}',
  });
  print(response.body);
}
