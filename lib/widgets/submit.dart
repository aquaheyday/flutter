import 'package:flutter/material.dart';

class SubmitWidget extends StatefulWidget {
  const SubmitWidget({
    super.key,
    required this.text,
    required this.function,
  });

  final String text;
  final Function function;

  @override
  State<SubmitWidget> createState() => _SubmitWidgetState();
}

class _SubmitWidgetState extends State<SubmitWidget> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: _isLoading ? null : () {
        setState(() => _isLoading = true);
        widget.function().then((bool) {
          if (!bool) setState(() => _isLoading = false);
        });
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
      label: Text(widget.text),
    );

  }
}
