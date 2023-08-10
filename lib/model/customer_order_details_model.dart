// To parse this JSON data, do
//
//     final customerOrderDetails = customerOrderDetailsFromJson(jsonString);

import 'dart:convert';

CustomerOrderDetails customerOrderDetailsFromJson(String str) =>
    CustomerOrderDetails.fromJson(json.decode(str));

String customerOrderDetailsToJson(CustomerOrderDetails data) =>
    json.encode(data.toJson());

class CustomerOrderDetails {
  CustomerOrderDetails({
    this.status,
    this.errorCode,
  required  this.data,
    this.user

  });

  int? status;
  int? errorCode;
  Data data;
  User? user;

  factory CustomerOrderDetails.fromJson(Map<String, dynamic> json) =>
      CustomerOrderDetails(
        status: json["status"],
        errorCode: json["errorCode"],
        data: Data.fromJson(json["data"]),
  user: User.fromJson(json["user"]),

      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "errorCode": errorCode,
        "data": data.toJson(),
    "user": user?.toJson(),
      };
}

class Data {
  Data({
  required  this.shippingProductList,
  });

  List<GetShoppingListElement> shippingProductList;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        shippingProductList: List<GetShoppingListElement>.from(
            json["shipping_product_list"]
                .map((x) => GetShoppingListElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "shipping_product_list":
            List<dynamic>.from(shippingProductList.map((x) => x.toJson())),
      };
}

class GetShoppingListElement {
  GetShoppingListElement({
    this.id,
    this.teamPatientId,
    this.itemId,
    this.totalWeight,
    this.addedBy,
    this.createdAt,
    this.updatedAt,
    this.itemWeight,
    this.mealItem,
  });

  int? id;
  String? teamPatientId;
  String? itemId;
  String? totalWeight;
  String? addedBy;
  String? createdAt;
  String? updatedAt;
  String? itemWeight;
  MealItem? mealItem;

  factory GetShoppingListElement.fromJson(Map<String, dynamic> json) =>
      GetShoppingListElement(
        id: json["id"],
        teamPatientId: json["team_patient_id"].toString(),
        itemId: json["item_id"].toString(),
        totalWeight: json["total_weight"].toString(),
        addedBy: json["added_by"].toString(),
        createdAt: json["created_at"].toString(),
        updatedAt: json["updated_at"].toString(),
        itemWeight: json["item_weight"].toString(),
        mealItem: MealItem.fromJson(json["meal_item"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "team_patient_id": teamPatientId,
        "item_id": itemId,
        "total_weight": totalWeight,
        "added_by": addedBy,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "item_weight": itemWeight,
        "meal_item": mealItem?.toJson(),
      };
}

class MealItem {
  MealItem({
    this.id,
    this.name,
    this.mealTimingId,
    this.recipeId,
    this.programId,
    this.inCookingKit,
    this.addedBy,
    this.createdAt,
    this.updatedAt,
    this.mealItemWeight,
  });

  int? id;
  String? name;
  String? mealTimingId;
  String? recipeId;
  String? programId;
  String? inCookingKit;
  String? addedBy;
  String? createdAt;
  String? updatedAt;
  List<MealItemWeight>? mealItemWeight;

  factory MealItem.fromJson(Map<String, dynamic> json) => MealItem(
        id: json["id"],
        name: json["name"].toString(),
        mealTimingId: json["meal_timing_id"].toString(),
        recipeId: json["recipe_id"].toString(),
        programId: json["program_id"].toString(),
        inCookingKit: json["in_cooking_kit"].toString(),
        addedBy: json["added_by"].toString(),
        createdAt: json["created_at"].toString(),
        updatedAt: json["updated_at"].toString(),
        mealItemWeight: List<MealItemWeight>.from(
            json["meal_item_weight"].map((x) => MealItemWeight.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "meal_timing_id": mealTimingId,
        "recipe_id": recipeId,
        "program_id": programId,
        "in_cooking_kit": inCookingKit,
        "added_by": addedBy,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "meal_item_weight":
            List<dynamic>.from(mealItemWeight!.map((x) => x.toJson())),
      };
}

class MealItemWeight {
  MealItemWeight({
    this.id,
    this.mealPlanItemId,
    this.weight,
    this.weightTypeId,
    this.createdAt,
    this.updatedAt,
    this.weightType,
  });

  int? id;
  String? mealPlanItemId;
  String? weight;
  String? weightTypeId;
  String? createdAt;
  String? updatedAt;
  WeightType? weightType;

  factory MealItemWeight.fromJson(Map<String, dynamic> json) => MealItemWeight(
        id: json["id"] ?? "",
        mealPlanItemId: json["meal_plan_item_id"].toString(),
        weight: json["weight"].toString(),
        weightTypeId: json["weight_type_id"].toString(),
        createdAt: json["created_at"].toString(),
        updatedAt: json["updated_at"].toString(),
        weightType: WeightType.fromJson(json["weight_type"] ?? ""),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "meal_plan_item_id": mealPlanItemId,
        "weight": weight,
        "weight_type_id": weightTypeId,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "weight_type": weightType?.toJson(),
      };
}

class WeightType {
  WeightType({
    this.id,
    this.unit,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? unit;
  String? createdAt;
  String? updatedAt;

  factory WeightType.fromJson(Map<String, dynamic> json) => WeightType(
        id: json["id"] ?? "",
        unit: json["unit"].toString(),
        createdAt: json["created_at"].toString(),
        updatedAt: json["updated_at"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "unit": unit,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}

class User {
  int id;
  int userId;
  String maritalStatus;
  String address2;
  String city;
  String state;
  String country;
  int weight;
  String status;
  String shippingDeliveryDate;
  dynamic rejectedReason;
  int isArchieved;
  DateTime createdAt;
  DateTime updatedAt;
  UserUser user;

  User({
    required this.id,
    required this.userId,
    required this.maritalStatus,
    required this.address2,
    required this.city,
    required this.state,
    required this.country,
    required this.weight,
    required this.status,
    required this.shippingDeliveryDate,
    this.rejectedReason,
    required this.isArchieved,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    userId: json["user_id"],
    maritalStatus: json["marital_status"],
    address2: json["address2"],
    city: json["city"],
    state: json["state"],
    country: json["country"],
    weight: json["weight"],
    status: json["status"],
    shippingDeliveryDate: json["shipping_delivery_date"],
    rejectedReason: json["rejected_reason"].toString(),
    isArchieved: json["is_archieved"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    user: UserUser.fromJson(json["user"]),
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
    "shipping_delivery_date": shippingDeliveryDate,
    "rejected_reason": rejectedReason,
    "is_archieved": isArchieved,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "user": user.toJson(),
  };
}

class UserUser {
  int id;
  int roleId;
  String name;
  String fname;
  String lname;
  String email;
  dynamic emailVerifiedAt;
  String countryCode;
  String phone;
  String gender;
  String profile;
  String address;
  dynamic otp;
  String deviceToken;
  dynamic webDeviceToken;
  dynamic deviceType;
  String deviceId;
  String age;
  String kaleyraUserId;
  dynamic chatId;
  dynamic loginUsername;
  String pincode;
  int isDoctorAdmin;
  dynamic underAdminDoctor;
  dynamic successUserId;
  dynamic cetUserId;
  dynamic cetCompleted;
  int isActive;
  dynamic addedBy;
  dynamic latitude;
  dynamic longitude;
  DateTime createdAt;
  DateTime updatedAt;
  String signupDate;

  UserUser({
    required this.id,
    required this.roleId,
    required this.name,
    required this.fname,
    required this.lname,
    required this.email,
    this.emailVerifiedAt,
    required this.countryCode,
    required this.phone,
    required this.gender,
    required this.profile,
    required this.address,
    this.otp,
    required this.deviceToken,
    this.webDeviceToken,
    this.deviceType,
    required this.deviceId,
    required this.age,
    required this.kaleyraUserId,
    this.chatId,
    this.loginUsername,
    required this.pincode,
    required this.isDoctorAdmin,
    this.underAdminDoctor,
    this.successUserId,
    this.cetUserId,
    this.cetCompleted,
    required this.isActive,
    this.addedBy,
    this.latitude,
    this.longitude,
    required this.createdAt,
    required this.updatedAt,
    required this.signupDate,
  });

  factory UserUser.fromJson(Map<String, dynamic> json) => UserUser(
    id: json["id"],
    roleId: json["role_id"],
    name: json["name"],
    fname: json["fname"],
    lname: json["lname"],
    email: json["email"],
    emailVerifiedAt: json["email_verified_at"].toString(),
    countryCode: json["country_code"],
    phone: json["phone"],
    gender: json["gender"],
    profile: json["profile"],
    address: json["address"],
    otp: json["otp"].toString(),
    deviceToken: json["device_token"],
    webDeviceToken: json["web_device_token"].toString(),
    deviceType: json["device_type"].toString(),
    deviceId: json["device_id"].toString(),
    age: json["age"],
    kaleyraUserId: json["kaleyra_user_id"],
    chatId: json["chat_id"].toString(),
    loginUsername: json["login_username"].toString(),
    pincode: json["pincode"],
    isDoctorAdmin: json["is_doctor_admin"],
    underAdminDoctor: json["under_admin_doctor"].toString(),
    successUserId: json["success_user_id"],
    cetUserId: json["cet_user_id"],
    cetCompleted: json["cet_completed"].toString(),
    isActive: json["is_active"],
    addedBy: json["added_by"].toString(),
    latitude: json["latitude"].toString(),
    longitude: json["longitude"].toString(),
    createdAt: DateTime.parse(json["created_at"]),
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
    "latitude": latitude,
    "longitude": longitude,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "signup_date": signupDate,
  };
}
