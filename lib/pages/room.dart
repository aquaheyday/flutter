import 'package:flutter/material.dart';
import 'package:flutter1/modals/order.dart';

class Room extends StatelessWidget {
  const Room({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: Text('Goseam'),
          ),
          body: Row(
            children: [
              Text('test'),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) {
                    return OrderModal();
                  }
              );
            },
            tooltip: '주문 하기',
            child: Icon(Icons.add),
          ),
        )
    );
  }
}
