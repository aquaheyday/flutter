import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter1/modals/register.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter1/widgets/switch.dart';
import 'package:flutter1/widgets/text_form_field.dart';
import 'package:flutter1/widgets/icon_elevated_button.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: "고심: 로그인",
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 40),
                child: Text(
                  "Goseam",
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                )
                /*Image(
                  image: AssetImage('assets/aaa.png'),
                  width: 300,
                  height: 100,
                  fit: BoxFit.fill,
                )*/,
              ),
              Container(
                width: 400,
                height: 300,
                margin: EdgeInsets.all(10.0),
                padding: EdgeInsets.all(30.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: LoginForm(),
              ),
              SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () => context.go('/register'),
                      child: Text(
                        '비밀번호찾기',
                        style: TextStyle(
                          fontSize: 12,
                          decoration: TextDecoration.underline,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (BuildContext context) {
                              return RegisterWidget();
                            }
                        );
                      },
                      child: Text(
                        '회원가입',
                        style: TextStyle(
                          fontSize: 12,
                          decoration: TextDecoration.underline,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox( height: 140),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        child: Text(
                          '이용약관',
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.black
                          ),
                        ),
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return Container(
                                height: 200,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('이용약관 내용'),
                                      ElevatedButton(
                                        child: Text('닫기'),
                                        onPressed: () => Navigator.pop(context),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                      Text('|'),
                      TextButton(
                        child: Text(
                          '개인정보처리방침',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                          ),
                        ),
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return Container(
                                height: 200,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('개인정보처리방침 내용'),
                                      ElevatedButton(
                                        child: Text('닫기'),
                                        onPressed: () => Navigator.pop(context),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Copyright © 2023. GOSEAM. All Rights Reserved.',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final formKey = GlobalKey<FormState>();

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController check = TextEditingController();

  _callAPI() async {
    bool success = false;
    if (formKey.currentState!.validate()) {
      var response = await http.post(
        Uri.parse('http://localhost/api/login'),
        headers: <String, String>{
          'Content-Type': 'application/json'
        },
        body: jsonEncode({
          'email': email.text,
          'password': password.text,
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
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 180,
            child: Column(
              children: [
                MyTextFormField(name: email, label: '이메일', validator: 'Please enter your e-mail', obscure: false),
                SizedBox(height: 10),
                MyTextFormField(name: password, label: '비밀번호', validator: 'Please enter your password', obscure: true),
                SizedBox(height: 10),
                Row(
                  children: [
                    MySwitch(),
                    Text(
                      '로그인 상태 유지',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 40,
            child: MyIconElevatedButton(text: '로그인', function: _callAPI),
          ),
        ],
      ),
    );
  }
}
