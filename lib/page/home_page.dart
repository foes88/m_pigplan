import 'package:flutter/material.dart';
import 'dart:developer';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:m_pigplan/home/daily_report.dart';
import 'package:m_pigplan/home/grade_graph.dart';
import 'package:m_pigplan/home/iot_page.dart';
import 'package:m_pigplan/home/pig_info.dart';

import 'package:m_pigplan/page/my_page.dart';
import 'package:m_pigplan/page/qr_page.dart';
import 'package:m_pigplan/page/quick_page.dart';
import 'package:m_pigplan/widget/bottom_bar.dart';

import 'package:m_pigplan/home/daily_report.dart';
import 'package:m_pigplan/home/grade_graph.dart';
import 'package:m_pigplan/home/iot_page.dart';
import 'package:m_pigplan/home/pig_info.dart';
import 'package:m_pigplan/home/quick_menu.dart';

import 'login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => DefaultTabController(
      length: 5,
      child: Scaffold(
      appBar: AppBar(
        title: const Text('PigPlan'),
        centerTitle: true,
        bottom: const TabBar(
          tabs: [
            Tab(text: "일보"),
            Tab(text: "IOT"),
            Tab(text: "성적그래프"),
            Tab(text: "양돈정보"),
            Tab(text: "퀵메뉴"),
          ],
        ),
      ),
        body: const TabBarView(
          children: [
            DailyReport(),
            IotPage(),
            GradeGraph(),
            PigInfo(),
            QuickMenu(),
          ],
        ),

  ),

    );





}