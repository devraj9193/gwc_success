import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../model/meal_plan_model.dart';
import '../utils/gwc_api.dart';

class DayPlanListController extends GetxController {
  DayPlanModel? dayPlanModel;

  Future<DayPlanModel> fetchDayPlanList(
      String selectedDay) async {
    dynamic res;
    print("selectedDay: $selectedDay");

    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString("token")!;
    var user_Id = preferences.getString("user_id")!;

    final response = await http.get(
        Uri.parse("${GwcApi.dayMealListUrl}/$selectedDay/$user_Id"),
        headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      print("meal: ${response.body}");
      res = jsonDecode(response.body);
      dayPlanModel = DayPlanModel.fromJson(res);
    } else {
      throw Exception();
    }
    return DayPlanModel.fromJson(res);
  }
}
