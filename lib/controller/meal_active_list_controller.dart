import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../model/consultation_model.dart';
import '../model/meal_active_model.dart';
import '../utils/gwc_api.dart';
import '../utils/success_api_urls.dart';

class MealActiveListController extends GetxController {
  MealActiveModel? mealActiveModel;

  @override
  void onInit() {
    super.onInit();
    fetchMealPlanList();
    fetchActiveList();
  }

  Future<List<UserDetails>?> fetchMealPlanList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString("token")!;

    final response = await http.get(Uri.parse(SuccessApiUrls.successMealPlanList), headers: {
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      print("meal: ${response.body}");
      MealActiveModel jsonData = mealActiveModelFromJson(response.body);
      List<UserDetails>? arrData = jsonData.mealPlanList;
      //print("status: ${arrData?[0].userDetails?.status}");
      return arrData;
    } else {
      throw Exception();
    }
  }

  Future<List<UserDetails>?> fetchActiveList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString("token")!;

    final response = await http.get(Uri.parse(SuccessApiUrls.successMealPlanList), headers: {
      'Authorization': 'Bearer $token',
    });
    print("Active List: ${response.body}");
    if (response.statusCode == 200) {
      MealActiveModel jsonData = mealActiveModelFromJson(response.body);
      List<UserDetails>? arrData = jsonData.activeDetails;
      return arrData;
    } else {
      throw Exception();
    }
  }
}