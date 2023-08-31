import 'package:flutter/material.dart';

class TextFormFieldWidget extends StatefulWidget {
  const TextFormFieldWidget({
    super.key,
    required this.name,
    required this.label,
    required this.validator,
    required this.obscure,
  });

  final TextEditingController name;
  final String label;
  final String validator;
  final bool obscure;

  @override
  State<TextFormFieldWidget> createState() => _TextFormFieldWidgetState();
}

class _TextFormFieldWidgetState extends State<TextFormFieldWidget> {
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.name,
      obscureText: widget.obscure,
      style: TextStyle(
          fontSize: 14
      ),
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: widget.label,
        errorStyle: TextStyle(
          fontSize: 12,
          height: 0.3,
        ),
      ),
      validator: (value) {
        if (!widget.validator.isEmpty && (value == null || value.isEmpty)) {
          return widget.validator;
        }
        return null;
      },
    );
  }
}
