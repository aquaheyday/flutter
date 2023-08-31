import 'dart:html';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter1/widgets/submit.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter1/widgets/textFormField.dart';
import 'package:flutter1/widgets/dropDwon.dart';


class ListAddModal extends StatefulWidget {
  const ListAddModal({super.key});

  @override
  State<ListAddModal> createState() => _ListAddModalState();
}

class _ListAddModalState extends State<ListAddModal> {

  final formKey = GlobalKey<FormState>();

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController c_password = TextEditingController();

  Future<bool> _CallRegister() async {
    bool success = false;

    if (formKey.currentState!.validate()) {
      var response = await http.post(
        Uri.parse('/api/register'),
        headers: <String, String> {
          'Content-Type': 'application/json'
        },
        body: jsonEncode({
          'name': name.text,
          'email': email.text,
          'password': password.text,
          'c_password': c_password.text,
        }),
      );
      if (response.statusCode == 200) {
        json.decode(response.body);
        Map<String, dynamic> map = jsonDecode(response.body);

        if (map['success']) {
          window.localStorage['tkn'] = map['data']['token'];
          context.go('/list');
        } else {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  actions: [
                    Text(map['message'] ?? null),
                  ],
                );
              }
          );
        }
        success = map['success'];
      }
    }

    return success;
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
                      DropdownMenuExample(),
                      SizedBox(height: 10),
                      TextFormFieldWidget(name: name, label: '제목', validator: 'Please enter your nickname', obscure: false),
                      SizedBox(height: 10),
                      TextFormFieldWidget(name: password, label: '비밀번호', validator: 'Please enter your password', obscure: true),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 40,
                child: SubmitWidget(text: '생성하기', function: _CallRegister),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
