import 'package:flutter/material.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:flutter1/router.dart';

void main() {
  setPathUrlStrategy();
  runApp(const MyApp());
}

router _router = router();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
        routerConfig: _router.MyRouter,
    );
  }
}
