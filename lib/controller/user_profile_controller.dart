import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../model/user_profile_model.dart';
import '../utils/gwc_api.dart';

class UserProfileController extends GetxController {
  GetUserModel? getUserModel;

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
  }

  Future<GetUserModel> fetchUserProfile() async {
    dynamic res;

    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString("token")!;

    final response =
        await http.get(Uri.parse(GwcApi.getUserProfileApiUrl), headers: {
      'Authorization': 'Bearer $token',
    });
    print("User Response: ${response.body}");
    if (response.statusCode == 200) {
      res = jsonDecode(response.body);
      getUserModel = GetUserModel.fromJson(res);
      print(getUserModel!.data!.name);
    } else {
      throw Exception();
    }
    return GetUserModel.fromJson(res);
  }
}
