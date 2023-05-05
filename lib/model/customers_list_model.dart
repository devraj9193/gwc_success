// To parse this JSON data, do
//
//     final customersList = customersListFromJson(jsonString);

import 'dart:convert';

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
        key: json["key"],
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
        fname: json["fname"],
        lname: json["lname"],
        phone: json["phone"],
        date: json["date"],
        time: json["time"],
        profile: json["profile"],
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
        teamPatientId: json["team_patient_id"],
        date: json["date"],
        slotStartTime: json["slot_start_time"],
        slotEndTime: json["slot_end_time"],
        type: json["type"],
        status: json["status"],
        kaleyraUserUrl: json["kaleyra_user_url"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        appointmentDate: json["appointment_date"],
        appointmentStartTime: json["appointment_start_time"],
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
    required this.id,
    required this.teamId,
    required this.patientId,
    this.programId,
    required this.assignedDate,
    required this.uploadTime,
    required this.status,
    this.initialTeam,
    required this.isArchieved,
    required this.createdAt,
    required this.updatedAt,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.updateDate,
    required this.updateTime,
    required this.manifestUrl,
    required this.labelUrl,
    required this.team,
    required this.appointments,
  });

  int id;
  String teamId;
  String patientId;
  dynamic programId;
  DateTime assignedDate;
  String uploadTime;
  String status;
  String? initialTeam;
  String isArchieved;
  DateTime createdAt;
  DateTime updatedAt;
  String appointmentDate;
  String appointmentTime;
  String updateDate;
  String updateTime;
  String manifestUrl;
  String labelUrl;
  PurpleTeam team;
  List<TeamElement> appointments;

  factory TeamPatients.fromJson(Map<String, dynamic> json) => TeamPatients(
        id: json["id"],
        teamId: json["team_id"],
        patientId: json["patient_id"],
        programId: json["program_id"],
        assignedDate: DateTime.parse(json["assigned_date"]),
        uploadTime: json["upload_time"],
        status: json["status"],
        initialTeam: json["initial_team"],
        isArchieved: json["is_archieved"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        appointmentDate: json["appointment_date"],
        appointmentTime: json["appointment_time"],
        updateDate: json["update_date"],
        updateTime: json["update_time"],
        manifestUrl: json["manifest_url"],
        labelUrl: json["label_url"],
        team: PurpleTeam.fromJson(json["team"]),
        appointments: List<TeamElement>.from(
            json["appointments"].map((x) => TeamElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "team_id": teamId,
        "patient_id": patientId,
        "program_id": programId,
        "assigned_date":
            "${assignedDate.year.toString().padLeft(4, '0')}-${assignedDate.month.toString().padLeft(2, '0')}-${assignedDate.day.toString().padLeft(2, '0')}",
        "upload_time": uploadTime,
        "status": status,
        "initial_team": initialTeam,
        "is_archieved": isArchieved,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "appointment_date": appointmentDate,
        "appointment_time": appointmentTime,
        "update_date": updateDate,
        "update_time": updateTime,
        "manifest_url": manifestUrl,
        "label_url": labelUrl,
        "team": team.toJson(),
        "appointments": List<dynamic>.from(appointments.map((x) => x.toJson())),
      };
}

class TeamElement {
  TeamElement({
    required this.id,
    required this.teamPatientId,
    required this.date,
    required this.slotStartTime,
    required this.slotEndTime,
    required this.type,
    required this.status,
    required this.kaleyraUserUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.appointmentDate,
    required this.appointmentStartTime,
    this.teamPatients,
  });

  int id;
  String teamPatientId;
  DateTime date;
  String slotStartTime;
  String slotEndTime;
  String type;
  String status;
  String kaleyraUserUrl;
  DateTime createdAt;
  DateTime updatedAt;
  String appointmentDate;
  String appointmentStartTime;
  TeamPatients? teamPatients;

  factory TeamElement.fromJson(Map<String, dynamic> json) => TeamElement(
        id: json["id"],
        teamPatientId: json["team_patient_id"],
        date: DateTime.parse(json["date"]),
        slotStartTime: json["slot_start_time"],
        slotEndTime: json["slot_end_time"],
        type: json["type"],
        status: json["status"],
        kaleyraUserUrl: json["kaleyra_user_url"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        appointmentDate: json["appointment_date"],
        appointmentStartTime: json["appointment_start_time"],
        teamPatients: json["team_patients"] == null
            ? null
            : TeamPatients.fromJson(json["team_patients"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "team_patient_id": teamPatientId,
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "slot_start_time": slotStartTime,
        "slot_end_time": slotEndTime,
        "type": type,
        "status": status,
        "kaleyra_user_url": kaleyraUserUrl,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "appointment_date": appointmentDate,
        "appointment_start_time": appointmentStartTime,
        "team_patients": teamPatients?.toJson(),
      };
}

class PurpleTeam {
  PurpleTeam({
    required this.id,
    required this.teamName,
    required this.shiftId,
    required this.slotsPerDay,
    required this.isArchieved,
    required this.createdAt,
    required this.updatedAt,
    required this.teamMember,
  });

  int id;
  String teamName;
  String shiftId;
  String slotsPerDay;
  String isArchieved;
  DateTime createdAt;
  DateTime updatedAt;
  List<TeamMember> teamMember;

  factory PurpleTeam.fromJson(Map<String, dynamic> json) => PurpleTeam(
        id: json["id"],
        teamName: json["team_name"],
        shiftId: json["shift_id"],
        slotsPerDay: json["slots_per_day"],
        isArchieved: json["is_archieved"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        teamMember: List<TeamMember>.from(
            json["team_member"].map((x) => TeamMember.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "team_name": teamName,
        "shift_id": shiftId,
        "slots_per_day": slotsPerDay,
        "is_archieved": isArchieved,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "team_member": List<dynamic>.from(teamMember.map((x) => x.toJson())),
      };
}

class TeamMember {
  TeamMember({
    required this.id,
    required this.teamId,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
  });

  int id;
  String teamId;
  String userId;
  DateTime createdAt;
  DateTime updatedAt;
  User user;

  factory TeamMember.fromJson(Map<String, dynamic> json) => TeamMember(
        id: json["id"],
        teamId: json["team_id"],
        userId: json["user_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "team_id": teamId,
        "user_id": userId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "user": user.toJson(),
      };
}

class User {
  User({
    required this.id,
    required this.roleId,
    required this.name,
    required this.fname,
    this.lname,
    required this.email,
    this.emailVerifiedAt,
    this.countryCode,
    this.phone,
    required this.gender,
    required this.profile,
    this.address,
    this.otp,
    this.deviceToken,
    this.deviceType,
    this.deviceId,
    this.age,
    required this.kaleyraUserId,
    required this.chatId,
    required this.loginUsername,
    this.pincode,
    required this.isDoctorAdmin,
    this.underAdminDoctor,
    required this.isActive,
    this.addedBy,
    this.createdAt,
    required this.updatedAt,
    this.signupDate,
  });

  int id;
  String roleId;
  String name;
  String fname;
  String? lname;
  String email;
  dynamic emailVerifiedAt;
  String? countryCode;
  String? phone;
  String gender;
  String profile;
  dynamic address;
  dynamic otp;
  String? deviceToken;
  dynamic deviceType;
  dynamic deviceId;
  String? age;
  String kaleyraUserId;
  String chatId;
  String loginUsername;
  dynamic pincode;
  String isDoctorAdmin;
  String? underAdminDoctor;
  String isActive;
  dynamic addedBy;
  DateTime? createdAt;
  DateTime updatedAt;
  String? signupDate;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        roleId: json["role_id"],
        name: json["name"],
        fname: json["fname"],
        lname: json["lname"],
        email: json["email"],
        emailVerifiedAt: json["email_verified_at"],
        countryCode: json["country_code"],
        phone: json["phone"],
        gender: json["gender"],
        profile: json["profile"],
        address: json["address"],
        otp: json["otp"],
        deviceToken: json["device_token"],
        deviceType: json["device_type"],
        deviceId: json["device_id"],
        age: json["age"],
        kaleyraUserId: json["kaleyra_user_id"],
        chatId: json["chat_id"],
        loginUsername: json["login_username"],
        pincode: json["pincode"],
        isDoctorAdmin: json["is_doctor_admin"],
        underAdminDoctor: json["under_admin_doctor"],
        isActive: json["is_active"],
        addedBy: json["added_by"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
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
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "signup_date": signupDate,
      };
}

// // To parse this JSON data, do
// //
// //     final customersList = customersListFromJson(jsonString);
//
// import 'dart:convert';
//
// CustomersList customersListFromJson(String str) =>
//     CustomersList.fromJson(json.decode(str));
//
// String customersListToJson(CustomersList data) => json.encode(data.toJson());
//
// class CustomersList {
//   CustomersList({
//     this.status,
//     this.errorCode,
//     this.key,
//     this.data,
//   });
//
//   int? status;
//   int? errorCode;
//   String? key;
//   List<Datum>? data;
//
//   factory CustomersList.fromJson(Map<String, dynamic> json) => CustomersList(
//         status: json["status"],
//         errorCode: json["errorCode"],
//         key: json["key"],
//         data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "status": status,
//         "errorCode": errorCode,
//         "key": key,
//         "data": List<dynamic>.from(data!.map((x) => x.toJson())),
//       };
// }
//
// class Datum {
//   Datum({
//     this.id,
//     this.fname,
//     this.lname,
//     this.date,
//     this.time,
//     this.profile,
//     this.team,
//   });
//
//   int? id;
//   String? fname;
//   String? lname;
//   String? date;
//   String? time;
//   String? profile;
//   Team? team;
//
//   factory Datum.fromJson(Map<String, dynamic> json) => Datum(
//         id: json["id"],
//         fname: json["fname"],
//         lname: json["lname"],
//         date: json["date"],
//         time: json["time"],
//         profile: json["profile"],
//         team: (json['team'] == null || json['team'].runtimeType == int)
//             ? null
//             : Team.fromJson(json["team"]),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "fname": fname,
//         "lname": lname,
//         "date": date,
//         "time": time,
//         "profile": profile,
//         "team": team?.toJson(),
//       };
// }
//
// class Team {
//   Team({
//     this.id,
//     this.teamPatientId,
//     this.date,
//     this.slotStartTime,
//     this.slotEndTime,
//     this.type,
//     this.status,
//     this.kaleyraUserUrl,
//     this.createdAt,
//     this.updatedAt,
//     this.appointmentDate,
//     this.appointmentStartTime,
//     this.teamPatients,
//   });
//
//   int? id;
//   String? teamPatientId;
//   String? date;
//   String? slotStartTime;
//   String? slotEndTime;
//   String? type;
//   String? status;
//   String? kaleyraUserUrl;
//   String? createdAt;
//   String? updatedAt;
//   String? appointmentDate;
//   String? appointmentStartTime;
//   TeamPatients? teamPatients;
//
//   factory Team.fromJson(Map<String, dynamic> json) => Team(
//         id: json["id"],
//         teamPatientId: json["team_patient_id"],
//         date: json["date"],
//         slotStartTime: json["slot_start_time"],
//         slotEndTime: json["slot_end_time"],
//         type: json["type"],
//         status: json["status"],
//         kaleyraUserUrl: json["kaleyra_user_url"],
//         createdAt: json["created_at"],
//         updatedAt: json["updated_at"],
//         appointmentDate: json["appointment_date"],
//         appointmentStartTime: json["appointment_start_time"],
//         teamPatients: json["team_patients"] == null
//             ? null
//             : TeamPatients.fromJson(json["team_patients"]),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "team_patient_id": teamPatientId,
//         "date": date,
//         "slot_start_time": slotStartTime,
//         "slot_end_time": slotEndTime,
//         "type": type,
//         "status": status,
//         "kaleyra_user_url": kaleyraUserUrl,
//         "created_at": createdAt,
//         "updated_at": updatedAt,
//         "appointment_date": appointmentDate,
//         "appointment_start_time": appointmentStartTime,
//         "team_patients": teamPatients?.toJson(),
//       };
// }
//
// class TeamPatients {
//   TeamPatients({
//     this.id,
//     this.teamId,
//     this.patientId,
//     this.programId,
//     this.assignedDate,
//     this.uploadTime,
//     this.status,
//     this.initialTeam,
//     this.isArchieved,
//     this.createdAt,
//     this.updatedAt,
//     this.appointmentDate,
//     this.appointmentTime,
//     this.updateDate,
//     this.updateTime,
//     this.manifestUrl,
//     this.labelUrl,
//     this.team,
//     this.appointments,
//   });
//
//   int? id;
//   String? teamId;
//   String? patientId;
//   String? programId;
//   String? assignedDate;
//   String? uploadTime;
//   String? status;
//   String? initialTeam;
//   String? isArchieved;
//   String? createdAt;
//   String? updatedAt;
//   String? appointmentDate;
//   String? appointmentTime;
//   String? updateDate;
//   String? updateTime;
//   String? manifestUrl;
//   String? labelUrl;
//   PurpleTeam? team;
//   List<Appointment>? appointments;
//
//   factory TeamPatients.fromJson(Map<String, dynamic> json) => TeamPatients(
//         id: json["id"],
//         teamId: json["team_id"],
//         patientId: json["patient_id"],
//         programId: json["program_id"],
//         assignedDate: json["assigned_date"],
//         uploadTime: json["upload_time"],
//         status: json["status"],
//         initialTeam: json["initial_team"],
//         isArchieved: json["is_archieved"],
//         createdAt: json["created_at"],
//         updatedAt: json["updated_at"],
//         appointmentDate: json["appointment_date"],
//         appointmentTime: json["appointment_time"],
//         updateDate: json["update_date"],
//         updateTime: json["update_time"],
//         manifestUrl: json["manifest_url"],
//         labelUrl: json["label_url"],
//         team: PurpleTeam.fromJson(json["team"]),
//         appointments: List<Appointment>.from(
//             json["appointments"].map((x) => Appointment.fromJson(x))),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "team_id": teamId,
//         "patient_id": patientId,
//         "program_id": programId,
//         "assigned_date": assignedDate,
//         "upload_time": uploadTime,
//         "status": status,
//         "initial_team": initialTeam,
//         "is_archieved": isArchieved,
//         "created_at": createdAt,
//         "updated_at": updatedAt,
//         "appointment_date": appointmentDate,
//         "appointment_time": appointmentTime,
//         "update_date": updateDate,
//         "update_time": updateTime,
//         "manifest_url": manifestUrl,
//         "label_url": labelUrl,
//         "team": team?.toJson(),
//         "appointments":
//             List<Appointment>.from(appointments!.map((x) => x.toJson())),
//       };
// }
//
// class PurpleTeam {
//   PurpleTeam({
//     required this.id,
//     required this.teamName,
//     required this.shiftId,
//     required this.slotsPerDay,
//     required this.isArchieved,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.teamMember,
//   });
//
//   int? id;
//   String? teamName;
//   String? shiftId;
//   String? slotsPerDay;
//   String? isArchieved;
//   String? createdAt;
//   String? updatedAt;
//   List<TeamMember> teamMember;
//
//   factory PurpleTeam.fromJson(Map<String, dynamic> json) => PurpleTeam(
//         id: json["id"],
//         teamName: json["team_name"],
//         shiftId: json["shift_id"],
//         slotsPerDay: json["slots_per_day"],
//         isArchieved: json["is_archieved"],
//         createdAt: json["created_at"],
//         updatedAt: json["updated_at"],
//         teamMember: List<TeamMember>.from(
//             json["team_member"].map((x) => TeamMember.fromJson(x))),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "team_name": teamName,
//         "shift_id": shiftId,
//         "slots_per_day": slotsPerDay,
//         "is_archieved": isArchieved,
//         "created_at": createdAt,
//         "updated_at": updatedAt,
//         "team_member": List<dynamic>.from(teamMember.map((x) => x.toJson())),
//       };
// }
//
// class TeamMember {
//   TeamMember({
//     this.id,
//     this.teamId,
//     this.userId,
//     this.createdAt,
//     this.updatedAt,
//     this.user,
//   });
//
//   int? id;
//   String? teamId;
//   String? userId;
//   String? createdAt;
//   String? updatedAt;
//   User? user;
//
//   factory TeamMember.fromJson(Map<String, dynamic> json) => TeamMember(
//         id: json["id"],
//         teamId: json["team_id"],
//         userId: json["user_id"],
//         createdAt: json["created_at"],
//         updatedAt: json["updated_at"],
//         user: User.fromJson(json["user"]),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "team_id": teamId,
//         "user_id": userId,
//         "created_at": createdAt,
//         "updated_at": updatedAt,
//         "user": user?.toJson(),
//       };
// }
//
// class User {
//   User({
//     this.id,
//     this.roleId,
//     this.name,
//     this.fname,
//     this.lname,
//     this.email,
//     this.emailVerifiedAt,
//     this.countryCode,
//     this.phone,
//     this.gender,
//     this.profile,
//     this.address,
//     this.otp,
//     this.deviceToken,
//     this.deviceType,
//     this.deviceId,
//     this.age,
//     this.kaleyraUserId,
//     this.chatId,
//     this.loginUsername,
//     this.pincode,
//     this.isDoctorAdmin,
//     this.underAdminDoctor,
//     this.isActive,
//     this.addedBy,
//     this.createdAt,
//     this.updatedAt,
//     this.signupDate,
//   });
//
//   int? id;
//   String? roleId;
//   String? name;
//   String? fname;
//   String? lname;
//   String? email;
//   String? emailVerifiedAt;
//   String? countryCode;
//   String? phone;
//   String? gender;
//   String? profile;
//   String? address;
//   String? otp;
//   String? deviceToken;
//   String? deviceType;
//   String? deviceId;
//   String? age;
//   String? kaleyraUserId;
//   String? chatId;
//   String? loginUsername;
//   String? pincode;
//   String? isDoctorAdmin;
//   String? underAdminDoctor;
//   String? isActive;
//   String? addedBy;
//   String? createdAt;
//   String? updatedAt;
//   String? signupDate;
//
//   factory User.fromJson(Map<String, dynamic> json) => User(
//         id: json["id"],
//         roleId: json["role_id"],
//         name: json["name"],
//         fname: json["fname"],
//         lname: json["lname"],
//         email: json["email"],
//         emailVerifiedAt: json["email_verified_at"],
//         countryCode: json["country_code"],
//         phone: json["phone"],
//         gender: json["gender"],
//         profile: json["profile"],
//         address: json["address"],
//         otp: json["otp"],
//         deviceToken: json["device_token"],
//         deviceType: json["device_type"],
//         deviceId: json["device_id"],
//         age: json["age"],
//         kaleyraUserId: json["kaleyra_user_id"],
//         chatId: json["chat_id"],
//         loginUsername: json["login_username"],
//         pincode: json["pincode"],
//         isDoctorAdmin: json["is_doctor_admin"],
//         underAdminDoctor: json["under_admin_doctor"],
//         isActive: json["is_active"],
//         addedBy: json["added_by"],
//         createdAt: json["created_at"],
//         updatedAt: json["updated_at"],
//         signupDate: json["signup_date"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "role_id": roleId,
//         "name": name,
//         "fname": fname,
//         "lname": lname,
//         "email": email,
//         "email_verified_at": emailVerifiedAt,
//         "country_code": countryCode,
//         "phone": phone,
//         "gender": gender,
//         "profile": profile,
//         "address": address,
//         "otp": otp,
//         "device_token": deviceToken,
//         "device_type": deviceType,
//         "device_id": deviceId,
//         "age": age,
//         "kaleyra_user_id": kaleyraUserId,
//         "chat_id": chatId,
//         "login_username": loginUsername,
//         "pincode": pincode,
//         "is_doctor_admin": isDoctorAdmin,
//         "under_admin_doctor": underAdminDoctor,
//         "is_active": isActive,
//         "added_by": addedBy,
//         "created_at": createdAt,
//         "updated_at": updatedAt,
//         "signup_date": signupDate,
//       };
// }
//
// class Appointment {
//   Appointment({
//     this.id,
//     this.teamPatientId,
//     this.date,
//     this.slotStartTime,
//     this.slotEndTime,
//     this.type,
//     this.status,
//     this.kaleyraUserUrl,
//     this.createdAt,
//     this.updatedAt,
//     this.appointmentDate,
//     this.appointmentStartTime,
//   });
//
//   int? id;
//   String? teamPatientId;
//   String? date;
//   String? slotStartTime;
//   String? slotEndTime;
//   String? type;
//   String? status;
//   String? kaleyraUserUrl;
//   String? createdAt;
//   String? updatedAt;
//   String? appointmentDate;
//   String? appointmentStartTime;
//
//   factory Appointment.fromJson(Map<String, dynamic> json) => Appointment(
//         id: json["id"],
//         teamPatientId: json["team_patient_id"],
//         date: json["date"],
//         slotStartTime: json["slot_start_time"],
//         slotEndTime: json["slot_end_time"],
//         type: json["type"],
//         status: json["status"],
//         kaleyraUserUrl: json["kaleyra_user_url"],
//         createdAt: json["created_at"],
//         updatedAt: json["updated_at"],
//         appointmentDate: json["appointment_date"],
//         appointmentStartTime: json["appointment_start_time"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "team_patient_id": teamPatientId,
//         "date": date,
//         "slot_start_time": slotStartTime,
//         "slot_end_time": slotEndTime,
//         "type": type,
//         "status": status,
//         "kaleyra_user_url": kaleyraUserUrl,
//         "created_at": createdAt,
//         "updated_at": updatedAt,
//         "appointment_date": appointmentDate,
//         "appointment_start_time": appointmentStartTime,
//       };
// }
