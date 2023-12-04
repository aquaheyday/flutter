import 'dart:html';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:go_router/go_router.dart';
import 'package:flutter1/widgets/text_form_field.dart';


class RegisterWidget extends StatefulWidget {
  const RegisterWidget({super.key});

  @override
  State<RegisterWidget> createState() => _RegisterWidgetState();
}

class _RegisterWidgetState extends State<RegisterWidget> {
  bool _isLoading = false;
  final formKey = GlobalKey<FormState>();

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController number = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController c_password = TextEditingController();

  Future<bool> _CallRegister() async {
    bool success = false;

    if (formKey.currentState!.validate()) {
      var response = await http.post(
        Uri.parse('https://goseam.com/api/register'),
        headers: <String, String> {
          'Content-Type': 'application/json'
        },
        body: jsonEncode({
          'name': name.text,
          'email': email.text,
          'number': number.text,
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
      setState(() {
        _isLoading = false;
      });
    }

    return success;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: SizedBox(
            width: 310,
            height: 500,
            child: Column(
              children: [
                SizedBox(
                  height: 440,
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
                        SizedBox(height: 40),
                        MyTextFormField(name: name, label: '이름', validator: '이름을 입력해 주세요.'),
                        MyTextFormField(name: number, label: '연락처', validator: '연락처를 입력해 주세요.'),
                        MyTextFormField(name: email, label: '이메일', validator: '이메일을 입력해 주세요.'),
                        MyTextFormField(name: password, label: '비밀번호', validator: '비밀번호를 입력해 주세요.', obscure: true),
                        MyTextFormField(name: c_password, label: '비밀번호 확인', validator: '비밀번호 확인을 입력해 주세요.', obscure: true),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : () {
                      if (formKey.currentState!.validate()) {
                        setState(() => _isLoading = true);
                        _CallRegister();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(16.0),
                      backgroundColor: Color.fromRGBO(65, 105, 225, 1),
                    ),
                    icon: _isLoading ? Container(
                      width: 24,
                      height: 24,
                      padding: EdgeInsets.all(2.0),
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3,
                      ),
                    ) : Icon(Icons.check),
                    label: Text('가입하기'),
                  )
                ),
              ],
            ),
        ),
      ),
    );
  }
}
