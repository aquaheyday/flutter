import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter1/modals/order.dart';
import 'package:flutter1/modals/close.dart';
import 'package:flutter1/modals/open.dart';
import 'package:flutter1/screens/app_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Room extends StatelessWidget {
  const Room({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "고심",
      home: Scaffold(
        appBar: MyAppBar(),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ViewList(),
            SizedBox(
              width: 30,
            ),
            Container(
              width: 280,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 80,
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          width: 1.0,
                          color: Colors.blueAccent,
                        )
                      ),
                    ),
                    child: Text(
                      '짐캐리',
                      /*style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),*/
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Wrap(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage('assets/dog.png'),
                                ),
                              ),
                            ),
                            Text(
                              '김병준',
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (BuildContext context) {
                      return ListOpenModal();
                    }
                );
              },
              tooltip: '오픈 하기',
              child: Icon(Icons.open_in_new),
            ),
            SizedBox(
              height: 10,
            ),
            FloatingActionButton(
              onPressed: () {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (BuildContext context) {
                      return ListCloseModal();
                    }
                );
              },
              tooltip: '종료 하기',
              child: Icon(Icons.close),
            ),
            SizedBox(
              height: 10,
            ),
            FloatingActionButton(
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
          ],
        )
      ),
    );
  }
}

class ViewList extends StatefulWidget {
  const ViewList({super.key});

  @override
  State<ViewList> createState() => _ViewListState();
}

class _ViewListState extends State<ViewList> {
  bool loading = false;
  var user = [];
  var menu = [];
  var room = [];

  String? para1 = Uri.base.queryParameters["no"];

  callAPI() async {
    print(para1);
    var response = await http.get(
      Uri.parse('http://localhost/api/order/' + para1!),
      headers: <String, String>{
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + window.localStorage['tkn'].toString(),
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        var decodeBody = utf8.decode(response.bodyBytes);
        user = jsonDecode(decodeBody)['data']['user'];
        menu = jsonDecode(decodeBody)['data']['menu'];
        room = jsonDecode(decodeBody)['data']['room'];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    callAPI();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 700,
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              margin: EdgeInsets.fromLTRB(0, 30, 0, 10),
              child: Text(
                room.length > 0 ? room[0]['title'].toString() + " (" + room[0]['room_type'] + ")" : "",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              child: TabBar(
                labelColor: Colors.black,
                tabs: [
                  Tab(
                    text: "인원별 (" + user.length.toString() + ")",
                  ),
                  Tab(
                    text: "메뉴별 (" + menu.length.toString() + ")",
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Container(
                    child: Column(
                      children: [
                        Container(
                          height: 50,
                          child: Card(
                            color: Colors.blueAccent,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 34,
                                ),
                                Text(
                                  '사용자',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  width: 170,
                                ),
                                Text(
                                  '메인 메뉴',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  width: 230,
                                ),
                                Text(
                                  '서브 메뉴',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            key: PageStorageKey("USER_LIST"),
                            itemCount: user.length,
                            itemBuilder: (context, index) => Container(
                              height: 100,
                              child: Card(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Container(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(50),
                                                image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: AssetImage('assets/dog.png'),
                                                )
                                            ),
                                          ),
                                          Text(
                                            user[index]['name'],
                                            style: TextStyle(
                                                fontSize: 12
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 30,
                                    ),
                                    Container(
                                      width: 280,
                                      child: ListTile(
                                        title: Row(
                                          children: [
                                            Text(
                                              "(" + user[index]['menu_type'].toString() + ") ",
                                              style: TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                            Text(
                                              user[index]['menu_size'].toString() + " ",
                                              style: TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                            Text(
                                              user[index]['menu'].toString(),
                                              style: TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                        subtitle: Text(
                                          (user[index]['menu_detail'] ?? '').toString(),
                                          style: TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 200,
                                      child: ListTile(
                                        title: Row(
                                          children: [
                                            Text(
                                              "(" + user[index]['sub_menu_type'].toString() + ") ",
                                              style: TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                            Text(
                                              user[index]['sub_menu_size'].toString() + " ",
                                              style: TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                            Text(
                                              user[index]['sub_menu'].toString(),
                                              style: TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                        subtitle: Text(
                                          (user[index]['sub_menu_detail'] ?? '').toString(),
                                          style: TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                      child: Column(
                        children: [
                          Container(
                            height: 50,
                            child: Card(
                              color: Colors.blueAccent,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 100,
                                  ),
                                  Text(
                                    '메뉴명',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 120,
                                  ),
                                  Text(
                                    '갯수',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 230,
                                  ),
                                  Text(
                                    '인원',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              key: PageStorageKey("MENU_LIST"),
                              itemCount: menu.length,
                              itemBuilder: (context, index) => Container(
                                height: 100,
                                child: Card(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 260,
                                        child: ListTile(
                                          title: Row(
                                            children: [
                                              Text(
                                                "(" + menu[index]['menu_type'].toString() + ") ",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                              Text(
                                                menu[index]['menu_size'].toString() + " ",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                              Text(
                                                menu[index]['menu'].toString(),
                                                style: TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                          subtitle: Text((menu[index]['menu_detail'] ?? '').toString()),
                                        ),
                                      ),
                                      Container(
                                        width: 200,
                                        child: Text(menu[index]['count'].toString()),
                                      ),
                                      Expanded(
                                          child: Text(menu[index]['name'].toString())
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

