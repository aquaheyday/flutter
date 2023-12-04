import 'package:flutter/material.dart';
import 'package:flutter1/widgets/text_form_field.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class FindPasswordModal extends StatefulWidget {
  const FindPasswordModal({super.key});

  @override
  State<FindPasswordModal> createState() => _FindPasswordModalState();
}

class _FindPasswordModalState extends State<FindPasswordModal> {
  bool _isLoading = false;
  bool _passwordCheck = false;
  String password = "";
  final _formKey = GlobalKey<FormState>();

  TextEditingController email = TextEditingController();

  _test() async {
    var response = await http.post(
      Uri.parse('https://goseam.com/api/password'),
      headers: <String, String> {
        'Content-Type': 'application/json'
      },
      body: jsonEncode({
        'email': email.text,
      }),
    );

    if (response.statusCode == 200) {
      var decodeBody = utf8.decode(response.bodyBytes);

      Map<String, dynamic> map = jsonDecode(decodeBody);

      if (map['success']) {
        _passwordCheck = true;
        password = map['data']['password'] ?? '조회된 이메일이 없습니다.';
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
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: SizedBox(
          width: 310,
          height: 220,
          child: Column(
            children: [
              SizedBox(
                height: 160,
                child: Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  key: _formKey,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '비밀번호찾기',
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
                      if (_passwordCheck) Container(
                        margin: EdgeInsets.only(top: 18),
                        child: Text(password),
                      )
                      else MyTextFormField(name: email, label: '이메일', validator: '이메일을 입력해 주세요.', obscure: false),
                    ],
                  ),
                ),
              ),
              if (_passwordCheck) SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() => _passwordCheck = false);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(16.0),
                      backgroundColor: Color.fromRGBO(65, 105, 225, 1),
                    ),
                    child: Text('재조회하기'),
                  )
              )
              else
              SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : () {
                      if (_formKey.currentState!.validate()) {
                        setState(() => _isLoading = true);
                        _test();
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
                    label: Text('조회하기'),
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
}



