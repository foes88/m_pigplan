import 'dart:developer';

import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:http/http.dart' as http;
import 'package:m_pigplan/model/combolist_model.dart';
import 'package:m_pigplan/model/eungdon_model.dart';
import 'package:m_pigplan/model/modon_dropbox_model.dart';
import 'package:m_pigplan/model/modon_history/modon_history_model.dart';

//개발, 운영 설정파일

class Util {

  String _baseUrl = "http://192.168.4.141:8080";

  //모돈 리스트 조회
  Future<List<ModonDropboxModel>> getModonList(pigNo) async {

    print(pigNo);
    late List<ModonDropboxModel> modonList = List<ModonDropboxModel>.empty(growable: true);

    String url = _baseUrl + "/common/combogridModonList.json";

    var parameters = json.encode({
      "searchPigNo": pigNo,
      "searchType": '2',
      "orderby": 'FARM_PIG_NO',
    //  "searchStatus": {'010002', '010006', '010007'},
    });

    url += "?searchType=2&orderby=FARM_PIG_NO&searchStatus=" + "010002,010006,010007";

    dynamic session_id = await FlutterSession().get("SESSION_ID");
    final response = await http.post(Uri.parse(url),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: 'application/json',
          'cookie': session_id,
        },
        body: parameters
    );

    var statusCode = response.statusCode;

    if (statusCode == 200) {
      var data = jsonDecode(response.body);
      String value = "";

      for (int i = 0; i < data.length; i++) {
        modonList.add(ModonDropboxModel.fromJson(data[i]));
      }
      return modonList;
    } else {
      throw Exception('error');
    }
  }

  // 단일 코드값 조회
  Future<String> getCodeRecord(String type, String code, String pcode) async {

    // 코드가 없을 경우 return
    if (code.isEmpty) {
      return "";
    }

    // RequestBody로 받아줘서 body로 넘기는게 가능
    String url = _baseUrl + "/common/getCodes.json";

    var parameters = json.encode({
      'lang': 'ko',
    });

    // ModelAttribute로 받아줘서 url뒤로 넘김
    url += "?type="+type+"&code=" + code + "&pcode=" + pcode;

    print(url);

    dynamic session_id = await FlutterSession().get("SESSION_ID");
    final response = await http.post(Uri.parse(url),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: 'application/json',
          'cookie': session_id,
        },
        body: parameters
    );

    var statusCode = response.statusCode;

    if (statusCode == 200) {
      var data = jsonDecode(response.body);
      String value = "";
      for (int i = 0; i < data.length; i++) {
        if (data[i]['code'] == code) {
          value = data[i]['cname'];
          return value;
        }
      }
      return value;
    } else {
      throw Exception('error');
    }
  }

  // 코드리스트 값 조회
  Future<List<ComboListModel>> getCodeList(String type, String code, String pcode, String gbn) async {

    late List<ComboListModel> cbList = List<ComboListModel>.empty(growable: true);
    // RequestBody로 받아줘서 body로 넘기는게 가능
    String url = _baseUrl + "/common/getCodes.json";

    var gbnValue = gbn.toString().split(",");

    var parameters = json.encode({
      'lang': 'ko',
    });

    // ModelAttribute로 받아줘서 url뒤로 넘김
    url += "?type="+type+"&code=" + code + "&pcode=" + pcode;

    dynamic session_id = await FlutterSession().get("SESSION_ID");
    final response = await http.post(Uri.parse(url),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: 'application/json',
          'cookie': session_id,
        },
        body: parameters
    );

    var statusCode = response.statusCode;

    if (statusCode == 200) {
      var data = jsonDecode(response.body);

      for(int i=0; i<data.length; i++) {
        for(int j=0; j<gbnValue.length; j++) {
          // 얻어야하는 값이랑 같으면 list에 추가
          if(data[i]['code'] == gbnValue[j]) {
            cbList.add(ComboListModel.fromJson(data[i]));
          }
        }
      }
      return cbList;
    } else {
      throw Exception('error');
    }
  }

  // 농장 공통 코드 조회
  Future<List<ComboListModel>> getFarmCodeList(String code, String pcode) async {

    // 코드가 없을 경우 return
    if (pcode.isEmpty) {
      throw Exception("error");
    }

    List<ComboListModel> list = List<ComboListModel>.empty(growable: true);

    // RequestBody로 받아줘서 body로 넘기는게 가능
    String url = _baseUrl + "/common/comboFarmCodeCd.json";

    var parameters = json.encode({
      'lang': 'ko',
    });

    url += "?pcode=" + pcode;

    dynamic session_id = await FlutterSession().get("SESSION_ID");
    final response = await http.post(Uri.parse(url),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: 'application/json',
          'cookie': session_id,
        },
        body: parameters);

    var statusCode = response.statusCode;

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

  // 장소구분
  Future<List<ComboListModel>> getLocation() async {
    List<ComboListModel> list = List<ComboListModel>.empty(growable: true);
    dynamic session_id = await FlutterSession().get("SESSION_ID");

    // url, parameter 셋팅
    var url = _baseUrl + "/common/comboCodeFarmDonBang.json";
    var parameters = {
      'pcodeTp': '080001, 080002, 080003',
      'lang': 'ko'
    };

    final uri = Uri.http('192.168.4.141:8080', '/common/comboCodeFarmDonBang.json', parameters);

    final response = await http.get(uri, headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      'cookie': session_id,
    });

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

  // 웅돈 조회
  Future<List<EungdonModel>> getEungdon() async {
    List<EungdonModel> list = List<EungdonModel>.empty(growable: true);
    dynamic session_id = await FlutterSession().get("SESSION_ID");

    // url, parameter 셋팅
    var url = _baseUrl + "/common/comboBoarList.json";
    var parameters = {
      'pcodeTp': '080001, 080002, 080003',
      'lang': 'ko'
    };

    final uri = Uri.http('192.168.4.141:8080', '/common/comboBoarList.json', parameters);

    final response = await http.get(uri, headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      'cookie': session_id,
    });

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      for (int i = 0; i < data.length; i++) {
        list.add(EungdonModel.fromJson(data[i]));
      }
      return list;
    } else {
      throw Exception('error');
    }




  }





}
