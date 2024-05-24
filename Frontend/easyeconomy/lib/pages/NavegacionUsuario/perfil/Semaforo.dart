import 'package:easyeconomy/Chat/ChatPage.dart';
import 'package:easyeconomy/models/user_cubir.dart';
import 'package:easyeconomy/models/user_model.dart';
import 'package:easyeconomy/service/apiGastos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:snippet_coder_utils/hex_color.dart';

class SemaforoContainer extends StatefulWidget {
  const SemaforoContainer({super.key});

  @override
  State<SemaforoContainer> createState() => _SemaforoContainerState();
}

class _SemaforoContainerState extends State<SemaforoContainer> {
  UserModer? user;
  double Expense = 0;
  double Incomes = 0;

  @override
  void initState() {
    super.initState();
    user = context.read<UserCubit>().state;
    _getExpense();
    _getIngresos();
  }

  Future _getExpense() async {
    double _data = await getExpense(user!);
    setState(() {
      Expense = _data;
    });
  }

  Future _getIngresos() async {
    Map<String, dynamic> _data = await getEstados(user!);
    setState(() {
      Incomes = _data['total'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Incomes * 0.9 < Expense
        ? Padding(
            padding: const EdgeInsets.only(left: 24, right: 24),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(36),
                image: DecorationImage(
                  image: AssetImage('assets/images/DiseñoPantalla.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 36, right: 36, top: 20),
                    child: Text('Your financial status is critical',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                  Lottie.asset('assets/json/bob2.json',
                      width: 150, height: 200),
                  Container(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            PageTransition(
                                child: ChatFrom(),
                                type: PageTransitionType.rightToLeftWithFade));
                      },
                      child: Text('Talk to Bob',
                          style: TextStyle(
                            color: HexColor('#e71818'),
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.normal,
                          )),
                    ),
                  )
                ],
              ),
            ),
          )
        : Incomes * 0.9 > Expense && Incomes * 0.8 < Expense
            ? Padding(
                padding: const EdgeInsets.only(left: 24, right: 24, top: 20),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(36),
                    image: DecorationImage(
                      image: AssetImage('assets/images/DiseñoPantalla2.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 36, right: 36, top: 20),
                        child: Text(
                            'Your financial statements are stable but you need to improve',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                      Lottie.asset('assets/json/bob2.json',
                          width: 150, height: 200),
                      Container(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                PageTransition(
                                    child: ChatFrom(),
                                    type: PageTransitionType
                                        .rightToLeftWithFade));
                          },
                          child: Text('Talk to Bob',
                              style: TextStyle(
                                color: HexColor('#EBD224'),
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.normal,
                              )),
                        ),
                      )
                    ],
                  ),
                ),
              )
            : Incomes * 0.8 > Expense
                ? Padding(
                    padding: const EdgeInsets.only(left: 24, right: 24),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(36),
                        image: DecorationImage(
                          image:
                              AssetImage('assets/images/DiseñoPantalla3.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 40, right: 40, top: 20),
                            child: Text(
                                'You\'re the best! Keep going',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                          Lottie.asset('assets/json/bob2.json',
                              width: 150, height: 200),
                          Container(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                    context,
                                    PageTransition(
                                        child: ChatFrom(),
                                        type: PageTransitionType
                                            .rightToLeftWithFade));
                              },
                              child: Text('Talk to Bob',
                                  style: TextStyle(
                                    color: HexColor('#30E718'),
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.normal,
                                  )),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                : Container(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
        ],
      ),
    );
  }
}