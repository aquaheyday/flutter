import 'package:flutter/material.dart';

//const List<String> list = <String>['One', 'Two', 'Three', 'Four', 'One', 'Two', 'Three', 'Four'];

class DropdownMenuWidget extends StatefulWidget {
  const DropdownMenuWidget({
    super.key,
    required this.name,
    required this.list
  });

  final TextEditingController name;
  final List<String> list;

  @override
  State<DropdownMenuWidget> createState() => _DropdownMenuWidgetState();
}

class _DropdownMenuWidgetState extends State<DropdownMenuWidget> {
  @override
  Widget build(BuildContext context) {
    return DropdownMenu(
      controller: widget.name,
      width: 320,
      menuHeight: 200,
      initialSelection: widget.list.first,

      onSelected: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          //widget.list.first = value!;
        });
      },
      dropdownMenuEntries: widget.list.map<DropdownMenuEntry<String>>((String value) {
        return DropdownMenuEntry<String>(value: value, label: value);
      }).toList(),
    );
  }
}
