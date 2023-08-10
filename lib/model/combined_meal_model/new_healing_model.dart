import 'detox_nourish_model/child_detox_model.dart';

class NewHealingModel {
  String? data;
  int? totalDays;
  ChildDetoxModel? value;

  NewHealingModel({this.data, this.totalDays, this.value});

  NewHealingModel.fromJson(Map<String, dynamic> json) {
    data = json['data'];
    totalDays = json['total_days'];
    value = json['value'] != null ? new ChildDetoxModel.fromJson(json['value']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data;
    data['total_days'] = this.totalDays;

    if (this.value != null) {
      data['value'] = this.value!.toJson();
    }
    return data;
  }
}