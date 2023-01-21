import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../model/terms_conditions_model.dart';
import '../utils/gwc_api.dart';

class TermsConditionsController extends GetxController {
  TermsModel? termsModel;

  @override
  void onInit() {
    super.onInit();
    fetchTerms();
  }

  Future<TermsModel> fetchTerms() async {
    dynamic res;

    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString("token")!;

    final response =
        await http.get(Uri.parse(GwcApi.termsAndConditionsApiUrl), headers: {
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      res = jsonDecode(response.body);
      termsModel = TermsModel.fromJson(res);
      // print(termsModel!.data);
    } else {
      throw Exception();
    }
    return TermsModel.fromJson(res);
  }
}
