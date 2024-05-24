import 'package:easyeconomy/Chat/ChatPage.dart';
import 'package:easyeconomy/models/user_cubir.dart';
import 'package:easyeconomy/models/user_model.dart';
import 'package:easyeconomy/pages/Home/Home.dart';

import 'package:easyeconomy/pages/NavegacionUsuario/feed/feed.dart';
import 'package:easyeconomy/pages/NavegacionUsuario/perfil/perfil.dart';
import 'package:easyeconomy/pages/loginPage.dart';
import 'package:easyeconomy/service/api.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:snippet_coder_utils/hex_color.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DrawerHome extends StatefulWidget {
  const DrawerHome({super.key});

  @override
  State<DrawerHome> createState() => _DrawerHomeState();
}

class _DrawerHomeState extends State<DrawerHome> {
  UserModer? user;

  @override
  void initState() {
    super.initState();
    user = context.read<UserCubit>().state;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
                color: HexColor('B401FF'),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                )),
            child: Center(
                child: Column(
              children: [
                user?.imagen_profile != null 
                  ? Padding(
                    padding: const EdgeInsets.only(top: 32),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(user!.imagen_profile!),
                    ),
                  )
                  : Lottie.asset('assets/json/user2.json',
                    width: 150, height: 150, fit: BoxFit.fill),

                Text(
                  '@${user?.name}',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  '${user?.email}',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.white,
                    fontSize: 10,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            )),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
              padding: const EdgeInsets.only(
                  left: 10, top: 10, bottom: 10, right: 10),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.home),
                    title: const Text('Home', style: TextStyle(fontFamily: 'Poppins'),),
                    onTap: () {
                      Navigator.pushReplacement(context, PageTransition(child: MyHomePage(), type: PageTransitionType.rightToLeftWithFade));

                    },
                  ),
                  Divider(
                    height: 10,
                    thickness: 0.3,
                    indent: 16,
                    endIndent: 16,
                  ),
                  ListTile(
                    leading: Icon(Icons.person),
                    title: const Text('Profile', style: TextStyle(fontFamily: 'Poppins'),),
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return ProfilePage();
                      }));
                    },
                  ),
                  Divider(
                    height: 10,
                    thickness: 0.3,
                    indent: 16,
                    endIndent: 16,
                  ),
                  ListTile(
                    leading: Icon(Icons.feed),
                    title: const Text('Feed', style: TextStyle(fontFamily: 'Poppins'),),
                    onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => FeedPage()));
                    },
                  ),
                  Divider(
                    height: 10,
                    thickness: 0.3,
                    indent: 16,
                    endIndent: 16,
                  ),
                  ListTile(
                    leading: Icon(Icons.smart_toy),
                    title: const Text('BOB', style: TextStyle(fontFamily: 'Poppins'),),
                    onTap: () {
                      Navigator.of(context)
                          .pushReplacement(PageTransition(child: ChatFrom(), type: PageTransitionType.rightToLeftWithFade));
                    },
                  ),

                ],
              )),
          Expanded(child: Container()),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
              decoration: BoxDecoration(
                color: HexColor('B401FF'),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: ListTile(
                leading: Icon(
                  Icons.logout_outlined,
                  color: Colors.white,
                ),
                title: const Text('Logout',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.white,
                    )),
                onTap: () async {
                  await logout(user!.token!);
                  Navigator.of(context)
                      .pushReplacement(MaterialPageRoute(builder: (context) => Login_Page()));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
