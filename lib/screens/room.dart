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
    required this.token,
  });

  final String token;

  @override
  State<Room> createState() => _RoomState();
}

class _RoomState extends State<Room> {
  bool loading = true;
  var user = [];
  var menu = [];
  var room = [];
  var end_yn = 'N';
  var create_yn = 'N';

  callAPI(token) async {
    if (token != '') {
      var response = await http.get(
        Uri.parse('https://goseam.com/api/order/' + token),
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
          end_yn = room[0]['end_yn'];
          create_yn = room[0]['create_yn'];
        });
      } else if (response.statusCode == 500) {
        window.localStorage.remove('tkn');
        context.go('/');
      }
    }
  }

  deleteApi(id) async {
    if (id != '') {
      var response = await http.delete(
        Uri.parse('https://goseam.com/api/order/' + id),
        headers: <String, String>{
          'Accept': 'application/json',
          'Authorization': 'Bearer ' + window.localStorage['tkn'].toString(),
        },
      );

      if (response.statusCode == 200) {
        ReBuild();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    if (window.localStorage['tkn'] != null) {
      callAPI(widget.token);
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
      end_yn = 'N';
      create_yn = 'N';
    });
    callAPI(widget.token);
  }

  @override
  Widget build(BuildContext context) {
    //var pageWidth = MediaQuery.of(context).size.width;
    //var isWeb = pageWidth > 800 ? true : false;

    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Pretendard',
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromRGBO(65, 105, 225, 1),
        ),
      ),
      title: "고심" + (room.length > 0 ? ": " + room[0]['title'].toString() : ""),
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
                    if (loading) Container(
                      margin: EdgeInsets.fromLTRB(0, 30, 0, 10),
                      height: 26,
                      width: 26,
                      child: CircularProgressIndicator(),
                    )
                    else Container(
                      margin: EdgeInsets.fromLTRB(0, 30, 0, 10),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              room.length > 0 ? room[0]['title'].toString() : "",
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 4),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              room.length > 0 ? room[0]['type'] : "",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                    Container(
                      child: TabBar(
                        indicatorColor: Color.fromRGBO(65, 105, 225, 1),
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
                    SizedBox(height: 20),
                    Expanded(
                      child: TabBarView(
                        children: [
                          Container(
                            child: Column(
                              children: [
                                Container(
                                  height: 50,
                                  child: Card(
                                    color: Color.fromRGBO(65, 105, 225, 1),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        SizedBox(width: 46),
                                        Text(
                                          '사용자',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(width: 110),
                                        Text(
                                          '메인 메뉴',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(width: 230),
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
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              SizedBox(width: 10),
                                              Container(
                                                width: 100,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      width: 50,
                                                      height: 50,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(50),
                                                        border: Border.all(
                                                          color: Colors.grey,
                                                          width: 1,
                                                        ),
                                                        image: DecorationImage(
                                                          fit: BoxFit.cover,
                                                          image: NetworkImage('https://goseam.com' + user[index]['image_path'].toString()),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(height: 4),
                                                    if (user[index]['pick_up_yn'] == 'Y') Text(
                                                      user[index]['name'],
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: Color.fromRGBO(65, 105, 225, 1),
                                                      ),
                                                    )
                                                    else Text(
                                                      user[index]['name'],
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              SizedBox(width: 30),
                                              Container(
                                                width: 250,
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
                                              SizedBox(width: 30),
                                              Container(
                                                width: 196,
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
                                              if (end_yn == 'N' && user[index]['create_yn'] == "Y") Container(
                                                width: 40,
                                                height: 40,
                                                margin: EdgeInsets.only(left: 10, right: 10),
                                                child: IconButton(
                                                  padding: EdgeInsets.zero,
                                                  constraints: BoxConstraints(),
                                                  onPressed: () { deleteApi(user[index]['id'].toString()); },
                                                  tooltip: '삭제',
                                                  icon: Icon(
                                                    Icons.close,
                                                    color: Colors.redAccent,
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
                                    color: Color.fromRGBO(65, 105, 225, 1),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        SizedBox(width: 100),
                                        Text(
                                          '메뉴명',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(width: 134),
                                        Text(
                                          '갯수',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(width: 200),
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
                                            children: [
                                              SizedBox(width: 10),
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
                                              SizedBox(width: 6),
                                              Container(
                                                width: 120,
                                                child: Text(menu[index]['count'].toString()),
                                              ),
                                              Container(
                                                width: 260,
                                                child: Text(menu[index]['name'].toString()),
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
            SizedBox(width: 30),
            Container(
              width: 280,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 140,
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          width: 1,
                          color: Colors.grey,
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
                    if (end_yn == 'Y')
                      Align(
                        alignment: Alignment.topLeft,
                        child: Wrap(
                          children: [
                            for (int i = 0; i < user.length; i++)
                              if (user[i]['pick_up_yn'] == 'Y')
                                Container(
                                  margin: EdgeInsets.fromLTRB(0, 4, 10, 0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(50),
                                          border: Border.all(
                                            color: Colors.grey,
                                            width: 1,
                                          ),
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage('https://goseam.com' + user[i]['image_path'].toString()),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        user[i]['name'],
                                        style: TextStyle(
                                          fontSize: 14,
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
          ],
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (loading) Container(
              margin: EdgeInsets.fromLTRB(0, 30, 0, 10),
              child: CircularProgressIndicator(),
            ) else
              if (create_yn == 'Y')
                if (end_yn == 'Y') FloatingActionButton(
                  backgroundColor: Color.fromRGBO(65, 105, 225, 1),
                  onPressed: () {
                    showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext context) {
                          return ListOpenModal(function: ReBuild, token: widget.token);
                        }
                    );
                  },
                  tooltip: '오픈 하기',
                  child: Icon(Icons.open_in_new),
                ) else FloatingActionButton(
                  backgroundColor: Color.fromRGBO(65, 105, 225, 1),
                  onPressed: () {
                    showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext context) {
                          return ListCloseModal(function: ReBuild, token: widget.token);
                        }
                    );
                  },
                  tooltip: '마감 하기',
                  child: Icon(Icons.close),
                ),
            SizedBox(
              height: 10,
            ),
            if (!loading && end_yn == 'N')
            FloatingActionButton(
              backgroundColor: Color.fromRGBO(65, 105, 225, 1),
              onPressed: () {
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) {
                    return OrderModal(function: ReBuild, token: widget.token);
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

