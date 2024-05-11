import 'dart:convert';

import 'package:easyeconomy/models/user_model.dart';
import 'package:easyeconomy/service/api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class UserCubit extends Cubit<UserModer> {
  UserCubit(UserModer initialState) : super(initialState);

  Future<void> actualizarInformacion(
      String token, int userId, String imagePath, String name) async {
    print('entro a la funcion');
    var url = Uri.parse('${Api.BaseUrl}/user/actualizar_usuario/$userId/');
    Map<String, dynamic> data = {
      'username': name, // Puedes modificar esto según tus necesidades
      'imagen_profile': imagePath,
    };

    var response = await http.put(url, body: data, headers: {
      'Authorization': 'Token $token',
    });

    if (response.statusCode == 200) {
      // Si la actualización fue exitosa, obtén nuevamente los datos del usuario actualizado
      var updatedUser = await getUser(token);
      emit(
          updatedUser); // Actualiza el estado del cubit con los nuevos datos del usuario
      print('Información actualizada exitosamente');
    } else {
      print('Error al actualizar la información');
    }
  }

  Future<UserModer> getUser(String token) async {
    var url = Uri.parse('${Api.BaseUrl}/user/user_detail/');
    var res = await http.get(url, headers: {
      'Authorization': 'Token $token',
    });

    if (res.statusCode == 200) {
      var json = jsonDecode(res.body);
      UserModer user = UserModer.fromJson(json);
      user.token = token;
      return user;
    } else {
      throw Exception('Error al obtener los datos del usuario');
    }
  }
}
