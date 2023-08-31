import 'package:go_router/go_router.dart';
import 'package:flutter1/pages/home.dart';
import 'package:flutter1/pages/list.dart';

class router {
  final GoRouter MyRouter = GoRouter(
      routes: [
        GoRoute(
            path: '/',
            builder: (context, state) => Home(),
        ),
        GoRoute(
          path: '/list',
          builder: (context, state) => List(),
        ),
      ]
  );
}