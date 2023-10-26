import 'package:flutter/material.dart';
import 'package:flutter1/widgets/text_form_field.dart';

class FindPasswordModal extends StatefulWidget {
  const FindPasswordModal({super.key});

  @override
  State<FindPasswordModal> createState() => _FindPasswordModalState();
}

class _FindPasswordModalState extends State<FindPasswordModal> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  TextEditingController email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        margin: const EdgeInsets.fromLTRB(40, 20, 40, 0),
        child: SizedBox(
          width: 320,
          height: 250,
          child: Column(
            children: [
              SizedBox(
                height: 180,
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
                      SizedBox(height: 30),
                      MyTextFormField(name: email, label: '이메일', validator: '이메일을 입력해 주세요.', obscure: false),
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



