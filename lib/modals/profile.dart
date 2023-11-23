import 'package:flutter/material.dart';
import 'package:flutter1/widgets/text_form_field.dart';
import 'dart:html';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfileModal extends StatefulWidget {
  const ProfileModal({
    super.key,
    required this.type,
    required this.function,
  });

  final String type;
  final Function function;

  @override
  State<ProfileModal> createState() => _ProfileModalState();
}

class _ProfileModalState extends State<ProfileModal> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  TextEditingController profile = TextEditingController();
  TextEditingController c_password = TextEditingController();

  callAPI() async {
    var response = await http.put(
      Uri.parse('https://goseam.com/api/user/' + widget.type),
      headers: <String, String>{
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + window.localStorage['tkn'].toString(),
      },
      body: jsonEncode({
        widget.type: profile.text,
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
        widget.function(profile);
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
    String key = "프로필명";

    if (widget.type == "password") {
      key = "비밀번호";
    } else if (widget.type == "email") {
      key = "이메일";
    } else if (widget.type == "number") {
      key = "연락처";
    }
    return AlertDialog(
      content: Container(
        margin: const EdgeInsets.fromLTRB(40, 20, 40, 0),
        child: SizedBox(
          width: 320,
          height: widget.type == "password" ? 270 : 220,
          child: Column(
            children: [
              SizedBox(
                height: widget.type == "password" ? 210 : 150,
                child: Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  key: _formKey,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            key,
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
                      MyTextFormField(name: profile, label: key, validator: key + '을 입력해 주세요.', obscure: widget.type == 'password' ? true : false),
                      if (widget.type == "password") SizedBox(height: 10,),
                      if (widget.type == "password") MyTextFormField(name: c_password, label: '비밀번호 확인', validator: '비밀번호 확인을 입력해 주세요.', obscure: true),
                    ],
                  ),
                ),
              ),
              SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : () {
                      if (_formKey.currentState!.validate()) {
                        setState(() => _isLoading = true);
                        callAPI();
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
                    label: Text('수정하기'),
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
}



