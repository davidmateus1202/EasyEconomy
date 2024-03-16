import 'package:easyeconomy/models/user_cubir.dart';
import 'package:easyeconomy/models/user_model.dart';
import 'package:easyeconomy/pages/NavegacionUsuario/Home.dart';
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
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
                  const Center(
                    child: Text(
                      'Or',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  _Navigator_Register()
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }

  login(String name, String pssword) async {
    var response = await userApi(name, pssword);
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
    }else if(response.runtimeType == UserModer){
      UserModer user = response;
      context.read<UserCubit>().emit(user);
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {return Home();}));
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
          color: Colors.white,
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
        labelStyle: const TextStyle(color: Colors.white),
        prefixIcon: Icon(Icons.person, color: Colors.white),
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
        labelStyle: const TextStyle(color: Colors.white),
        prefixIcon: Icon(Icons.lock, color: Colors.white),
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
          if (_formKeyName.currentState!.validate() &&
              _formKeyPassword.currentState!.validate()) {
            String name = nameController.text.trim();
            String password = passwordController.text.trim();

            login(name, password);
          }
        },
        child: const Text('Login'),
        style: ElevatedButton.styleFrom(
          primary: Colors.white,
          onPrimary: HexColor('066269'),
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        ),
      ),
    );
  }

  Widget _Navigator_Register() {
    return Center(
      child: RichText(
        text: TextSpan(
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14.0,
            ),
            children: <TextSpan>[
              const TextSpan(
                  text: 'Don\'t have an account? ',
                  style: TextStyle(color: Color.fromARGB(104, 242, 250, 253))),
              TextSpan(
                text: 'Sing up',
                style: const TextStyle(
                  decoration: TextDecoration.underline,
                ),

                //navigate to register page when user click on sing up
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                      return RegisterPage();}));
                  },
              )
            ]),
      ),
    );
  }
}
