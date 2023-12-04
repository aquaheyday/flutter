import 'package:flutter1/screens//room.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter1/screens/login.dart';
import 'package:flutter1/screens/list.dart';
import 'package:flutter1/screens/profile.dart';

class router {
  final GoRouter MyRouter = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => Login(),
        ),
        GoRoute(
          path: '/list',
          builder: (context, state) => MyList(),
        ),
        GoRoute(
          path: '/room/:token',
          builder: (context, state) => Room(token: state.pathParameters['token'].toString()),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => MyProfile(),
        ),
      ]
  );
}