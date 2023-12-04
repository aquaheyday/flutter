import 'dart:html';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter1/widgets/drop_down_menu.dart';
import 'package:flutter1/widgets/gesture_button.dart';
import 'package:flutter1/widgets/icon_elevated_button.dart';
import 'package:flutter1/widgets/text_form_field.dart';

class OrderModal extends StatefulWidget {
  const OrderModal({
    super.key,
    required this.function,
    required this.token,
  });

  final Function function;
  final String token;

  @override
  State<OrderModal> createState() => _OrderModalState();
}

class _OrderModalState extends State<OrderModal> with SingleTickerProviderStateMixin {
  List<String> list = ['아메리카노', '라떼'];
  List<String> size = ['S', 'M', 'L', 'XL'];
  List<String> type = ['ice', 'hot'];

  final formKey = GlobalKey<FormState>();

  TextEditingController menu = TextEditingController();
  late String menu_type = type.first;
  late String menu_size = size.first;
  TextEditingController menu_detail = TextEditingController();
  TextEditingController sub_menu = TextEditingController();
  late String sub_menu_type = type.first;
  late String sub_menu_size = size.first;
  TextEditingController sub_menu_detail = TextEditingController();

  late final _tabController = TabController(length: 2, vsync: this);

  callAPI() async {
    var response = await http.post(
      Uri.parse('https://goseam.com/api/order/' + widget.token),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + window.localStorage['tkn'].toString(),
      },
      body: jsonEncode({
        'menu': menu.text,
        'menu_type': menu_type,
        'menu_size': menu_size,
        'menu_detail': menu_detail.text,
        'sub_menu': sub_menu.text,
        'sub_menu_type': sub_menu_type,
        'sub_menu_size': sub_menu_size,
        'sub_menu_detail': sub_menu_detail.text,
      }),
    );

    if (response.statusCode == 200) {
      var decodeBody = utf8.decode(response.bodyBytes);
      Map<String, dynamic> map = jsonDecode(decodeBody);
      if (map['success']) {
        Navigator.pop(context);
        widget.function();
      } else {
        Navigator.pop(context);
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Text(map['message']),
              );
            }
        );
        widget.function();
      }
    }
  }

  menuType(value) {
    menu_type = value;
  }

  menuSize(value) {
    menu_size = value;
  }

  subMenuType(value) {
    sub_menu_type = value;
  }

  subMenuSize(value) {
    sub_menu_size = value;
  }


  @override
  Widget build(BuildContext context) {
    var pageWidth = MediaQuery.of(context).size.width;
    var isWeb = pageWidth > 800 ? true : false;
    return AlertDialog(
      content: Container(
        margin: const EdgeInsets.fromLTRB(40, 20, 40, 0),
        child: SizedBox(
          width: 320,
          height: 460,
          child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 460,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('메인 주문'),
                              IconButton(
                                padding: EdgeInsets.zero,
                                constraints: BoxConstraints(),
                                onPressed: () => Navigator.pop(context),
                                icon: Icon(Icons.close),
                              ),
                            ],
                          ),
                          SizedBox(height: 50),
                          MyGestureButton(width: isWeb ? 150 : 120, list: type, function: menuType),
                          SizedBox(height: 20),
                          MyGestureButton(width: 60, list: size, function: menuSize),
                          SizedBox(height: 20),
                          MyDropDownMenu(name: menu, list: list),
                          SizedBox(height: 20),
                          MyTextFormField(name: menu_detail, label: '비고', validator: '', obscure: false),
                          SizedBox(height: 50),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton.icon(
                              onPressed: () => _tabController.index = 1,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(16.0),
                                backgroundColor: Color.fromRGBO(65, 105, 225, 1),
                              ),
                              icon: Icon(Icons.arrow_circle_right_rounded ),
                              label: Text('다음으로'),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: BoxConstraints(),
                                    onPressed: () => _tabController.index = 0,
                                    icon: Icon(Icons.arrow_back),
                                  ),
                                  SizedBox(width: 20,),
                                  Text('서브 주문'),
                                ],
                              ),
                              IconButton(
                                padding: EdgeInsets.zero,
                                constraints: BoxConstraints(),
                                onPressed: () => Navigator.pop(context),
                                icon: Icon(Icons.close),
                              ),
                            ],
                          ),
                          SizedBox(height: 50),
                          MyGestureButton(width: 150, list: type, function: subMenuType),
                          SizedBox(height: 20),
                          MyGestureButton(width: 60, list: size, function: subMenuSize),
                          SizedBox(height: 20),
                          MyDropDownMenu(name: sub_menu, list: list),
                          SizedBox(height: 20),
                          MyTextFormField(name: sub_menu_detail, label: '비고', validator: '', obscure: false),
                          SizedBox(height: 50),
                          MyElevatedButtonIcon(label: '주문하기', function: callAPI),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

