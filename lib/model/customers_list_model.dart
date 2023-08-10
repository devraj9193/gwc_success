// To parse this JSON data, do
//
//     final customersList = customersListFromJson(jsonString);

import 'dart:convert';

import 'meal_active_model.dart';

CustomersList customersListFromJson(String str) =>
    CustomersList.fromJson(json.decode(str));

String customersListToJson(CustomersList data) => json.encode(data.toJson());

class CustomersList {
  CustomersList({
    required this.status,
    required this.errorCode,
    required this.key,
    required this.data,
  });

  int status;
  int errorCode;
  String key;
  List<Datum> data;

  factory CustomersList.fromJson(Map<String, dynamic> json) => CustomersList(
        status: json["status"],
        errorCode: json["errorCode"],
        key: json["key"].toString(),
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "errorCode": errorCode,
        "key": key,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    required this.id,
    this.fname,
    this.lname,
    this.phone,
    this.date,
    this.time,
    this.profile,
    this.team,
    this.kaleyraUserId,
  });

  int id;
  String? fname;
  String? lname;
  String? phone;
  String? date;
  String? time;
  String? profile;
  Team? team;
  String? kaleyraUserId;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        fname: json["fname"].toString(),
        lname: json["lname"].toString(),
        phone: json["phone"].toString(),
        date: json["date"].toString(),
        time: json["time"].toString(),
        profile: json["profile"].toString(),
        team: (json['team'] == null || json['team'].runtimeType == int)
            ? null
            : Team.fromJson(json["team"]),
        kaleyraUserId: json["kaleyra_user_id"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "fname": fname,
        "lname": lname,
        "phone": phone,
        "date": date,
        "time": time,
        "profile": profile,
        "team": team,
        "kaleyra_user_id": kaleyraUserId,
      };
}

class Team {
  Team({
    this.id,
    this.teamPatientId,
    this.date,
    this.slotStartTime,
    this.slotEndTime,
    this.type,
    this.status,
    this.kaleyraUserUrl,
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
  String? kaleyraUserUrl;
  String? createdAt;
  String? updatedAt;
  String? appointmentDate;
  String? appointmentStartTime;
  TeamPatients? teamPatients;

  factory Team.fromJson(Map<String, dynamic> json) => Team(
        id: json["id"],
        teamPatientId: json["team_patient_id"].toString(),
        date: json["date"].toString(),
        slotStartTime: json["slot_start_time"].toString(),
        slotEndTime: json["slot_end_time"].toString(),
        type: json["type"].toString(),
        status: json["status"].toString(),
        kaleyraUserUrl: json["kaleyra_user_url"].toString(),
        createdAt: json["created_at"].toString(),
        updatedAt: json["updated_at"].toString(),
        appointmentDate: json["appointment_date"].toString(),
        appointmentStartTime: json["appointment_start_time"].toString(),
        teamPatients: json["team_patients"] != null
            ? TeamPatients.fromJson(json["team_patients"])
            : null,
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
        "created_at": createdAt,
        "updated_at": updatedAt,
        "appointment_date": appointmentDate,
        "appointment_start_time": appointmentStartTime,
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
    this.initialTeam,
    this.isArchieved,
    this.createdAt,
    this.updatedAt,
    this.appointmentDate,
    this.appointmentTime,
    this.updateDate,
    this.updateTime,
    this.manifestUrl,
    this.labelUrl,
    this.team,
    this.appointments,
  });

  int? id;
  String? teamId;
  String? patientId;
  String? programId;
  String? assignedDate;
  String? uploadTime;
  String? status;
  String? initialTeam;
  String? isArchieved;
  String? createdAt;
  String? updatedAt;
  String? appointmentDate;
  String? appointmentTime;
  String? updateDate;
  String? updateTime;
  String? manifestUrl;
  String? labelUrl;
  PurpleTeam? team;
  List<Appointment>? appointments;

  factory TeamPatients.fromJson(Map<String, dynamic> json) => TeamPatients(
        id: json["id"],
        teamId: json["team_id"].toString(),
        patientId: json["patient_id"].toString(),
        programId: json["program_id"].toString(),
        assignedDate: json["assigned_date"].toString(),
        uploadTime: json["upload_time"].toString(),
        status: json["status"].toString(),
        initialTeam: json["initial_team"].toString(),
        isArchieved: json["is_archieved"].toString(),
        createdAt: json["created_at"].toString(),
        updatedAt: json["updated_at"].toString(),
        appointmentDate: json["appointment_date"].toString(),
        appointmentTime: json["appointment_time"].toString(),
        updateDate: json["update_date"].toString(),
        updateTime: json["update_time"].toString(),
        manifestUrl: json["manifest_url"].toString(),
        labelUrl: json["label_url"].toString(),
        team: PurpleTeam.fromJson(json["team"]),
        appointments: List<Appointment>.from(
            json["appointments"].map((x) => Appointment.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "team_id": teamId,
        "patient_id": patientId,
        "program_id": programId,
        "assigned_date": assignedDate,
        "upload_time": uploadTime,
        "status": status,
        "initial_team": initialTeam,
        "is_archieved": isArchieved,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "appointment_date": appointmentDate,
        "appointment_time": appointmentTime,
        "update_date": updateDate,
        "update_time": updateTime,
        "manifest_url": manifestUrl,
        "label_url": labelUrl,
        "team": team?.toJson(),
        "appointments":
            List<dynamic>.from(appointments!.map((x) => x.toJson())),
      };
}

class PurpleTeam {
  PurpleTeam({
    this.id,
    this.teamName,
    this.shiftId,
    this.slotsPerDay,
    this.isArchieved,
    this.createdAt,
    this.updatedAt,
    this.teamMember,
  });

  int? id;
  String? teamName;
  String? shiftId;
  String? slotsPerDay;
  String? isArchieved;
  String? createdAt;
  String? updatedAt;
  List<TeamMember>? teamMember;

  factory PurpleTeam.fromJson(Map<String, dynamic> json) => PurpleTeam(
        id: json["id"],
        teamName: json["team_name"].toString(),
        shiftId: json["shift_id"].toString(),
        slotsPerDay: json["slots_per_day"].toString(),
        isArchieved: json["is_archieved"].toString(),
        createdAt: json["created_at"].toString(),
        updatedAt: json["updated_at"].toString(),
        teamMember: List<TeamMember>.from(
            json["team_member"].map((x) => TeamMember.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "team_name": teamName,
        "shift_id": shiftId,
        "slots_per_day": slotsPerDay,
        "is_archieved": isArchieved,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "team_member": List<dynamic>.from(teamMember!.map((x) => x.toJson())),
      };
}

class TeamMember {
  TeamMember({
    this.id,
    this.teamId,
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  int? id;
  String? teamId;
  String? userId;
  String? createdAt;
  String? updatedAt;
  User? user;

  factory TeamMember.fromJson(Map<String, dynamic> json) => TeamMember(
        id: json["id"],
        teamId: json["team_id"].toString(),
        userId: json["user_id"].toString(),
        createdAt: json["created_at"].toString(),
        updatedAt: json["updated_at"].toString(),
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "team_id": teamId,
        "user_id": userId,
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
    this.kaleyraUserId,
    this.chatId,
    this.loginUsername,
    this.pincode,
    this.isDoctorAdmin,
    this.underAdminDoctor,
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
  String? kaleyraUserId;
  String? chatId;
  String? loginUsername;
  String? pincode;
  String? isDoctorAdmin;
  String? underAdminDoctor;
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
        kaleyraUserId: json["kaleyra_user_id"].toString(),
        chatId: json["chat_id"].toString(),
        loginUsername: json["login_username"].toString(),
        pincode: json["pincode"].toString(),
        isDoctorAdmin: json["is_doctor_admin"].toString(),
        underAdminDoctor: json["under_admin_doctor"].toString(),
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
        "kaleyra_user_id": kaleyraUserId,
        "chat_id": chatId,
        "login_username": loginUsername,
        "pincode": pincode,
        "is_doctor_admin": isDoctorAdmin,
        "under_admin_doctor": underAdminDoctor,
        "is_active": isActive,
        "added_by": addedBy,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "signup_date": signupDate,
      };
}
