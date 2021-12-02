import 'package:flutter/material.dart';
import 'dart:convert';

class ComboListModel {

  List<ComboListModel> welcomeFromJson(String str) => List<ComboListModel>.from(
      json.decode(str).map((x) => ComboListModel.fromJson(x)));

  String welcomeToJson(List<ComboListModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

  late final String code;
  late final String cname;

  ComboListModel({
    required this.code,
    required this.cname
  });

  factory ComboListModel.fromJson(Map<String, dynamic> json) => ComboListModel(
    code: json['code'] ?? "",
    cname: json['cname'] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "cname": cname,
  };

}
