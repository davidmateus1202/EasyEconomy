
import 'package:easyeconomy/models/PublicacionesModel.dart';
import 'package:easyeconomy/models/user_cubir.dart';
import 'package:easyeconomy/models/user_model.dart';
import 'package:easyeconomy/pages/NavegacionUsuario/feed/apiPublicaciones.dart';
import 'package:easyeconomy/pages/cargarImagenes.dart';
import 'package:easyeconomy/widget/drawerHome.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:snippet_coder_utils/hex_color.dart';


class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  UserModer? user;
  ApiPublicaciones apiPublicaciones = ApiPublicaciones();
  late List<PublicacionesModel> publicaciones;

  @override
  void initState() {
    super.initState();
    user = context.read<UserCubit>().state;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor('5C10C7'),
        actions: <Widget>[
          Padding(
              padding: const EdgeInsets.only(right: 20),
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => 
                    CargarImagenes()
                  ));
                },
                mini: true,
                shape: CircleBorder(),
                backgroundColor: HexColor('944FFF'),
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              )),
        ],
      ),
      drawer: DrawerHome(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 100,
              decoration: BoxDecoration(
                color: HexColor('5C10C7'),
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(120),
                ),
              ),
              child: Column(
                children: [
                  Row(children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 48),
                      child: Text('Hi! ${user!.name}',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  ]),
                  const Row(children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 70),
                      child: Text('Estos son los consejos del dia',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.normal)),
                    ),
                  ]),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - 200,
              child: FutureBuilder<ListaPubliaciones?>(
                future: apiPublicaciones.ObtenerPublicaciones(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: Container(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator(),
                    ));
                  } else if (snapshot.hasData) {
                    List<PublicacionesModel> publicaciones =
                        snapshot.data!.publicaciones;
                    return ListView.builder(
                      itemCount: publicaciones.length,
                      itemBuilder: (context, index) {
                        final publicacion = publicaciones[index];
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          child: Card(
                            elevation: 4,
                            shadowColor: HexColor('5C10C7'),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 5),
                                    child: Row(
                                      children: [
                                        Lottie.asset('assets/json/user2.json',
                                            width: 50,
                                            height: 50,
                                            fit: BoxFit.fill),
                                        Text(
                                          publicacion.usuario!,
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 24, right: 24, bottom: 10),
                                      child: Row(
                                        children: [
                                          Flexible(
                                              child: Text(
                                            publicacion.contenido!,
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ))
                                        ],
                                      )),
                                  publicacion.image != null
                                      ? Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 24, vertical: 5),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: FadeInImage(
                                                fadeInDuration: Duration(milliseconds: 300),
                                                placeholder: AssetImage('assets/images/loading2.gif'),
                                                image: NetworkImage(publicacion.image!)

                                            )

                                          )
                                        )
                                      : Container(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 12, bottom: 12),
                                        child: Text(
                                          DateFormat.yMEd()
                                              .add_jms()
                                              .format(publicacion.fecha!),
                                          style: const TextStyle(
                                              fontFamily: 'Poppins',
                                              color: Colors.purple,
                                              fontSize: 10,
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error al cargar las publicaciones');
                  } else {
                    return Text('No hay publicaciones');
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
