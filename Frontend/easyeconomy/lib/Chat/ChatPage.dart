import 'package:easyeconomy/service/apiChat.dart';
import 'package:easyeconomy/widget/drawerHome.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:snippet_coder_utils/hex_color.dart';

class ChatFrom extends StatefulWidget {
  const ChatFrom({super.key});

  @override
  State<ChatFrom> createState() => _ChatFromState();
}

class _ChatFromState extends State<ChatFrom> {
  bool isLoading = false;
  TextEditingController _messageCotroller = TextEditingController();
  final _formKeyMessage = GlobalKey<FormFieldState>();
  String message = 'En que te puedo ayudar hoy?';
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
                  text: 'I am',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    color: HexColor('B401FF'),
                    fontWeight: FontWeight.bold,
                  )),
              TextSpan(
                  text: ' BOB',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    color: HexColor('#5C10C7'),
                    fontWeight: FontWeight.bold,
                  )),
            ]),
          ),
        ],
      )),
      drawer: DrawerHome(),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.7,
                  decoration: BoxDecoration(
                    color: HexColor('#B401FF'),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Card(
                            elevation: 8,
                            shadowColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Container(
                              width: 220,
                              height: 250,
                              child: Padding(
                                padding: EdgeInsets.all(24),
                                child: SingleChildScrollView(
                                  child: message == 'En que te puedo ayudar hoy?' ?
                                  RichText(text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'How can',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          color: HexColor('B401FF'),
                                          fontSize: 20,
                                          fontWeight: FontWeight.normal
                                        )
                                      ),
                                      TextSpan(
                                        text: ' I help you',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 20,
                                          color: HexColor('#5C10C7'),
                                          fontWeight: FontWeight.bold
                                        )
                                      ),
                                      TextSpan(
                                        text: ' today?',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 20,
                                          color: HexColor('B401FF'),
                                          fontWeight: FontWeight.normal
                                        )
                                      )                                     
                                    ]
                                  ) 
                                  )
                                : Text(
                                  '$message',
                             
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal
                                )
                                )
                              ),
                            ),
                            )
                          ),
                        ],
                      ),
                      Lottie.asset('assets/json/bob2.json',
                          width: 250, height: 300),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/onda.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 24, left: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: TextFormField(
                            maxLines: null,
                            controller: _messageCotroller,
                            key: _formKeyMessage,
                            onChanged: (value) {
                              _formKeyMessage.currentState!.validate();
                            },
                            decoration: InputDecoration(
                              hintText: 'Write a message',
                              hintStyle: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 15,
                                color: HexColor('B401FF'),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty || value == null) {
                                return 'Campo vacio';
                              }
                            },
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            setState(() {
                              isLoading = true;
                            });
                            if (_formKeyMessage.currentState!.validate()) {
                              String messageResponse = await chat(_messageCotroller.text);
                              setState(() {
                                message = messageResponse;
                              });
                            }

                            setState(() {
                              isLoading = false;
                            });
                          },
                          icon: Icon(Icons.send),
                        )
                      ],
                    )),
                    SizedBox(height: 20,)
              ],
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
