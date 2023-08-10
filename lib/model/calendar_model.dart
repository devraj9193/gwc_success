// To parse this JSON data, do
//
//     final calendarModel = calendarModelFromJson(jsonString);

import 'dart:convert';

CalendarModel calendarModelFromJson(String str) =>
    CalendarModel.fromJson(json.decode(str));

String calendarModelToJson(CalendarModel data) => json.encode(data.toJson());

class CalendarModel {
  CalendarModel({
    this.status,
    this.errorCode,
    this.data,
    this.followUpSchedule,
  });

  int? status;
  int? errorCode;
  List<Meeting>? data;
  List<FollowUpSchedule>? followUpSchedule;

  factory CalendarModel.fromJson(Map<String, dynamic> json) => CalendarModel(
    status: json["status"],
    errorCode: json["errorCode"],
    data: List<Meeting>.from(json["data"].map((x) => Meeting.fromJson(x))),
    followUpSchedule: List<FollowUpSchedule>.from(json['follow_up_schedule']
        .map((x) => FollowUpSchedule.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "errorCode": errorCode,
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
    'follow_up_schedule':
    List<dynamic>.from(followUpSchedule!.map((x) => x.toJson())),
  };
}

class Meeting {
  Meeting({
    required this.userId,
    required this.type,
    required this.title,
    required this.date,
    required this.start,
    required this.end,
    required this.color,
    required this.allDay,
  });

  int userId;
  String title;
  String type;
  DateTime date;
  DateTime start;
  DateTime end;
  String color;
  bool allDay;

  factory Meeting.fromJson(Map<String, dynamic> json) => Meeting(
    userId: json['user_id'],
    type: json['type'].toString(),
    title: json["title"],
    date: DateTime.parse(json["date"]),
    start: DateTime.parse(json["start"]),
    end: DateTime.parse(json["end"]),
    color: json["color"],
    allDay: json["allDay"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    'type': type,
    "title": title,
    "date":
    "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
    "start": start.toIso8601String(),
    "end": end.toIso8601String(),
    "color": color,
    "allDay": allDay,
  };
}

class FollowUpSchedule {
  int? id;
  int? teamPatientId;
  String? date;
  String? slotStartTime;
  String? slotEndTime;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? type;
  TeamPatients? teamPatients;

  FollowUpSchedule({
    this.id,
    this.teamPatientId,
    this.date,
    this.slotStartTime,
    this.slotEndTime,
    this.createdAt,
    this.updatedAt,
    this.type,
    this.teamPatients,
  });

  factory FollowUpSchedule.fromJson(Map<String, dynamic> json) =>
      FollowUpSchedule(
        id: json["id"],
        teamPatientId: json["team_patient_id"],
        date: json["date"],
        slotStartTime: json["slot_start_time"],
        slotEndTime: json["slot_end_time"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        type: json["type"],
        teamPatients: TeamPatients.fromJson(json["team_patients"]),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "team_patient_id": teamPatientId,
    "date": date,
    "slot_start_time": slotStartTime,
    "slot_end_time": slotEndTime,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "type": type,
    "team_patients": teamPatients?.toJson(),
  };
}

class TeamPatients {
  TeamPatients({
    this.id,
    this.teamId,
    this.patientId,
    this.programId,
    this.assignedDate,
    this.uploadTime,
    this.status,
    this.isArchieved,
    this.createdAt,
    this.updatedAt,
    this.appointmentDate,
    this.appointmentTime,
    this.updateDate,
    this.updateTime,
    this.manifestUrl,
    this.labelUrl,
    this.patient,
    this.appointments,
  });

  int? id;
  String? teamId;
  String? patientId;
  String? programId;
  String? assignedDate;
  String? uploadTime;
  String? status;
  String? isArchieved;
  String? createdAt;
  String? updatedAt;
  String? appointmentDate;
  String? appointmentTime;
  String? updateDate;
  String? updateTime;
  String? manifestUrl;
  String? labelUrl;
  Patient? patient;
  List<dynamic>? appointments;

  factory TeamPatients.fromJson(Map<String, dynamic> json) => TeamPatients(
    id: json["id"],
    teamId: json["team_id"].toString(),
    patientId: json["patient_id"].toString(),
    programId: json["program_id"].toString(),
    assignedDate: json["assigned_date"].toString(),
    uploadTime: json["upload_time"].toString(),
    status: json["status"].toString(),
    isArchieved: json["is_archieved"].toString(),
    createdAt: json["created_at"].toString(),
    updatedAt: json["updated_at"].toString(),
    appointmentDate: json["appointment_date"].toString(),
    appointmentTime: json["appointment_time"].toString(),
    updateDate: json["update_date"].toString(),
    updateTime: json["update_time"].toString(),
    manifestUrl: json["manifest_url"].toString(),
    labelUrl: json["label_url"].toString(),
    patient: Patient.fromJson(json["patient"]),
    appointments: List<dynamic>.from(json["appointments"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "team_id": teamId,
    "patient_id": patientId,
    "program_id": programId,
    "assigned_date": assignedDate,
    "upload_time": uploadTime,
    "status": status,
    "is_archieved": isArchieved,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "appointment_date": appointmentDate,
    "appointment_time": appointmentTime,
    "update_date": updateDate,
    "update_time": updateTime,
    "manifest_url": manifestUrl,
    "label_url": labelUrl,
    "patient": patient?.toJson(),
    "appointments":
    List<dynamic>.from(appointments!.map((x) => x.toJson())),
  };
}

class Appointment {
  Appointment({
    this.id,
    this.teamPatientId,
    this.date,
    this.slotStartTime,
    this.slotEndTime,
    this.type,
    this.status,
    this.zoomJoinUrl,
    this.zoomStartUrl,
    this.zoomId,
    this.zoomPassword,
    this.createdAt,
    this.updatedAt,
    this.appointmentDate,
    this.appointmentStartTime,
    this.teamPatients,
  });

  int? id;
  String? teamPatientId;
  String? date;
  String? slotStartTime;
  String? slotEndTime;
  String? type;
  String? status;
  String? zoomJoinUrl;
  String? zoomStartUrl;
  String? zoomId;
  String? zoomPassword;
  String? createdAt;
  String? updatedAt;
  String? appointmentDate;
  String? appointmentStartTime;
  TeamPatients? teamPatients;

  factory Appointment.fromJson(Map<String, dynamic> json) => Appointment(
    id: json["id"],
    teamPatientId: json["team_patient_id"].toString(),
    date: json["date"].toString(),
    slotStartTime: json["slot_start_time"].toString(),
    slotEndTime: json["slot_end_time"].toString(),
    type: json["type"].toString(),
    status: json["status"].toString(),
    zoomJoinUrl: json["zoom_join_url"].toString(),
    zoomStartUrl: json["zoom_start_url"].toString(),
    zoomId: json["zoom_id"].toString(),
    zoomPassword: json["zoom_password"].toString(),
    createdAt: json["created_at"].toString(),
    updatedAt: json["updated_at"].toString(),
    appointmentDate: json["appointment_date"].toString(),
    appointmentStartTime: json["appointment_start_time"].toString(),
    teamPatients: TeamPatients.fromJson(json["team_patients"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "team_patient_id": teamPatientId,
    "date": date,
    "slot_start_time": slotStartTime,
    "slot_end_time": slotEndTime,
    "type": type,
    "status": status,
    "zoom_join_url": zoomJoinUrl,
    "zoom_start_url": zoomStartUrl,
    "zoom_id": zoomId,
    "zoom_password": zoomPassword,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "appointment_date": appointmentDate,
    "appointment_start_time": appointmentStartTime,
    "team_patients": teamPatients?.toJson(),
  };
}

class DocumentUpload {
  DocumentUpload({
    this.id,
    this.teamId,
    this.patientId,
    this.programId,
    this.assignedDate,
    this.uploadTime,
    this.status,
    this.isArchieved,
    this.createdAt,
    this.updatedAt,
    this.appointmentDate,
    this.appointmentTime,
    this.updateDate,
    this.updateTime,
    this.manifestUrl,
    this.labelUrl,
    this.appointments,
    this.patient,
  });

  int? id;
  String? teamId;
  String? patientId;
  String? programId;
  String? assignedDate;
  String? uploadTime;
  String? status;
  String? isArchieved;
  String? createdAt;
  String? updatedAt;
  String? appointmentDate;
  String? appointmentTime;
  String? updateDate;
  String? updateTime;
  String? manifestUrl;
  String? labelUrl;
  List<dynamic>? appointments;
  Patient? patient;

  factory DocumentUpload.fromJson(Map<String, dynamic> json) => DocumentUpload(
    id: json["id"],
    teamId: json["team_id"].toString(),
    patientId: json["patient_id"].toString(),
    programId: json["program_id"].toString(),
    assignedDate: json["assigned_date"].toString(),
    uploadTime: json["upload_time"].toString(),
    status: json["status"].toString(),
    isArchieved: json["is_archieved"].toString(),
    createdAt: json["created_at"].toString(),
    updatedAt: json["updated_at"].toString(),
    appointmentDate: json["appointment_date"].toString(),
    appointmentTime: json["appointment_time"].toString(),
    updateDate: json["update_date"].toString(),
    updateTime: json["update_time"].toString(),
    manifestUrl: json["manifest_url"].toString(),
    labelUrl: json["label_url"].toString(),
    appointments: List<dynamic>.from(json["appointments"].map((x) => x)),
    patient: Patient.fromJson(json["patient"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "team_id": teamId,
    "patient_id": patientId,
    "program_id": programId,
    "assigned_date": assignedDate,
    "upload_time": uploadTime,
    "status": status,
    "is_archieved": isArchieved,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "appointment_date": appointmentDate,
    "appointment_time": appointmentTime,
    "update_date": updateDate,
    "update_time": updateTime,
    "manifest_url": manifestUrl,
    "label_url": labelUrl,
    "appointments":
    List<dynamic>.from(appointments!.map((x) => x.toJson())),
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
    this.user,
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
  User? user;

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
    user: User.fromJson(json["user"]),
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
    "user": user?.toJson(),
  };
}

class User {
  User({
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
    this.deviceType,
    this.deviceId,
    this.age,
    this.pincode,
    this.isActive,
    this.addedBy,
    this.createdAt,
    this.updatedAt,
    this.signupDate,
  });

  int? id;
  String? roleId;
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
  String? deviceType;
  String? deviceId;
  String? age;
  String? pincode;
  String? isActive;
  String? addedBy;
  String? createdAt;
  String? updatedAt;
  String? signupDate;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    roleId: json["role_id"].toString(),
    name: json["name"].toString(),
    fname: json["fname"].toString(),
    lname: json["lname"].toString(),
    email: json["email"].toString(),
    emailVerifiedAt: json["email_verified_at"].toString(),
    countryCode: json["country_code"].toString(),
    phone: json["phone"].toString(),
    gender: json["gender"].toString(),
    profile: json["profile"].toString(),
    address: json["address"].toString(),
    otp: json["otp"].toString(),
    deviceToken: json["device_token"].toString(),
    deviceType: json["device_type"].toString(),
    deviceId: json["device_id"].toString(),
    age: json["age"].toString(),
    pincode: json["pincode"].toString(),
    isActive: json["is_active"].toString(),
    addedBy: json["added_by"].toString(),
    createdAt: json["created_at"].toString(),
    updatedAt: json["updated_at"].toString(),
    signupDate: json["signup_date"].toString(),
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
    "device_type": deviceType,
    "device_id": deviceId,
    "age": age,
    "pincode": pincode,
    "is_active": isActive,
    "added_by": addedBy,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "signup_date": signupDate,
  };
}
