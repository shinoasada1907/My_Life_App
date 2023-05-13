import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:my_life_app/models/imagesend.dart';

class FlaskApi {
  static Future<ImageSending> sendImage(dynamic image) async {
    const String url = 'http://192.168.95.33:5000/image';
    final uri = Uri.parse(url);
    final respone = await http.post(uri, body: image);
    if (respone.statusCode == 200) {
      final result = jsonDecode(respone.body);
      return ImageSending.fromJson(result);
    } else {
      throw Exception(respone.reasonPhrase);
    }
  }
}
