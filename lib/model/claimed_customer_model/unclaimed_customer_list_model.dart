// To parse this JSON data, do
//
//     final unClaimedCustomerList = unClaimedCustomerListFromJson(jsonString);

import 'dart:convert';

UnClaimedCustomerList unClaimedCustomerListFromJson(String str) => UnClaimedCustomerList.fromJson(json.decode(str));

String unClaimedCustomerListToJson(UnClaimedCustomerList data) => json.encode(data.toJson());

class UnClaimedCustomerList {
  int? status;
  int? errorCode;
  List<NotClaimedCustomer>? notClaimedCustomer;

  UnClaimedCustomerList({
    this.status,
    this.errorCode,
    this.notClaimedCustomer,
  });

  factory UnClaimedCustomerList.fromJson(Map<String, dynamic> json) => UnClaimedCustomerList(
    status: json["status"],
    errorCode: json["errorCode"],
    notClaimedCustomer: List<NotClaimedCustomer>.from(json["not_claimed_customer"].map((x) => NotClaimedCustomer.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "errorCode": errorCode,
    "not_claimed_customer": List<dynamic>.from(notClaimedCustomer!.map((x) => x.toJson())),
  };
}

class NotClaimedCustomer {
  String? name;
  String? email;
  String? countryCode;
  String? phone;
  String? gender;
  String? age;
  int? userId;
  String? signupDate;
  Patient? patient;

  NotClaimedCustomer({
    this.name,
    this.email,
    this.countryCode,
    this.phone,
    this.gender,
    this.age,
    this.userId,
    this.signupDate,
    this.patient,
  });

  factory NotClaimedCustomer.fromJson(Map<String, dynamic> json) => NotClaimedCustomer(
    name: json["name"],
    email: json["email"],
    countryCode: json["country_code"],
    phone: json["phone"],
    gender: json["gender"],
    age: json["age"],
    userId: json["user_id"],
    signupDate: json["signup_date"],
    patient: Patient.fromJson(json["patient"]),

  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "country_code": countryCode,
    "phone": phone,
    "gender": gender,
    "age": age,
    "user_id": userId,
    "signup_date": signupDate,
    "patient": patient?.toJson(),
  };
}

class Patient {
  Patient({
    this.id,
    this.userId,
    this.maritalStatus,
    this.address2,
    this.city,
    this.state,
    this.country,
    this.weight,
    this.status,
    this.isArchieved,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? userId;
  String? maritalStatus;
  String? address2;
  String? city;
  String? state;
  String? country;
  String? weight;
  String? status;
  String? isArchieved;
  String? createdAt;
  String? updatedAt;

  factory Patient.fromJson(Map<String, dynamic> json) => Patient(
    id: json["id"],
    userId: json["user_id"].toString(),
    maritalStatus: json["marital_status"].toString(),
    address2: json["address2"].toString(),
    city: json["city"].toString(),
    state: json["state"].toString(),
    country: json["country"].toString(),
    weight: json["weight"].toString(),
    status: json["status"].toString(),
    isArchieved: json["is_archieved"].toString(),
    createdAt: json["created_at"].toString(),
    updatedAt: json["updated_at"].toString(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "marital_status": maritalStatus,
    "address2": address2,
    "city": city,
    "state": state,
    "country": country,
    "weight": weight,
    "status": status,
    "is_archieved": isArchieved,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}

