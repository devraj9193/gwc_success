// To parse this JSON data, do
//
//     final claimedCustomerListModel = claimedCustomerListModelFromJson(jsonString);

import 'dart:convert';

ClaimedCustomerListModel claimedCustomerListModelFromJson(String str) => ClaimedCustomerListModel.fromJson(json.decode(str));

String claimedCustomerListModelToJson(ClaimedCustomerListModel data) => json.encode(data.toJson());

class ClaimedCustomerListModel {
  int? status;
  int? errorCode;
  String? key;
  List<ClaimedCustomer>? data;

  ClaimedCustomerListModel({
    this.status,
    this.errorCode,
    this.key,
    this.data,
  });

  factory ClaimedCustomerListModel.fromJson(Map<String, dynamic> json) => ClaimedCustomerListModel(
    status: json["status"],
    errorCode: json["errorCode"],
    key: json["key"],
    data: List<ClaimedCustomer>.from(json["data"].map((x) => ClaimedCustomer.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "errorCode": errorCode,
    "key": key,
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class ClaimedCustomer {
  int? id;
  int? roleId;
  String? name;
  String? fname;
  String? lname;
  String? email;
  String? emailVerifiedAt;
  String? countryCode;
  String? phone;
  String? gender;
  String? profile;
  String? address;
  String? otp;
  String? deviceToken;
  String? webDeviceToken;
  String? deviceType;
  String? deviceId;
  String? age;
  String? kaleyraUserId;
  String? chatId;
  String? loginUsername;
  String? pincode;
  String? isDoctorAdmin;
  String? underAdminDoctor;
  String? successUserId;
  String? cetUserId;
  String? cetCompleted;
  String? isActive;
  String? addedBy;
  String? createdAt;
  String? updatedAt;
  String? signupDate;

  ClaimedCustomer({
     this.id,
     this.roleId,
     this.name,
     this.fname,
     this.lname,
     this.email,
    this.emailVerifiedAt,
     this.countryCode,
     this.phone,
     this.gender,
     this.profile,
     this.address,
    this.otp,
     this.deviceToken,
    this.webDeviceToken,
    this.deviceType,
    this.deviceId,
     this.age,
     this.kaleyraUserId,
    this.chatId,
    this.loginUsername,
     this.pincode,
     this.isDoctorAdmin,
    this.underAdminDoctor,
     this.successUserId,
     this.cetUserId,
    this.cetCompleted,
     this.isActive,
    this.addedBy,
     this.createdAt,
     this.updatedAt,
     this.signupDate,
  });

  factory ClaimedCustomer.fromJson(Map<String, dynamic> json) => ClaimedCustomer(
    id: json["id"],
    roleId: json["role_id"],
    name: json["name"],
    fname: json["fname"].toString(),
    lname: json["lname"].toString(),
    email: json["email"],
    emailVerifiedAt: json["email_verified_at"],
    countryCode: json["country_code"],
    phone: json["phone"],
    gender: json["gender"],
    profile: json["profile"],
    address: json["address"],
    otp: json["otp"].toString(),
    deviceToken: json["device_token"],
    webDeviceToken: json["web_device_token"],
    deviceType: json["device_type"],
    deviceId: json["device_id"],
    age: json["age"],
    kaleyraUserId: json["kaleyra_user_id"],
    chatId: json["chat_id"],
    loginUsername: json["login_username"],
    pincode: json["pincode"],
    isDoctorAdmin: json["is_doctor_admin"].toString(),
    underAdminDoctor: json["under_admin_doctor"],
    successUserId: json["success_user_id"],
    cetUserId: json["cet_user_id"],
    cetCompleted: json["cet_completed"],
    isActive: json["is_active"].toString(),
    addedBy: json["added_by"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    signupDate: json["signup_date"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "role_id": roleId,
    "name": name,
    "fname": fname,
    "lname": lname,
    "email": email,
    "email_verified_at": emailVerifiedAt,
    "country_code": countryCode,
    "phone": phone,
    "gender": gender,
    "profile": profile,
    "address": address,
    "otp": otp,
    "device_token": deviceToken,
    "web_device_token": webDeviceToken,
    "device_type": deviceType,
    "device_id": deviceId,
    "age": age,
    "kaleyra_user_id": kaleyraUserId,
    "chat_id": chatId,
    "login_username": loginUsername,
    "pincode": pincode,
    "is_doctor_admin": isDoctorAdmin,
    "under_admin_doctor": underAdminDoctor,
    "success_user_id": successUserId,
    "cet_user_id": cetUserId,
    "cet_completed": cetCompleted,
    "is_active": isActive,
    "added_by": addedBy,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "signup_date": signupDate,
  };
}
