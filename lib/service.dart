import 'package:http/http.dart' as http;
import 'package:flutter1/models/list.dart';
import 'dart:html';

class Services {
  static const String url = 'http://localhost/api/reception';

  static Future<List<User>> getInfo() async {
    //try {
      var response =  await http.get(
        Uri.parse('http://localhost/api/reception'),
        headers: <String, String>{
          'Accept': 'application/json',
          'Authorization': 'Bearer ' + window.localStorage['tkn'].toString(),
        },
      );
      if (response.statusCode == 200) {
        var user = userFromJson(response.body);
        print(user);

        print(user);
        return <User>[];
      } else {
        return <User>[];
      }
    //} catch(e) {
      //return <User>[];
    //}
  }
}