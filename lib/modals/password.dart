import 'dart:html';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter1/widgets/icon_elevated_button.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter1/widgets/text_form_field.dart';


class ListPasswordModal extends StatefulWidget {
  const ListPasswordModal({
    super.key,
    required this.id,
    required this.type,
  });

  final int id;
  final String type;

  @override
  State<ListPasswordModal> createState() => _ListPasswordModalState();
}

class _ListPasswordModalState extends State<ListPasswordModal> {

  final formKey = GlobalKey<FormState>();

  TextEditingController password = TextEditingController();

  callAPI() async {
    if (widget.type == 'in') {
      var response = await http.get(
        Uri.parse('https://goseam.com/api/room/' + widget.id.toString()),
        headers: <String, String>{
          'Accept': 'application/json',
          'Authorization': 'Bearer ' + window.localStorage['tkn'].toString(),
        },
      );

      if (response.statusCode == 200) {
        context.go('/room?no=' + widget.id.toString());
      }
    } else {
      var response = await http.delete(
        Uri.parse('https://goseam.com/api/room/' + widget.id.toString()),
        headers: <String, String>{
          'Accept': 'application/json',
          'Authorization': 'Bearer ' + window.localStorage['tkn'].toString(),
        },
      );

      if (response.statusCode == 200) {
        setState(() {

        });
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
          height: widget.type == 'in' ? 200 : 140,
          child: Column(
            children: [
              SizedBox(
                height: widget.type == 'in' ? 130 : 80,
                child: Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  key: formKey,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.type == 'in' ? '입장' : '삭제',
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
                      if (widget.type == 'in') SizedBox(height: 30),
                      if (widget.type == 'in') MyTextFormField(name: password, label: '비밀번호', validator: 'Please enter password', obscure: true),
                    ],
                  ),
                ),
              ),
              MyElevatedButtonIcon(label: widget.type == 'in' ? '입장 하기' : '삭제 하기', function: callAPI),
            ],
          ),
        ),
      ),
    );
  }
}
