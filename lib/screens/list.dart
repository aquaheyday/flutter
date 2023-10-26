import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter1/modals/add.dart';
import 'package:flutter1/widgets/text_form_field.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter1/screens/app_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyList extends StatelessWidget {
  const MyList({super.key});

  @override
  Widget build(BuildContext context) {
    var pageWidth = MediaQuery.of(context).size.width;
    var isWeb = pageWidth > 700 ? true : false;

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
              width: isWeb ? 700 : 400,
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
            SizedBox(width: 20,),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 60,
                ),
                Container(
                  width: 300,
                  padding: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 1,
                        color: Colors.grey,

                      ),
                      /*right: BorderSide(
                                width: 1,
                                color: Colors.grey,
                              ),*/
                    ),
                    //borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5),bottomRight: Radius.circular(5)),
                  ),
                  child: Text('배달원 당첨율'),
                ),
                Container(
                  width: 300,
                  height: 300,
                  child: PieChartSample3(),
                )
              ],
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
      Uri.parse('https://goseam.com/api/room'),
      headers: <String, String>{
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + window.localStorage['tkn'].toString(),
      },
    );

    if (response.statusCode == 200) {

      setState(() {
        var decodeBody = utf8.decode(response.bodyBytes);
        Map<String, dynamic> map = jsonDecode(decodeBody);
        all = map['data']['all'];
        inside = map['data']['inside'];
        create = map['data']['create'];
        loading = false;
      });
    }
  }

  _RoomInApi(id) async {
    var response = await http.get(
      Uri.parse('http://goseam.com/api/room/' + id.toString()),
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
    var pageWidth = MediaQuery.of(context).size.width;
    var isWeb = pageWidth > 700 ? true : false;

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
                                  width: isWeb ? 200 : 170,
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
                                    width: isWeb ? 200 : 170,
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
                                  width: isWeb ? 200 : 170,
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
      Uri.parse('http://goseam.com/api/room/' + id.toString()),
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
      Uri.parse('http://goseam.com/api/room/' + no.toString()),
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

class PieChartSample3 extends StatefulWidget {
  const PieChartSample3({super.key});

  @override
  State<StatefulWidget> createState() => PieChartSample3State();
}

class PieChartSample3State extends State {
  int touchedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: AspectRatio(
        aspectRatio: 1,
        child: PieChart(
          PieChartData(
            pieTouchData: PieTouchData(
              touchCallback: (FlTouchEvent event, pieTouchResponse) {
                setState(() {
                  if (!event.isInterestedForInteractions ||
                      pieTouchResponse == null ||
                      pieTouchResponse.touchedSection == null) {
                    touchedIndex = -1;
                    return;
                  }
                  touchedIndex =
                      pieTouchResponse.touchedSection!.touchedSectionIndex;
                });
              },
            ),
            borderData: FlBorderData(
              show: false,
            ),
            sectionsSpace: 0,
            centerSpaceRadius: 0,
            sections: showingSections(),
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(2, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 20.0 : 16.0;
      final radius = isTouched ? 110.0 : 100.0;
      final widgetSize = isTouched ? 55.0 : 40.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Colors.blue,
            value: 1,
            title: '10%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
              shadows: shadows,
            ),
            badgeWidget: _Badge(
              'assets/icons/ophthalmology-svgrepo-com.svg',
              size: widgetSize,
              borderColor: Colors.black,
            ),
            badgePositionPercentageOffset: .98,
          );
        case 1:
          return PieChartSectionData(
            color: Colors.grey,
            value: 9,
            title: '90%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
              shadows: shadows,
            ),
            badgePositionPercentageOffset: .98,
          );
        default:
          throw Exception('Oh no');
      }
    });
  }
}

class _Badge extends StatelessWidget {
  const _Badge(
      this.svgAsset, {
        required this.size,
        required this.borderColor,
      });
  final String svgAsset;
  final double size;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: PieChart.defaultDuration,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(.5),
            offset: const Offset(3, 3),
            blurRadius: 3,
          ),
        ],
      ),
      padding: EdgeInsets.all(size * .15),
      child: Center(
        child: SvgPicture.asset(
          svgAsset,
        ),
      ),
    );
  }
}