import 'package:flutter/material.dart';

class MyGestureButton extends StatefulWidget {
  const MyGestureButton({
    super.key,
    required this.width,
    required this.list,
    required this.function,
  });

  final double width;
  final List<String> list;
  final Function function;

  @override
  State<MyGestureButton> createState() => _MyGestureButtonState();
}

class _MyGestureButtonState extends State<MyGestureButton> with AutomaticKeepAliveClientMixin<MyGestureButton> {
  late String _target = widget.list.first;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (var item in widget.list) MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => setState(() {
              _target = item;
              widget.function(item);
            }),
            child: Container(
              width: widget.width,
              height: 40,
              decoration: BoxDecoration(
                color: _target == item ? Color.fromRGBO(65, 105, 225, 1) : null,
                border: Border.all(
                  color: Colors.grey,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Center(
                child: Text(
                  item,
                  style: TextStyle(
                    color: _target == item ? Colors.white : null,
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
