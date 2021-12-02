import 'package:flutter/material.dart';
import 'dart:convert';

class MatingRecordModel {

  List<MatingRecordModel> welcomeFromJson(String str) => List<MatingRecordModel>.from(json.decode(str).map((x) => MatingRecordModel.fromJson(x)));

  String welcomeToJson(List<MatingRecordModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

  late final int farmNo;
  late final String farmPigNo;
  late String? sancha = "";
  late String pumjongNm;
  late String igakNo = "";
  late String wkDt = "";
  late String ufarmPigNo1 = "";
  late String ufarmPigNo2 = "";
  late String ufarmPigNo3 = "";
  late String locNm = "";

  MatingRecordModel(
      {
        required this.farmNo,
        required this.farmPigNo,
        required this.sancha,
        required this.pumjongNm,
        required this.igakNo,
        required this.wkDt,
        required this.ufarmPigNo1,
        required this.ufarmPigNo2,
        required this.ufarmPigNo3,
        required this.locNm,
      });

  factory MatingRecordModel.fromJson(Map<String, dynamic> json) => MatingRecordModel(
      farmNo: json['farmNo'],
      farmPigNo: json['farmPigNo'],
      sancha: json['sancha'] ?? "",
      pumjongNm: json['pumjongNm'] ?? "",
      igakNo: json['igakNo'] ?? "",
      wkDt: json['wkDt'] ?? "",
      ufarmPigNo1: json['ufarmPigNo1'] ?? "",
      ufarmPigNo2: json['ufarmPigNo2'] ?? "",
      ufarmPigNo3: json['ufarmPigNo3'] ?? "",
      locNm: json['locNm'] ?? "",
    );

  Map<String, dynamic> toJson() => {
    "farmNo": farmNo,
    "farmPigNo": farmPigNo,
    "sancha": sancha,
    "pumjongNm": pumjongNm,
    "igakNo": igakNo,
    "wkDt": wkDt,
    "ufarmPigNo1": ufarmPigNo1,
    "ufarmPigNo2": ufarmPigNo2,
    "ufarmPigNo3": ufarmPigNo3,
    "locNm": locNm,
  };


}
