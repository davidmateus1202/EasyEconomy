import 'dart:convert';
import 'dart:io';

import 'package:easyeconomy/models/user_cubir.dart';
import 'package:easyeconomy/models/user_model.dart';
import 'package:easyeconomy/pages/NavegacionUsuario/feed/apiPublicaciones.dart';
import 'package:easyeconomy/pages/NavegacionUsuario/feed/feed.dart';
import 'package:easyeconomy/service/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:snippet_coder_utils/hex_color.dart';

class CargarImagenes extends StatefulWidget {
  const CargarImagenes({super.key});

  @override
  State<CargarImagenes> createState() => _CargarImagenesState();
}

class _CargarImagenesState extends State<CargarImagenes> {
  UserModer? user;
  TextEditingController _controller = TextEditingController();
  final _formConcepto = GlobalKey<FormFieldState>();

  @override
  void initState() {
    super.initState();
    user = context.read<UserCubit>().state;
  }

  File? _imageFile;
  String? _imageURL;
  var _imagen;
  String? _concepto;

  ImagePicker picker = ImagePicker();

  Future<void> cargarImagen(op) async {
    if (op == 1) {
      _imagen = await picker.pickImage(source: ImageSource.gallery);
    } else if (op == 2) {
      _imagen = await picker.pickImage(source: ImageSource.camera);
    }
    if (_imagen != null) {
      setState(() {
        _imageFile = File(_imagen.path);
      });
    }
  }

  Future<void> _subirImagenes() async {
    final url = Uri.parse('https://api.cloudinary.com/v1_1/dwosvvfvu/upload');
    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = 'mn5uhtfq'
      ..files.add(await http.MultipartFile.fromPath('file', _imageFile!.path));

    final response = await request.send();
    print('///////////////////////////////////////////////////////////');
    print(response.statusCode);
    if (response.statusCode == 200) {
      final responseData = await response.stream.toBytes();
      final responseString = String.fromCharCodes(responseData);
      final jsonMap = jsonDecode(responseString);

      setState(() {
        final url = jsonMap['url'];
        _imageURL = url;
        if (response.statusCode == 200) {
          guardarPublicacion(_concepto);
        } else {
          print('error');
        }
      });
    } else {
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

  Future<void> guardarPublicacion(concepto) async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Comparte tu opinion',
            style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 48, left: 24, right: 24, bottom: 10),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: HexColor('19131B'),
                  ),
                  child: Row(
                    children: [
                      Lottie.asset('assets/json/user2.json',
                          width: 130, height: 150, fit: BoxFit.fill),
                      Text(
                        '@${user!.name}',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 24, right: 24, bottom: 10),
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: HexColor('19131B'),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(24),
                          child: TextFormField(
                            key: _formConcepto,
                            onChanged: (value) {
                              _formConcepto.currentState!.validate();
                            },
                            controller: _controller,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                label: Text(
                                    'Que estas pensando hoy? ${user!.name}'),
                                labelStyle: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colors.white,
                                  fontSize: 12,
                                )),
                            maxLines: null,
                            validator: (value) {
                              if (value!.isEmpty || value == null) {
                                return 'Por favor ingreso un concepto';
                              }
                            },
                          ),
                        ),
                        _imageFile != null
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: FadeInImage(
                                      fadeInDuration:
                                          Duration(milliseconds: 300),
                                      placeholder: AssetImage(
                                          'assets/images/loading2.gif'),
                                      image: FileImage(
                                        _imageFile!,
                                      ),
                                    )),
                              )
                            : Container(),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: HexColor('5C10C7'),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        cargarImagen(1);
                                      },
                                      icon: Icon(Icons.photo_album)),
                                  IconButton(
                                      onPressed: () {
                                        cargarImagen(2);
                                      },
                                      icon: Icon(Icons.camera)),
                                  IconButton(
                                      onPressed: () {
                                        if (_formConcepto.currentState!
                                                .validate() &&
                                            _imageFile != null) {
                                          setState(() {
                                            _concepto = _controller.text.trim();
                                          });
                                          _subirImagenes();
                                        } else {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text(
                                                  'Error',
                                                  style: TextStyle(
                                                      fontFamily: 'Poppins',
                                                      color: HexColor('5C10C7'),
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                content: Text(
                                                  'Por favor ingrese un concepto y una imagen',
                                                  style: TextStyle(
                                                      fontFamily: 'Poppins',
                                                      color: Colors.white,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.normal),
                                                ),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Text('Aceptar'),
                                                  )
                                                ],
                                              );
                                            },
                                          );
                                        }
                                      },
                                      icon: Icon(Icons.save))
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    )),
              ),
            ],
          ),
        ));
  }
}
