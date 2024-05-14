import 'package:easyeconomy/models/user_cubir.dart';
import 'package:easyeconomy/models/user_model.dart';
import 'package:easyeconomy/pages/Home/Home.dart';
import 'package:easyeconomy/pages/NavegacionUsuario/perfil/perfil.dart';
import 'package:easyeconomy/pages/registerPage.dart';
import 'package:easyeconomy/service/api.dart';
import 'package:easyeconomy/widget/topLogo.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snippet_coder_utils/hex_color.dart';

class Login_Page extends StatefulWidget {
  const Login_Page({super.key});

  @override
  State<Login_Page> createState() => _Login_PageState();
}

class _Login_PageState extends State<Login_Page> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _formKeyPassword = GlobalKey<FormFieldState>();
  final _formKeyName = GlobalKey<FormFieldState>();

  bool _isloging = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
          child: ListView(
            children: [
              Center(
                child: Column(
                  children: [
                    const Top_logo_register(),
                    SpaceBox(),
                    _TextLogin(),
                    SpaceBox(),
                    _PaddinForm(),
                    SpaceBox(),
                    _ButtonLogin(),
                    SpaceBox(),
                    Center(
                      child: Text(
                        'Or',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    _Navigator_Register()
                  ],
                ),
              ),
            ],
          ),
        ),
        if (_isloging)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: Center(
                child: Image.asset(
              'assets/images/loading.gif',
              width: 50,
              height: 50,
            )),
          )
      ],
    ));
  }

  login(String name, String pssword) async {
    var response = await userApi(name, pssword, context);
    print(response.runtimeType);
    if (response.runtimeType == String) {
      showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              child: Container(
                alignment: Alignment.center,
                height: 200,
                width: 200,
                child: Text(response),
              ),
            );
          });
    } else if (response.runtimeType == UserModer) {
      UserModer user = response;
      context.read<UserCubit>().emit(user);
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return MyHomePage();
      }));
    }
  }

  Widget _PaddinForm() {
    return Container(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Column(
        children: [
          _FormLogin2(),
          SpaceBox(),
          _FormPassword2(),
        ],
      ),
    ));
  }

  // method to create space

  Widget SpaceBox() {
    return const SizedBox(
      height: 20,
    );
  }

  Widget _TextLogin() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: const Text(
        'Login',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // method to create form
  Widget _FormLogin2() {
    return TextFormField(
      key: _formKeyName,
      onChanged: (value) {
        _formKeyName.currentState?.validate();
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        label: const Text('Name'),
        labelStyle: const TextStyle(fontFamily: 'Poppins'),
        prefixIcon: Icon(
          Icons.person,
        ),
      ),
      controller: nameController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
      },
    );
  }

  Widget _FormPassword2() {
    return TextFormField(
      key: _formKeyPassword,
      onChanged: (value) {
        _formKeyPassword.currentState?.validate();
      },
      obscureText: true,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        label: const Text('Password'),
        labelStyle: const TextStyle(fontFamily: 'Poppins'),
        prefixIcon: Icon(Icons.lock),
      ),
      controller: passwordController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
      },
    );
  }

  Widget _ButtonLogin() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 90),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _isloging = true;
          });
          if (_formKeyName.currentState!.validate() &&
              _formKeyPassword.currentState!.validate()) {
            String name = nameController.text.trim();
            String password = passwordController.text.trim();

            login(name, password);
          }
          setState(() {
            _isloging = false;
          });
        },
        child: const Text(
          'Login',
          style: TextStyle(fontFamily: 'Poppins'),
        ),
        style: ElevatedButton.styleFrom(
          primary: HexColor('5C10C7'),
          onPrimary: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        ),
      ),
    );
  }

  Widget _Navigator_Register() {
    return Center(
      child: RichText(
        text: TextSpan(
            style: TextStyle(
              fontSize: 14.0,
            ),
            children: <TextSpan>[
              TextSpan(
                  text: 'Don\'t have an account? ',
                  style: TextStyle(
                      color: HexColor('B401FF'), fontFamily: 'Poppins')),
              TextSpan(
                text: 'Sing up',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontFamily: 'Poppins',
                  color: HexColor('B401FF'),
                ),

                //navigate to register page when user click on sing up
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return RegisterPage();
                    }));
                  },
              )
            ]),
      ),
    );
  }
}
