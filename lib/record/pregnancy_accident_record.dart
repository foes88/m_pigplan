import 'dart:developer';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';


import 'package:m_pigplan/common/util.dart';
import 'package:m_pigplan/model/combolist_model.dart';
import 'package:m_pigplan/model/modon_dropbox_model.dart';
import 'package:m_pigplan/model/pregnancy_accident_record_model.dart';
import 'package:m_pigplan/record/pregnancy_accident_record_detail.dart';
import 'package:m_pigplan/widget/bottom_bar.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:m_pigplan/api_call.dart';
import 'package:m_pigplan/model/mating_record_data.dart';
import 'package:http/http.dart' as http;

import '../model/mating_record_data.dart';
import 'matingrecord.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:flutter/services.dart';

class PregnancyAccidentRecord extends StatefulWidget {
  const PregnancyAccidentRecord({Key? key}) : super(key: key);

  @override
  _PregnancyAccidentRecord createState() => _PregnancyAccidentRecord();
}

class _PregnancyAccidentRecord extends State<PregnancyAccidentRecord> {
  TextEditingController searchController = TextEditingController(text: '');

  ScrollController listScrollController = ScrollController();
  final sccontroller = ScrollController();

  late List<ComboListModel> sagolists = List<ComboListModel>.empty(growable: true);
  late List<ComboListModel> locationlists = List<ComboListModel>.empty(growable: true);
  late List<ModonDropboxModel> modonLists = [];

  ComboListModel? selectedLocation;
  ComboListModel? selectedSago;

  // 사고 구분
  List<ComboListModel> sagoValue = <ComboListModel>[
    ComboListModel(code: '050001', cname: '10.재발불임'),
    ComboListModel(code: '050007', cname: '20.공태'),
    ComboListModel(code: '050002', cname: '30.유산'),
    ComboListModel(code: '050003', cname: '40.도태'),
    ComboListModel(code: '050004', cname: '50.폐사'),
    ComboListModel(code: '050005', cname: '60.임돈전출'),
    ComboListModel(code: '050006', cname: '70.임돈판매'),
  ];

  // 장소
  List<ComboListModel> locationValue = <ComboListModel>[
    ComboListModel(code: '080003', cname: '임신사'),
    ComboListModel(code: '13309', cname: '임신군사1방'),
    ComboListModel(code: '1234', cname: '임신군사2방'),
  ];

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

  late String _searchResult = "";
  late List<String> filteredSearchHistory;
  late String selectedTerm;
  late List<PregnancyAccidentRecordModel> lists = [];
  late String _searchValue = "";

  // 날짜 셋팅1
  DateTime selectedFromDate = DateTime(
      DateTime.now().year, DateTime.now().month - 6, DateTime.now().day);
  Future<void> _selectFromDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedFromDate,
        firstDate: DateTime(selectedFromDate.year, selectedFromDate.month - 6),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedFromDate) {
      setState(() {
        selectedFromDate = picked;
      });
    }
  }

  // 날짜 셋팅2
  DateTime selectedToDate = DateTime.now();
  Future<void> _selectToDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedToDate,
        firstDate: DateTime(selectedToDate.year, selectedToDate.month - 6),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedToDate) {
      setState(() {
        selectedToDate = picked;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      method();
    });
  }

  method() async {

    sagolists = await getSagoGbn();
    locationlists = await Util().getLocation();



    var url = 'pigplan/pmd/inputmd/sagoList.json';
    lists = await restApiPostJson(url);
    setState(() {
      // List호출
      const SingleChildScrollView();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
          title: const Text('PigPlan'),
          leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop())),
      floatingActionButton: FloatingActionButton(
        onPressed: scrollUp,
        isExtended: true,
        tooltip: "top",
        backgroundColor: Colors.lightBlueAccent,
        mini: true,
        child: const Icon(Icons.arrow_upward),
      ),
      body: ListView(
        controller: sccontroller,
        children: <Widget>[
          ExpansionTile(
            title: const Text(
              '검색',
              textAlign: TextAlign.center,
            ),
            children: [
              Table(
                columnWidths: const {
                  0: FixedColumnWidth(80),
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
                      ButtonBar(children: [
                        ButtonTheme(
                            height: 30,
                            buttonColor: Colors.blueGrey,
                            child: RaisedButton(
                              onPressed: () => _selectFromDate(context),
                              child: Text("${selectedFromDate.toLocal()}"
                                  .split(" ")[0]
                                  .toString()),
                            )
                        ),
                        ButtonTheme(
                          height: 30,
                          buttonColor: Colors.blueGrey,
                          child: RaisedButton(
                              onPressed: () => _selectToDate(context),
                              child: Text("${selectedToDate.toLocal()}"
                                  .split(" ")[0]
                                  .toString())),
                        ),
                      ]),
                    ]),
                  ]
                  ),
                  TableRow(children: [
                    Column(children: const [Text('검색')]),
                    Column(children: [
                      TextFormField(
                        cursorColor: Theme.of(context).cursorColor,
                        initialValue: '',
                        maxLength: 20,
                        decoration: const InputDecoration(
                          // icon: Icon(Icons.favorite),
                          contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                          // labelText: '비고',
                          labelStyle: TextStyle(
                            color: Colors.black,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          helperText: '',
                        ),
                        onChanged: (value) async {
                          setState(() {
                            _searchResult = value;
                          });
                          // 조회
                          method();
                        },
                      ),
                    ]),
                  ]
                  ),
                ],
              ),
            ],
          ),
          Column(
            children: <Widget>[
              /* Card(
                  child: ListTile(
                leading: const Icon(Icons.search),
                onTap: () {
                  setState(() {
                    method();
                    // 키패드 내리기
                    FocusScope.of(context).unfocus();
                  });
                },
                title: TextField(
                  controller: searchController,
                  decoration: const InputDecoration(
                    hintText: '검색',
                    border: InputBorder.none,
                  ),
                  onChanged: (value) async {
                    print(value);
                    setState(() {
                      _searchResult = value;
                    });
                    // 조회
                    method();
                  },
                ),
              )),*/
              ExpansionTile(
                title: const Text(
                  '신규 등록',
                  textAlign: TextAlign.center,
                ),
                children: [
                  Table(
                    columnWidths: const {
                      0: FixedColumnWidth(120),
                      1: FlexColumnWidth(),
                    },
                    border: TableBorder.all(
                        color: Colors.black,
                        style: BorderStyle.solid,
                        width: 2),
                    children: [
                      TableRow(children: [
                        Column(children: const [
                          Text('모돈선택', style: TextStyle(fontSize: 16.0))
                        ]),
                        Column(children: [
                          DropdownSearch(
                            // mode: Mode.MENU,
                            showSearchBox: true,
                            // isFilteredOnline: true,
                            onFind: (String? filter) => Util().getModonList(filter),
                            itemAsString: (ModonDropboxModel? m) => m!.farmPigNo.toString(),
                            onChanged: (value) => setState(() {
                              _searchValue = value.toString();
                              // Util().getModonList(value);
                            }),
                          ),
                        ]),
                      ]),
                      TableRow(children: [
                        Column(children: const [
                          Text('사고일', style: TextStyle(fontSize: 16.0))
                        ]),
                        Column(children: [
                          RaisedButton(
                            onPressed: () => _selectDate(context),
                            child:
                                Text('${selectedDate.toLocal()}'.split(" ")[0]),
                          ),
                        ]),
                      ]),
                      TableRow(children: [
                        Column(children: const [
                          Text('임신사고원인', style: TextStyle(fontSize: 16.0))
                        ]),
                        Column(children: [
                          DropdownButton<ComboListModel>(
                            isDense: true,
                            value: selectedSago,
                            hint: const Text('선택'),
                            icon: const Icon(Icons.arrow_downward),
                            underline: DropdownButtonHideUnderline(child:Container()),
                            iconSize: 24,
                            elevation: 16,
                            style: const TextStyle(color: Colors.black),
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
                        ]),
                      ]),
                      TableRow(children: [
                        Column(children: const [
                          Text('진단장소', style: TextStyle(fontSize: 16.0))
                        ]),
                        Column(children: [
                          DropdownButton<ComboListModel>(
                            value: selectedLocation,
                            icon: const Icon(Icons.arrow_downward),
                            hint: const Text('선택'),
                            iconSize: 24,
                            elevation: 16,
                            style: const TextStyle(color: Colors.black),
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
                              maxLength: 20,
                              decoration: const InputDecoration(
                                // icon: Icon(Icons.favorite),
                                contentPadding:
                                    EdgeInsets.fromLTRB(10, 10, 10, 0),
                                // labelText: '비고',
                                labelStyle: TextStyle(
                                  color: Colors.black,
                                ),
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
                              //bigo = bigoController.text;
                              //setInsert(farmNo, pigNo, bigo, selectedSago, selectedLocation, selectedDate);
                            },
                            child: const Text(
                              '저장',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ]),
                      ]),
                    ],
                  ),
                ],
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  sortAscending: true,
                  // 컬럼 헤더 색상
                  headingRowColor: MaterialStateColor.resolveWith(
                      (states) => Colors.blueGrey.shade50),
                  columns: const <DataColumn>[
                    DataColumn(label: Text('개체번호')),
                    DataColumn(label: Text('이각번호')),
                    DataColumn(label: Text('산차')),
                    DataColumn(label: Text('사고구분')),
                    DataColumn(label: Text('교배일')),
                    DataColumn(label: Text('사고일')),
                    DataColumn(label: Text('현재상태')),
                    DataColumn(label: Text('장소')),
                  ],
                  rows: lists
                      .map(
                        ((element) => DataRow(
                              cells: [
                                DataCell(Text(element.farmPigNo), onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            PregnancyAccidentRecordRegit(
                                          farmNo: element.farmNo,
                                          pigNo: element.pigNo,
                                          farmPigNo: element.farmPigNo,
                                          sancha: element.sancha ?? "",
                                          igakNo: element.igakNo ?? "",
                                          sagoGubunNm: element.sagoGubunNm ?? "",
                                        ),
                                        /*settings: RouteSettings(
                                              arguments: element)*/
                                      ));
                                }),
                                DataCell(Text(element.igakNo.toString()),
                                    onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PregnancyAccidentRecordRegit(
                                                farmNo: element.farmNo,
                                                pigNo: element.pigNo,
                                                farmPigNo: element.farmPigNo,
                                                sancha: element.sancha ?? "",
                                                igakNo: element.igakNo ?? "",
                                                sagoGubunNm:
                                                    element.sagoGubunNm ?? "",
                                              ),
                                          settings: RouteSettings(
                                              arguments: element)));
                                }),
                                DataCell(Text((element.sancha).toString())),
                                DataCell(Text((element.sagoGubunNm).toString())),
                                DataCell(Text((element.wkDtP).toString())),
                                DataCell(Text((element.wkDt).toString())),
                                DataCell(Text(element.wkGubunNm.toString())),
                                DataCell(Text(element.locNm.toString())),
                              ],
                            )),
                      ).toList(),
                ),
              ),
              // SfCartesianChart(),
              //environmentSection,
              //reportSection
            ],
          ),
        ],
      ),
    ));
  }

  Widget monitoringSection = Container(
    // 컨테이너 내부 상하좌우에 32픽셀만큼의 패딩 삽입
    padding: const EdgeInsets.all(32),
    // 자식으로 로우를 추가
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      // 로우에 위젯들(Expanded, Icon, Text)을 자식들로 추가
      children: <Widget>[
        const Text("농가 현황", textAlign: TextAlign.start),
        OutlinedButton(onPressed: () {}, child: Text('위험탐지  17건>')),
        OutlinedButton(onPressed: () {}, child: Text('질병탐지  13건>')),
        OutlinedButton(onPressed: () {}, child: Text('환경이상탐지  2건>')),
      ],
    ),
  );

  // 조회
  Future<List<PregnancyAccidentRecordModel>> restApiPostJson(url) async {
    List<PregnancyAccidentRecordModel> datas =
        List<PregnancyAccidentRecordModel>.empty(growable: true);

    const String _baseUrl = "http://192.168.4.141:8080/";

    var parameters = {
      'searchFarmNo': '105',
      'farmNo': '105',
      'searchFarmPigNo': _searchResult,
      'lang': 'ko',
      'searchFromWkDt': selectedFromDate.toLocal().toString().split(" ")[0],
      'searchToWkDt': selectedToDate.toLocal().toString().split(" ")[0],
    };

    print(_baseUrl + url);

    dynamic session_id = await FlutterSession().get("SESSION_ID");
    print("header cookie값 :: " + session_id);

    final response = await http.post(Uri.parse(_baseUrl + url),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
          'cookie': session_id,
        },
        body: parameters
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['rows'];

      // print(data);

      for (int i = 0; i < data.length; i++) {
        datas.add(PregnancyAccidentRecordModel.fromJson(data[i]));
      }
      return datas;
    } else {
      throw Exception('error');
    }
  }

  void scrollUp() {
    const double start = 0;
    sccontroller.jumpTo(start);
  }

// 사고구분 값
  String _baseUrl = "http://192.168.4.141:8080/mobile/";

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

      for (int i = 0; i < data.length; i++) {
        list.add(ComboListModel.fromJson(data[i]));
      }
      return list;
    } else {
      throw Exception('error');
    }
  }





}
