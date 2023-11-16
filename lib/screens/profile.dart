import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter1/screens/app_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:go_router/go_router.dart';

class MyProfile extends StatelessWidget {
  const MyProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Pretendard'),
      title: "고심: 내정보",
      home: Scaffold(
        appBar: MyAppBar(),
        body: Align(
          alignment: Alignment.topCenter,
          child: Container(
            width: 600,
            child: MyInfo(),
          ),
        ),
      ),
    );
  }
}

class MyInfo extends StatefulWidget {
  const MyInfo({super.key});

  @override
  State<MyInfo> createState() => _MyInfoState();
}

class _MyInfoState extends State<MyInfo> {

  String name = "";
  String email = "";
  int total_count = 0;
  int pick_up_count = 0;

  bool check = false;
  bool check2 = false;

  _ListApi() async {
    var response = await http.get(
      Uri.parse('https://goseam.com/api/user'),
      headers: <String, String>{
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + window.localStorage['tkn'].toString(),
      },
    );

    if (response.statusCode == 200) {

      setState(() {
        var decodeBody = utf8.decode(response.bodyBytes);
        Map<String, dynamic> map = jsonDecode(decodeBody);
        name = map["data"]["name"];
        email = map["data"]["email"];
        total_count = map["data"]["total_count"];
        pick_up_count = int.parse(map["data"]["pick_up_count"]);
      });
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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 40,
        ),
        Text(
          " 기본 정보",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 6,),
        Container(
          width: double.infinity,
          height: 250,
          child: Card(
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                      child: Row(
                        children: [
                          InkWell(
                            hoverColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () {
                              print("test");
                            },
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage('assets/dog.png'),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4,),
                              Text(
                                email,
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                      child: ElevatedButton(
                        onPressed: () {
                          print("test2");
                        },
                        child: Text("프로필명 수정"),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        width: 1,
                        color: Color.fromRGBO(230, 230, 230, 1),
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.lock_outline,
                            color: Colors.grey,
                          ),
                          SizedBox(width: 10,),
                          Text('비밀번호'),
                        ],
                      ),
                      Container(
                        child: ElevatedButton(
                          onPressed: () {
                            print("test2");
                          },
                          child: Text("수정"),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        width: 1,
                        color: Color.fromRGBO(230, 230, 230, 1),
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.email_outlined,
                            color: Colors.grey,
                          ),
                          SizedBox(width: 10,),
                          Text('이메일'),
                        ],
                      ),
                      Container(
                        child: ElevatedButton(
                          onPressed: () {
                            print("test2");
                          },
                          child: Text("수정"),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        width: 1,
                        color: Color.fromRGBO(230, 230, 230, 1),
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.phone_android_outlined,
                            color: Colors.grey,
                          ),
                          SizedBox(width: 10,),
                          Text('연락처'),
                        ],
                      ),
                      Container(
                        child: ElevatedButton(
                          onPressed: () {
                            print("test2");
                          },
                          child: Text("수정"),
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
          height: 20,
        ),
        Text(
          " 정보 수신 동의",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 6,
        ),
        Container(
          width: double.infinity,
          height: 120,
          child: Card(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.email_outlined,
                            color: Colors.grey,
                          ),
                          SizedBox(width: 10,),
                          Text('이메일'),
                        ],
                      ),
                      SizedBox(
                        height: 34,
                        child: FittedBox(
                          fit: BoxFit.fill,
                          child: Switch(
                            value: check,
                            onChanged: (value) {
                              setState(() {
                                check = value;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        width: 1,
                        color: Color.fromRGBO(230, 230, 230, 1),
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.phone_android_outlined,
                            color: Colors.grey,
                          ),
                          SizedBox(width: 10,),
                          Text('연락처'),
                        ],
                      ),
                      SizedBox(
                        height: 34,
                        child: FittedBox(
                          fit: BoxFit.fill,
                          child: Switch(
                            value: check2,
                            onChanged: (value) {
                              setState(() {
                                check2 = value;
                              });
                            },
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
        SizedBox(
          height: 20,
        ),
        Text(
          " 주문횟수",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 6,
        ),
        Container(
          width: double.infinity,
          height: 100,
          child: Card(
            child: Container(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Row(
                children: [
                  Text(total_count.toString()),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          " 배달횟수",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 6,),
        Container(
          width: double.infinity,
          height: 100,
          child: Card(
            child: Container(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Row(
                children: [
                  Text(pick_up_count.toString()),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

