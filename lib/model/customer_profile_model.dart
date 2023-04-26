// To parse this JSON data, do
//
//     final getCustomerModel = getCustomerModelFromJson(jsonString);

import 'dart:convert';

GetCustomerModel getCustomerModelFromJson(String str) =>
    GetCustomerModel.fromJson(json.decode(str));

String getCustomerModelToJson(GetCustomerModel data) =>
    json.encode(data.toJson());

class GetCustomerModel {
  GetCustomerModel({
    this.status,
    this.errorCode,
    this.key,
    this.username,
    this.age,
    this.profile,
    this.consultationDateAndTime,
    this.programName,
    this.mealAndYogaPlan,
    this.mrReport,
    this.caseSheet,
  });

  int? status;
  int? errorCode;
  String? key;
  String? username;
  String? age;
  String? profile;
  ConsultationDateAndTime? consultationDateAndTime;
  MealAndYogaPlan? programName;
  MealAndYogaPlan? mealAndYogaPlan;
  CaseSheet? mrReport;
  CaseSheet? caseSheet;

  factory GetCustomerModel.fromJson(Map<String, dynamic> json) =>
      GetCustomerModel(
        status: json["status"],
        errorCode: json["errorCode"],
        key: json["key"],
        username: json["username"],
        age: json["age"],
        profile: json["profile"],
        consultationDateAndTime: json["consultation_date_and_time"] != null
            ? ConsultationDateAndTime.fromJson(json["consultation_date_and_time"])
            : null,
        programName: json["program_name"] != null
            ? MealAndYogaPlan.fromJson(json["program_name"])
            : null,
        mealAndYogaPlan: json["meal_and_yoga_plan"] != null
            ? MealAndYogaPlan.fromJson(json["meal_and_yoga_plan"])
            : null,
        mrReport: json["mr_report"] != null
            ? CaseSheet.fromJson(json["mr_report"])
            : null,
        caseSheet: json["case_sheet"] != null
            ? CaseSheet.fromJson(json["case_sheet"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "status": status ?? "",
        "errorCode": errorCode ?? "",
        "key": key ?? "",
        "username": username ?? "",
        "age": age ?? "",
        "profile": profile ?? "",
        "consultation_date_and_time": consultationDateAndTime?.toJson() ?? {},
        "program_name": programName?.toJson() ?? {},
        "meal_and_yoga_plan": mealAndYogaPlan?.toJson() ?? {},
        "mr_report": mrReport?.toJson() ?? {},
        "case_sheet": caseSheet?.toJson() ?? {},
      };
}

class CaseSheet {
  CaseSheet({
    this.id,
    this.doctorId,
    this.patientId,
    this.appointmentId,
    this.report,
    this.reportType,
    this.isArchieved,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? doctorId;
  String? patientId;
  String? appointmentId;
  String? report;
  String? reportType;
  String? isArchieved;
  String? createdAt;
  String? updatedAt;

  factory CaseSheet.fromJson(Map<String, dynamic> json) => CaseSheet(
        id: json["id"],
        doctorId: json["doctor_id"],
        patientId: json["patient_id"],
        appointmentId: json["appointment_id"],
        report: json["report"],
        reportType: json["report_type"],
        isArchieved: json["is_archieved"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "doctor_id": doctorId,
        "patient_id": patientId,
        "appointment_id": appointmentId,
        "report": report,
        "report_type": reportType,
        "is_archieved": isArchieved,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}

class ConsultationDateAndTime {
  ConsultationDateAndTime({
    this.id,
    this.teamPatientId,
    this.date,
    this.slotStartTime,
    this.slotEndTime,
    this.type,
    this.status,
    this.kaleyraUserUrl,
    this.userSuccessChatRoom,
    this.createdAt,
    this.updatedAt,
    this.appointmentDate,
    this.appointmentStartTime,
  });

  int? id;
  String? teamPatientId;
  String? date;
  String? slotStartTime;
  String? slotEndTime;
  String? type;
  String? status;
  String? kaleyraUserUrl;
  String? userSuccessChatRoom;
  String? createdAt;
  String? updatedAt;
  String? appointmentDate;
  String? appointmentStartTime;

  factory ConsultationDateAndTime.fromJson(Map<String, dynamic> json) =>
      ConsultationDateAndTime(
        id: json["id"],
        teamPatientId: json["team_patient_id"],
        date: json["date"],
        slotStartTime: json["slot_start_time"],
        slotEndTime: json["slot_end_time"],
        type: json["type"],
        status: json["status"],
        kaleyraUserUrl: json["kaleyra_user_url"],
        userSuccessChatRoom: json["user_success_chat_room"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        appointmentDate: json["appointment_date"],
        appointmentStartTime: json["appointment_start_time"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "team_patient_id": teamPatientId,
        "date": date,
        "slot_start_time": slotStartTime,
        "slot_end_time": slotEndTime,
        "type": type,
        "status": status,
        "kaleyra_user_url": kaleyraUserUrl,
        "user_success_chat_room": userSuccessChatRoom,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "appointment_date": appointmentDate,
        "appointment_start_time": appointmentStartTime,
      };
}

class MealAndYogaPlan {
  MealAndYogaPlan({
    this.id,
    this.issueId,
    this.name,
    this.noOfDays,
    this.desc,
    this.price,
    this.profile,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? issueId;
  String? name;
  String? noOfDays;
  String? desc;
  String? price;
  String? profile;
  String? createdAt;
  String? updatedAt;

  factory MealAndYogaPlan.fromJson(Map<String, dynamic> json) =>
      MealAndYogaPlan(
        id: json["id"],
        issueId: json["issue_id"],
        name: json["name"],
        noOfDays: json["no_of_days"],
        desc: json["desc"],
        price: json["price"],
        profile: json["profile"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "issue_id": issueId,
        "name": name,
        "no_of_days": noOfDays,
        "desc": desc,
        "price": price,
        "profile": profile,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
