import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter1/modals/add.dart';
import 'package:flutter1/widgets/text_form_field.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter1/screens/app_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';

class MyList extends StatelessWidget {
  const MyList({super.key});

  @override
  Widget build(BuildContext context) {
    var pageWidth = MediaQuery.of(context).size.width;
    var isWeb = pageWidth > 700 ? true : false;

    return MaterialApp(
      title: "고심: 목록",
      theme: ThemeData(
        fontFamily: 'Pretendard',
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromRGBO(65, 105, 225, 1),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: MyAppBar(),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: isWeb ? 500 : 300,
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
                    child: MyMainList(),
                  ),
                ],
              ),
            ),
            if (isWeb) SizedBox(width: 20),
            if (isWeb) Container(
              width: 240,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 82),
                  Container(
                    width: 240,
                    padding: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          width: 1,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    child: Text('배달원 당첨율'),
                  ),
                  Container(
                    width: 240,
                    height: 320,
                    child: MyPieChart(),
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
                      ),
                    ),
                    child: Text('Top 10'),
                  ),
                  Container(
                    width: 300,
                    height: 300,
                    child: MyTopList(),
                  ),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color.fromRGBO(65, 105, 225, 1),
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

class MyMainList extends StatefulWidget {
  const MyMainList({super.key});

  @override
  State<MyMainList> createState() => MyMainListState();
}

class MyMainListState extends State<MyMainList> {
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

  _RoomInApi(token) async {
    var response = await http.get(
      Uri.parse('https://goseam.com/api/room/' + token),
      headers: <String, String>{
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + window.localStorage['tkn'].toString(),
      },
    );

    if (response.statusCode == 200) {
      context.go('/room/' + token);
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
              indicatorColor: Color.fromRGBO(65, 105, 225, 1),
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
                if (loading) Center( child: CircularProgressIndicator(color: Color.fromRGBO(65, 105, 225, 1),),),
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
                                  width: isWeb ? 350 : 170,
                                  child: ListTile(
                                    title: Text((all[index]['end_yn'] == 'Y' ? '(마감) ' : '') + all[index]['title']),
                                    subtitle: Text(all[index]['name']),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 50,
                                      child: IconButton(
                                        tooltip: "입장",
                                        color: Color.fromRGBO(65, 105, 225, 1),
                                        padding: EdgeInsets.zero,
                                        constraints: BoxConstraints(),
                                        onPressed: () {
                                          if (all[index]['create_yn'] == 'Y' || all[index]['inside_yn'] == 'Y') {
                                            _RoomInApi(all[index]['token']);
                                          } else {
                                            showDialog(
                                                barrierDismissible: false,
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return InButton(token: all[index]['token']);
                                                }
                                            );
                                          }
                                        },
                                        icon: Icon(Icons.sensor_door_outlined, size: 18),
                                      ),
                                    ),
                                    if (all[index]['create_yn'] == 'Y') Container(
                                      width: 50,
                                      child: IconButton(
                                        tooltip: "삭제",
                                        color: Colors.redAccent,
                                        onPressed: () {
                                          showDialog(
                                              barrierDismissible: false,
                                              context: context,
                                              builder: (BuildContext context) {
                                                return DeleteButton(token: all[index]['token'], function: ReBuild);
                                              }
                                          );
                                        },
                                        icon: Icon(Icons.delete, size: 18),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                  ],
                                ),
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
                                    width: isWeb ? 350 : 170,
                                    child: ListTile(
                                      title: Text((all[index]['end_yn'] == 'Y' ? '(마감) ' : '') + all[index]['title']),
                                      subtitle: Text(all[index]['name']),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 50,
                                        child: IconButton(
                                          tooltip: "입장",
                                          color: Colors.blue,
                                          padding: EdgeInsets.zero,
                                          constraints: BoxConstraints(),
                                          onPressed: () {
                                            if (all[index]['create_yn'] == 'Y' || all[index]['inside_yn'] == 'Y') {
                                              _RoomInApi(all[index]['token']);
                                            } else {
                                              showDialog(
                                                  barrierDismissible: false,
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return InButton(token: all[index]['token']);
                                                  }
                                              );
                                            }
                                          },
                                          icon: Icon(Icons.sensor_door_outlined, size: 18),
                                        ),
                                      ),
                                      if (all[index]['create_yn'] == 'Y') Container(
                                        width: 50,
                                        child: IconButton(
                                          tooltip: "삭제",
                                          color: Colors.redAccent,
                                          onPressed: () {
                                            showDialog(
                                                barrierDismissible: false,
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return DeleteButton(token: all[index]['token'], function: ReBuild);
                                                }
                                            );
                                          },
                                          icon: Icon(Icons.delete, size: 18),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                    ],
                                  ),
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
                                  width: isWeb ? 350 : 170,
                                  child: ListTile(
                                    title: Text((all[index]['end_yn'] == 'Y' ? '(마감) ' : '') + all[index]['title']),
                                    subtitle: Text(all[index]['name']),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 50,
                                      child: IconButton(
                                        tooltip: "입장",
                                        color: Colors.blue,
                                        padding: EdgeInsets.zero,
                                        constraints: BoxConstraints(),
                                        onPressed: () {
                                          if (all[index]['create_yn'] == 'Y' || all[index]['inside_yn'] == 'Y') {
                                            _RoomInApi(all[index]['token']);
                                          } else {
                                            showDialog(
                                                barrierDismissible: false,
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return InButton(token: all[index]['token']);
                                                }
                                            );
                                          }
                                        },
                                        icon: Icon(Icons.sensor_door_outlined, size: 18),
                                      ),
                                    ),
                                    if (all[index]['create_yn'] == 'Y') Container(
                                      width: 50,
                                      child: IconButton(
                                        tooltip: "삭제",
                                        color: Colors.redAccent,
                                        onPressed: () {
                                          showDialog(
                                              barrierDismissible: false,
                                              context: context,
                                              builder: (BuildContext context) {
                                                return DeleteButton(token: all[index]['token'], function: ReBuild);
                                              }
                                          );
                                        },
                                        icon: Icon(Icons.delete, size: 18),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                  ],
                                ),
                              ],
                            )
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DeleteButton extends StatefulWidget {
  const DeleteButton({
    super.key,
    required this.token,
    required this.function,
  });

  final String token;
  final Function function;

  @override
  State<DeleteButton> createState() => _DeleteButtonState();
}

class _DeleteButtonState extends State<DeleteButton> {
  bool _isLoading = false;

  RoomDeleteApi(BuildContext context, token) async {
    await http.delete(
      Uri.parse('https://goseam.com/api/room/' + token),
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
                    RoomDeleteApi(context, widget.token);
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
    required this.token,
  });

  final String token;

  @override
  State<InButton> createState() => _InButtonState();
}

class _InButtonState extends State<InButton> {
  bool _isLoading = false;

  final formKey = GlobalKey<FormState>();
  TextEditingController password = TextEditingController();

  callAPI(token) async {
    var response = await http.get(
      Uri.parse('https://goseam.com/api/room/' + token),
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
        context.go('/room/' + token);
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
          height: 220,
          child: Column(
            children: [
              SizedBox(
                height: 150,
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
                      MyTextFormField(name: password, label: '비밀번호', validator: '비밀번호를 입력해 주세요.', obscure: true),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 40,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : () {
                    if (formKey.currentState!.validate()) {
                      setState(() => _isLoading = true);
                      callAPI(widget.token);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16.0),
                    backgroundColor: Color.fromRGBO(65, 105, 225, 1),
                  ),
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

class MyPieChart extends StatefulWidget {
  const MyPieChart({super.key});

  @override
  State<StatefulWidget> createState() => MyPieChartState();
}

class MyPieChartState extends State {
  int touchedIndex = 0;

  bool loading = true;

  double userRate = 0;
  double totalRate = 0;
  int allCount = 0;
  int pickUpCount = 0;

  _aApi() async {
    var response = await http.get(
      Uri.parse('https://goseam.com/api/room/chart'),
      headers: <String, String>{
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + window.localStorage['tkn'].toString(),
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        var decodeBody = utf8.decode(response.bodyBytes);
        Map<String, dynamic> map = jsonDecode(decodeBody);
        userRate = map['data']['userRate'];
        totalRate = map['data']['totalRate'];
        allCount = map['data']['allCount'];
        pickUpCount = map['data']['pickUpCount'];
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _aApi();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Container(
            child: TabBar(
              indicatorColor: Color.fromRGBO(65, 105, 225, 1),
              labelColor: Colors.black,
              tabs: [
                Tab(
                  text: '내정보',
                ),
                Tab(
                  text: '전체',
                ),
              ],
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                TabBarView(
                  children: [
                    AspectRatio(
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
                            sections: List.generate(2, (i) {
                              final isTouched = i == touchedIndex;
                              final fontSize = isTouched ? 20.0 : 16.0;
                              final radius = isTouched ? 110.0 : 100.0;
                              final widgetSize = isTouched ? 55.0 : 40.0;
                              const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

                              switch (i) {
                                case 0:
                                  return PieChartSectionData(
                                    color: Colors.blue,
                                    value: userRate,
                                    title: userRate.toString() + '%',
                                    radius: radius,
                                    titleStyle: TextStyle(
                                      fontSize: fontSize,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xffffffff),
                                      shadows: shadows,
                                    ),
                                    badgeWidget: _Badge(
                                      'assets/dog.png',
                                      size: widgetSize,
                                      borderColor: Colors.black,
                                    ),
                                    badgePositionPercentageOffset: .98,
                                  );
                                case 1:
                                  return PieChartSectionData(
                                    color: Colors.grey,
                                    value: (100 - userRate),
                                    title: (100 - userRate).toString() + '%',
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
                            }),
                          ),
                        ),
                      ),
                    ),
                    AspectRatio(
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
                            sections: List.generate(2, (i) {
                              final isTouched = i == touchedIndex;
                              final fontSize = isTouched ? 20.0 : 16.0;
                              final radius = isTouched ? 110.0 : 100.0;
                              final widgetSize = isTouched ? 55.0 : 40.0;
                              const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

                              switch (i) {
                                case 0:
                                  return PieChartSectionData(
                                    color: Colors.blue,
                                    value: totalRate,
                                    title: totalRate.toString() + '%',
                                    radius: radius,
                                    titleStyle: TextStyle(
                                      fontSize: fontSize,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xffffffff),
                                      shadows: shadows,
                                    ),
                                    badgeWidget: _Badge(
                                      'assets/dog.png',
                                      size: widgetSize,
                                      borderColor: Colors.black,
                                    ),
                                    badgePositionPercentageOffset: .98,
                                  );
                                case 1:
                                  return PieChartSectionData(
                                    color: Colors.grey,
                                    value: 100 - totalRate,
                                    title: (100 - totalRate).toString() + '%',
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
                            }),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
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
        child: Text(
          '당첨',
          style: TextStyle(
              fontSize: 12
          ),
        ),
      ),
    );
  }
}

class MyTopList extends StatefulWidget {
  const MyTopList({super.key});

  @override
  State<MyTopList> createState() => _MyTopListState();
}

class _MyTopListState extends State<MyTopList> {
  int touchedIndex = 0;

  bool loading = true;

  var menu = [];
  var email = [];

  _ListApi() async {
    var response = await http.get(
      Uri.parse('https://goseam.com/api/room/top'),
      headers: <String, String>{
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + window.localStorage['tkn'].toString(),
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        var decodeBody = utf8.decode(response.bodyBytes);
        Map<String, dynamic> map = jsonDecode(decodeBody);
        menu = map['data']['menu'];
        email = map['data']['email'];
        loading = false;
      });
    } else if (response.statusCode == 500) {
      window.localStorage.remove('tkn');
      context.go('/');
    }
  }

  @override
  void initState() {
    super.initState();
    _ListApi();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Container(
            child: TabBar(
              indicatorColor: Color.fromRGBO(65, 105, 225, 1),
              labelColor: Colors.black,
              tabs: [
                Tab(
                  text: '배달원',
                ),
                Tab(
                  text: '메뉴',
                ),
              ],
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                if (loading) Center( child: CircularProgressIndicator(color: Color.fromRGBO(65, 105, 225, 1),),),
                TabBarView(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 6),
                        Expanded(
                          child: ListView.builder(
                            itemCount: email.length,
                            itemBuilder: (context, index) => Container(
                              height: 30,
                              alignment: Alignment.centerLeft,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text((index + 1).toString() + '. ' + email[index]['name']),
                                  Text(email[index]['cnt'].toString() + '회'),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 6),
                        Expanded(
                          child: ListView.builder(
                            itemCount: menu.length,
                            itemBuilder: (context, index) => Container(
                              height: 30,
                              alignment: Alignment.centerLeft,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text((index + 1).toString() + '. ' + menu[index]['menu']),
                                  Text(menu[index]['cnt'].toString() + '번'),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}