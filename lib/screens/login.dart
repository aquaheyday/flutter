import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter1/modals/register.dart';
import 'package:flutter1/modals/find_password.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter1/widgets/switch.dart';
import 'package:flutter1/widgets/text_form_field.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      theme: ThemeData(fontFamily: 'Pretendard'),
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
                    fontSize: 62,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
              Container(
                width: 422,
                height: 364,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  //borderRadius: BorderRadius.only(topLeft: Radius.zero, topRight: Radius.zero, bottomLeft: Radius.circular(5), bottomRight: Radius.circular(5)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          hoverColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          /*onTap: () {
                            print('test');
                          },*/
                          child: Container(
                            width: 140,
                            height: 50,
                            child: Center(
                              child: Text('ID 로그인',),
                            ),
                          ),
                        ),
                        InkWell(
                          hoverColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Center(child: Text(
                                      '준비중 입니다.',
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  )
                                );
                              },
                            );
                          },
                          child: Container(
                            width: 140,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(240, 240, 240, 1),
                              border: Border(
                                bottom: BorderSide(
                                  width: 1,
                                  color: Colors.grey,
                                ),
                                left: BorderSide(
                                  width: 1,
                                  color: Colors.grey,
                                ),
                                /*right: BorderSide(
                                width: 1,
                                color: Colors.grey,
                              ),*/
                              ),
                              //borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5),bottomRight: Radius.circular(5)),
                            ),
                            child: Center(
                              child: Text('로그인 연동'),
                            ),
                          ),
                        ),
                        InkWell(
                          hoverColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                    title: Center(child: Text(
                                      '준비중 입니다.',
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    )
                                  ),
                                );
                              },
                            );
                          },
                          child: Container(
                            width: 140,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(240, 240, 240, 1),
                              border: Border(
                                left: BorderSide(
                                  width: 1,
                                  color: Colors.grey,
                                ),
                                bottom: BorderSide(
                                  width: 1,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            child: Center(
                              child: Text('QR 로그인'),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 300,
                      padding: EdgeInsets.only(
                        left: 30,
                        right: 30,
                        top: 10,
                      ),
                      child: LoginForm(),
                    ),
                  ],
                ),
              ),
              SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (BuildContext context) {
                              return FindPasswordModal();
                            }
                        );
                      },
                      child: Text(
                        '비밀번호찾기',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Container(
                      height: 10,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 1,
                            color: Colors.grey,

                          ),
                          left: BorderSide(
                            width: 1,
                            color: Colors.grey,
                          ),
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
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox( height: 20),
              Container(
                width: 420,
                height: 140,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/images/login.jpg'),
                  ),
                ),
              ),
              SizedBox( height: 40),
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
                      Container(
                        height: 10,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              width: 1,
                              color: Colors.grey,

                            ),
                            left: BorderSide(
                              width: 1,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
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
  bool _isLoading = false;
  final formKey = GlobalKey<FormState>();

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool check = false;

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
          'check': check,
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
  void initState() {
    super.initState();
    if (window.localStorage['tkn'] != null) {
      context.go('/list');
    }
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
            height: 160,
            child: Column(
              children: [
                MyTextFormField(name: email, label: '이메일', validator: '이메일을 입력해 주세요.', obscure: false),
                SizedBox(height: 14),
                MyTextFormField(name: password, label: '비밀번호', validator: '비밀번호를 입력해 주세요.', obscure: true),
              ],
            ),
          ),
          Column(
            children: [
              Row(
                children: [
                  Switch(
                    value: check,
                    onChanged: (value) {
                      setState(() {
                        check = value;
                      });
                    },
                  ),
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
              SizedBox(height: 4,),
              SizedBox(
                width: double.infinity,
                height: 40,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : () {
                    if (formKey.currentState!.validate()) {
                      setState(() => _isLoading = true);
                      _callAPI();
                    }
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
                  label: Text(
                    '로그인',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
