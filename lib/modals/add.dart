import 'dart:html';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:go_router/go_router.dart';
import 'package:flutter1/widgets/text_form_field.dart';
import 'package:flutter1/widgets/drop_down_menu.dart';


class ListAddModal extends StatefulWidget {
  const ListAddModal({super.key});

  @override
  State<ListAddModal> createState() => _ListAddModalState();
}

class _ListAddModalState extends State<ListAddModal> {
  bool _isLoading = false;
  final formKey = GlobalKey<FormState>();

  TextEditingController type = TextEditingController();
  TextEditingController title = TextEditingController();
  TextEditingController password = TextEditingController();
  List<String> list = ['스타벅스', '더카페', '커피쿡'];

  callAPI() async {
    var response = await http.post(
      Uri.parse('http://localhost/api/room'),
      headers: <String, String>{
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + window.localStorage['tkn'].toString(),
      },
      body: jsonEncode({
        'type': type.text,
        'title': title.text,
        'password': password.text,
      }),
    );

    if (response.statusCode == 200) {
      var decodeBody = utf8.decode(response.bodyBytes);
      Map<String, dynamic> map = jsonDecode(decodeBody);

      setState(() {
        _isLoading = false;
      });

      if (map['success']) {
        Navigator.pop(context);
        context.go('/room/' + jsonDecode(response.body)['data']['room_id'].toString());
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Text(map['message']),
              );
            }
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      content: Container(
        margin: const EdgeInsets.fromLTRB(40, 20, 40, 0),
        child: SizedBox(
          width: 320,
          height: 320,
          child: Column(
            children: [
              SizedBox(
                height: 250,
                child: Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  key: formKey,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '생성',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(),
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(Icons.close),
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      MyDropDownMenu(name: type, list: list),
                      SizedBox(height: 10),
                      MyTextFormField(name: title, label: '제목', validator: 'Please enter your nickname', obscure: false),
                      SizedBox(height: 10),
                      MyTextFormField(name: password, label: '비밀번호', validator: 'Please enter your password', obscure: true),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : () {
                    setState(() => _isLoading = true);
                    callAPI();
                  },
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16.0)),
                  icon: _isLoading ? Container(
                    width: 24,
                    height: 24,
                    padding: EdgeInsets.all(2.0),
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                  ) : Icon(Icons.check),
                  label: Text('생성하기'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
