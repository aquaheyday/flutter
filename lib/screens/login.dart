import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter1/widgets/icon_elevated_button.dart';
import 'package:flutter1/widgets/switch.dart';
import 'package:flutter1/widgets//show_text_button.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter1/widgets/text_form_field.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    var pageWidth = MediaQuery.of(context).size.width;
    var isWeb = pageWidth > 700 ? true : false;

    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Pretendard',
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromRGBO(65, 105, 225, 1),
        ),
      ),
      title: '고심: 로그인',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 40),
                child: Text(
                  'Goseam',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(65, 105, 225, 1),
                  ),
                ),
              ),
              Container(
                width: isWeb ? 400 : 300,
                height: 366,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                child: LoginForm(),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MyShowTextButton(label: '이메일찾기'),
                    Container(
                      height: 10,
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(
                            width: 1,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    MyShowTextButton(label: '비밀번호찾기'),
                    Container(
                      height: 10,
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(
                            width: 1,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    MyShowTextButton(label: '회원가입'),
                  ],
                ),
              ),
              Container(
                width: 400,
                height: 140,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/images/login.jpg'),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      child: Text(
                        '이용약관',
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
                                    Text('이용약관 내용'),
                                    SizedBox(height: 20,),
                                    ElevatedButton(
                                      child: Text('닫기'),
                                      onPressed: () => Navigator.pop(context),
                                    ),
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
              ),
              Text(
                'Copyright © 2023. GOSEAM. All Rights Reserved.',
                style: TextStyle(fontSize: 12),
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
  bool check = false;

  int loginKey = 1;

  switchEvent (result) {
    check = result;
  }

  loginApi() async {
    var response = await http.post(
      Uri.parse('https://goseam.com/api/login'),
      headers: <String, String> {
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
    }
  }

  @override
  void initState() {
    super.initState();
    if (window.localStorage['tkn'] != null) context.go('/list');
  }

  @override
  Widget build(BuildContext context) {
    var pageWidth = MediaQuery.of(context).size.width;
    var isWeb = pageWidth > 700 ? true : false;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (loginKey == 1)
              Container(
                width: isWeb ? 132 : 99,
                height: 50,
                child: Center(
                  child: Text('ID 로그인'),
                )
              )
            else
              InkWell(
                hoverColor: Colors.transparent,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () {
                  setState(() {
                    loginKey = 1;
                  });
                },
                child: Container(
                  width: isWeb ? 132 : 99,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(240, 240, 240, 1),
                    border: Border(
                      bottom: BorderSide(
                        width: 1,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  child: Center(
                    child: Text('ID 로그인',),
                  ),
                ),
              ),
            if (loginKey == 2)
              Container(
                width: isWeb ? 132 : 99,
                height: 50,
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      width: 1,
                      color: Colors.grey,
                    ),
                  ),
                ),
                child: Center(
                  child: Text('로그인 연동'),
                ),
              )
            else
              InkWell(
                hoverColor: Colors.transparent,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () {
                  setState(() {
                    loginKey = 2;
                  });
                },
                child: Container(
                  width: isWeb ? 132 : 99,
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
                    ),
                  ),
                  child: Center(
                    child: Text('로그인 연동'),
                  ),
                ),
              ),
            if (loginKey == 3)
              Container(
                width: isWeb ? 132 : 99,
                height: 50,
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      width: 1,
                      color: Colors.grey,
                    ),
                  ),
                ),
                child: Center(
                  child: Text('QR 로그인'),
                ),
              )
            else
              InkWell(
                hoverColor: Colors.transparent,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () {
                  setState(() {
                    loginKey = 3;
                  });
                },
                child: Container(
                  width: isWeb ? 132 : 99,
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
        if (loginKey == 1)
          Container(
            padding: EdgeInsets.only(
              left: 30,
              right: 30,
              top: 40,
            ),
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: formKey,
              child: Column(
                children: [
                  Container(
                    height: 150,
                    child: Column(
                      children: [
                        MyTextFormField(name: email, label: '이메일', validator: '이메일을 입력해 주세요.'),
                        MyTextFormField(name: password, label: '비밀번호', validator: '비밀번호를 입력해 주세요.', obscure: true),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      MySwitch(func: switchEvent),
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
                  SizedBox(height: 4),
                  MyElevatedButtonIcon(label: '로그인', function: loginApi, form: formKey),
                ],
              ),
            ),
          )
        else
          Container(
            margin: EdgeInsets.fromLTRB(0, 140, 0, 0),
            child: Center(
              child: Text(
                '작업중 입니다.',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
