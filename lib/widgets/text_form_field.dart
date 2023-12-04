import 'package:flutter/material.dart';

class MyTextFormField extends StatefulWidget {
  const MyTextFormField({
    super.key,
    required this.name,
    required this.label,
    required this.validator,
    this.obscure,
  });

  final TextEditingController name;
  final String label;
  final String validator;
  final obscure;

  @override
  State<MyTextFormField> createState() => _MyTextFormFieldState();
}

class _MyTextFormFieldState extends State<MyTextFormField> {
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: TextFormField(
        controller: widget.name,
        obscureText: widget.obscure ?? false,
        style: TextStyle(
            fontSize: 14
        ),
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: widget.label,
          errorStyle: TextStyle(
            fontSize: 12,
            height: 0.6,
          ),
        ),
        validator: (value) {
          if (!widget.validator.isEmpty && (value == null || value.isEmpty)) {
            return widget.validator;
          }
          return null;
        },
      ),
    );
  }
}
