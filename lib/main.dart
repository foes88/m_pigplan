import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:m_pigplan/dashboard.dart';
import 'package:m_pigplan/page/home_page.dart';
import 'package:m_pigplan/page/login_page.dart';
import 'package:m_pigplan/api_call.dart';

import 'package:http/http.dart' as http;
import 'package:m_pigplan/page/my_page.dart';
import 'package:m_pigplan/page/qr_page.dart';
import 'package:m_pigplan/page/quick_page.dart';
import 'package:m_pigplan/widget/bottom_bar.dart';
import 'package:xml2json/xml2json.dart';
import 'dart:developer';
import 'dart:convert';

Future<void> main(List<String> args) async {

  //개발, 운영 설정파일
  await dotenv.load(
    fileName: "assets/.env"
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyApp createState() => _MyApp();
}

class _MyApp extends State<MyApp> {

  late TabController controller;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "pigplan",
      theme: ThemeData(
          // brightness: Brightness.dark,
          primaryColor: Colors.black,
          accentColor: Colors.white
      ),
      /*
      home: const DefaultTabController(
        length: 4,
        child: Scaffold(
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(), // 사용자가 직접 손가락 모션을 통해 탭을 움직이지 않도록
            children: [
              HomePage(),
              QuickPage(),
              QrPage(),
              MyPage(),
            ],
          ),
          bottomNavigationBar: BottomBar(),
        ),
      ),
      */
      home: const LoginPage(),

    );
  }
}


