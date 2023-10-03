import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter1/modals/add.dart';
import 'package:flutter1/widgets/text_form_field.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter1/screens/app_bar.dart';
import 'package:go_router/go_router.dart';

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
                  /*Container(
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
                  ),*/
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
  State<tab> createState() => tabState();
}

class tabState extends State<tab> {
  bool loading = true;

  var all = [];
  var inside = [];
  var create = [];

  get no => null;

  _ListApi() async {
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

  _RoomInApi(id) async {
    var response = await http.get(
      Uri.parse('http://localhost/api/room/' + id.toString()),
      headers: <String, String>{
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + window.localStorage['tkn'].toString(),
      },
    );

    if (response.statusCode == 200) {
      context.go('/room/' + id.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    if (window.localStorage['tkn'] != null) {
      _ListApi();
    } else {
      context.go('/');
    }
  }

  ReBuild() {
    setState(() {
      all = [];
      inside = [];
      create = [];
      loading = true;
    });
    _ListApi();
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
                                    title: Text((all[index]['end'] == 'Y' ? '(마감) ' : '') + all[index]['title']),
                                    subtitle: Text(all[index]['name']),
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
                                          if (all[index]['creater'] == 1 || all[index]['insider'] == 1) {
                                            _RoomInApi(all[index]['id']);
                                          } else {
                                            showDialog(
                                                barrierDismissible: false,
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return InButton(no: all[index]['id']);
                                                }
                                            );
                                          }
                                        },
                                        child: Text('입장'),
                                      ),
                                    ),
                                    if (all[index]['creater'] == 1) Container(
                                      width: 100,
                                      height: 40,
                                      child: TextButton(
                                        onPressed: () {
                                          showDialog(
                                              barrierDismissible: false,
                                              context: context,
                                              builder: (BuildContext context) {
                                                return DeleteButton(id: all[index]['id'], function: ReBuild);
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
                    Container(
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
                                      title: Text((inside[index]['end'] == 'Y' ? '(마감) ' : '') + inside[index]['title']),
                                      subtitle: Text(inside[index]['name']),
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
                                            _RoomInApi(inside[index]['id']);
                                          },
                                          child: Text('입장'),
                                        ),
                                      ),
                                      if (inside[index]['creater'] == 1) Container(
                                        width: 100,
                                        height: 40,
                                        child: TextButton(
                                          onPressed: () {
                                            showDialog(
                                                barrierDismissible: false,
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return DeleteButton(id: inside[index]['id'], function: ReBuild);
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
                    Container(
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
                                    title: Text((create[index]['end'] == 'Y' ? '(마감) ' : '') + create[index]['title']),
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
                                          _RoomInApi(create[index]['id']);
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
                                                return DeleteButton(id: create[index]['id'], function: ReBuild);
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

class DeleteButton extends StatefulWidget {
  const DeleteButton({
    super.key,
    required this.id,
    required this.function,
  });

  final int id;
  final Function function;

  @override
  State<DeleteButton> createState() => _DeleteButtonState();
}

class _DeleteButtonState extends State<DeleteButton> {
  bool _isLoading = false;

  RoomDeleteApi(BuildContext context, id) async {
    await http.delete(
      Uri.parse('http://localhost/api/room/' + id.toString()),
      headers: <String, String>{
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + window.localStorage['tkn'].toString(),
      },
    );
    setState(() {
      _isLoading = false;
    });
    Navigator.pop(context);
    widget.function();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        margin: const EdgeInsets.fromLTRB(40, 20, 40, 0),
        child: SizedBox(
          width: 320,
          height: 140,
          child: Column(
            children: [
              SizedBox(
                height: 80,
                child: Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '삭제',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(),
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(Icons.close),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 40,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : () {
                    setState(() => _isLoading = true);
                    RoomDeleteApi(context, widget.id);
                  },
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16.0)),
                  icon: _isLoading ? Container(
                    width: 24,
                    height: 24,
                    padding: EdgeInsets.all(2.0),
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                  ) : Icon(Icons.check),
                  label: Text('삭제하기'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InButton extends StatefulWidget {
  const InButton({
    super.key,
    required this.no,
  });

  final int no;

  @override
  State<InButton> createState() => _InButtonState();
}

class _InButtonState extends State<InButton> {
  bool _isLoading = false;

  final formKey = GlobalKey<FormState>();
  TextEditingController password = TextEditingController();

  callAPI(no) async {
    var response = await http.get(
      Uri.parse('http://localhost/api/room/' + no.toString()),
      headers: <String, String>{
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + window.localStorage['tkn'].toString(),
        'password': password.text,
      },
    );

    if (response.statusCode == 200) {
      var decodeBody = utf8.decode(response.bodyBytes);
      Map<String, dynamic> map = jsonDecode(decodeBody);
      if (map['success']) {
        context.go('/room/' + no.toString());
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Text(map['message']),
              );
            }
        );
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        margin: const EdgeInsets.fromLTRB(40, 20, 40, 0),
        child: SizedBox(
          width: 320,
          height: 200,
          child: Column(
            children: [
              SizedBox(
                height: 130,
                child: Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  key: formKey,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '입장',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(),
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(Icons.close),
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      MyTextFormField(name: password, label: '비밀번호', validator: 'Please enter password', obscure: true),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 40,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : () {
                    setState(() => _isLoading = true);
                    callAPI(widget.no);
                  },
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16.0)),
                  icon: _isLoading ? Container(
                    width: 24,
                    height: 24,
                    padding: EdgeInsets.all(2.0),
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                  ) : Icon(Icons.check),
                  label: Text('입장하기'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



