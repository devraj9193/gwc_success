// To parse this JSON data, do
//
//     final sentReplyModel = sentReplyModelFromJson(jsonString);

import 'dart:convert';

SentReplyModel sentReplyModelFromJson(String str) => SentReplyModel.fromJson(json.decode(str));

String sentReplyModelToJson(SentReplyModel data) => json.encode(data.toJson());

class SentReplyModel {
  String? success;
  String? description;

  SentReplyModel({
     this.success,
     this.description,
  });

  factory SentReplyModel.fromJson(Map<String, dynamic> json) => SentReplyModel(
    success: json["success"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "description": description,
  };
}
