import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter1/modals/add.dart';
import 'package:flutter1/modals/password.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter1/screens/app_bar.dart';

class List extends StatelessWidget {
  const List({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "고심: 목록",
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        //backgroundColor: Colors.grey,
        appBar: MyAppBar(),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 800,
              margin: EdgeInsets.fromLTRB(0, 40, 0, 0),
              child: Column(
                children: [
                  Container(
                    height: 50,
                    child: Row(
                      children: [
                        Icon(
                          Icons.search,
                          color: Colors.black12,
                        ),
                        SizedBox(
                          width: 200,
                          child: TextField(
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: tab(),
                  ),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context) {
                  return ListAddModal();
                }
            );
          },
          tooltip: '생성 하기',
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}

class tab extends StatefulWidget {
  const tab({super.key});

  @override
  State<tab> createState() => _tabState();
}

class _tabState extends State<tab> {
  bool loading = true;
  var all = [];
  var inside = [];
  var create = [];

  callAPI() async {
    var response = await http.get(
      Uri.parse('http://localhost/api/room'),
      headers: <String, String>{
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + window.localStorage['tkn'].toString(),
      },
    );

    if (response.statusCode == 200) {

      setState(() {
        all = jsonDecode(response.body)['data']['all'];
        inside = jsonDecode(response.body)['data']['inside'];
        create = jsonDecode(response.body)['data']['create'];
        loading = false;
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
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
            child: TabBar(
              //indicatorColor: Colors.yellow,
              labelColor: Colors.black,
              tabs: [
                Tab(
                  text: '전체 목록',
                ),
                Tab(
                  text: '입장 목록',
                ),
                Tab(
                  text: '생성 목록',
                ),
              ],
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                if (loading) Center( child: CircularProgressIndicator(),),
                TabBarView(
                  children: [
                    Container(
                      //color: Colors.orange,
                      child: ListView.builder(
                        key: PageStorageKey("ALL_LIST"),
                        itemCount: all.length,
                        itemBuilder: (context, index) => Container(
                          height: 100,
                          child: Card(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 200,
                                  child: ListTile(
                                    title: Text(all[index]['title']),
                                    subtitle: Text(all[index]['user']['name']),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 100,
                                      height: 40,
                                      child: TextButton(
                                        onPressed: () {
                                          showDialog(
                                            barrierDismissible: false,
                                            context: context,
                                            builder: (BuildContext context) {
                                              return ListPasswordModal(id: all[index]['id'], type: 'in');
                                            }
                                          );
                                        },
                                        child: Text('입장'),
                                      ),
                                    ),
                                    if (all[index]['creater'] == 1) aa(context, all[index]['id']),
                                    SizedBox(
                                      width: 20,
                                    ),
                                  ],
                                )
                              ],
                            )
                          ),
                        ),
                      ),
                    ),
                    Container(
                      //color: Colors.orange,
                      child: ListView.builder(
                        key: PageStorageKey("INSIDE_LIST"),
                        itemCount: inside.length,
                        itemBuilder: (context, index) => Container(
                          height: 100,
                          child: Card(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 200,
                                    child: ListTile(
                                      title: Text(inside[index]['room'] != null ? inside[index]['room']['title'] : ''),
                                      subtitle: Text(inside[index]['room'] != null ? inside[index]['room']['user']['name'] : ''),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 100,
                                        height: 40,
                                        child: TextButton(
                                          onPressed: () {
                                            showDialog(
                                                barrierDismissible: false,
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return ListPasswordModal(id: inside[index]['id'], type: 'in');
                                                }
                                            );
                                          },
                                          child: Text('입장'),
                                        ),
                                      ),
                                      if (all[index]['creater'] == 1) aa(context, inside[index]['id']),
                                      SizedBox(
                                        width: 20,
                                      ),
                                    ],
                                  )
                                ],
                              )
                          ),
                        ),
                      ),
                    ),
                    Container(
                      //color: Colors.orange,
                      child: ListView.builder(
                        key: PageStorageKey("ALL_LIST"),
                        itemCount: create.length,
                        itemBuilder: (context, index) => Container(
                          height: 100,
                          child: Card(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 200,
                                  child: ListTile(
                                    title: Text(create[index]['title']),
                                    subtitle: Text(create[index]['user']['name']),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 100,
                                      height: 40,
                                      child: TextButton(
                                        onPressed: () {
                                          showDialog(
                                              barrierDismissible: false,
                                              context: context,
                                              builder: (BuildContext context) {
                                                return ListPasswordModal(id: create[index]['id'], type: 'in');
                                              }
                                          );
                                        },
                                        child: Text('입장'),
                                      ),
                                    ),
                                    Container(
                                      width: 100,
                                      height: 40,
                                      child: TextButton(
                                        onPressed: () {
                                          showDialog(
                                              barrierDismissible: false,
                                              context: context,
                                              builder: (BuildContext context) {
                                                return ListPasswordModal(id: create[index]['id'], type: 'out');
                                              }
                                          );
                                        },
                                        child: Text(
                                          '삭제',
                                          style: TextStyle(
                                              color: Colors.redAccent
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                  ],
                                )
                              ],
                            )
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )
          ),
        ],
      ),
    );
  }
}

aa(BuildContext context, id){
  return Container(
    width: 100,
    height: 40,
    child: TextButton(
      onPressed: () {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return ListPasswordModal(id: id, type: 'out');
            }
        );
      },
      child: Text(
        '삭제',
        style: TextStyle(
            color: Colors.redAccent
        ),
      ),
    ),
  );
}


