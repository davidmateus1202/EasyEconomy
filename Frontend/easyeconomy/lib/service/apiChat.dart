import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiChat {
  static String url = 'https://xxp0hp9r-8000.use.devtunnels.ms/appi/ia/';
}

Future<String> chat(String question) async {
  var url = Uri.parse('${ApiChat.url}');
  int num_palabras = 300;
  Map<String, String> data = {
    "input_text": question,
  };
  var res = await http.post(url, body: data);
  print(res.body);
  Map<String, dynamic> json = jsonDecode(res.body);
  String messae = json['Generated Text'];
  return messae;
}
