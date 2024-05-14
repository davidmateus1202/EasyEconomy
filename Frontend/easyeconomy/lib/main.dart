import 'package:cloudinary_flutter/cloudinary_object.dart';
import 'package:cloudinary_url_gen/cloudinary.dart';
import 'package:easyeconomy/service/apiChat.dart';
import 'package:easyeconomy/Chat/ChatPage.dart';
import 'package:easyeconomy/models/user_cubir.dart';
import 'package:easyeconomy/models/user_model.dart';
import 'package:easyeconomy/pages/NavegacionUsuario/perfil/perfil.dart';
import 'package:easyeconomy/pages/loginPage.dart';
import 'package:easyeconomy/themas/thema.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Cloudinary cloudinary =
      CloudinaryObject.fromCloudName(cloudName: 'dwosvvfvu');
  runApp(MultiProvider(providers: [
    BlocProvider(create: (context) {
      return UserCubit(UserModer());
    }),
  ], child: EasyEconomy()));
}

class EasyEconomy extends StatefulWidget {
  const EasyEconomy({super.key});

  @override
  State<EasyEconomy> createState() => _EasyEconomyState();
}

class _EasyEconomyState extends State<EasyEconomy> {
  SharedPreferences? sharedPreferences;
  var User;

@override
  void setState(VoidCallback fn) {
    super.setState(fn);
    User = context.read<UserCubit>().state;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CambioTema(ThemeData.light()),
      child: MaterialWidget(),
    );
  }
}

class MaterialWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<CambioTema>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Easy Economy',
      theme: theme.getTheme(),
      home: Login_Page(),
      routes: {
        '/login': (context) => const Login_Page(),
        '/perfil': (context) => const ProfilePage(),
      },
    );
  }
}
