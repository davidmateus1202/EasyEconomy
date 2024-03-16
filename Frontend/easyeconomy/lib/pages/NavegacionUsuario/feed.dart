import 'package:easyeconomy/models/user_cubir.dart';
import 'package:easyeconomy/models/user_model.dart';
import 'package:easyeconomy/widget/drawerHome.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:snippet_coder_utils/hex_color.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  //////////// MODELO DE USUSARIO PARA ATRAER LOS DATOS /////////////////
  UserModer? user;

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
            child: ContainerPublicacion(),
          ),
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
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  ]),
                  Row(children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 70),
                      child: Text('Estos son los consejos del dia',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.normal)),
                    ),
                  ]),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - 200,
            ),
          ],
        ),
      ),
    );
  }

 Widget ContainerPublicacion() {
    return FloatingActionButton(
      mini: true,
      shape: CircleBorder(),
      backgroundColor: HexColor('A47EFF'),
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
                padding: EdgeInsets.symmetric(horizontal: 24),
                height: MediaQuery.of(context).size.height * 0.6,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                       Row(
                        children: [
                          Lottie.asset('assets/json/user2.json',
                              width: 100, height: 100, fit: BoxFit.fill
                          ),
                          Text('@${user!.name}',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold
                              ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: HexColor('5C10C7')),
                            ),
                            label: Text(
                              'Que estas pensando hoy? ${user!.name}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.normal,
                              ),
                            )
                        
                          ),
                        ),
                      )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }}
