import 'dart:html';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget{
  const MyAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color.fromRGBO(65, 105, 225, 1),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text('Goseam'),
          SizedBox(width: 50,),
          TextButton(
            onPressed: () => context.go('/list'),
            child: Text(
              '목록',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    context.go('/profile');
                  },
                  child: Text(
                    "내정보",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    window.localStorage.remove('tkn');
                    context.go('/');
                  },
                  child: Text(
                    "로그아웃",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            )
          ),
        ],
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}