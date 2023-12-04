import 'package:flutter/material.dart';
import 'package:flutter1/widgets/text_form_field.dart';
import 'package:flutter1/widgets/icon_elevated_button.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class FindModal extends StatefulWidget {
  const FindModal({
    super.key,
    required this.label,
  });

  final String label;

  @override
  State<FindModal> createState() => _FindModalState();
}

class _FindModalState extends State<FindModal> {
  bool _emailCheck = false;
  String email = "조회된 이메일이 없습니다.";

  final formKey = GlobalKey<FormState>();

  TextEditingController number = TextEditingController();

  callApi() async {
    var response = await http.post(
      Uri.parse('https://goseam.com/api/eamil'),
      headers: <String, String> {
        'Content-Type': 'application/json'
      },
      body: jsonEncode({
        'number': number.text,
      }),
    );

    if (response.statusCode == 200) {
      var decodeBody = utf8.decode(response.bodyBytes);

      Map<String, dynamic> map = jsonDecode(decodeBody);

      if (map['success']) {
        _emailCheck = true;
        email = map['data']['email'] ?? '조회된 이메일이 없습니다.';
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
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        margin: const EdgeInsets.fromLTRB(40, 20, 40, 0),
        child: SizedBox(
          width: 320,
          height: 210,
          child: Column(
            children: [
              SizedBox(
                height: 150,
                child: Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  key: formKey,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '이메일 찾기',
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
                      if (_emailCheck) Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Text(email),
                      )
                      else MyTextFormField(name: number, label: '연락처', validator: '연락처를 입력해 주세요.'),
                    ],
                  ),
                ),
              ),
              if (_emailCheck) SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {
                        setState(() => _emailCheck = false);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16.0),
                      backgroundColor: Color.fromRGBO(65, 105, 225, 1),
                    ),
                    child: Text('재조회하기'),
                  )
              )
              else
              MyElevatedButtonIcon(label: "조회하기", function: callApi, form: formKey),
            ],
          ),
        ),
      ),
    );
  }
}



