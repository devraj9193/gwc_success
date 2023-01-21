import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../model/evaluation_details_model.dart';
import '../utils/gwc_api.dart';

class EvaluationDetailsController extends GetxController {
  EvaluationDetailsModel? evaluationDetailsModel;

  @override
  void onInit() {
    super.onInit();
    fetchEvaluationDetails();
  }

  Future<EvaluationDetailsModel>? fetchEvaluationDetails() async {
    dynamic res;

    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString("token")!;
    var patientId = preferences.getString("patient_id");

    print("team_patient_id : ${GwcApi.customerMRReport}/$patientId");

    final response =
        await http.get(Uri.parse("$GwcApi.evaluationUrl/$patientId"), headers: {
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      res = jsonDecode(response.body);
      evaluationDetailsModel = EvaluationDetailsModel.fromJson(res);
      print("Result: ${evaluationDetailsModel?.data?.tongueCoating}");
    } else {}
    return EvaluationDetailsModel.fromJson(res);
  }
}
