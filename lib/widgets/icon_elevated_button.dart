import 'package:flutter/material.dart';

class MyElevatedButtonIcon extends StatefulWidget {
  const MyElevatedButtonIcon({
    super.key,
    required this.label,
    required this.function,
    this.form,
  });

  final String label;
  final Function function;
  final form;

  @override
  State<MyElevatedButtonIcon> createState() => _MyElevatedButtonIconState();
}

class _MyElevatedButtonIconState extends State<MyElevatedButtonIcon> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 40,
      child: ElevatedButton.icon(
        onPressed: _loading ? null : () {
          if (widget.form == null || widget.form.currentState!.validate()) {
            setState(() => _loading = true);
            widget.function().then((id) => setState(() => _loading = false));
          }
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(16.0),
          backgroundColor: Color.fromRGBO(65, 105, 225, 1),
        ),
        icon: _loading ? Container(
          width: 24,
          height: 24,
          padding: EdgeInsets.all(2.0),
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 3,
          ),
        ) : Icon(Icons.check),
        label: Text(widget.label),
      ),
    );
  }
}
