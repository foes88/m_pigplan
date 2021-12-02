import 'dart:developer';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:m_pigplan/common/util.dart';
import 'package:m_pigplan/model/combolist_model.dart';
import 'package:m_pigplan/model/eungdon_model.dart';
import 'package:m_pigplan/model/modon_history/location_record_model.dart';
import 'package:m_pigplan/widget/bottom_bar.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:m_pigplan/nav.dart';
import 'package:m_pigplan/api_call.dart';
import 'package:m_pigplan/model/mating_record_data.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_session/flutter_session.dart';

import '../model/mating_record_data.dart';

class MatingRecord extends StatefulWidget {
  const MatingRecord({Key? key}) : super(key: key);

  @override
  _MatingRecord createState() => _MatingRecord();
}

class _MatingRecord extends State<MatingRecord> {
  TextEditingController controller = TextEditingController();
  ScrollController listScrollController = ScrollController();
  final sccontroller = ScrollController();

  late String _searchResult = "";
  late List<String> filteredSearchHistory;
  late String selectedTerm;

  late List<MatingRecordModel> lists = [];
  late List<ComboListModel> gbList = [];
  late List<ComboListModel> lcList = [];
  late List<EungdonModel> edList = [];
  late List<ComboListModel> edGbnList = [];

  ComboListModel? selectedGbValue;
  ComboListModel? selectedGblValue;
  EungdonModel? selectedEd1Value;
  EungdonModel? selectedEd2Value;
  EungdonModel? selectedEd3Value;

  ComboListModel? selectedCbEd1Value;
  ComboListModel? selectedCbEd2Value;
  ComboListModel? selectedCbEd3Value;


  static const historyLength = 3;

  // 교배일
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
    //var url = 'mobile/selectGyobaeList.json';
    var url = 'pigplan/pmd/inputmd/selectGyobaeList.json';

    lists = await restApiPostJson(url);
    gbList = await Util().getFarmCodeList('','G');
    lcList = await Util().getLocation();
    edList = await Util().getEungdon();
    // 교배방법
    edGbnList = await Util().getCodeList('sys', 'A', '995', '995001,995002');

    setState(() {
      const SingleChildScrollView();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PigPlan'),
      ),
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
          backgroundColor: Colors.white,
          title: const Text(
            '검색',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          children: [
            const SizedBox(
               width: 300,
               child: TextField(
                 textInputAction: TextInputAction.done,
                 textAlign: TextAlign.center,
                 decoration: InputDecoration(
                   hintText: '검색',
                   enabledBorder: UnderlineInputBorder(
                     borderSide: BorderSide(color: Colors.black),
                   ),
                   focusedBorder: UnderlineInputBorder(
                     borderSide: BorderSide(color: Colors.red),
                   )
                 ),
               ),
            ),
            SizedBox(
              child: ButtonBar(children: [
                ButtonTheme(
                    height: 25,
                    buttonColor: Colors.blueGrey,
                    child: RaisedButton(
                      onPressed: () => _selectFromDate(context),
                      child: Text("${selectedFromDate.toLocal()}"
                          .split(" ")[0]
                          .toString()),
                    )),
                ButtonTheme(
                  height: 25,
                  buttonColor: Colors.blueGrey,
                  child: RaisedButton(
                      onPressed: () => _selectToDate(context),
                      child: Text("${selectedToDate.toLocal()}"
                          .split(" ")[0]
                          .toString())),
                ),
              ]),
            ),

            /* Card(
                child: ListTile(
                    leading: const Icon(Icons.search),
                    title : TextField(
                      controller: controller,
                      decoration: const InputDecoration(
                          hintText: '검색',
                          border: InputBorder.none
                      ),
                      onChanged: (value) {
                        print(value);
                        setState(() {
                          _searchResult = value;
                        });
                        // 조회
                        method();
                      },
                    )
                )
            )*/

          ],
        ),
        ExpansionTile(
            title: const Text(
            '교배기록 등록',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,

            ),
          ),
          children: [
            SizedBox(
              width: 300,
              child: ButtonBar(
                children: [
                  Container(
                    child: const Text('교배일',
                      style: TextStyle(fontSize: 16,
                        fontFamily: 'Signatra',
                      ),
                    ),
                    padding: EdgeInsets.only(right: 50.0),
                  ),
                  ButtonTheme(
                    child: RaisedButton(onPressed: () => _selectFromDate(context),
                      child: Text("${selectedFromDate.toLocal()}"
                          .split(" ")[0]
                          .toString()),
                    ),
                    buttonColor: Colors.grey,
                  )
                ],
              )
            ),
            SizedBox(
                width: 300,
                child: ButtonBar(
                  children: [
                    Container(
                      child: const Text('교배자',
                        style: TextStyle(fontSize: 16,
                          fontFamily: 'Signatra',
                        ),
                      ),
                      padding: const EdgeInsets.only(right: 50.0),
                    ),
                    SizedBox(
                      width: 130,
                      child: DropdownButton<ComboListModel>(
                        isDense: true,
                        isExpanded: true,
                        hint: const Text('선택'),
                        value: selectedGbValue,
                        style: const TextStyle(color: Colors.black),
                        onChanged: (ComboListModel? newValue) {
                          setState(() {
                            selectedGbValue = newValue!;
                          });
                        },
                        items: gbList.map((ComboListModel item) {
                          return DropdownMenuItem<ComboListModel>(
                            child: Text(item.cname),
                            value: item,
                          );
                        }).toList(),
                      ),
                    )
                  ]
                )
            ),
            SizedBox(
                width: 300,
                child: ButtonBar(
                  children: [
                    Container(
                      child: const Text('교배장소',
                        style: TextStyle(fontSize: 16,
                          fontFamily: 'Signatra',
                        ),
                      ),
                      padding: EdgeInsets.only(right: 50.0),
                    ),
                    SizedBox(
                      width: 130,
                      child: DropdownButton(
                        isDense: true,
                        isExpanded: true,
                        hint: const Text('선택'),
                        value: selectedGblValue,
                        style: const TextStyle(color: Colors.black),
                        onChanged: (ComboListModel? newValue) {
                          setState(() {
                            selectedGblValue = newValue!;
                          });
                        },
                        items: lcList.map((ComboListModel item) {
                          return DropdownMenuItem<ComboListModel>(
                            child: Text(item.cname),
                            value: item,
                          );
                        }).toList(),
                      ),
                    )
                  ],
                )
            ),
            SizedBox(
                width: 350,
                child: ButtonBar(
                  children: [
                    Container(
                      child: const Text('웅돈1회',
                        style: TextStyle(fontSize: 16,
                          fontFamily: 'Signatra',
                        ),
                      ),
                      padding: EdgeInsets.only(right: 50.0),
                    ),
                    SizedBox(
                      width: 130,
                      child: DropdownButton(
                        isDense: true,
                        isExpanded: true,
                        hint: const Text('선택'),
                        value: selectedEd1Value,
                        style: const TextStyle(color: Colors.black),
                        onChanged: (EungdonModel? newValue) {
                          setState(() {
                            selectedEd1Value = newValue!;
                          });
                        },
                        items: edList.map((EungdonModel item) {
                          return DropdownMenuItem<EungdonModel>(
                            child: Text(item.farmPigNo),
                            value: item,
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(
                      width: 80,
                      child: DropdownButton<ComboListModel>(
                        isDense: true,
                        isExpanded: true,
                        hint: const Text('선택'),
                        value: selectedCbEd1Value,
                        style: const TextStyle(color: Colors.black),
                        onChanged: (ComboListModel? newValue) {
                          setState(() {
                            selectedCbEd1Value = newValue!;
                          });
                        },
                        items: edGbnList.map((ComboListModel item) {
                          return DropdownMenuItem<ComboListModel>(
                            child: Text(item.cname),
                            value: item,
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                )
            ),
            SizedBox(
                width: 350,
                child: ButtonBar(
                  children: [
                    Container(
                      child: const Text('웅돈2회',
                        style: TextStyle(fontSize: 16,
                          fontFamily: 'Signatra',
                        ),
                      ),
                      padding: const EdgeInsets.only(right: 50.0),
                    ),
                    SizedBox(
                      width: 130,
                      child: DropdownButton(
                        isDense: true,
                        isExpanded: true,
                        hint: const Text('선택'),
                        value: selectedEd2Value,
                        style: const TextStyle(color: Colors.black),
                        onChanged: (EungdonModel? newValue) {
                          setState(() {
                            selectedEd2Value = newValue!;
                          });
                        },
                        items: edList.map((EungdonModel item) {
                          return DropdownMenuItem<EungdonModel>(
                            child: Text(item.farmPigNo),
                            value: item,
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(
                      width: 80,
                      child: DropdownButton<ComboListModel>(
                        isDense: true,
                        isExpanded: true,
                        hint: const Text('선택'),
                        value: selectedCbEd2Value,
                        style: const TextStyle(color: Colors.black),
                        onChanged: (ComboListModel? newValue) {
                          setState(() {
                            selectedCbEd2Value = newValue!;
                          });
                        },
                        items: edGbnList.map((ComboListModel item) {
                          return DropdownMenuItem<ComboListModel>(
                            child: Text(item.cname),
                            value: item,
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                )
            ),
            SizedBox(
                width: 350,
                child: ButtonBar(
                  children: [
                    Container(
                      child: const Text('웅돈3회',
                        style: TextStyle(fontSize: 16,
                          fontFamily: 'Signatra',
                        ),
                      ),
                      padding: EdgeInsets.only(right: 50.0),
                    ),
                    SizedBox(
                      width: 130,
                      child: DropdownButton(
                        isDense: true,
                        isExpanded: true,
                        hint: const Text('선택'),
                        value: selectedEd3Value,
                        style: const TextStyle(color: Colors.black),
                        onChanged: (EungdonModel? newValue) {
                          setState(() {
                            selectedEd3Value = newValue!;
                          });
                        },
                        items: edList.map((EungdonModel item) {
                          return DropdownMenuItem<EungdonModel>(
                            child: Text(item.farmPigNo),
                            value: item,
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(
                      width: 80,
                      child: DropdownButton<ComboListModel>(
                        isDense: true,
                        isExpanded: true,
                        hint: const Text('선택'),
                        value: selectedCbEd3Value,
                        style: const TextStyle(color: Colors.black),
                        onChanged: (ComboListModel? newValue) {
                          setState(() {
                            selectedCbEd3Value = newValue!;
                          });
                        },
                        items: edGbnList.map((ComboListModel item) {
                          return DropdownMenuItem<ComboListModel>(
                            child: Text(item.cname),
                            value: item,
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                )
            ),
            const SizedBox(
              width: 300,
              child: TextField(
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  labelText: "비고",
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    )
                ),

              ),
            )
          ],
        ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,

            child: DataTable(
              sortAscending: true,
              columns: const <DataColumn>[
                DataColumn(label: Text('모돈번호',)),
                DataColumn(label: Text('이각번호')),
                DataColumn(label: Text('산차')),
                DataColumn(label: Text('교배일')),
                DataColumn(label: Text('교배방법')),
                DataColumn(label: Text('웅돈1회')),
                DataColumn(label: Text('웅돈2회')),
                DataColumn(label: Text('웅돈3회')),
              ],
              rows: lists
                  .map(
                ((element) => DataRow(
                  cells: [
                    DataCell(Text(element.farmPigNo)),
                    DataCell(Text((element.igakNo).toString())),
                    DataCell(Text((element.sancha).toString())),
                    DataCell(Text(element.wkDt)),
                    DataCell(Text(element.ufarmPigNo1)),
                    DataCell(Text(element.ufarmPigNo1)),
                    DataCell(Text(element.ufarmPigNo2)),
                    DataCell(Text(element.ufarmPigNo3)),
                  ],
                )),
              ).toList(),
            ),
          ),
      ]


        /*
        children: <Widget>[
          Column(
            children: <Widget>[
              Card(
                child: ListTile(
                  leading: const Icon(Icons.search),
                  title : TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: '검색', border: InputBorder.none
                    ),
                    onChanged: (value) {
                      print(value);
                      setState(() {
                        _searchResult = value;
                      });

                      // 조회
                      method();
                    },
                  )
                )

              ),
              *//*
              Container(
                // 컨테이너 내부 상하좌우에 32픽셀만큼의 패딩 삽입
                padding: const EdgeInsets.all(32),
                // 자식으로 로우를 추가
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  // 로우에 위젯들(Expanded, Icon, Text)을 자식들로 추가
                  children: <Widget>[
                    const Text("교배기록", textAlign: TextAlign.start),
                    OutlinedButton(onPressed: () {}, child: const Text('대시보드')),
                  ],
                ),
              ),
              *//*
              TextButton(
                  style: TextButton.styleFrom(primary: Colors.black26),
                  onPressed: () async {
                    var url = 'mobile/selectGyobaeList.json';
                    lists = await restApiPostJson(url);

                    print("DATA RESULT");
                    print(lists[0]);

                    const SingleChildScrollView();
                  },
                  child: const Text('조회')
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,

                child: DataTable(
                  sortAscending: true,
                  columns: const <DataColumn>[
                    DataColumn(label: Text('개체번호',)),
                    DataColumn(label: Text('품종')),
                    DataColumn(label: Text('산차')),
                  ],
                  rows: lists
                      .map(
                        ((element) => DataRow(
                              cells: [
                                DataCell(Text(element.farmPigNo)),
                                DataCell(Text((element.pumjongNm).toString())),
                                DataCell(Text((element.sancha).toString())),
                              ],
                            )),
                      )
                      .toList(),

                ),
              ),
              // SfCartesianChart(),
              //environmentSection,
              //reportSection
            ],
          )
        ],
        */

      ),
    );
  }

  // 조회
  Future<List<MatingRecordModel>> restApiPostJson(url) async {
    List<MatingRecordModel> datas = List<MatingRecordModel>.empty(growable: true);

    const String _baseUrl = "http://192.168.4.141:8080/";

    var parameters = {
      'searchFarmPigNo': _searchResult,
      'searchFromWkDt': selectedFromDate.toLocal().toString().split(" ")[0],
      'searchToWkDt': selectedToDate.toLocal().toString().split(" ")[0],
    };

    dynamic session_id = await FlutterSession().get("SESSION_ID");

    final response = await http.post(Uri.parse(_baseUrl + url),
        headers: {
          'cookie': session_id,
        },
        body: parameters
    );

    // print("교배기록 조회 :: " + response.body);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['rows'];

      for (int i = 0; i < data.length; i++) {
        datas.add(MatingRecordModel.fromJson(data[i]));
      }
      return datas;
    } else {
      throw Exception('error');
    }

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

  void scrollUp() {
    const double start = 0;
    sccontroller.jumpTo(start);
  }

  /*
  List<String> filterSearchTerms({
    required String filter,
  }) {
    if (filter != null && filter.isNotEmpty) {
      // Reversed because we want the last added items to appear first in the UI
      return _searchResult.reversed
          .where((term) => term.startsWith(filter))
          .toList();
    } else {
      return _searchResult.reversed.toList();
    }
  }

  void addSearchTerm(String term) {
    if (_searchResult.contains(term)) {
      // This method will be implemented soon
      putSearchTermFirst(term);
      return;
    }
    _searchResult.add(term);
    if (_searchResult.length > historyLength) {
      _searchResult.removeRange(0, _searchResult.length - historyLength);
    }
    // Changes in _searchHistory mean that we have to update the filteredSearchHistory
    filteredSearchHistory = filterSearchTerms(filter: "");
  }

  void deleteSearchTerm(String term) {
    _searchResult.removeWhere((t) => t == term);
    filteredSearchHistory = filterSearchTerms(filter: "");
  }

  void putSearchTermFirst(String term) {
    deleteSearchTerm(term);
    addSearchTerm(term);
  }
*/
/*
  Widget builDataTable() {

    return DataTable(
        columns: getColumns(columns)
        , rows: rows)
  }

  List<DataColumn> getColumns(List<String> columns) => columns
      .map((String column) => DataColumn(
      label: Text(column)
      ))
  .toList();
*/

}
