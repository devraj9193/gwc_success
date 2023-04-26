import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../model/customer_call_model.dart';
import '../utils/gwc_api.dart';
import '../widgets/widgets.dart';

class CustomerCallController extends GetxController {
  CustomerCallModel? customerCallModel;

  @override
  void onInit() {
    super.onInit();
    fetchCustomersCall;
  }

  Future<CustomerCallModel> fetchCustomersCall(String userId) async {
    dynamic res;

    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString("token")!;

    final response =
        await http.get(Uri.parse("${GwcApi.callApiUrl}/$userId"), headers: {
      'Authorization': 'Bearer $token',
    });
    print("CustomerCallResponse:${response.body}");
    print("CustomerCallUrl:${GwcApi.callApiUrl}/$userId");
    print("CustomerCallUserId:$userId");

    Map<String, dynamic> responseData = jsonDecode(response.body);
    if (response.statusCode == 200) {
      res = jsonDecode(response.body);
      customerCallModel = CustomerCallModel.fromJson(res);
    } else {
      buildSnackBar("Call Not Connected", responseData['data']);
      throw Exception();
    }
    return CustomerCallModel.fromJson(res);
  }
}
