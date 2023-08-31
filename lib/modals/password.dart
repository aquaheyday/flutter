import 'dart:html';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter1/widgets/submit.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter1/widgets/textFormField.dart';


class ListPasswordModal extends StatefulWidget {
  const ListPasswordModal({super.key});

  @override
  State<ListPasswordModal> createState() => _ListPasswordModalState();
}

class _ListPasswordModalState extends State<ListPasswordModal> {

  final formKey = GlobalKey<FormState>();

  TextEditingController password = TextEditingController();

  Future<bool> _CallRegister() async {
    bool success = false;

    if (formKey.currentState!.validate()) {
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
          height: 200,
          child: Column(
            children: [
              SizedBox(
                height: 130,
                child: Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  key: formKey,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '입장',
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
                      TextFormFieldWidget(name: password, label: '비밀번호', validator: 'Please enter password', obscure: true),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 40,
                child: SubmitWidget(text: '입장 하기', function: _CallRegister),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
