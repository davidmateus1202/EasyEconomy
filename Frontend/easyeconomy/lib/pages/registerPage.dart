// ignore_for_file: non_constant_identifier_names

import 'package:easyeconomy/models/user_cubir.dart';
import 'package:easyeconomy/models/user_model.dart';
import 'package:easyeconomy/pages/NavegacionUsuario/Home.dart';
import 'package:easyeconomy/service/api.dart';
import 'package:easyeconomy/widget/topLogo.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snippet_coder_utils/hex_color.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKeyName = GlobalKey<FormFieldState>();
  final _formKeyEmail = GlobalKey<FormFieldState>();
  final _formKeyPassword = GlobalKey<FormFieldState>();
  final _formKeyConfirm = GlobalKey<FormFieldState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: HexColor('5C10C7'),
        body: Center(
          child: ListView(
            children: [
              const Top_logo_register(),
              SpaceBox(),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: TextRegister()),
              // SpaceBox(),
              // _photoProfile(),
              SpaceBox(),
              PaddinForm(),
              SpaceBox(),
              _ButtonRegister(),
              SpaceBox(),
              _Navigator_login(),
              SpaceBox(),
            ],
          ),
        ),
      ),
    );
  }

  // method to create space
  Widget SpaceBox() {
    return SizedBox(
      height: 20,
    );
  }

  Widget PaddinForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 15),
      child: Column(
        children: [
          _FormRegistern2(),
          SpaceBox(),
          _FormEmail(),
          SpaceBox(),
          _FormPassword(),
          SpaceBox(),
          _FormPasswordConfirm(),
        ],
      ),
    );
  }

  Widget _photoProfile() {
    return CircleAvatar(
      backgroundImage: AssetImage(
        'assets/images/user_profile_2.png',
      ),
      radius: 100,
      backgroundColor: Colors.white,
    );
  }

  Widget TextRegister() {
    return Text(
      'Register',
      style: TextStyle(
        color: Colors.white,
        fontSize: 30,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _FormRegistern2() {
    return TextFormField(
      key: _formKeyName,
      controller: nameController,
      onChanged: (value) {
        _formKeyName.currentState!.validate();
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        label: Text('Name'),
        labelStyle: TextStyle(color: Colors.white),
        prefixIcon: Icon(
          Icons.person,
          color: Colors.white,
        ),
      ),
      validator: (value) {
        if (value == null || value!.isEmpty) {
          return 'Name is required';
        }
      },
    );
  }

  Widget _FormEmail() {
    return TextFormField(
      key: _formKeyEmail,
      controller: emailController,
      onChanged: (value) {
        _formKeyEmail.currentState!.validate();
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        label: Text('Email'),
        labelStyle: TextStyle(color: Colors.white),
        prefixIcon: Icon(
          Icons.email,
          color: Colors.white,
        ),
      ),
      validator: (value) {
        if (value == null || value!.isEmpty) {
          return 'Email is not valid';
        }
        if (!value.contains('@')) {
          return 'Email is not valid';
        } else {
          return null;
        }
      },
    );
  }

  // method to create form register

  Widget _FormPassword() {
    return TextFormField(
      key: _formKeyPassword,
      obscureText: true,
      controller: passwordController,
      onChanged: (value) {
        _formKeyPassword.currentState!.validate();
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        label: Text('Password'),
        labelStyle: TextStyle(color: Colors.white),
        prefixIcon: const Icon(
          Icons.lock,
          color: Colors.white,
        ),
      ),
      validator: (value) {
        if (value == null || value!.isEmpty) {
          return 'Password is not valid';
        }
      },
    );
  }

  Widget _FormPasswordConfirm() {
    return TextFormField(
      key: _formKeyConfirm,
      controller: passwordConfirmController,
      obscureText: true,
      onChanged: (value) {
        _formKeyConfirm.currentState!.validate();
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        label: Text('Confirm password'),
        labelStyle: TextStyle(color: Colors.white),
        prefixIcon: const Icon(
          Icons.lock,
          color: Colors.white,
        ),
      ),
      validator: (value) {
        if (value == null || value!.isEmpty) {
          return 'Password is not valid';
        }
        if (value != _formKeyPassword.currentState!.value) {
          return 'Password not match';
        } else {
          return null;
        }
      },
    );
  }

  Widget _ButtonRegister() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 90),
      child: ElevatedButton(
        onPressed: () async {
          if (_formKeyName.currentState!.validate() &&
              _formKeyEmail.currentState!.validate() &&
              _formKeyPassword.currentState!.validate() &&
              _formKeyConfirm.currentState!.validate()) {
            String username = nameController.text.trim();
            String email = emailController.text.trim();
            String password1 = passwordController.text.trim();
            String password2 = passwordConfirmController.text.trim();

            registrarUsuario(username, email, password1, password2, context);

            // _controller.register(username, email, password);
          } else {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Registration Failed'),
                    content: Text('Please try again later'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('OK'),
                      )
                    ],
                  );
                });
          }
        },
        child: Text('Register'),
        style: ElevatedButton.styleFrom(
          primary: Colors.white,
          onPrimary: HexColor('066269'),
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        ),
      ),
    );
  }

  Widget _Navigator_login() {
    return Center(
      child: RichText(
        text: TextSpan(
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.0,
            ),
            children: <TextSpan>[
              TextSpan(
                  text: 'You have an account? ',
                  style: TextStyle(color: Color.fromARGB(104, 242, 250, 253))),
              TextSpan(
                text: 'Login',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                ),

                //navigate to register page when user click on sing up
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.pushNamed(context, '/login');
                  },
              )
            ]),
      ),
    );
  }

}
