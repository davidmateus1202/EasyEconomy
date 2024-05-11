import 'dart:io';

import 'package:easyeconomy/models/user_cubir.dart';
import 'package:easyeconomy/models/user_model.dart';
import 'package:easyeconomy/service/apiPost.dart';
import 'package:easyeconomy/widget/AlertDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:snippet_coder_utils/hex_color.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  bool _isloding = false;
  UserModer? user;
  File? imagePost;
  TextEditingController _controller = TextEditingController();
  final _formConcepto = GlobalKey<FormFieldState>();

  @override
  void initState() {
    super.initState();
    user = context.read<UserCubit>().state;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RichText(
            text: TextSpan(children: [
              TextSpan(
                  text: 'Create',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    color: HexColor('#B401FF'),
                    fontWeight: FontWeight.bold,
                  )),
              TextSpan(
                  text: ' Post',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  )),
            ]),
          ),
        ],
      )),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 2,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 12, left: 12),
                              child: Row(
                                children: [
                                  Lottie.asset('assets/json/user2.json',
                                      width: 50, height: 50),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 12),
                                    child: Text(
                                      '${user?.name}',
                                      style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: 100,
                          child: TextFormField(
                            controller: _controller,
                            key: _formConcepto,
                            maxLines: 10,
                            decoration: InputDecoration(
                              hintText: 'Why are feeling today?',
                              hintStyle: TextStyle(fontFamily: 'Poppins'),
                              border: const UnderlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        imagePost != null
                            ? Container(
                                width: MediaQuery.of(context).size.width * 0.9,
                                height:
                                    MediaQuery.of(context).size.height * 0.4,
                                child: FadeInImage(
                                  fadeInDuration: Duration(milliseconds: 300),
                                  placeholder:
                                      AssetImage('assets/images/loading2.gif'),
                                  image: FileImage(imagePost!),
                                ))
                            : Container(
                                width: MediaQuery.of(context).size.width * 0.9,
                                height:
                                    MediaQuery.of(context).size.height * 0.4,
                                child: FadeInImage(
                                  placeholder: AssetImage(
                                      'assets/images/giflodingPost.gif'),
                                  image:
                                      AssetImage('assets/images/loading2.gif'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
                Card(
                  elevation: 16,
                  shadowColor: HexColor('9A0EE2'),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                      side: BorderSide(
                          color: Colors.grey[200] ?? Colors.transparent,
                          width: 2)),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 2.5,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          height: 15,
                          color: HexColor('9A0EE2'),
                        ),
                        Padding(
                            padding: EdgeInsets.only(top: 24, left: 24),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.photo,
                                  color: HexColor('9A0EE2'),
                                  size: 35,
                                ),
                                TextButton(
                                    onPressed: () async {
                                      File image = await imagePostFile(1);
                                      setState(() {
                                        imagePost = image;
                                      });
                                    },
                                    child: Text(
                                      'Photo / ',
                                      style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 15,
                                          fontWeight: FontWeight.normal),
                                    )),
                                Padding(
                                  padding: const EdgeInsets.only(right: 12),
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      if (_formConcepto.currentState!
                                              .validate() &&
                                          imagePost != null) {
                                        await subirImagenes(context, imagePost!,
                                            _controller.text, user!);
                                      }else {
                                        ShowDialogs.showAlertDialog(context, 'Error data', 'Form data is incorrect, please check the data entered');
                                      }
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.resolveWith(
                                              (states) => HexColor('AF33E1')),
                                    ),
                                    child: const Text(
                                      'Post',
                                      style: TextStyle(
                                          fontFamily: 'Poppins',
                                          color: Colors.white,
                                          fontSize: 12),
                                    ),
                                  ),
                                )
                              ],
                            )),
                        Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Divider()),
                        Padding(
                            padding: EdgeInsets.only(top: 24, left: 24),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.camera,
                                  color: HexColor('9A0EE2'),
                                  size: 35,
                                ),
                                TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      'Camera',
                                      style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 15,
                                          fontWeight: FontWeight.normal),
                                    )),
                              ],
                            )),
                        Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Divider()),
                        Padding(
                            padding: EdgeInsets.only(top: 24, left: 24),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.photo,
                                  color: HexColor('9A0EE2'),
                                  size: 35,
                                ),
                                TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      'Nose',
                                      style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 15,
                                          fontWeight: FontWeight.normal),
                                    )),
                              ],
                            )),
                        Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Divider()),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          if (_isloding)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: Image.asset(
                  'assets/images/loading.gif',
                  width: 50,
                  height: 50,
                ),
              ),
            )
        ],
      ),
    );
  }
}
