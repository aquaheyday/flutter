import 'package:flutter/material.dart';

class MySwitch extends StatefulWidget {
  MySwitch({
    super.key,
    required this.func,
  });

  final Function func;

  @override
  State<MySwitch> createState() => _MySwitchState();
}

class _MySwitchState extends State<MySwitch> {
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    return Switch(
      value: isChecked,
      activeColor: Color.fromRGBO(65, 105, 225, 1),
      onChanged: (value) {
        setState(() {
          isChecked = value;
          widget.func(value);
        });
      },
    );
  }
}
