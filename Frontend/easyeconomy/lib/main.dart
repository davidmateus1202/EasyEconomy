import 'package:cloudinary_flutter/cloudinary_object.dart';
import 'package:cloudinary_url_gen/cloudinary.dart';
import 'package:easyeconomy/models/user_cubir.dart';
import 'package:easyeconomy/models/user_model.dart';
import 'package:easyeconomy/pages/NavegacionUsuario/perfil/perfil.dart';
import 'package:easyeconomy/pages/loginPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Cloudinary cloudinary = CloudinaryObject.fromCloudName(cloudName: 'dwosvvfvu');
  runApp(EasyEconomy());
}

class EasyEconomy extends StatefulWidget {
  const EasyEconomy({super.key});

  @override
  State<EasyEconomy> createState() => _EasyEconomyState();
}

class _EasyEconomyState extends State<EasyEconomy> {
  SharedPreferences? sharedPreferences;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return UserCubit(UserModer());
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Easy Economy',
        theme: ThemeData(
          primaryColor: Colors.white,
        ),
        
        darkTheme: ThemeData.dark(),
        home: const Login_Page(),
        routes: {
          '/login': (context) => const Login_Page(),
          '/perfil':(context) => const ProfilePage(),
        },
      ),
    );
  }
}
