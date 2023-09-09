import 'package:flutter/material.dart';

class MyDropDownMenu extends StatefulWidget {
  const MyDropDownMenu({
    super.key,
    required this.name,
    required this.list
  });

  final TextEditingController name;
  final List<String> list;

  @override
  State<MyDropDownMenu> createState() => _MyDropDownMenuState();
}

class _MyDropDownMenuState extends State<MyDropDownMenu> {
  @override
  Widget build(BuildContext context) {
    return DropdownMenu(
      controller: widget.name,
      width: 320,
      menuHeight: 200,
      initialSelection: widget.list.first,

      onSelected: (String? value) {
        // This is called when the user selects an item.
        /*setState(() {
          //widget.list.first = value!;
        });*/
      },
      dropdownMenuEntries: widget.list.map<DropdownMenuEntry<String>>((String value) {
        return DropdownMenuEntry<String>(value: value, label: value);
      }).toList(),
    );
  }
}
