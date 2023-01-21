import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../utils/gwc_api.dart';
import '../model/day_progress_model.dart';

class DayProgressController extends GetxController {
  DayProgressModel? dayProgressModel;

  @override
  void onInit() {
    super.onInit();
    fetchDayProgressList();
  }

  Future<List<double>?> fetchDayProgressList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString("token")!;
    var userId = preferences.getString("user_id")!;

    final response = await http
        .get(Uri.parse("${GwcApi.dayProgressListUrl}/$userId"), headers: {
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      print("Customer Profile:${response.body}");
      DayProgressModel jsonData = dayProgressModelFromJson(response.body);
      List<double>? arrData = jsonData.data;
      print("status: ${arrData?[0]}");
      return arrData;
    } else {
      throw Exception();
    }
  }
}
