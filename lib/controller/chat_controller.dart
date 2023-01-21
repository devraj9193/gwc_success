import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../model/message_model/get_chat_groupid_model.dart';
import '../utils/gwc_api.dart';

class ChatController extends GetxController {
  GetChatGroupIdModel? chatGroupIdModel;

  @override
  void onInit() {
    super.onInit();
    fetchChatList();
  }

  Future<GetChatGroupIdModel> fetchChatList() async {
    dynamic res;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString("token");

    final response = await http.get(
        Uri.parse("${GwcApi.calendarUrl}?start=2022-10-13&end=2022-10-31"),
        headers: {
          'Authorization': 'Bearer $token',
        });
    if (response.statusCode == 200) {
      res = jsonDecode(response.body);
      chatGroupIdModel = GetChatGroupIdModel.fromJson(res);
    } else {
      throw Exception();
    }
    return GetChatGroupIdModel.fromJson(res);
  }
}
