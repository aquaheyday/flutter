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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 500,
              child: DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    Container(
                      child: TabBar(
                        labelColor: Colors.black,
                        tabs: [
                          Tab(
                            text: '인원별',
                          ),
                          Tab(
                            text: '메뉴별',
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          Container(
                            child: ListView.builder(
                              key: PageStorageKey("USER_LIST"),
                              itemCount: 10,
                              itemBuilder: (context, index) => Container(
                                height: 100,
                                child: Card(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: 200,
                                          child: ListTile(
                                            title: Text('ice'),
                                            subtitle: Text('test'),
                                          ),
                                        ),
                                      ],
                                    )
                                ),
                              ),
                            ),
                          ),
                          Container(
                            child: ListView.builder(
                              key: PageStorageKey("MENU_LIST"),
                              itemCount: 10,
                              itemBuilder: (context, index) => Container(
                                height: 100,
                                child: Card(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: 200,
                                          child: ListTile(
                                            title: Text('ice'),
                                            subtitle: Text('test'),
                                          ),
                                        ),
                                      ],
                                    )
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: 300,
              child: Text('test'),
            ),
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
      ),
    );
  }
}
