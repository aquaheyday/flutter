import 'package:flutter/material.dart';
import 'package:flutter1/widgets/dropDwon.dart';
import 'package:flutter1/widgets/radioButton.dart';
import 'package:flutter1/widgets/submit.dart';

class OrderModal extends StatefulWidget {
  const OrderModal({super.key});

  @override
  State<OrderModal> createState() => _OrderModalState();
}

class _OrderModalState extends State<OrderModal> {
  List<String> list = ['1', '2'];

  final formKey = GlobalKey<FormState>();

  TextEditingController menu = TextEditingController();
  var type;

  callAPI() async {
    print(type);
  }
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        margin: const EdgeInsets.fromLTRB(40, 20, 40, 0),
        child: SizedBox(
            width: 320,
            height: 320,
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: formKey,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('주문'),
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.close),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  RadioButtonWidget(name: type,width: 150, list: ['ice', 'hot']),
                  //RadioButtonWidget(width: 100, list: ['s', 'm', 'l']),
                  SizedBox(height: 20),
                  DropdownMenuWidget(name: menu, list: list),
                  SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: SubmitWidget(text: '생성하기', function: callAPI),
                  ),
                ],
              ),
            )
        ),
      ),
    );
  }
}
