import 'package:flutter1/screens//room.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter1/screens/home.dart';
import 'package:flutter1/screens/list.dart';

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
        GoRoute(
          path: '/room/:no',
          builder: (context, state) => Room( no: state.pathParameters['no'].toString()),
        ),
      ]
  );
}