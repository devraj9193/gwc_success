import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../model/error_model.dart';
import '../model/message_model/get_chat_groupid_model.dart';
import '../model/user_profile_model.dart';
import '../utils/gwc_api.dart';

class ApiClient {
  ApiClient({
    required this.httpClient,
  });

  final http.Client httpClient;
  SharedPreferences? preferences;

  final _prefs = GwcApi.preferences;

  getChatGroupId(String userId) async {
    String path = GwcApi.customerChatListApiUrl;

    dynamic result;

    var token = preferences?.getString("token")!;

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

  Future getSuccessMemberProfileApi(String accessToken) async {
    final path = GwcApi.getUserProfileApiUrl;
    var result;

    print("token: $accessToken");
    try {
      final response = await httpClient.get(
        Uri.parse(path),
        headers: {
          "Authorization": "Bearer $accessToken",
        },
      ).timeout(const Duration(seconds: 45));

      print(
          "getUserProfileApi response code:" + response.statusCode.toString());
      print("getUserProfileApi response body:" + response.body);

      final res = jsonDecode(response.body);
      print('${res['status'].runtimeType} ${res['status']}');
      if (res['status'].toString() == '200') {
        result = GetUserModel.fromJson(res);
        // preferences?.setString(
        //     GwcApi.successMemberName, res['data']['name'] ?? '');
        // preferences?.setString(GwcApi.successMemberProfile,res['data']['profile'] ?? '');
        // preferences?.setString(GwcApi.successMemberAddress,res['data']['address'] ?? '');
      } else if (response.statusCode == 500) {
        result = ErrorModel(status: "0", message: GwcApi.oopsMessage);
      } else {
        result = ErrorModel.fromJson(res);
      }
    } catch (e) {
      print("getUserProfileApi catch error ${e}");
      result = ErrorModel(status: "0", message: e.toString());
    }
    return result;
  }

  Future getKaleyraAccessTokenApi(String kaleyraUID) async{
    dynamic result;
    // production or sandbox
    // final environment = "sandbox";
    // final region = "eu";
    // testing api key: ak_live_c1ef0ed161003e0a2b419d20
    // final endPoint = "https://cs.${environment}.${region}.bandyer.com";
    /// live endpoint
    const endPoint = "https://api.in.bandyer.com";

    const String url = "$endPoint/rest/sdk/credentials";
    try{

      final response = await httpClient.post(Uri.parse(url),
          headers: {
            'apikey': 'ak_live_d2ad6702fe931fbeb2fa9cb4'
          },
          body: {
            "user_id": kaleyraUID
          }
      );
      if(response.statusCode == 200){
        final json = jsonDecode(response.body);
        result = json['access_token'];
        print("access token got");
        _prefs!.setString(GwcApi.kaleyraAccessToken, result);
      }
      else{
        final json = jsonDecode(response.body);
        result = ErrorModel.fromJson(json);
      }
    }
    catch(e){
      result = ErrorModel(status: "", message: e.toString());
    }
    return result;
  }

}
