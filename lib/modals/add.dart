import 'dart:html';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter1/widgets/icon_elevated_button.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter1/widgets/text_form_field.dart';
import 'package:flutter1/widgets/drop_down_menu.dart';


class ListAddModal extends StatefulWidget {
  const ListAddModal({super.key});

  @override
  State<ListAddModal> createState() => _ListAddModalState();
}

class _ListAddModalState extends State<ListAddModal> {

  final formKey = GlobalKey<FormState>();

  TextEditingController type = TextEditingController();
  TextEditingController title = TextEditingController();
  TextEditingController password = TextEditingController();
  List<String> list = ['1', '2'];

  callAPI() async {
    var response = await http.post(
      Uri.parse('http://localhost/api/reception'),
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
                child: MyIconElevatedButton(text: '생성하기', function: callAPI),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
