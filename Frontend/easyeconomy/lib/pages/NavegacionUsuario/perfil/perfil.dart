import 'dart:convert';
import 'package:intl/intl.dart';

import 'package:easyeconomy/models/TransaccionModel.dart';
import 'package:easyeconomy/models/user_cubir.dart';
import 'package:easyeconomy/models/user_model.dart';
import 'package:easyeconomy/service/api.dart';
import 'package:easyeconomy/pages/NavegacionUsuario/perfil/apiTransacciones.dart';
import 'package:easyeconomy/widget/drawerHome.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:snippet_coder_utils/hex_color.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  double totalIngresos = 0;
  double totalEgresos = 0;
  UserModer? user;
  late Future<List<TransaccionesModel>?> _futureTransacciones;

  @override
  void initState() {
    super.initState();
    user = context.read<UserCubit>().state;
    _futureTransacciones = ConsultarTransacciones();
  }

  /////////////////// metodo para crear transacciones //////////////////////

  Future<List<TransaccionesModel>?> ConsultarTransacciones() async {
    var user = context.read<UserCubit>().state;
    var url = Uri.parse('${Api.BaseUrl}/transaccion/getTransacciones/');
    var response = await http.get(url, headers: {
      'Authorization': 'Token ${user.token}',
    });
    print(response.body);

    //almacenar el total de ingresos
    double _totalIngresos = 0;

    //almacenar el total de egresos
    double _totalEgresos = 0;

    var datos = jsonDecode(response.body);
    List<TransaccionesModel> registros = [];

    for (var data in datos) {
      registros.add(TransaccionesModel.fromJson(data));
      if (data['tipo'] == 'ingreso') {
        _totalIngresos += double.parse(data['monto'].toString());
      }else if(data['tipo'] == 'egreso'){
        _totalEgresos += double.parse(data['monto'].toString());

      }
    }

    setState(() {
      totalIngresos = _totalIngresos;
      totalEgresos = _totalEgresos;
    });
    print('${totalIngresos}');
    return registros;
  }

  // varibles para capturar los datos ingresados por el ususario

  TextEditingController _valorController = TextEditingController();
  TextEditingController _tipoController = TextEditingController();
  TextEditingController _conceptoController = TextEditingController();

  ////////////////////////////////////////////////////////////////

  //////// Validaciones de formulaios /////////////////////////////

  final _formValor = GlobalKey<FormFieldState>();
  final _formTipoMovimiento = GlobalKey<FormFieldState>();
  final _formConcepto = GlobalKey<FormFieldState>();

  ////////////////////////////////////////////////////////////////

  void rebuildPage() {
    setState(() {
      _futureTransacciones = ConsultarTransacciones();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(),
      drawer: DrawerHome(),
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: ContainerProfile(),
            ),
            TextMovimientos(),
            Expanded(
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
                              height: 120,
                              width: 200,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 10),
                                child: Card(
                                  shadowColor:
                                      data[index].tipo.toString() == 'ingreso'
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
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(height: 10),
                                                const Icon(
                                                  Icons.monetization_on,
                                                  color: Colors.white,
                                                ),
                                              ],
                                            ),
                                            Expanded(child: Container()),
                                            Column(
                                              children: [
                                                Text(
                                                  data[index]
                                                      .monto!
                                                      .toDouble()
                                                      .toString(),
                                                  style: const TextStyle(
                                                      fontFamily: 'Poppins',
                                                      color: Colors.white,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.normal),
                                                ),
                                                Text(
                                                  data[index]
                                                      .descripcion
                                                      .toString(),
                                                  style: const TextStyle(
                                                      fontFamily: 'Poppins',
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  DateFormat.yMEd()
                                                      .add_jms()
                                                      .format(
                                                          data[index].fecha!),
                                                  style: const TextStyle(
                                                      fontFamily: 'Poppins',
                                                      color: Colors.white,
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.normal),
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
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.only(right: 24, bottom: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Movimientos(),
                  ],
                ),
              ),
            )
          ],
        ),
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
        height: MediaQuery.of(context).size.height * 0.40,
        child: Column(
          children: [
            Lottie.asset('assets/json/user2.json',
                width: 150, height: 150, fit: BoxFit.fill),
            Center(
              child: Text(
                '@${user!.name}',
                style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
            RichText(
              text: TextSpan(
                text: 'Movimientos Mensuales',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.white,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text(totalIngresos.toStringAsFixed(0),
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.normal)),
                      Text(
                        'Ingresos',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Container(
                    width: 0.5,
                    height: 45,
                    color: Colors.white,
                  ),
                  Column(
                    children: [
                      Text(totalEgresos.toStringAsFixed(0),
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.normal)),
                      Text(
                        'Egresos',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget Movimientos() {
    return FloatingActionButton(
      shape: CircleBorder(),
      backgroundColor: HexColor('5c10c7'),
      child: Icon(
        Icons.add,
        color: Colors.white,
      ),
      onPressed: () {
        showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (BuildContext context) {
            return SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                height: MediaQuery.of(context).size.height * 0.6,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Text(
                        'Registra tus movimientos',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.90,
                      child: TextFormMovimientos(),
                    ),
                    SizedBox(height: 15),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.90,
                      child: TextFormTipo(),
                    ),
                    SizedBox(height: 15),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.90,
                      child: TextFormConcepto(),
                    ),
                    SizedBox(height: 15),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.90,
                      child: ButtonMovimientos(),
                    ),
                    SizedBox(height: 15),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // method to create textoform for ingresos

  Widget TextFormMovimientos() {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        width: 150,
        height: 60,

        /////// FORMULARIOOO //////////////////
        child: TextFormField(
          onChanged: (value) {
            _formValor.currentState!.validate();
          },
          key: _formValor,
          keyboardType: TextInputType.number,
          controller: _valorController,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.white),
            ),
            label: Text('Valor'),
            labelStyle: TextStyle(
              fontFamily: 'Poppins',
              color: Colors.white,
              fontSize: 12,
            ),
            prefixIcon: Icon(Icons.attach_money, color: Colors.white),
          ),
          validator: (value) {
            if (value == null || value!.isEmpty) {
              return 'Por favor ingrese un valor';
            }
          },
        ),
      ),
    );
  }

  ///////////// FORMULARIOOO CAMPO TIPO DE MOVIMIENTO //////////////////////
  Widget TextFormTipo() {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        width: 150,
        height: 60,

        ////////// FORMULARIOO //////////////////////////
        child: TextFormField(
          onChanged: (value) {
            _formTipoMovimiento.currentState!.validate();
          },
          key: _formTipoMovimiento,
          controller: _tipoController,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.white),
            ),
            label: Text('Tipo de movimiento'),
            labelStyle: TextStyle(
              fontFamily: 'Poppins',
              color: Colors.white,
              fontSize: 12,
            ),
            prefixIcon: Icon(Icons.payment, color: Colors.white),
          ),
          validator: (value) {
            if (value!.isEmpty || value == null) {
              return 'Por favor ingrese un valor';
            }
          },
        ),
      ),
    );
  }

/////////// FORMULARIO PARA EL CONCEPTO DE MOVIMIENTO ///////////////////////
  Widget TextFormConcepto() {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        width: 150,
        height: 60,

        ////////// FORMULARIOO //////////////////////////
        child: TextFormField(
          onChanged: (value) {
            _formConcepto.currentState!.validate();
          },
          key: _formConcepto,
          controller: _conceptoController,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.white),
            ),
            label: Text('Concepto'),
            labelStyle: TextStyle(
              fontFamily: 'Poppins',
              color: Colors.white,
              fontSize: 12,
            ),
            prefixIcon: Icon(Icons.find_in_page, color: Colors.white),
          ),
          validator: (value) {
            if (value!.isEmpty || value == null) {
              return 'Por favor ingrese el concepto';
            }
          },
        ),
      ),
    );
  }

  Widget ButtonMovimientos() {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        width: 150,
        height: 60,
        child: ElevatedButton(
          onPressed: () async {
            if (_formValor.currentState!.validate() &&
                _formTipoMovimiento.currentState!.validate() &&
                _formConcepto.currentState!.validate()) {
              String tipo = _tipoController.text.trim();
              String concepto = _conceptoController.text.trim();
              double valor = double.parse(_valorController.text.trim());

              await CrearTransaccion(user!, tipo, valor, concepto, context);
              rebuildPage();
            }
          },
          child: Text(
            'Guardar',
            style: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
          ),
          style: ElevatedButton.styleFrom(
            primary: HexColor('5C10C7'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }

  Widget TextMovimientos() {
    return Container(
        child: Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, top: 20),
          child: Text(
            'Movimientos',
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ));
  }
}
