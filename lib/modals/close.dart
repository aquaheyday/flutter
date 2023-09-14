import 'dart:html';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter1/widgets/icon_elevated_button.dart';


class ListCloseModal extends StatefulWidget {
  const ListCloseModal({super.key});

  @override
  State<ListCloseModal> createState() => _ListCloseModalState();
}

class _ListCloseModalState extends State<ListCloseModal> {

  final formKey = GlobalKey<FormState>();

  callAPI() async {
    var response = await http.post(
      Uri.parse('http://localhost/api/reception'),
      headers: <String, String>{
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + window.localStorage['tkn'].toString(),
      },
      body: jsonEncode({

      }),
    );

    if (response.statusCode == 200) {

    }

  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        margin: const EdgeInsets.fromLTRB(40, 20, 40, 0),
        child: SizedBox(
          width: 320,
          height: 120,
          child: Column(
            children: [
              SizedBox(
                height: 50,
                child: Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  key: formKey,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '종료',
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
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: MyIconElevatedButton(text: '종료하기', function: callAPI),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
