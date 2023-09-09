import 'package:flutter/material.dart';

class MyRadio extends StatefulWidget {
  const MyRadio({
    super.key,
    required this.name,
    required this.width,
    required this.list
  });

  final name;
  final double width;
  final List<String> list;

  @override
  State<MyRadio> createState() => _MyRadioState();
}

class _MyRadioState extends State<MyRadio> {
  late String name = widget.list.first;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
