import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../model/claim_customer_model.dart';
import '../utils/gwc_api.dart';
import '../widgets/widgets.dart';

class ClaimCustomerController extends GetxController {
  ClaimCustomerModel? claimCustomerModel;

  @override
  void onInit() {
    super.onInit();
    sentClaimCustomer;
  }

  Future<ClaimCustomerModel> sentClaimCustomer(String userId) async {
    dynamic res;

    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString("token")!;

    final response =
    await http.get(Uri.parse("${GwcApi.claimCustomerApiUrl}/$userId"), headers: {
      'Authorization': 'Bearer $token',
    });
    print("Claim Customer Response:${response.body}");
    print("Claim Customer Url:${GwcApi.callApiUrl}/$userId");
    print("Claim Customer UserId:$userId");

    Map<String, dynamic> responseData = jsonDecode(response.body);
    if (response.statusCode == 200) {
      res = jsonDecode(response.body);
      claimCustomerModel = ClaimCustomerModel.fromJson(res);
      buildSnackBar("Claim", responseData['message']);
    } else {
      buildSnackBar("Claim", responseData['data']);
      throw Exception();
    }
    return ClaimCustomerModel.fromJson(res);
  }
}
