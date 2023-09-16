import 'dart:html';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter1/widgets/icon_elevated_button.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter1/widgets/text_form_field.dart';


class RegisterWidget extends StatefulWidget {
  const RegisterWidget({super.key});

  @override
  State<RegisterWidget> createState() => _RegisterWidgetState();
}

class _RegisterWidgetState extends State<RegisterWidget> {

  final formKey = GlobalKey<FormState>();

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController c_password = TextEditingController();

  Future<bool> _CallRegister() async {
    bool success = false;

    if (formKey.currentState!.validate()) {
      var response = await http.post(
        Uri.parse('http://localhost/api/register'),
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
        var decodeBody = utf8.decode(response.bodyBytes);

        Map<String, dynamic> map = jsonDecode(decodeBody);

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
            height: 390,
            child: Column(
              children: [
                SizedBox(
                  height: 340,
                  child: Form(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    key: formKey,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '회원가입',
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
                        MyTextFormField(name: name, label: '닉네임', validator: 'Please enter your nickname', obscure: false),
                        SizedBox(height: 10),
                        MyTextFormField(name: email, label: '이메일', validator: 'Please enter your e-mail', obscure: false),
                        SizedBox(height: 10),
                        MyTextFormField(name: password, label: '비밀번호', validator: 'Please enter your password', obscure: true),
                        SizedBox(height: 10),
                        MyTextFormField(name: c_password, label: '비밀번호확인', validator: 'Please enter your password check', obscure: true),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: MyIconElevatedButton(text: '가입하기', function: _CallRegister),
                ),
              ],
            ),
        ),
      ),
    );
  }
}
