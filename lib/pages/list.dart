import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter1/modals/add.dart';
import 'package:flutter1/modals/password.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class List extends StatelessWidget {
  const List({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Goseam",
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        //backgroundColor: Colors.grey,
        appBar: AppBar(
          title: Text('Goseam'),
        ),
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
  bool loading = false;
  var data = [];

  callAPI() async {
    var response = await http.get(
      Uri.parse('http://localhost/api/reception'),
      headers: <String, String>{
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + window.localStorage['tkn'].toString(),
      },
    );

    if (response.statusCode == 200) {
     // return response.body;
    }
    setState(() => data = jsonDecode(response.body)['data']);
  }

  @override
  void initState() {
    super.initState();
    callAPI();
  }
  @override
  Widget build(BuildContext context) {
    print(data);
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
            child: TabBarView(
              children: [
                Container(
                  //color: Colors.orange,
                  child: ListView.builder(
                    key: PageStorageKey("LIST_VIEW"),
                    itemCount: data.length,
                    itemBuilder: (context, index) => Container(
                      height: 100,
                      child: Card(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 200,
                                child: ListTile(
                                  title: Text('전체 목록 ' + index.toString()),
                                  subtitle: Text('작성자'),
                                ),
                              ),
                              Container(
                                  width: 200,
                                  child: TextButton(
                                    onPressed: () {
                                      showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (BuildContext context) {
                                            return ListPasswordModal();
                                          }
                                      );
                                    },
                                    child: Text('입장 하기'),
                                  )
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
                    key: PageStorageKey("bb_VIEW"),
                    itemCount: 20,
                    itemBuilder: (context, index) => Container(
                      height: 100,
                      child: Card(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 200,
                                child: ListTile(
                                  title: Text('입장 목록 ' + index.toString()),
                                  subtitle: Text('작성자'),
                                ),
                              ),
                              Container(
                                  width: 200,
                                  child: TextButton(
                                    onPressed: () {

                                    },
                                    child: Text('입장 하기'),
                                  )
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
                    key: PageStorageKey("aa_VIEW"),
                    itemCount: 20,
                    itemBuilder: (context, index) => Container(
                      height: 100,
                      child: Card(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 200,
                                child: ListTile(
                                  title: Text('생성 목록 ' + index.toString()),
                                  subtitle: Text('작성자'),
                                ),
                              ),
                              Container(
                                  width: 200,
                                  child: TextButton(
                                    onPressed: () {

                                    },
                                    child: Text('입장 하기'),
                                  )
                              )
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
    );
  }
}



