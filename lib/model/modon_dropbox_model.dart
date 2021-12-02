import 'package:flutter/material.dart';
import 'dart:convert';

class ModonDropboxModel {

  List<ModonDropboxModel> welcomeFromJson(String str) => List<ModonDropboxModel>.from(json.decode(str).map((x) => ModonDropboxModel.fromJson(x)));

  String welcomeToJson(List<ModonDropboxModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

  late final int farmNo;
  late int pigNo;
  late String? farmPigNo = "";
  late String? igakNo = "";

  ModonDropboxModel({
        required this.farmNo,
        required this.pigNo,
        required this.farmPigNo,
        required this.igakNo,
      });

  factory ModonDropboxModel.fromJson(Map<String, dynamic> json) => ModonDropboxModel(
    farmNo: json['farmNo'] ?? "",
    pigNo: json['pigNo'],
    farmPigNo: json['farmPigNo'] ?? "",
      igakNo: json['igakNo'] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "farmNo": farmNo,
    "pigNo": pigNo,
    "farmPigNo": farmPigNo,
    "igakNo": igakNo,
  };

}
