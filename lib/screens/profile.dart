import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter1/screens/app_bar.dart';

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
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 40,
        ),
        Text(
          "기본정보",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          width: double.infinity,
          height: 100,
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
                                "닉네임aaa",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "bjkim@enliple.com",
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
                        child: Text("수정"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          "주문횟수",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          width: double.infinity,
          height: 100,
          child: Card(
            child: Container(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Row(
                children: [
                  Text("123")
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          "배달횟수",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          width: double.infinity,
          height: 100,
          child: Card(
            child: Container(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Row(
                children: [
                  Text("12")
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

