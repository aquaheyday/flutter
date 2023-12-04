import 'package:flutter/material.dart';
import 'package:flutter1/modals/register.dart';
import 'package:flutter1/modals/find_email.dart';
import 'package:flutter1/modals/find_password.dart';

class MyShowTextButton extends StatefulWidget {
  const MyShowTextButton({
    super.key,
    required this.label,
  });

  final label;

  @override
  State<MyShowTextButton> createState() => _MyShowTextButtonState();
}

class _MyShowTextButtonState extends State<MyShowTextButton> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              if (widget.label == '회원가입') {
                return RegisterWidget();
              } else if (widget.label == '이메일찾기') {
                return FindEmailModal();
              } else {
                return FindPasswordModal();
              }
            }
        );
      },
      child: Text(
        widget.label,
        style: TextStyle(
          fontSize: 12,
          color: Colors.black,
        ),
      ),
    );
  }
}
