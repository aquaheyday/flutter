import 'dart:html';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:go_router/go_router.dart';
import 'package:flutter1/widgets/text_form_field.dart';
import 'package:flutter1/widgets/drop_down_menu.dart';
import 'package:flutter1/widgets/icon_elevated_button.dart';


class ListAddModal extends StatefulWidget {
  const ListAddModal({super.key});

  @override
  State<ListAddModal> createState() => _ListAddModalState();
}

class _ListAddModalState extends State<ListAddModal> {
  bool _isLoading = false;
  final formKey = GlobalKey<FormState>();

  TextEditingController type = TextEditingController();
  TextEditingController title = TextEditingController();
  TextEditingController password = TextEditingController();
  List<String> list = ['스타벅스', '더카페', '커피쿡'];

  callAPI() async {
    var response = await http.post(
      Uri.parse('https://goseam.com/api/room'),
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
      var decodeBody = utf8.decode(response.bodyBytes);
      Map<String, dynamic> map = jsonDecode(decodeBody);

      setState(() {
        _isLoading = false;
      });

      if (map['success']) {
        Navigator.pop(context);
        context.go('/room/' + jsonDecode(response.body)['data']['token'].toString());
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
    var pageWidth = MediaQuery.of(context).size.width;
    var isWeb = pageWidth > 700 ? true : false;

    return AlertDialog(
      content: Container(
        margin: const EdgeInsets.fromLTRB(40, 20, 40, 0),
        child: SizedBox(
          width: isWeb ? 320 : 200,
          height: 380,
          child: Column(
            children: [
              SizedBox(
                height: 300,
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
                      MyTextFormField(name: title, label: '제목', validator: '제목을 입력해 주세요.', obscure: false),
                      MyTextFormField(name: password, label: '비밀번호', validator: '비밀번호를 입력해 주세요.', obscure: true),
                    ],
                  ),
                ),
              ),
              MyElevatedButtonIcon(label: '생성하기', function: callAPI, form: formKey),
            ],
          ),
        ),
      ),
    );
  }
}
