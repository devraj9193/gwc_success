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
    DateTime now = DateTime.now();
    DateTime lastDayOfMonth = DateTime(now.year, now.month, now.day - 7);
    DateTime nextDayOfMonth = DateTime(now.year, now.month, now.day + 7);
    var startDate =
        "${lastDayOfMonth.year}-${lastDayOfMonth.month}-${lastDayOfMonth.day}";
    var endDate =
        "${nextDayOfMonth.year}-${nextDayOfMonth.month}-${nextDayOfMonth.day}";
    print(startDate);
    print(endDate);

    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString("token");

    final response = await http.get(
        Uri.parse("${GwcApi.calendarUrl}?start=$startDate&end=$endDate"),
        headers: {
          'Authorization': 'Bearer $token',
        });print("Calendar: ${response.body}");
    if (response.statusCode == 200) {
      CalendarModel jsonData = calendarModelFromJson(response.body);
      List<Meeting>? arrData = jsonData.data;

      return arrData;
    } else {
      throw Exception();
    }
  }
}
