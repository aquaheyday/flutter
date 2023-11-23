import 'package:flutter/material.dart';
import 'package:flutter1/widgets/text_form_field.dart';

class FindEmailModal extends StatefulWidget {
  const FindEmailModal({super.key});

  @override
  State<FindEmailModal> createState() => _FindEmailModalState();
}

class _FindEmailModalState extends State<FindEmailModal> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  TextEditingController number = TextEditingController();

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
                  key: _formKey,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '이메일찾기',
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
                      MyTextFormField(name: number, label: '연락처', validator: '연락처를 입력해 주세요.', obscure: false),
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



