import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../model/customer_profile_model.dart';
import '../model/user_profile_model.dart';
import '../utils/gwc_api.dart';

class CustomerProfileController extends GetxController {
  GetCustomerModel? getCustomerModel;

  @override
  void onInit() {
    super.onInit();
    fetchCustomersProfile();
  }

  Future<GetCustomerModel> fetchCustomersProfile() async {
    dynamic res;

    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString("token")!;
    var userId = preferences.getString("user_id");

    final response = await http
        .get(Uri.parse("${GwcApi.getCustomerProfileApiUrl}/$userId"), headers: {
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      print("Customer Profile:${response.body}");
      res = jsonDecode(response.body);
      getCustomerModel = GetCustomerModel.fromJson(res);
      print("Name: ${getCustomerModel!.username}");
    } else {
      throw Exception();
    }
    return GetCustomerModel.fromJson(res);
  }
}
