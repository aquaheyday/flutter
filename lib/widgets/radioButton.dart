import 'package:flutter/material.dart';

class RadioButtonWidget extends StatefulWidget {
  const RadioButtonWidget({
    super.key,
    required this.name,
    required this.width,
    required this.list
  });

  final name;
  final double width;
  final List<String> list;

  @override
  State<RadioButtonWidget> createState() => _RadioButtonWidgetState();
}

class _RadioButtonWidgetState extends State<RadioButtonWidget> {
  late String name = widget.list.first;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var item in widget.list) SizedBox(
          width: widget.width,
          child: ListTile(
            title: Text(item),
            leading: Radio(
              value: item,
              groupValue: name,
              onChanged: (value) {
                setState(() {
                  name = value.toString();
                });
              }
            ),
          ),
        ),
      ],
    );
  }
}
