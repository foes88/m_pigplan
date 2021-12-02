import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:developer';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:m_pigplan/common/modon_history.dart';
import 'package:m_pigplan/common/util.dart';
import 'package:m_pigplan/home/daily_report.dart';
import 'package:m_pigplan/home/grade_graph.dart';
import 'package:m_pigplan/home/iot_page.dart';
import 'package:m_pigplan/home/pig_info.dart';
import 'package:m_pigplan/home/quick_menu.dart';

import 'package:m_pigplan/model/combolist_model.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:client_cookie/client_cookie.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:m_pigplan/model/modon_history/bunman_record_model.dart';
import 'package:m_pigplan/model/modon_history/eyu_record_model.dart';
import 'package:m_pigplan/model/modon_history/location_record_model.dart';
import 'package:m_pigplan/model/modon_history/poyu_record_model.dart';
import 'package:m_pigplan/model/modon_history/sancha_record_model.dart';
import 'package:m_pigplan/model/modon_history/vaccien_record_model.dart';
import 'package:m_pigplan/model/pregnancy_accident_record_model.dart';
import 'package:m_pigplan/record/modon_history_page/bunman_page.dart';
import 'package:m_pigplan/record/modon_history_page/eyu_page.dart';
import 'package:m_pigplan/record/modon_history_page/location_page.dart';
import 'package:m_pigplan/record/modon_history_page/poyu_page.dart';
import 'package:m_pigplan/record/modon_history_page/sancha_page.dart';
import 'package:m_pigplan/record/modon_history_page/vaccien_page.dart';

class PregnancyAccidentRecordRegit extends StatefulWidget {
  final int farmNo;
  final int pigNo;
  final String farmPigNo;
  final String sancha;
  final String igakNo;
  final String sagoGubunNm;

  const PregnancyAccidentRecordRegit({
    Key? key,
    required this.farmNo,
    required this.pigNo,
    required this.farmPigNo,
    required this.sancha,
    required this.igakNo,
    required this.sagoGubunNm,
  }) : super(key: key);

  @override
  _PregnancyAccidentRecordRegit createState() => _PregnancyAccidentRecordRegit(
      farmNo, pigNo, farmPigNo, sancha, igakNo, sagoGubunNm);
}

class _PregnancyAccidentRecordRegit
    extends State<PregnancyAccidentRecordRegit> with TickerProviderStateMixin {
  final int farmNo;
  final int pigNo;
  final String farmPigNo;
  final String sancha;
  final String igakNo;
  final String sagoGubunNm;

  _PregnancyAccidentRecordRegit(this.farmNo, this.pigNo, this.farmPigNo,
      this.sancha, this.igakNo, this.sagoGubunNm
      );

  late List<ComboListModel> sagolists = List<ComboListModel>.empty(growable: true);
  late List<ComboListModel> locationlists = List<ComboListModel>.empty(growable: true);

  late List<PregnancyAccidentRecordModel> lists = [];


  // 모돈 기록리스트 각 항목별
  late List<SanchaRecordModel> sanchaLists = List<SanchaRecordModel>.empty(growable: true);
  late List<BunmanRecordModel> bunmanLists =  List<BunmanRecordModel>.empty(growable: true);
  late List<EyuRecordModel> eyuLists = List<EyuRecordModel>.empty(growable: true);
  late List<PoyuRecordModel> poyuLists = List<PoyuRecordModel>.empty(growable: true);
  late List<VaccienRecordModel> vaccienLists = List<VaccienRecordModel>.empty(growable: true);
  late List<LocationRecordModel> locationRecordLists = List<LocationRecordModel>.empty(growable: true);

  //String sagoValue = '';
  ComboListModel? selectedLocation;
  ComboListModel? selectedSago;

  late TabController _tabController;
  late TabController _tabController2;

  // 날짜 셋팅
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(DateTime.now().year, DateTime.now().month),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 6, vsync: this);
    _tabController2 = TabController(length: 6, vsync: this);

    _tabController.addListener(() {
      if (_tabController.indexIsChanging == false) {
        if(_tabController.index == 1) {
          //Trigger your request
        }
      }
    });
    // 필요 정보 호출(개체정보, 사고구분, 장소)
    setState(() {
      method();
    });
  }

  method() async {
    // dropbox
    sagolists = await getSagoGbn();
    locationlists = await Util().getLocation();

    // 하단 tab list
    // 산차기록
    //sanchaLists = await getSanchaRecord(pigNo);
    // 분만기록
    //bunmanLists = await getBunmanRecord(pigNo);
    // 이유기록
    //eyuLists = await getIyuRecord(pigNo);
    // 포유자돈
    //poyuLists = await getPoyuPig(pigNo);
    // 백신기록
    //vaccienLists = await getVaccineRecord(pigNo);
    // 장소이동
    //locationRecordLists = await getMoveLocation(pigNo);

  }

  @override
  Widget build(BuildContext context) {
    String bigo = "";
    TextEditingController bigoController = TextEditingController(text: '');

    return MaterialApp(
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('ko', 'KR'),
        ],
        home: Scaffold(
          // resizeToAvoidBottomInset : false,
          appBar: AppBar(
            title: const Text('PigPlan'),
            //title: Text(farmPigNo),
            // 뒤로가기
            leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop()),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Table(
                columnWidths: const {
                  0: FlexColumnWidth(),
                  1: FlexColumnWidth(),
                  2: FlexColumnWidth(),
                  3: FlexColumnWidth(),
                },
                border: TableBorder.all(
                    color: Colors.blueGrey,
                    style: BorderStyle.solid,
                    width: 2,
                    borderRadius: const BorderRadius.all(Radius.circular(5))),
                children: [
                  TableRow(children: [
                    Column(children: const [
                      Text('개체번호', style: TextStyle(fontSize: 16.0))
                    ]),
                    Column(children: [
                      Text(farmPigNo, style: const TextStyle(fontSize: 16.0))
                    ]),
                    Column(children: const [
                      Text('이각번호', style: TextStyle(fontSize: 16.0))
                    ]),
                    Column(children: [
                      Text(igakNo, style: const TextStyle(fontSize: 16.0))
                    ]),
                  ]),
                  TableRow(children: [
                    Column(children: const [
                      Text('사고구분', style: TextStyle(fontSize: 16.0))
                    ]),
                    Column(children: [
                      Text(sagoGubunNm, style: const TextStyle(fontSize: 16.0))
                    ]),
                    Column(children: const [
                      Text('현재산차', style: TextStyle(fontSize: 16.0))
                    ]),
                    Column(children: [
                      Text(sancha, style: const TextStyle(fontSize: 16.0))
                    ]),
                  ]),
                ],
              ),
              // padding
              const Padding(padding: EdgeInsets.only(bottom: 20)),

              Table(
                columnWidths: const {
                  0: FixedColumnWidth(120),
                  1: FlexColumnWidth(),
                },
                border: TableBorder.all(
                    color: Colors.black, style: BorderStyle.solid, width: 2),
                children: [
                  TableRow(children: [
                    Column(children: const [
                      Text('사고일', style: TextStyle(fontSize: 16.0))
                    ]),
                    Column(children: [
                      RaisedButton(
                        onPressed: () => _selectDate(context),
                        child: Text('${selectedDate.toLocal()}'.split(" ")[0]),
                      ),
                    ]),
                  ]),
                  TableRow(children: [
                    Column(children: const [
                      Text('임신사고원인', style: TextStyle(fontSize: 16.0))
                    ]),
                    Column(children: [
                      Container(
                        height: 30,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.grey,
                                width: 1,
                                style: BorderStyle.solid
                            ),
                            borderRadius: BorderRadius.circular(2)
                        ),
                        child: DropdownButton<ComboListModel>(
                          value: selectedSago,
                          hint: const Text('선택'),
                          icon: const Icon(Icons.arrow_downward),
                          iconSize: 24,
                          elevation: 16,
                          style: const TextStyle(color: Colors.black),
                          underline: DropdownButtonHideUnderline(child: Container()),
                          onChanged: (ComboListModel? newValue) {
                            setState(() {
                              selectedSago = newValue!;
                            });
                          },
                          items: sagolists.map((ComboListModel item) {
                            return DropdownMenuItem<ComboListModel>(
                              child: Text(item.cname),
                              value: item,
                            );
                          }).toList(),
                        ),
                      )
                    ]),
                  ]),
                  TableRow(children: [
                    Column(children: const [
                      Text('진단장소', style: TextStyle(fontSize: 16.0))
                    ]),
                    Column(children: [
                      Container(
                        height: 30,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.grey,
                                width: 1,
                                style: BorderStyle.solid
                            ),
                            borderRadius: BorderRadius.circular(2)
                        ),
                        child: DropdownButton<ComboListModel>(
                          value: selectedLocation,
                          hint: const Text('선택'),
                          icon: const Icon(Icons.arrow_downward),
                          iconSize: 24,
                          elevation: 16,
                          style: const TextStyle(color: Colors.black),
                          underline: DropdownButtonHideUnderline(child: Container()),
                          onChanged: (ComboListModel? newValue) {
                            setState(() {
                              selectedLocation = newValue!;
                            });
                          },
                          items: locationlists.map((ComboListModel item) {
                            return DropdownMenuItem<ComboListModel>(
                              child: Text(item.cname),
                              value: item,
                            );
                          }).toList(),
                        ),
                      )
                    ]),
                  ]),
                  TableRow(
                    children: [
                      Column(children: const [
                        Text('비고', style: TextStyle(fontSize: 16.0))
                      ]),
                      Column(children: [
                        TextFormField(
                          cursorColor: Theme.of(context).cursorColor,
                          initialValue: '',
                          maxLength: 100,
                          decoration: const InputDecoration(
                            // icon: Icon(Icons.favorite),
                            contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                            // labelText: '비고',
                            labelStyle: TextStyle(
                              color: Colors.black,
                            ),
                            // suffixIcon: Icon(
                            //   Icons.check_circle,
                            // ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            helperText: '',
                          ),
                        ),
                      ]),
                    ],
                  ),
                  TableRow(children: [
                    Column(children: const [Text('')]),
                    Column(children: [
                      RaisedButton(
                        onPressed: () async {
                          bigo = bigoController.text;
                          setUpdate(farmNo, pigNo, bigo, selectedSago,
                              selectedLocation, selectedDate);
                        },
                        child: const Text('수정', style: TextStyle(fontSize: 20),),
                      ),
                    ]),
                  ]),
                ],
              ),

              const Padding(
                padding: EdgeInsets.all(0.0),
              ),

              // padding
              const Padding(padding: EdgeInsets.only(bottom: 20)),

              SingleChildScrollView(
                child: TabBar(
                  controller: _tabController,
                  indicatorColor: Colors.lime,
                  isScrollable: true,
                  labelColor: Colors.black,
                  tabs: const [
                    Tab(text: "산차기록",),
                    Tab(text: "분만기록",),
                    Tab(text: "이유기록",),
                    Tab(text: "포유자돈",),
                    Tab(text: "백신기록",),
                    Tab(text: "장소이동",),
                  ],
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () =>
                    Future.delayed(const Duration(seconds: 1)),
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      SanchaListPage(pigNo: pigNo),
                      BunmanListPage(pigNo: pigNo),
                      EyuListPage(pigNo: pigNo),
                      PoyuListPage(pigNo: pigNo),
                      VaccienListPage(pigNo: pigNo),
                      LocationListPage(pigNo: pigNo),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  String _baseUrl = "http://192.168.4.141:8080/";

// 사고구분 값
  Future<List<ComboListModel>> getSagoGbn() async {
    List<ComboListModel> list = List<ComboListModel>.empty(growable: true);

    // url, parameter 셋팅
    var url = _baseUrl + "comboSysCodeCd.json?" + "pcode=05&lang=ko";
    var parameters = {
      'pcode': '05',
      'lang': 'ko',
    };

    final uri = Uri.http('192.168.4.141:8080', '/common/comboSysCodeCd.json', parameters);
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      // print(data);
      for (int i = 0; i < data.length; i++) {
        sagolists.add(ComboListModel.fromJson(data[i]));
      }
      setState(() {});
      return sagolists;
    } else {
      throw Exception('error');
    }
  }

  // 사고리스트
  Future<List<ComboListModel>> getSageList() async {
    List<ComboListModel> list = List<ComboListModel>.empty(growable: true);
    dynamic session_id = await FlutterSession().get("SESSION_ID");

    // url, parameter 셋팅
    var url = _baseUrl + "comboCodeFarmDonBang.json";
    var parameters = {
      'pcodeTp': '080001, 080002, 080003',
      'lang': 'ko'
    };

    final uri = Uri.http('192.168.4.141:8080', '/pigplan/pmd/inputmd/selectSagoOne.json', parameters);

    final response = await http.get(uri, headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      'cookie': session_id,
    });

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      // print(data);

      for (int i = 0; i < data.length; i++) {
        locationlists.add(ComboListModel.fromJson(data[i]));
      }
      return locationlists;
    } else {
      throw Exception('error');
    }
  }

// 데이터 저장
  Future<String> setUpdate(int farmNo, int pigNo, String bigo,
      ComboListModel? selectedSago, ComboListModel? selectedLocation, DateTime selectedDate) async {
    //var url = 'mobile/updateOrStoreSago.json';
    var url = 'pigplan/pmd/inputmd/updateOrStorePregnancy.json';

    const String _baseUrl = "http://192.168.4.141:8080/";

    print(selectedSago!.code.toString());
    print(selectedLocation!.code);

    final parameter = json.encode({
      'pigNo': pigNo.toString(),
      'farmNo': farmNo.toString(),
      'sagoGubunCd': selectedSago.code.toString(), //사고코드
      'locCd': selectedLocation.code.toString(), // 장소코드
      'bigo': bigo,
      'wkDt': selectedDate.toLocal().toString().split(" ")[0], // 2021-11-03
      'iuFlag': 'U', // I, U
      'lang': 'ko',
      'dateFormat': 'yyyy-MM-dd',
      'logInsId': 'test001',
      'memberId': 'test001'
    });

    print(parameter);
    print(_baseUrl + url);

    dynamic session_id = await FlutterSession().get("SESSION_ID");

    print("header cookie값 :: " + session_id);

    final response = await http.post(Uri.parse(_baseUrl + url),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: 'application/json',
          'cookie': session_id,
        },
        body: parameter);

    print(response.body);

    if (response.statusCode == 200) {
      return "sucess";
    } else {
      throw Exception('error');
      return "false";
    }
  }
}
