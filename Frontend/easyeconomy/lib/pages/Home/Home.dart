import 'package:easyeconomy/models/user_cubir.dart';
import 'package:easyeconomy/models/user_model.dart';
import 'package:easyeconomy/pages/Home/BarGraph.dart';
import 'package:easyeconomy/pages/NavegacionUsuario/perfil/perfil.dart';
import 'package:easyeconomy/service/apiGastos.dart';
import 'package:easyeconomy/widget/BankAccountBalanceView.dart';
import 'package:easyeconomy/widget/drawerHome.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:snippet_coder_utils/hex_color.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  UserModer? user;
  Map<String, dynamic> data = {};
  NumberFormat currencyFormat = NumberFormat.currency(symbol: '\$');
  @override
  void initState() {
    super.initState();
    user = context.read<UserCubit>().state;
    _getGastos();
  }

  Future _getGastos() async {
    Map<String, dynamic> _data = await getEstados(user!);
    setState(() {
      data = _data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/Home.png'),
            fit: BoxFit.cover, // Ajuste de la imagen dentro del contenedor
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 36),
                    child: CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(user!.imagen_profile ?? ''),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 36),
                    child: Text(
                      'Good Day, ${user?.name}',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Poppins',
                        fontSize: 25,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Card(
                elevation: 8,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(36),
                ),
                child: Container(
                  height: 350,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 36, top: 36),
                            child: Text(
                              'Your Total Balance',
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 18,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '\$${data['total']}',
                        style: TextStyle(
                          color: HexColor('#B401FF'),
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Container(
                        height: 200,
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: BarGraph(),
                      ),
                
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 36,
              ),
              Card(
                elevation: 8,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(36),
                ),
                child: Container(
                  height: 150,
                  width: MediaQuery.of(context).size.width * 0.8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(36),
                    image: DecorationImage(
                      image: AssetImage('assets/images/button.png'),
                      fit: BoxFit.cover,
                    
                    )
                  ),

                  child: Row(
                    children: [
                      TextButton(
                        onPressed: () {
                      
                          Navigator.pushReplacement(context, PageTransition(type: PageTransitionType.rightToLeft, child: ProfilePage()));
                          
                        },
                        child: Text(
                          'Check your expenses',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios, color: Colors.white,)
                    ],
                  )

                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
