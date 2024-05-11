import 'package:easyeconomy/models/user_cubir.dart';
import 'package:easyeconomy/models/user_model.dart';
import 'package:easyeconomy/pages/NavegacionUsuario/perfil/ShowModalButton.dart';
import 'package:easyeconomy/service/apiSumary.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Container_Buttons extends StatefulWidget {
  const Container_Buttons({super.key});

  @override
  State<Container_Buttons> createState() => _Container_ButtonsState();
}

class _Container_ButtonsState extends State<Container_Buttons> {
  UserModer? user;
  double Total = 0;



  @override
  void initState() {
    super.initState();
    user = context.read<UserCubit>().state;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          height: 70,
          width: MediaQuery.of(context).size.width * 0.4,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/4.png'),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(36),
          ),
          child: ElevatedButton(
            onPressed: () {
              Movimientos(context, 'Expenses', 2, user);
            },
            child: Text(
              'Expenses',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.normal,
              ),
            ),
            style: ButtonStyle(
              elevation: MaterialStateProperty.all<double>(0),
              backgroundColor: MaterialStateProperty.all<Color?>(
                Color.fromARGB(0, 212, 174, 174),
              ),
            ),
          ),
        ),
        Container(
          height: 70,
          width: MediaQuery.of(context).size.width * 0.4,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/4.png'),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(36),
          ),
          child: ElevatedButton(
            onPressed: () {
              Movimientos(context, 'Income', 1, user);
            },
            child: Text(
              'Income',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.normal,
              ),
            ),
            style: ButtonStyle(
              elevation: MaterialStateProperty.all<double>(0),
              backgroundColor: MaterialStateProperty.all<Color?>(
                Color.fromARGB(0, 212, 174, 174),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
