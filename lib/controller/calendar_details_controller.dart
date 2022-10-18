import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/calendar_model.dart';
import 'package:http/http.dart' as http;

import '../utils/gwc_api.dart';

class CalendarDetailsController extends GetxController {
  CalendarModel? calendarModel;

  @override
  void onInit() {
    super.onInit();
    fetchCalendarList();
  }

  Future<List<Meeting>?> fetchCalendarList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString("token");

    final response = await http.get(
        Uri.parse("${GwcApi.calendarUrl}?start=2022-10-13&end=2022-10-31"),
        headers: {
          'Authorization': 'Bearer $token',
        });
    if (response.statusCode == 200) {
      CalendarModel jsonData = calendarModelFromJson(response.body);
      List<Meeting>? arrData = jsonData.data;
      //print("status: ${response.body}");
      return arrData;
    } else {
      throw Exception();
    }
  }
}
