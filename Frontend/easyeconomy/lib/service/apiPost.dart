import 'dart:convert';
import 'dart:io';
import 'package:easyeconomy/models/user_model.dart';
import 'package:easyeconomy/pages/NavegacionUsuario/feed/feed.dart';
import 'package:easyeconomy/pages/loginPage.dart';
import 'package:easyeconomy/service/api.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

Future<dynamic> imagePostFile(op) async {
  ImagePicker picker = ImagePicker();
  var image;
  File imageFile;

  if (op == 1) {
    image = await picker.pickImage(source: ImageSource.gallery);
  } else {
    image = await picker.pickImage(source: ImageSource.camera);
  }

  if (image != null) {
    imageFile = File(image.path);
    return imageFile;
  }
}

  Future<void> subirImagenes(BuildContext context, File imageFile, String concepto, UserModer user) async {
    final url = Uri.parse('https://api.cloudinary.com/v1_1/dwosvvfvu/upload');
    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = 'mn5uhtfq'
      ..files.add(await http.MultipartFile.fromPath('file', imageFile!.path));

    final response = await request.send();
    print('///////////////////////////////////////////////////////////');
    print(response.statusCode);
    if (response.statusCode == 200) {
      final responseData = await response.stream.toBytes();
      final responseString = String.fromCharCodes(responseData);
      final jsonMap = jsonDecode(responseString);


        final url = jsonMap['url'];
        String _imageUrl = url;
        if (response.statusCode == 200) {
          guardarPublicacion(concepto, user, _imageUrl, context);
        } else {
          print('error');
        }
    
    } else if (response.statusCode == 403) {
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: const Text('Error de autenticacion'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                      return Login_Page();
                    }));
                  },
                  child: Text('Aceptar'),
                )
              ],
            );
          });

    } else {
      // ignore: use_build_context_synchronously
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Error al subir la imagen'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Aceptar'),
                )
              ],
            );
          });
    }
  }


    Future<void> guardarPublicacion(String concepto, UserModer user, String _imageURL, BuildContext context) async {
    var url = Uri.parse('${Api.BaseUrl}/publicacion/crearPublicacion/');
    Map data = {
      'usuario': '${user!.id}',
      'contenido': concepto,
      'image': _imageURL,
    };

    var response = await http.post(url, body: data, headers: {
      'Authorization': 'Token ${user!.token}',
    });
    print(response.body);
    if (response.statusCode == 200) {
      print('Publicacion guardada');
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return FeedPage();
      }));
    } else {
      print('Error al guardar la publicacion }');
    }
  }