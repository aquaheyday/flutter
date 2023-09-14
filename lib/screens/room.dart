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
      title: "고심: 방제목",
      home: Scaffold(
        appBar: MyAppBar(),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 700,
              child: DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.fromLTRB(0, 30, 0, 10),
                      child: Text(
                        '방제목 (스타벅스)',
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
                            text: '인원별 (10)',
                          ),
                          Tab(
                            text: '메뉴별 (1)',
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: ViewList(),
                    ),
                  ],
                ),
              ),
            ),
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
  var all = [];
  var inside = [];
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
        all = jsonDecode(response.body)['data']['all'];
        inside = jsonDecode(response.body)['data']['inside'];
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
    return TabBarView(
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
                  itemCount: 1,
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
                                  '김병준',
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
                              title: Text(
                                '(ice) M 여수 윤슬 헤이즐넛 콜드브루',
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              subtitle: Text(
                                '덜달게',
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 280,
                            child: ListTile(
                              title: Text(
                                '(ice) M 아메리카노',
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
                    itemCount: 1,
                    itemBuilder: (context, index) => Container(
                      height: 100,
                      child: Card(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: 260,
                              child: ListTile(
                                title: Text('(ice) M 아메리카노'),
                                subtitle: Text(''),
                              ),
                            ),
                            Container(
                              width: 200,
                              child: Text('2개'),
                            ),
                            Expanded(
                                child: Text('김병준')
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
    );
  }
}

