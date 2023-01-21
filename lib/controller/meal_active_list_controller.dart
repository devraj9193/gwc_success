import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../model/meal_active_model.dart';
import '../utils/gwc_api.dart';

class MealActiveListController extends GetxController {
  MealActiveModel? mealActiveModel;

  @override
  void onInit() {
    super.onInit();
    fetchMealPlanList();
    fetchActiveList();
  }

  Future<List<MealPlanList>?> fetchMealPlanList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString("token")!;

    final response =
        await http.get(Uri.parse(GwcApi.mealPlanListUrl), headers: {
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      MealActiveModel jsonData = mealActiveModelFromJson(response.body);
      List<MealPlanList>? arrData = jsonData.mealPlanList;
     // print("status: ${arrData?[0].status}");
      return arrData;
    } else {
      throw Exception();
    }
  }

  Future<List<MealPlanList>?> fetchActiveList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString("token")!;

    final response =
        await http.get(Uri.parse(GwcApi.mealPlanListUrl), headers: {
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      print("Active: ${response.body}");
      MealActiveModel jsonData = mealActiveModelFromJson(response.body);
      List<MealPlanList>? arrData = jsonData.completedMealPlanList;
    //  print("status: ${arrData?[0].status}");
      return arrData;
    } else {
      throw Exception();
    }
  }
}
