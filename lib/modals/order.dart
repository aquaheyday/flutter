import 'package:flutter/material.dart';
import 'package:flutter1/widgets/drop_down_menu.dart';
import 'package:flutter1/widgets/gesture_button.dart';
import 'package:flutter1/widgets/icon_elevated_button.dart';
import 'package:flutter1/widgets/text_form_field.dart';

class OrderModal extends StatefulWidget {
  const OrderModal({super.key});

  @override
  State<OrderModal> createState() => _OrderModalState();
}

class _OrderModalState extends State<OrderModal> with SingleTickerProviderStateMixin {
  List<String> list = ['아메리카노', '라떼'];
  List<String> size = ['S', 'M', 'L', 'XL'];
  List<String> type = ['ice', 'hot'];

  final formKey = GlobalKey<FormState>();

  TextEditingController menu = TextEditingController();
  TextEditingController aa = TextEditingController();
  TextEditingController menu2 = TextEditingController();
  TextEditingController aa2 = TextEditingController();
  late String sizeType = size.first;
  late String menuType = type.first;

  late final _tabController = TabController(length: 2, vsync: this);

  callAPI() async {
    print(type);
  }

  test(a) {
    sizeType = a;
    print(sizeType);
  }

  test2(a) {
    menuType = a;
    print(menuType);
  }

  @override
  Widget build(BuildContext context) {
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
                          MyGestureButton(width: 150, list: type, function: test2),
                          SizedBox(height: 20),
                          MyGestureButton(width: 60, list: size, function: test),
                          SizedBox(height: 20),
                          MyDropDownMenu(name: menu, list: list),
                          SizedBox(height: 20),
                          MyTextFormField(name: aa, label: '비고', validator: '', obscure: false),
                          SizedBox(height: 50),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton.icon(
                              onPressed: () => _tabController.index = 1,
                              style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16.0)),
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
                          MyGestureButton(width: 150, list: type, function: test2),
                          SizedBox(height: 20),
                          MyGestureButton(width: 60, list: size, function: test),
                          SizedBox(height: 20),
                          MyDropDownMenu(name: menu2, list: list),
                          SizedBox(height: 20),
                          MyTextFormField(name: aa2, label: '비고', validator: '', obscure: false),
                          SizedBox(height: 50),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: MyIconElevatedButton(text: '주문하기', function: callAPI),
                          )
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

