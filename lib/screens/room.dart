import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter1/modals/order.dart';
import 'package:flutter1/modals/close.dart';
import 'package:flutter1/modals/open.dart';
import 'package:flutter1/screens/app_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:go_router/go_router.dart';

class Room extends StatefulWidget {
  const Room({
    super.key,
    required this.no,
  });

  final String no;

  @override
  State<Room> createState() => _RoomState();
}

class _RoomState extends State<Room> {
  bool loading = true;
  var user = [];
  var menu = [];
  var room = [];
  var end = 'N';
  var creater = 0;

  callAPI(no) async {
    if (no != '') {
      var response = await http.get(
        Uri.parse('https://goseam.com/api/order/' + no),
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
          loading = false;
          end = room[0]['end'];
          creater = room[0]['creater'];
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    if (window.localStorage['tkn'] != null) {
      callAPI(widget.no);
    } else {
      context.go('/');
    }
  }

  ReBuild() {
    setState(() {
      user = [];
      menu = [];
      room = [];
      loading = true;
      end = 'N';
      creater = 0;
    });
    callAPI(widget.no);
  }

  @override
  Widget build(BuildContext context) {
    var pageWidth = MediaQuery.of(context).size.width;
    var isWeb = pageWidth > 800 ? true : false;

    return MaterialApp(
      title: "고심",
      home: Scaffold(
        appBar: MyAppBar(),
        body: isWeb ? Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 700,
              child: DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    if (loading) Container(
                      margin: EdgeInsets.fromLTRB(0, 30, 0, 10),
                      height: 26,
                      width: 26,
                      child: CircularProgressIndicator(),
                    )
                    else Container(
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
                                          width: 56,
                                        ),
                                        Text(
                                          '사용자',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 140,
                                        ),
                                        Text(
                                          '메인 메뉴',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 250,
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
                                if (loading) Container(
                                  margin: EdgeInsets.fromLTRB(0, 30, 0, 10),
                                  child: CircularProgressIndicator(),
                                )
                                else
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
                                                    if (user[index]['pickup'] == 'Y') Text(
                                                      '(당첨) ' + user[index]['name'],
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.blue,
                                                      ),
                                                    )
                                                    else Text(
                                                      user[index]['name'],
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                      ),
                                                    )
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
                                if (loading) Container(
                                  margin: EdgeInsets.fromLTRB(0, 30, 0, 10),
                                  child: CircularProgressIndicator(),
                                )
                                else
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
                                            SizedBox(width: 6,),
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
                            ),
                          ),
                        ],
                      ),
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
                        ),
                      ),
                    ),
                    child: Text('배달원'),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  if (loading) Container(
                    margin: EdgeInsets.fromLTRB(0, 30, 0, 10),
                    child: CircularProgressIndicator(),
                  ) else
                    if (end == 'Y')
                    Align(
                      alignment: Alignment.topLeft,
                      child: Wrap(
                        children: [
                          for (int i = 0; i < user.length; i++)
                            if (user[i]['pickup'] == 'Y')
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
                                    user[i]['name'],
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
        )
        : Center(
          child: Container(
            width: 400,
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  if (loading) Container(
                    margin: EdgeInsets.fromLTRB(0, 30, 0, 10),
                    height: 26,
                    width: 26,
                    child: CircularProgressIndicator(),
                  )
                  else Container(
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
                                        width: 30,
                                      ),
                                      Text(
                                        '사용자',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 140,
                                      ),
                                      Text(
                                        '메뉴',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              if (loading) Container(
                                margin: EdgeInsets.fromLTRB(0, 30, 0, 10),
                                child: CircularProgressIndicator(),
                              )
                              else
                                Expanded(
                                  child: ListView.builder(
                                    key: PageStorageKey("USER_LIST"),
                                    itemCount: user.length,
                                    itemBuilder: (context, index) => Container(
                                      height: 120,
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
                                                  if (user[index]['pickup'] == 'Y') Text(
                                                    '(당첨) ' + user[index]['name'],
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.blue,
                                                    ),
                                                  )
                                                  else Text(
                                                    user[index]['name'],
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: 30,
                                            ),
                                            Column(
                                              children: [
                                                Container(
                                                  width: 280,
                                                  height: 50,
                                                  child: ListTile(
                                                    title: Row(
                                                      children: [
                                                        Text(
                                                          "메인 : "
                                                        ),
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
                                                  width: 280,
                                                  height: 50,
                                                  child: ListTile(
                                                    title: Row(
                                                      children: [
                                                        Text(
                                                            "서브 : "
                                                        ),
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
                                    ],
                                  ),
                                ),
                              ),
                              if (loading) Container(
                                margin: EdgeInsets.fromLTRB(0, 30, 0, 10),
                                child: CircularProgressIndicator(),
                              )
                              else
                                Expanded(
                                  child: ListView.builder(
                                    key: PageStorageKey("MENU_LIST"),
                                    itemCount: menu.length,
                                    itemBuilder: (context, index) => Container(
                                      height: 120,
                                      child: Card(
                                        child: Column(
                                          children: [
                                            Row(
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
                                                SizedBox(width: 6,),
                                                Container(
                                                  width: 100,
                                                  child: Text(menu[index]['count'].toString()),
                                                ),
                                              ],
                                            ),
                                            Text(menu[index]['name'].toString()),
                                          ],
                                        ),
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
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (loading) Container(
              margin: EdgeInsets.fromLTRB(0, 30, 0, 10),
              child: CircularProgressIndicator(),
            ) else
              if (creater == 1)
                if (end == 'Y') FloatingActionButton(
                  onPressed: () {
                    showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext context) {
                          return ListOpenModal(function: ReBuild, no: widget.no);
                        }
                    );
                  },
                  tooltip: '오픈 하기',
                  child: Icon(Icons.open_in_new),
                ) else FloatingActionButton(
                  onPressed: () {
                    showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext context) {
                          return ListCloseModal(function: ReBuild, no: widget.no);
                        }
                    );
                  },
                  tooltip: '마감 하기',
                  child: Icon(Icons.close),
                ),
            SizedBox(
              height: 10,
            ),
            if (!loading && end == 'N')
            FloatingActionButton(
              onPressed: () {
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) {
                    return OrderModal(function: ReBuild, no: widget.no);
                  }
                );
              },
              tooltip: '주문 하기',
              child: Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}

