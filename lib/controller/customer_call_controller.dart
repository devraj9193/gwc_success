import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../model/customer_call_model.dart';
import '../utils/gwc_api.dart';

class CustomerCallController extends GetxController {
  CustomerCallModel? customerCallModel;

  @override
  void onInit() {
    super.onInit();
    fetchCustomersCall();
  }

  Future<CustomerCallModel> fetchCustomersCall() async {
    dynamic res;

    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString("token")!;
    var userId = preferences.getString("user_id");

    final response = await http
        .get(Uri.parse("${GwcApi.callApiUrl}/$userId"), headers: {
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      print("Customer Profile:${response.body}");
      res = jsonDecode(response.body);
      customerCallModel = CustomerCallModel.fromJson(res);
      print("Name: ${customerCallModel!.data}");
    } else {
      throw Exception();
    }
    return CustomerCallModel.fromJson(res);
  }
}
