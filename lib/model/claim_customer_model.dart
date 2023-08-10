// To parse this JSON data, do
//
//     final claimCustomerModel = claimCustomerModelFromJson(jsonString);

import 'dart:convert';

ClaimCustomerModel claimCustomerModelFromJson(String str) => ClaimCustomerModel.fromJson(json.decode(str));

String claimCustomerModelToJson(ClaimCustomerModel data) => json.encode(data.toJson());

class ClaimCustomerModel {
  int? status;
  int? errorCode;
  String? message;

  ClaimCustomerModel({
    this.status,
    this.errorCode,
    this.message,
  });

  factory ClaimCustomerModel.fromJson(Map<String, dynamic> json) => ClaimCustomerModel(
    status: json["status"],
    errorCode: json["errorCode"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "errorCode": errorCode,
    "message": message,
  };
}
