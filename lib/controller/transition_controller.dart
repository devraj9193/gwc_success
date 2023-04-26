import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../model/preparatory_transition_model.dart';
import '../utils/gwc_api.dart';

class TransitionController extends GetxController {
  PreparatoryTransitionModel? preparatoryTransitionModel;

  Future<PreparatoryTransitionModel> fetchDayPlanList() async {
    dynamic res;

    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString("token");
    var userId = preferences.getString("user_id")!;
    print(userId);

    final response = await http
        .get(Uri.parse("${GwcApi.transitionApiUrl}/$userId"), headers: {
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      print("meal: ${response.body}");
      res = jsonDecode(response.body);
      preparatoryTransitionModel = PreparatoryTransitionModel.fromJson(res);
        print("object: ${preparatoryTransitionModel?.data}");
    } else {
      throw Exception();
    }
    return PreparatoryTransitionModel.fromJson(res);
  }
}
