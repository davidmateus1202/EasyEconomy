import 'dart:convert';
import 'dart:io';
import 'package:easyeconomy/pages/Home/BarGraph.dart';
import 'package:easyeconomy/pages/NavegacionUsuario/perfil/Gastos.dart';
import 'package:easyeconomy/pages/NavegacionUsuario/perfil/Semaforo.dart';
import 'package:easyeconomy/pages/NavegacionUsuario/perfil/widgetButtons.dart';
import 'package:flutter/gestures.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'package:easyeconomy/models/TransaccionModel.dart';
import 'package:easyeconomy/models/user_cubir.dart';
import 'package:easyeconomy/models/user_model.dart';
import 'package:easyeconomy/service/api.dart';
import 'package:easyeconomy/widget/drawerHome.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:snippet_coder_utils/hex_color.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  //////////// control de pantalla de carga ///////////////////////
  bool _isLoad = false;
  UserModer? user;
  int op = 0;
  late Future<List<TransaccionesModel>?> _futureTransacciones;

  @override
  void initState() {
    super.initState();
    user = context.read<UserCubit>().state;
    _futureTransacciones = ConsultarTransacciones();
  }

  /////////////////// metodo para crear transacciones //////////////////////

  Future<List<TransaccionesModel>?> ConsultarTransacciones() async {
    var url = Uri.parse('${Api.BaseUrl}/transaccion/getTransacciones/');
    var response = await http.get(url, headers: {
      'Authorization': 'Token ${user!.token}',
    });
    print(response.body);

    var datos = jsonDecode(response.body);
    List<TransaccionesModel> registros = [];

    for (var data in datos) {
      registros.add(TransaccionesModel.fromJson(data));
    }

    return registros;
  }

  File? _imageFile;
  String? imagePath;
  var _image;
  ImagePicker picker = ImagePicker();

  Future<void> cargarImagenesProfile() async {
    _image = await picker.pickImage(source: ImageSource.gallery);
    if (_image != null) {
      setState(() {
        _imageFile = File(_image.path);
      });
    }
    final url = Uri.parse('https://api.cloudinary.com/v1_1/dwosvvfvu/upload');
    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = 'wndlqtyw'
      ..files.add(await http.MultipartFile.fromPath('file', _imageFile!.path));

    final response = await request.send();
    if (response.statusCode == 200) {
      final responseData = await response.stream.toBytes();
      final responseString = String.fromCharCodes(responseData);
      final jsonMap = jsonDecode(responseString);

      setState(() {
        final url = jsonMap['url'];
        imagePath = url;
      });

      final userCubit = context.read<UserCubit>();
      await userCubit.actualizarInformacion(
          user!.token!, user!.id!, imagePath!, user!.name!);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => ProfilePage()));
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

  void rebuildPage() {
    setState(() {
      _futureTransacciones = ConsultarTransacciones();
    });
  }

  NumberFormat currencyFormat = NumberFormat.currency(symbol: '\$');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(),
        drawer: DrawerHome(),
        body: Stack(
          children: [
            Container(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                    ),
                    child: ContainerProfile(),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  op == 0 ?
                  ContainerMovimientos()
                  : Expanded(child: SemaforoContainer()),
                  SizedBox(
                    height: 20,
                  ),
                  ContainerButtons(),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            if (_isLoad)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: Image.asset(
                    'assets/images/loading.gif',
                    width: 50,
                    height: 50,
                    fit: BoxFit.fill,
                  ),
                ),
              )
          ],
        ));
  }

  Expanded ContainerMovimientos() {
    return Expanded(
      child: FutureBuilder<List<TransaccionesModel>?>(
        future: _futureTransacciones,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return Center(
                child: Text(
              'Error: ${snapshot.error}',
              style: TextStyle(fontFamily: 'Poppins'),
            ));
          } else {
            List<TransaccionesModel>? data = snapshot.data;
            if (data != null && data.isNotEmpty) {
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                      width: 200,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 10),
                        child: Card(
                          shadowColor: data[index].tipo.toString() == 'ingreso'
                              ? HexColor('3BED62')
                              : HexColor('FF6767'),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 10),
                                child: Row(
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          data[index].tipo.toString(),
                                          style: const TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        const Icon(
                                          Icons.monetization_on,
                                        ),
                                      ],
                                    ),
                                    Expanded(child: Container()),
                                    Column(
                                      children: [
                                        Text(
                                          currencyFormat.format(
                                              data[index].monto!.toDouble()),
                                          style: const TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal),
                                        ),
                                         Text(
                                          data[index].descripcion.toString(),
                                          maxLines: null,
                                          style: const TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        
                                        Text(
                                          DateFormat.yMEd()
                                              .add_jms()
                                              .format(data[index].fecha!),
                                          style: const TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 10,
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ));
                },
              );
            } else {
              return Center(
                  child: Text('No hay transacciones disponibles',
                      style: const TextStyle(fontFamily: 'Poppins')));
            }
          }
        },
      ),
    );
  }

  Widget ContainerProfile() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      shadowColor: HexColor('5C10C7'),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.4,
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            user?.imagen_profile != null
                ? Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage(user!.imagen_profile!),
                    ),
                  )
                : Lottie.asset('assets/json/user2.json',
                    width: 150, height: 150, fit: BoxFit.fill),
            Center(
              child: Text(
                '@${user!.name}',
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
            RichText(
                text: TextSpan(
                    text: 'Edit',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11,
                        color: HexColor('5C10C7'),
                        fontWeight: FontWeight.bold,
                        textBaseline: TextBaseline.alphabetic),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        setState(() {
                          _isLoad = true;
                        });
                        await cargarImagenesProfile();
                        setState(() {
                          _isLoad = false;
                        });
                      })),
            SizedBox(
              height: 24,
            ),
            Container_Buttons(),
          ],
        ),
      ),
    );
  }

  Widget ContainerButtons() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.06,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        image: DecorationImage(
          image: AssetImage('assets/images/button.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      op = 0;
                    });
                  },
                  icon: Icon(Icons.person, color: Colors.white)),
            ],
          ),
          Column(
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.fade,
                            child: BolsilloPage()));
                  },
                  icon: Icon(Icons.wallet, color: Colors.white)),
            ],
          ),
          Column(
            children: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      op = 1;
                    });
                  },
                  icon: Icon(Icons.category, color: Colors.white,)),
            ],
          )
        ],
      ),
    );
  }
}
