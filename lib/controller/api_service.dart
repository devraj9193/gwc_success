import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../model/error_model.dart';
import '../model/message_model/get_chat_groupid_model.dart';
import '../utils/gwc_api.dart';

class ApiClient {
  ApiClient({
    required this.httpClient,
  });

  final http.Client httpClient;

  getChatGroupId(String userId) async {
    String path = GwcApi.customerChatListApiUrl;

    dynamic result;

    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString("token")!;

    try {
      final response = await httpClient.get(
        Uri.parse("$path/$userId"),
        headers: {
          "Authorization": "Bearer $token",
         // "Authorization": token,
        },
      ).timeout(const Duration(seconds: 45));

      print('getChatGroupId Response header: $path/$userId');
      print('getChatGroupId Response status: ${response.statusCode}');
      print('getChatGroupId Response body: ${response.body}');

      if (response.statusCode == 200) {
        final res = jsonDecode(response.body);
        if (res['status'].toString() == '200') {
          result = GetChatGroupIdModel.fromJson(res);
        } else {
          result = ErrorModel(
              status: res['status'].toString(), message: res.toString());
        }
      } else {
        print('getChatGroupId error: ${response.reasonPhrase}');
        result = ErrorModel.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      result = ErrorModel(status: "0", message: e.toString());
    }

    return result;
  }

  getGwcTeamChatGroupId(String userId) async {
    String path = GwcApi.doctorChatGroupIdUrl;

    dynamic result;

    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString("token")!;

    try {
      final response = await httpClient.get(
        Uri.parse("$path/$userId"),
        headers: {
          "Authorization": "Bearer $token",
          // "Authorization": token,
        },
      ).timeout(const Duration(seconds: 45));

      print('getChatGroupId Response header: $path/$userId');
      print('getChatGroupId Response status: ${response.statusCode}');
      print('getChatGroupId Response body: ${response.body}');

      if (response.statusCode == 200) {
        final res = jsonDecode(response.body);
        if (res['status'].toString() == '200') {
          result = GetChatGroupIdModel.fromJson(res);
        } else {
          result = ErrorModel(
              status: res['status'].toString(), message: res.toString());
        }
      } else {
        print('getChatGroupId error: ${response.reasonPhrase}');
        result = ErrorModel.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      result = ErrorModel(status: "0", message: e.toString());
    }

    return result;
  }
}
