import '../consultation_model.dart';

class GetDoctorDetailsModel {
  int? status;
  int? errorCode;
  Message? message;

  GetDoctorDetailsModel({
     this.status,
     this.errorCode,
     this.message,
  });

  factory GetDoctorDetailsModel.fromJson(Map<String, dynamic> json) => GetDoctorDetailsModel(
    status: json["status"],
    errorCode: json["errorCode"],
    message: Message.fromJson(json["message"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "errorCode": errorCode,
    "message": message?.toJson(),
  };
}

class Message {
  int? id;
  int? teamId;
  int? patientId;
  dynamic programId;
  DateTime? assignedDate;
  String? uploadTime;
  String? status;
  dynamic initialTeam;
  int? isArchieved;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? appointmentDate;
  String? appointmentTime;
  String? updateDate;
  String? updateTime;
  String? manifestUrl;
  String? labelUrl;
  Team? team;
  List<Appointment>? appointments;

  Message({
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

  factory Message.fromJson(Map<String, dynamic> json) => Message(
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
    team: Team.fromJson(json["team"]),
    appointments: List<Appointment>.from(json["appointments"].map((x) => Appointment.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "team_id": teamId,
    "patient_id": patientId,
    "program_id": programId,
    "assigned_date": "${assignedDate?.year.toString().padLeft(4, '0')}-${assignedDate?.month.toString().padLeft(2, '0')}-${assignedDate?.day.toString().padLeft(2, '0')}",
    "upload_time": uploadTime,
    "status": status,
    "initial_team": initialTeam,
    "is_archieved": isArchieved,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "appointment_date": appointmentDate,
    "appointment_time": appointmentTime,
    "update_date": updateDate,
    "update_time": updateTime,
    "manifest_url": manifestUrl,
    "label_url": labelUrl,
    "team": team?.toJson(),
    "appointments": List<dynamic>.from(appointments!.map((x) => x.toJson())),
  };
}

class Appointment {
  int? id;
  int? teamPatientId;
  DateTime? date;
  String? slotStartTime;
  String? slotEndTime;
  int? type;
  String? status;
  String? kaleyraUserUrl;
  dynamic userSuccessChatRoom;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? appointmentDate;
  String? appointmentStartTime;

  Appointment({
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

  factory Appointment.fromJson(Map<String, dynamic> json) => Appointment(
    id: json["id"],
    teamPatientId: json["team_patient_id"],
    date: DateTime.parse(json["date"]),
    slotStartTime: json["slot_start_time"],
    slotEndTime: json["slot_end_time"],
    type: json["type"],
    status: json["status"],
    kaleyraUserUrl: json["kaleyra_user_url"],
    userSuccessChatRoom: json["user_success_chat_room"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    appointmentDate: json["appointment_date"],
    appointmentStartTime: json["appointment_start_time"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "team_patient_id": teamPatientId,
    "date": "${date?.year.toString().padLeft(4, '0')}-${date?.month.toString().padLeft(2, '0')}-${date?.day.toString().padLeft(2, '0')}",
    "slot_start_time": slotStartTime,
    "slot_end_time": slotEndTime,
    "type": type,
    "status": status,
    "kaleyra_user_url": kaleyraUserUrl,
    "user_success_chat_room": userSuccessChatRoom,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "appointment_date": appointmentDate,
    "appointment_start_time": appointmentStartTime,
  };
}

class Team {
  int? id;
  String? teamName;
  int? shiftId;
  String? slotsPerDay;
  int? isArchieved;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<TeamMember>? teamMember;

  Team({
     this.id,
     this.teamName,
     this.shiftId,
     this.slotsPerDay,
     this.isArchieved,
     this.createdAt,
     this.updatedAt,
     this.teamMember,
  });

  factory Team.fromJson(Map<String, dynamic> json) => Team(
    id: json["id"],
    teamName: json["team_name"],
    shiftId: json["shift_id"],
    slotsPerDay: json["slots_per_day"],
    isArchieved: json["is_archieved"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    teamMember: List<TeamMember>.from(json["team_member"].map((x) => TeamMember.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "team_name": teamName,
    "shift_id": shiftId,
    "slots_per_day": slotsPerDay,
    "is_archieved": isArchieved,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "team_member": List<dynamic>.from(teamMember!.map((x) => x.toJson())),
  };
}

class TeamMember {
  int? id;
  int? teamId;
  int? userId;
  DateTime? createdAt;
  DateTime? updatedAt;
  User? user;

  TeamMember({
     this.id,
     this.teamId,
     this.userId,
     this.createdAt,
     this.updatedAt,
     this.user,
  });

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
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "user": user?.toJson(),
  };
}

