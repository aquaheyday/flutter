import 'dart:html';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter1/widgets/icon_elevated_button.dart';


class ListOpenModal extends StatefulWidget {
  const ListOpenModal({
    super.key,
    required this.function,
    required this.token,
  });

  final Function function;
  final String token;

  @override
  State<ListOpenModal> createState() => _ListOpenModalState();
}

class _ListOpenModalState extends State<ListOpenModal> {

  final formKey = GlobalKey<FormState>();

  callAPI() async {
    var response = await http.put(
      Uri.parse('https://goseam.com/api/room/' + widget.token.toString() + '/open'),
      headers: <String, String>{
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + window.localStorage['tkn'].toString(),
      },
    );

    if (response.statusCode == 200) {
      Navigator.pop(context);
      widget.function();
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
                            '오픈',
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
              MyElevatedButtonIcon(label: '오픈하기', function: callAPI),
            ],
          ),
        ),
      ),
    );
  }
}
