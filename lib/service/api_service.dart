import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../model/calendar_model.dart';
import '../model/claimed_customer_model/claimed_customer_list_model.dart';
import '../model/claimed_customer_model/unclaimed_customer_list_model.dart';
import '../model/combined_meal_model/all_day_tracker_model.dart';
import '../model/combined_meal_model/combined_meal_model.dart';
import '../model/combined_meal_model/dailyProgressMealPlanModel.dart';
import '../model/consultation_model.dart';
import '../model/customer_order_details_model.dart';
import '../model/customer_profile_model.dart';
import '../model/customers_list_model.dart';
import '../model/day_progress_model.dart';
import '../model/doctor_list_model.dart';
import '../model/error_model.dart';
import '../model/kaleyra_chat_list_model.dart/kaleyra_chat_list_model.dart';
import '../model/login_model/login_model.dart';
import '../model/login_model/logout_model.dart';
import '../model/maintenance_guide_model.dart';
import '../model/meal_active_model.dart';
import '../model/message_model/get_chat_groupid_model.dart';
import '../model/pending_list_model.dart';
import '../model/shiprocket_auth_model/ship_tracking_model.dart';
import '../model/shiprocket_auth_model/shiprocket_auth_model.dart';
import '../model/success_user_model/success_list_model.dart';
import '../model/user_profile_model.dart';
import '../model/uvDesk_model/get_doctor_details_model.dart';
import '../model/uvDesk_model/get_group_list_model.dart';
import '../model/uvDesk_model/get_ticket_list_model.dart';
import '../model/uvDesk_model/get_ticket_threads_list_model.dart';
import '../model/uvDesk_model/sent_reply_model.dart';
import '../model/uvDesk_model/uvDesk_ticket_raise_model.dart';
import '../utils/app_confiq.dart';
import '../utils/constants.dart';
import '../utils/gwc_api.dart';
import '../utils/success_api_urls.dart';
import '../utils/success_member_storage.dart';
import '../widgets/widgets.dart';

class ApiClient {
  ApiClient({
    required this.httpClient,
  });

  final http.Client httpClient;
  SharedPreferences? preferences;

  final _prefs = GwcApi.preferences;

  String getHeaderToken() {
    if (_prefs != null) {
      final token = _prefs!.getString("token");
      // AppConfig().tokenUser
      // .substring(2, AppConstant().tokenUser.length - 1);
      return "Bearer $token";
    } else {
      return "Bearer ${""}";
    }
  }

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

  // --- Ship Rocket --- //
  Future getShipRocketLoginApi(String email, String password) async {
    final path = GwcApi.shipRocketLoginApiUrl;

    Map bodyParam = {"email": email, "password": password};

    dynamic result;

    try {
      final response = await httpClient
          .post(Uri.parse(path), body: bodyParam)
          .timeout(Duration(seconds: 45));

      if (response.statusCode != 200) {

        result = ErrorModel.fromJson(jsonDecode(response.body));

      }   else if(response.statusCode == 500){
        result = ErrorModel(status: "0", message: GwcApi.oopsMessage);
      }
      else {
        result = ShipRocketTokenModel.fromJson(jsonDecode(response.body));
        storeShipRocketToken(result);
        print("ship rocket url : $path");
        print("ship rocket body : $bodyParam");
        print("ship rocket response : ${response.body}");

      }
    } catch (e) {
      result = ErrorModel(status: "0", message: e.toString());
    }
    return result;
  }

  Future serverShippingTrackerApi(String awbNumber) async {
    print(awbNumber);
    final String path = '${GwcApi.shippingTrackingApiUrl}/$awbNumber';
    dynamic result;

    String shipToken = _prefs?.getString(AppConfig().shipRocketBearer) ?? '';

    Map<String, String> shipRocketHeader = {
      "Authorization": "Bearer $shipToken",
      "Content-Type": "application/json"
    };

    print('shiptoken: $shipToken');
    try {
      final response = await httpClient
          .get(
        Uri.parse(path),
        headers: shipRocketHeader,
      )
          .timeout(const Duration(seconds: 45));

      print('serverShippingTrackerApi Response header: $path');
      print('serverShippingTrackerApi Response status: ${response.statusCode}');
      print('serverShippingTrackerApi Response body: ${response.body}');

      if (response.statusCode != 200) {
        final res = jsonDecode(response.body);
        result = ErrorModel.fromJson(res);
      }   else if(response.statusCode == 500){
        result = ErrorModel(status: "0", message: AppConfig.oopsMessage);
      }
      else {
        final res = jsonDecode(response.body);
        result = ShipTrackingModel.fromJson(res);
      }
    } catch (e) {
      result = ErrorModel(status: "0", message: e.toString());
    }

    return result;
  }

  void storeShipRocketToken(ShipRocketTokenModel result) {
    _prefs!.setString(AppConfig().shipRocketBearer, result.token ?? '');
  }

  serverLoginWithOtpApi(String phone, String otp, String deviceToken) async {
    var path = GwcApi.loginApiUrl;

    dynamic result;

    Map bodyParam = {'email': phone, 'password': otp, 'device_token': deviceToken};
    print("Login Details : $bodyParam");

    try {
      final response = await httpClient
          .post(Uri.parse(path), body: bodyParam)
          .timeout(const Duration(seconds: 45));

      print('serverLoginWithOtpApi Response header: $path');
      print('serverLoginWithOtpApi Response status: ${response.statusCode}');
      print('serverLoginWithOtpApi Response body: ${response.body}');
      final res = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (res['status'] == 200) {
          result = loginFromJson(response.body);
        } else {
          result = ErrorModel.fromJson(res);
        }
      } else {
        result = ErrorModel.fromJson(res);
      }
    } catch (e) {
      result = ErrorModel(status: "0", message: e.toString());
    }
    return result;
  }

  serverLogoutApi() async {
    var path = GwcApi.logoutApiUrl;

    dynamic result;

    try {
      final response = await httpClient.post(
        Uri.parse(path),
        headers: {
          // "Authorization": "Bearer ${AppConfig().bearerToken}",
          "Authorization": getHeaderToken(),
        },
      ).timeout(Duration(seconds: 45));

      print('serverLogoutApi Response header: $path');
      print('serverLogoutApi Response status: ${response.statusCode}');
      print('serverLogoutApi Response body: ${response.body}');
      final res = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (res['status'] == 200) {
          result = LogoutModel.fromJson(res);
          // inMemoryStorage.cache.clear();
        } else {
          result = ErrorModel.fromJson(res);
        }
      }
      else if(response.statusCode == 500){
        result = ErrorModel(status: "0", message: GwcApi.oopsMessage);
      }
      else {
        result = ErrorModel.fromJson(res);
      }
    } catch (e) {
      result = ErrorModel(status: "0", message: e.toString());
    }
    return result;
  }

  // --- Gwc Team Services --- //

  getCalendarListApi() async {

    DateTime now =  DateTime. now();
    DateTime lastDayOfMonth =  DateTime(now. year, now. month , now. day - 7);
    DateTime nextDayOfMonth =  DateTime(now. year, now. month , now. day + 7);
    var startDate = "${lastDayOfMonth.year}-${lastDayOfMonth.month}-${lastDayOfMonth.day}";
    var endDate = "${nextDayOfMonth.year}-${nextDayOfMonth.month}-${nextDayOfMonth.day}";
    print(startDate);
    print(endDate);

    String url = "${GwcApi.calendarUrl}?start=$startDate&end=$endDate";
    print(url);

    var token = _prefs?.getString("token")!;

    dynamic result;
    try{

      final response = await httpClient.get(Uri.parse(url),
        headers: {
          'Authorization' : "Bearer $token",
        },
      ).timeout(const Duration(seconds: 45));

      print('getCalendarListApi Url: $url');
      print('getCalendarListApi Response status: ${response.statusCode}');
      print('getCalendarListApi Response body: ${response.body}');

      if(response.statusCode == 200){
        final json = jsonDecode(response.body);
        result = CalendarModel.fromJson(json);
      }
      else if(response.statusCode == 500) {
        result = ErrorModel(status: "0", message: GwcApi.oopsMessage);
      }
      else{
        result = ErrorModel(status: response.statusCode.toString(), message: response.body);
      }
    }
    catch (e) {
      print(e);
      result = ErrorModel(status: "", message: e.toString());
    }
    return result;
  }

  getDoctorListApi() async{
    String url = GwcApi.doctorsListApiUrl;
    print(url);

    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString("token")!;

    dynamic result;
    try{

      final response = await httpClient.get(Uri.parse(url),
        headers: {
          'Authorization' : "Bearer $token",
        },
      ).timeout(const Duration(seconds: 45));

      print('getDoctorListApi Url: $url');
      print('getDoctorListApi Response status: ${response.statusCode}');
      print('getDoctorListApi Response body: ${response.body}');

      if(response.statusCode == 200){
        final json = jsonDecode(response.body);
        result = DoctorsList.fromJson(json);
      }
      else if(response.statusCode == 500) {
        result = ErrorModel(status: "0", message: GwcApi.oopsMessage);
      }
      else{
        result = ErrorModel(status: response.statusCode.toString(), message: response.body);
      }
    }
    catch (e) {
      print(e);
      result = ErrorModel(status: "", message: e.toString());
    }
    return result;
  }

  getSuccessListApi() async{
    String url = GwcApi.successTeamListApiUrl;
    print(url);

    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString("token")!;

    dynamic result;
    try{

      final response = await httpClient.get(Uri.parse(url),
        headers: {
          'Authorization' : "Bearer $token",
        },
      ).timeout(const Duration(seconds: 45));

      print('getSuccessListApi Url: $url');
      print('getSuccessListApi Response status: ${response.statusCode}');
      print('getSuccessListApi Response body: ${response.body}');

      if(response.statusCode == 200){
        final json = jsonDecode(response.body);
        result = SuccessList.fromJson(json);
      }
      else if(response.statusCode == 500) {
        result = ErrorModel(status: "0", message: GwcApi.oopsMessage);
      }
      else{
        result = ErrorModel(status: response.statusCode.toString(), message: response.body);
      }
    }
    catch (e) {
      print(e);
      result = ErrorModel(status: "", message: e.toString());
    }
    return result;
  }

  // --- Appi Services --- //

  getCustomerProfileApi(String userId) async{
    String url = "${GwcApi.getCustomerProfileApiUrl}/$userId";
    print(url);

    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString("token")!;

    dynamic result;
    try{

      final response = await httpClient.get(Uri.parse(url),
        headers: {
          'Authorization' : "Bearer $token",
        },
      ).timeout(const Duration(seconds: 45));

      print('getCustomerProfileApi Url: $url');
      print('getCustomerProfileApi Response status: ${response.statusCode}');
      print('getCustomerProfileApi Response body: ${response.body}');

      if(response.statusCode == 200){
        final json = jsonDecode(response.body);
        result = GetCustomerModel.fromJson(json);
      }
      else if(response.statusCode == 500) {
        result = ErrorModel(status: "0", message: GwcApi.oopsMessage);
      }
      else{
        result = ErrorModel(status: response.statusCode.toString(), message: response.body);
      }
    }
    catch (e) {
      print(e);
      result = ErrorModel(status: "", message: e.toString());
    }
    return result;
  }

  getAllCustomerListApi() async{
    String url = GwcApi.customersListApiUrl;
    print(url);

    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString("token")!;

    dynamic result;
    try{

      final response = await httpClient.get(Uri.parse(url),
        headers: {
          'Authorization' : "Bearer $token",
        },
      ).timeout(const Duration(seconds: 45));

      print('getShipmentListApi Url: $url');
      print('getShipmentListApi Response status: ${response.statusCode}');
      print('getShipmentListApi Response body: ${response.body}');

      if(response.statusCode == 200){
        final json = jsonDecode(response.body);
        result = CustomersList.fromJson(json);
      }
      else if(response.statusCode == 500) {
        result = ErrorModel(status: "0", message: GwcApi.oopsMessage);
      }
      else{
        result = ErrorModel(status: response.statusCode.toString(), message: response.body);
      }
    }
    catch (e) {
      print(e);
      result = ErrorModel(status: "", message: e.toString());
    }
    return result;
  }

  getUnClaimedCustomerListApi() async{
    String url = GwcApi.unClaimedCustomerListApiUrl;
    print(url);

    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString("token")!;

    dynamic result;
    try{

      final response = await httpClient.get(Uri.parse(url),
        headers: {
          'Authorization' : "Bearer $token",
        },
      ).timeout(const Duration(seconds: 45));

      print('getShipmentListApi Url: $url');
      print('getShipmentListApi Response status: ${response.statusCode}');
      print('getShipmentListApi Response body: ${response.body}');

      if(response.statusCode == 200){
        final json = jsonDecode(response.body);
        result = UnClaimedCustomerList.fromJson(json);
      }
      else if(response.statusCode == 500) {
        result = ErrorModel(status: "0", message: GwcApi.oopsMessage);
      }
      else{
        result = ErrorModel(status: response.statusCode.toString(), message: response.body);
      }
    }
    catch (e) {
      print(e);
      result = ErrorModel(status: "", message: e.toString());
    }
    return result;
  }

  Future sendClaimCustomerApi(String userId) async {
    final path = "${GwcApi.claimCustomerApiUrl}/$userId";

    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString("token")!;

    dynamic result;

    try {
      final response = await httpClient.get(
        Uri.parse(path),
        headers: {
          'Authorization' : "Bearer $token",
        },
      ).timeout(const Duration(seconds: 45));

      print('sendClaimCustomerApi Response header: $path');
      print('sendClaimCustomerApi Response status: ${response.statusCode}');
      print('sendClaimCustomerApi Response body: ${response.body}');
      final res = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        print('sendClaimCustomerApi result: $json');
        result = SentReplyModel.fromJson(json);
      } else {
        result = ErrorModel.fromJson(res);
      }
    } catch (e) {
      result = ErrorModel(status: "0", message: e.toString());
    }
    return result;
  }

  getClaimedCustomerListApi() async{
    String url = GwcApi.claimedCustomerListApiUrl;
    print(url);

    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString("token")!;

    dynamic result;
    try{

      final response = await httpClient.get(Uri.parse(url),
        headers: {
          'Authorization' : "Bearer $token",
        },
      ).timeout(const Duration(seconds: 45));

      print('getShipmentListApi Url: $url');
      print('getShipmentListApi Response status: ${response.statusCode}');
      print('getShipmentListApi Response body: ${response.body}');

      if(response.statusCode == 200){
        final json = jsonDecode(response.body);
        result = ClaimedCustomerListModel.fromJson(json);
      }
      else if(response.statusCode == 500) {
        result = ErrorModel(status: "0", message: GwcApi.oopsMessage);
      }
      else{
        result = ErrorModel(status: response.statusCode.toString(), message: response.body);
      }
    }
    catch (e) {
      print(e);
      result = ErrorModel(status: "", message: e.toString());
    }
    return result;
  }

  getConsultationPendingListApi() async{
    String url = SuccessApiUrls.successConsultationList;
    print(url);

    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString("token")!;

    dynamic result;
    try{

      final response = await httpClient.get(Uri.parse(url),
        headers: {
          'Authorization' : "Bearer $token",
        },
      ).timeout(const Duration(seconds: 45));

      print('getShipmentListApi Url: $url');
      print('getShipmentListApi Response status: ${response.statusCode}');
      print('getShipmentListApi Response body: ${response.body}');

      if(response.statusCode == 200){
        final json = jsonDecode(response.body);
        result = ConsultationModel.fromJson(json);
      }
      else if(response.statusCode == 500) {
        result = ErrorModel(status: "0", message: GwcApi.oopsMessage);
      }
      else{
        result = ErrorModel(status: response.statusCode.toString(), message: response.body);
      }
    }
    catch (e) {
      print(e);
      result = ErrorModel(status: "", message: e.toString());
    }
    return result;
  }

  getShipmentListApi() async{
    String url = GwcApi.pendingUserListApiUrl;
    print(url);

    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString("token")!;

    dynamic result;
    try{

      final response = await httpClient.get(Uri.parse(url),
        headers: {
          'Authorization' : "Bearer $token",
        },
      ).timeout(const Duration(seconds: 45));

      print('getShipmentListApi Url: $url');
      print('getShipmentListApi Response status: ${response.statusCode}');
      print('getShipmentListApi Response body: ${response.body}');

      if(response.statusCode == 200){
        final json = jsonDecode(response.body);
        result = PendingUserList.fromJson(json);
      }
      else if(response.statusCode == 500) {
        result = ErrorModel(status: "0", message: GwcApi.oopsMessage);
      }
      else{
        result = ErrorModel(status: response.statusCode.toString(), message: response.body);
      }
    }
    catch (e) {
      print(e);
      result = ErrorModel(status: "", message: e.toString());
    }
    return result;
  }

  getMealActiveListApi() async{
    String url = SuccessApiUrls.successMealPlanList;
    print(url);

    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString("token")!;

    dynamic result;
    try{

      final response = await httpClient.get(Uri.parse(url),
        headers: {
          'Authorization' : "Bearer $token",
        },
      ).timeout(const Duration(seconds: 45));

      print('getShipmentListApi Url: $url');
      print('getShipmentListApi Response status: ${response.statusCode}');
      print('getShipmentListApi Response body: ${response.body}');

      if(response.statusCode == 200){
        final json = jsonDecode(response.body);
        result = MealActiveModel.fromJson(json);
      }
      else if(response.statusCode == 500) {
        result = ErrorModel(status: "0", message: GwcApi.oopsMessage);
      }
      else{
        result = ErrorModel(status: response.statusCode.toString(), message: response.body);
      }
    }
    catch (e) {
      print(e);
      result = ErrorModel(status: "", message: e.toString());
    }
    return result;
  }

  getPostProgramListApi() async{
    String url = SuccessApiUrls.successPostProgramList;
    print(url);

    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString("token")!;

    dynamic result;
    try{

      final response = await httpClient.get(Uri.parse(url),
        headers: {
          'Authorization' : "Bearer $token",
        },
      ).timeout(const Duration(seconds: 45));

      print('getShipmentListApi Url: $url');
      print('getShipmentListApi Response status: ${response.statusCode}');
      print('getShipmentListApi Response body: ${response.body}');

      if(response.statusCode == 200){
        final json = jsonDecode(response.body);
        result = MaintenanceGuideModel.fromJson(json);
      }
      else if(response.statusCode == 500) {
        result = ErrorModel(status: "0", message: GwcApi.oopsMessage);
      }
      else{
        result = ErrorModel(status: response.statusCode.toString(), message: response.body);
      }
    }
    catch (e) {
      print(e);
      result = ErrorModel(status: "", message: e.toString());
    }
    return result;
  }

  getShoppingItemApi(String userId) async{
    String url = "${GwcApi.userOrderDetailsApiUrl}/$userId";
    print(url);

    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString("token")!;

    dynamic result;
    try{

      final response = await httpClient.get(Uri.parse(url),
        headers: {
          'Authorization' : "Bearer $token",
        },
      ).timeout(const Duration(seconds: 45));

      print('getShoppingItemApi Url: $url');
      print('getShoppingItemApi Response status: ${response.statusCode}');
      print('getShoppingItemApi Response body: ${response.body}');

      if(response.statusCode == 200){
        final json = jsonDecode(response.body);
        result = CustomerOrderDetails.fromJson(json);
      }
      else if(response.statusCode == 500) {
        result = ErrorModel(status: "0", message: GwcApi.oopsMessage);
      }
      else{
        result = ErrorModel(status: response.statusCode.toString(), message: response.body);
      }
    }
    catch (e) {
      print(e);
      result = ErrorModel(status: "", message: e.toString());
    }
    return result;
  }

  getProgressApi(String userId) async{
    String url = "${GwcApi.dayProgressListUrl}/$userId";
    print(url);

    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString("token")!;

    dynamic result;
    try{

      final response = await httpClient.get(Uri.parse(url),
        headers: {
          'Authorization' : "Bearer $token",
        },
      ).timeout(const Duration(seconds: 45));

      print('getShoppingItemApi Url: $url');
      print('getShoppingItemApi Response status: ${response.statusCode}');
      print('getShoppingItemApi Response body: ${response.body}');

      if(response.statusCode == 200){
        final json = jsonDecode(response.body);
        result = DayProgressModel.fromJson(json);
      }
      else if(response.statusCode == 500) {
        result = ErrorModel(status: "0", message: GwcApi.oopsMessage);
      }
      else{
        result = ErrorModel(status: response.statusCode.toString(), message: response.body);
      }
    }
    catch (e) {
      print(e);
      result = ErrorModel(status: "", message: e.toString());
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
        print("name : ${res['data']['name']}");
        result = GetUserModel.fromJson(res);
        preferences?.setString(
            GwcApi.successMemberName, res['data']['name'] ?? '');
        preferences?.setString(
            GwcApi.successMemberProfile, res['data']['profile'] ?? '');
        preferences?.setString(
            GwcApi.successMemberAddress, res['data']['address'] ?? '');
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

  Future getCombinedMealApi(String userId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString("token")!;

    final path = "${GwcApi.nutriDelightApiUrl}/$userId";
    var result;

    try {
      final response = await httpClient.get(
        Uri.parse(path),
        headers: {
          // "Authorization": "Bearer ${AppConfig().bearerToken}",
          "Authorization": "Bearer $token",
        },
      ).timeout(const Duration(seconds: 45));

      print("getCombinedMealApi response url:" + path);
      print(
          "getCombinedMealApi response code:" + response.statusCode.toString());
      print("getCombinedMealApi response body:" + response.body);

      if (response.statusCode == 200) {
        final res = jsonDecode(response.body);
        print('${res['status'].runtimeType} ${res['status']}');
        print(res['Detox']);

        if (res['status'].toString() == '200') {
          // result = CombinedMealModel.fromJson(mealJson);

          result = CombinedMealModel.fromJson(jsonDecode(response.body));
        } else {
          result = ErrorModel.fromJson(res);
        }
      } else if (response.statusCode == 500) {
        result = ErrorModel(status: "0", message: GwcApi.oopsMessage);
      } else {
        print('status not equal called');
        final res = jsonDecode(response.body);
        result = ErrorModel.fromJson(res);
      }
    } catch (e) {
      print("catch error::> $e");
      result = ErrorModel(status: "0", message: e.toString());
    }
    return result;
  }

  Future getDailyProgressMealPlanApi(
      String selectedDay, String detoxOrHealing,String userId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString("token")!;

    final path =
        "${GwcApi.dailyProgressMealPlanApiUrl}/$selectedDay/$userId/$detoxOrHealing";
    var result;

    try {
      final response = await httpClient.get(
        Uri.parse(path),
        headers: {
          // "Authorization": "Bearer ${AppConfig().bearerToken}",
          "Authorization": "Bearer $token",
        },
      ).timeout(const Duration(seconds: 45));

      print("getDailyProgressMealApi response url:" + path);
      print("getDailyProgressMealApi response code:" +
          response.statusCode.toString());
      print("getDailyProgressMealApi response body:" + response.body);

      if (response.statusCode == 200) {
        final res = jsonDecode(response.body);
        print('${res['status'].runtimeType} ${res['status']}');
        print(res['Detox']);

        if (res['status'].toString() == '200') {
          // result = CombinedMealModel.fromJson(mealJson);

          result =
              DailyProgressMealPlanModel.fromJson(jsonDecode(response.body));
        } else {
          result = ErrorModel.fromJson(res);
        }
      } else if (response.statusCode == 500) {
        result = ErrorModel(status: "0", message: GwcApi.oopsMessage);
      } else {
        print('status not equal called');
        final res = jsonDecode(response.body);
        result = ErrorModel.fromJson(res);
      }
    } catch (e) {
      print("catch error::> $e");
      result = ErrorModel(status: "0", message: e.toString());
    }
    return result;
  }

  Future getAllDayTrackerApi(String userId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString("token")!;

    final path = "${GwcApi.allDayTrackerApiUrl}/$userId";
    var result;

    try {
      final response = await httpClient.get(
        Uri.parse(path),
        headers: {
          // "Authorization": "Bearer ${AppConfig().bearerToken}",
          "Authorization": "Bearer $token",
        },
      ).timeout(const Duration(seconds: 45));

      print("getAllDayTrackerApi response url:" + path);
      print("getAllDayTrackerApi response code:" +
          response.statusCode.toString());
      print("getAllDayTrackerApi response body:" + response.body);

      if (response.statusCode == 200) {
        final res = jsonDecode(response.body);
        print('${res['status'].runtimeType} ${res['status']}');
        print(res['Detox']);

        if (res['status'].toString() == '200') {
          // result = CombinedMealModel.fromJson(mealJson);

          result = AllDayTrackerModel.fromJson(jsonDecode(response.body));
        } else {
          result = ErrorModel.fromJson(res);
        }
      } else if (response.statusCode == 500) {
        result = ErrorModel(status: "0", message: GwcApi.oopsMessage);
      } else {
        print('status not equal called');
        final res = jsonDecode(response.body);
        result = ErrorModel.fromJson(res);
      }
    } catch (e) {
      print("catch error::> $e");
      result = ErrorModel(status: "0", message: e.toString());
    }
    return result;
  }

//Kaleyra Integration

  Future getKaleyraAccessTokenApi(String kaleyraUID) async {
    dynamic result;
    // production or sandbox
    // final environment = "sandbox";
    // final region = "eu";
    // testing api key: ak_live_c1ef0ed161003e0a2b419d20
    // final endPoint = "https://cs.${environment}.${region}.bandyer.com";
    /// live endpoint
    const endPoint = "https://api.in.bandyer.com";

    const String url = "$endPoint/rest/sdk/credentials";
    try {
      final response = await httpClient.post(Uri.parse(url),
          headers: {'apikey': 'ak_live_d2ad6702fe931fbeb2fa9cb4'},
          body: {"user_id": kaleyraUID});
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        result = json['access_token'];
        print("access token got");
        _prefs!.setString(GwcApi.kaleyraAccessToken, result);
      } else {
        final json = jsonDecode(response.body);
        result = ErrorModel.fromJson(json);
      }
    } catch (e) {
      result = ErrorModel(status: "", message: e.toString());
    }
    return result;
  }

  Future getKaleyraChatListApi() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var kaleyraUserId = preferences.getString("kaleyraUserId")!;

    final path =
        "https://api.in.bandyer.com/rest/user/$kaleyraUserId/chat/list";

    dynamic result;

    print('getKaleyraChatListApi Response header: $path');

    try {
      final response = await httpClient.get(
        Uri.parse(path),
        headers: {
          'apikey': GwcApi.apiKey,
        },
      ).timeout(const Duration(seconds: 45));

      print('getKaleyraChatListApi Response header: $path');
      print('getKaleyraChatListApi Response status: ${response.statusCode}');
      print('getKaleyraChatListApi Response body: ${response.body}');

      final json = jsonDecode(response.body);
      print('serverGetAboutProgramDetails result: $json');

      if (response.statusCode == 200) {
        result = KaleyraChatListModel.fromJson(json);
      } else {
        result = ErrorModel.fromJson(json);
      }
    } catch (e) {
      result = ErrorModel(status: "0", message: e.toString());
    }

    return result;
  }

  //UV Desk Integration
  Future uvDeskTicketRaiseApi(Map data,{List<File>? attachments}) async {
    final path = GwcApi.uvDeskTicketRaiseApiUrl;

    Map bodyParam = data;
    // {
    //   "name" : name,
    //   "from" : email,
    //   "subject" : title,
    //   "message" : description,
    //   "actAsType" : "agent",
    //   "actAsEmail" : _prefs!.getString(SuccessMemberStorage.successMemberEmail),
    // };

        print("Login Details : $bodyParam");

    print("uvDesk Token : ${SuccessMemberStorage.uvDeskAccessToken}");

    dynamic result;
    var headers = {
      // "Authorization": adminToken,
      "Authorization": "Bearer ${SuccessMemberStorage.uvDeskAccessToken}",
    };

    try{

      var request = http.MultipartRequest('POST', Uri.parse(path));

      request.headers.addAll(headers);
      request.fields.addAll(Map.from(data));
      request.persistentConnection = false;

      if(attachments != null) {
        for(int i =0; i < attachments.length; i++){
          request.files.add(await http.MultipartFile.fromPath('attachments[$i]', attachments[i].path));
        }
      };

      // print("attachment .length: ${attachments!.length}");

      print("request.files.length: ${request.files.length}");

      var response = await http.Response.fromStream(await request.send())
          .timeout(Duration(seconds: 45));

      print('uvDeskTicketRaiseApi Response header: $path');
      print('uvDeskTicketRaiseApi Response status: ${response.statusCode}');
      print('uvDeskTicketRaiseApi Response body: ${response.body}');
      final res = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        print('uvDeskTicketRaiseApi result: $json');
        result = UvDeskTicketRaiseModel.fromJson(json);
      } else {
        result = ErrorModel.fromJson(res);
      }
    } catch (e) {
      result = ErrorModel(status: "0", message: e.toString());
    }
    return result;
  }

  getAllTicketListApi() async{
    String url = GwcApi.allTicketListApiUrl;
    print(url);

    dynamic result;
    try{
      final response = await httpClient.get(Uri.parse(url),
        headers: {
          'Authorization' : "Bearer ${SuccessMemberStorage.uvDeskAccessToken}",
        },
      ).timeout(Duration(seconds: 45));

      print('uvToken : ${SuccessMemberStorage.uvDeskAccessToken}');
      print('getTicketListApi Url: $url');
      print('getTicketListApi Response status: ${response.statusCode}');
      print('getTicketListApi Response body: ${response.body}');

      if(response.statusCode == 200){
        final json = jsonDecode(response.body);
        result = GetTicketListModel.fromJson(json);
      }
      else if(response.statusCode == 500) {
        result = ErrorModel(status: "0", message: GwcApi.oopsMessage);
      }
      else{
        result = ErrorModel(status: response.statusCode.toString(), message: response.body);
      }
    }
    catch (e) {
      print(e);
      result = ErrorModel(status: "", message: e.toString());
    }
    return result;
  }

  getOpenTicketListApi() async{
    String url = "${GwcApi.openListApiUrl}${_prefs!.getString(SuccessMemberStorage.successMemberUvId)}";
    print(url);

    dynamic result;
    try{
      final response = await httpClient.get(Uri.parse(url),
        headers: {
          'Authorization' : "Bearer ${SuccessMemberStorage.uvDeskAccessToken}",
        },
      ).timeout(Duration(seconds: 45));

      print('getOpenTicketListApi Url: $url');
      print('getOpenTicketListApi Response status: ${response.statusCode}');
      print('getOpenTicketListApi Response body: ${response.body}');

      if(response.statusCode == 200){
        final json = jsonDecode(response.body);
        result = GetTicketListModel.fromJson(json);
      }
      else if(response.statusCode == 500) {
        result = ErrorModel(status: "0", message: GwcApi.oopsMessage);
      }
      else{
        result = ErrorModel(status: response.statusCode.toString(), message: response.body);
      }
    }
    catch (e) {
      print(e);
      result = ErrorModel(status: "", message: e.toString());
    }
    return result;
  }

  getAnsweredThreadsApi(String ticketId) async{
    String url = "${GwcApi.answeredListApiUrl}${_prefs!.getString(SuccessMemberStorage.successMemberUvId)}";
    print(url);

    dynamic result;
    try{
      final response = await httpClient.get(Uri.parse(url),
        headers: {
          'Authorization' : "Bearer ${SuccessMemberStorage.uvDeskAccessToken}",
        },
      ).timeout(const Duration(seconds: 45));

      print('getAnsweredThreadsApi Url: $url');
      print('getAnsweredThreadsApi Response status: ${response.statusCode}');
      print('getAnsweredThreadsApi Response body: ${response.body}');

      if(response.statusCode == 200){
        final json = jsonDecode(response.body);
        result = GetTicketListModel.fromJson(json);
      }
      else if(response.statusCode == 500) {
        result = ErrorModel(status: "0", message: GwcApi.oopsMessage);
      }
      else{
        result = ErrorModel(status: response.statusCode.toString(), message: response.body);
      }
    }
    catch (e) {
      print(e);
      result = ErrorModel(status: "", message: e.toString());
    }
    return result;
  }

  getResolvedThreadsApi(String ticketId) async{
    String url = "${GwcApi.resolvedListApiUrl}${_prefs!.getString(SuccessMemberStorage.successMemberUvId)}";
    print(url);

    dynamic result;
    try{
      final response = await httpClient.get(Uri.parse(url),
        headers: {
          'Authorization' : "Bearer ${SuccessMemberStorage.uvDeskAccessToken}",
        },
      ).timeout(const Duration(seconds: 45));

      print('getResolvedThreadsApi Url: $url');
      print('getResolvedThreadsApi Response status: ${response.statusCode}');
      print('getResolvedThreadsApi Response body: ${response.body}');

      if(response.statusCode == 200){
        final json = jsonDecode(response.body);
        result = GetTicketListModel.fromJson(json);
      }
      else if(response.statusCode == 500) {
        result = ErrorModel(status: "0", message: GwcApi.oopsMessage);
      }
      else{
        result = ErrorModel(status: response.statusCode.toString(), message: response.body);
      }
    }
    catch (e) {
      print(e);
      result = ErrorModel(status: "", message: e.toString());
    }
    return result;
  }

  getClosedThreadsApi(String ticketId) async{
    String url = "${GwcApi.closedListApiUrl}${_prefs!.getString(SuccessMemberStorage.successMemberUvId)}";
    print(url);

    dynamic result;
    try{
      final response = await httpClient.get(Uri.parse(url),
        headers: {
          'Authorization' : "Bearer ${SuccessMemberStorage.uvDeskAccessToken}",
        },
      ).timeout(const Duration(seconds: 45));

      print('getClosedThreadsApi Url: $url');
      print('getClosedThreadsApi Response status: ${response.statusCode}');
      print('getClosedThreadsApi Response body: ${response.body}');

      if(response.statusCode == 200){
        final json = jsonDecode(response.body);
        result = GetTicketListModel.fromJson(json);
      }
      else if(response.statusCode == 500) {
        result = ErrorModel(status: "0", message: GwcApi.oopsMessage);
      }
      else{
        result = ErrorModel(status: response.statusCode.toString(), message: response.body);
      }
    }
    catch (e) {
      print(e);
      result = ErrorModel(status: "", message: e.toString());
    }
    return result;
  }

  getGroupListApi() async{

    String userName = "${_prefs!.getString(SuccessMemberStorage.successMemberName)}";
    print("User name : $userName");
    List<String> firstName = userName.split(' ');
    print("first name : ${firstName[0]}");
    
    String url = "${GwcApi.groupOfListApiUrl}${firstName[0]}";
    print(url);

    dynamic result;
    try{
      final response = await httpClient.get(Uri.parse(url),
        headers: {
          'Authorization' : "Bearer ${SuccessMemberStorage.uvDeskAccessToken}",
        },
      ).timeout(const Duration(seconds: 45));

      print('getClosedThreadsApi Url: $url');
      print('getClosedThreadsApi Response status: ${response.statusCode}');
      print('getClosedThreadsApi Response body: ${response.body}');

      if(response.statusCode == 200){
        final json = jsonDecode(response.body);
        result = GroupListModel.fromJson(json);
      }
      else if(response.statusCode == 500) {
        result = ErrorModel(status: "0", message: GwcApi.oopsMessage);
      }
      else{
        result = ErrorModel(status: response.statusCode.toString(), message: response.body);
      }
    }
    catch (e) {
      print(e);
      result = ErrorModel(status: "", message: e.toString());
    }
    return result;
  }

  getTicketThreadsApi(String ticketId) async{
    String url = "${GwcApi.threadsApiUrl}/$ticketId";
    print(url);
    dynamic result;
    try{
      final response = await httpClient.get(Uri.parse(url),
        headers: {
          'Authorization' : "Bearer ${SuccessMemberStorage.uvDeskAccessToken}",
        },
      ).timeout(const Duration(seconds: 45));

      print("uvToken : ${SuccessMemberStorage.uvDeskAccessToken}");

      print('getTicketThreadsApi Url: $url');
      print('getTicketThreadsApi Response status: ${response.statusCode}');
      print('getTicketThreadsApi Response body: ${response.body}');

      if(response.statusCode == 200){
        final json = jsonDecode(response.body);
        result = ThreadsListModel.fromJson(json);
      }
      else if(response.statusCode == 500) {
        result = ErrorModel(status: "0", message: GwcApi.oopsMessage);
      }
      else{
        result = ErrorModel(status: response.statusCode.toString(), message: response.body);
      }
    }
    catch (e) {
      print(e);
      result = ErrorModel(status: "", message: e.toString());
    }
    return result;
  }

  Future uvDeskSendReplyApi(String ticketId, Map data, {List<File>? attachments}) async {
    final path = "$uvBaseUrl/ticket/$ticketId/thread";
        // "https://fembuddy.uvdesk.com/en/api/ticket/$threadId/threads.json";

    print("data : $data");

    var bodyData = jsonEncode(data);

    dynamic result;
    var headers = {
      // "Authorization": adminToken,
      "Authorization": "Bearer ${SuccessMemberStorage.uvDeskAccessToken}",
    };
    try{
      var request = http.MultipartRequest('POST', Uri.parse(path));

      request.headers.addAll(headers);
      request.fields.addAll(Map.from(data));
      request.persistentConnection = false;

      if(attachments != null) {
        for(int i =0; i < attachments.length; i++){
          request.files.add(await http.MultipartFile.fromPath('attachments[$i]', attachments[i].path));
        }
        print("attachment .length: ${attachments.length}");
      }

      print("request.files.length: ${request.files.length}");

      var response = await http.Response.fromStream(await request.send())
          .timeout(Duration(seconds: 45));

      print("uvToken : ${SuccessMemberStorage.uvDeskAccessToken}");

      print('uvDeskSendReplyApi Response header: $path');
      print('uvDeskSendReplyApi Response status: ${response.statusCode}');
      print('uvDeskSendReplyApi Response body: ${response.body}');
      final res = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        print('uvDeskSendReplyApi result: $json');
        result = SentReplyModel.fromJson(json);
      } else {
        result = ErrorModel.fromJson(res);
      }
    } catch (e) {
      result = ErrorModel(status: "0", message: e.toString());
    }
    return result;
  }

  Future uvDeskCancelledApi(String property, String value,String threadId) async {
    final path = "${GwcApi.sendClosedResolvedApiUrl}/$threadId";

    Map bodyParam = {
      'property': property,
      'value': value,
    };
    print("Login Details : $bodyParam");

    print("uvDesk Token : ${SuccessMemberStorage.uvDeskAccessToken}");

    dynamic result;

    try {
      final response = await httpClient.patch(
        Uri.parse(path),
        body: bodyParam,
        headers: {
          'Authorization' : "Bearer ${SuccessMemberStorage.uvDeskAccessToken}",
          //   'OAuth 2.0': "Bearer ${GwcApi.uvDeskAccessToken}",
        },
      ).timeout(const Duration(seconds: 45));

      print('uvDeskCancelledApi Response header: $path');
      print('uvDeskCancelledApi Response status: ${response.statusCode}');
      print('uvDeskCancelledApi Response body: ${response.body}');
      final res = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        print('uvDeskSendReplyApi result: $json');
        result = SentReplyModel.fromJson(json);
      } else {
        result = ErrorModel.fromJson(res);
      }
    } catch (e) {
      result = ErrorModel(status: "0", message: e.toString());
    }
    return result;
  }

  Future uvDeskTransferToDoctorApi(String property,String value,String threadId) async {
    final path = "${GwcApi.sendTransferToDoctorApiUrl}/$threadId";

    Map bodyParam = {
      "property":property,
      "value":value
    };
    print("Login Details : $bodyParam");

    print("uvDesk Token : ${SuccessMemberStorage.uvDeskAccessToken}");

    dynamic result;

    try {
      final response = await httpClient.patch(
        Uri.parse(path),
        body: bodyParam,
        headers: {
          'Authorization' : "Bearer ${SuccessMemberStorage.uvDeskAccessToken}",
          //   'OAuth 2.0': "Bearer ${GwcApi.uvDeskAccessToken}",
        },
      ).timeout(const Duration(seconds: 45));

      print('uvDeskTransferToDoctorApi Response header: $path');
      print('uvDeskTransferToDoctorApi Response status: ${response.statusCode}');
      print('uvDeskTransferToDoctorApi Response body: ${response.body}');
      final res = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        print('uvDeskTransferToDoctorApi result: $json');
        result = SentReplyModel.fromJson(json);
      } else {
        result = ErrorModel.fromJson(res);
      }
    } catch (e) {
      result = ErrorModel(status: "0", message: e.toString());
    }
    return result;
  }

  Future uvDeskReassignApi(String agentId, String threadId) async {
    final path = "$uvBaseUrl/ticket/$threadId/agent";

    Map bodyParam = {
      'id': agentId,
    };
    print("Login Details : $bodyParam");

    print("uvDesk Token : ${SuccessMemberStorage.uvDeskAccessToken}");

    dynamic result;

    try {
      final response = await httpClient.put(
        Uri.parse(path),
        body: jsonEncode(bodyParam),
        headers: {
          'Authorization' : "Bearer ${SuccessMemberStorage.uvDeskAccessToken}",
        },
      ).timeout(const Duration(seconds: 45));

      print('uvDeskReassignApi Response header: $path');
      print('uvDeskReassignApi Response status: ${response.statusCode}');
      print('uvDeskReassignApi Response body: ${response.body}');
      final res = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        print('uvDeskReassignApi result: $json');
        result = SentReplyModel.fromJson(json);
      } else {
        result = ErrorModel.fromJson(res);
      }
    } catch (e) {
      result = ErrorModel(status: "0", message: e.toString());
    }
    return result;
  }

  getDoctorDetailsApi(String email) async{

      String url = "${GwcApi.getDoctorDetailsApiUrl}/$email";
    print(url);

      var token = _prefs?.getString("token")!;

    dynamic result;
    try{
      final response = await httpClient.get(Uri.parse(url),
        headers: {
          'Authorization' : "Bearer $token",
        },
      ).timeout(const Duration(seconds: 45));

      print('getDoctorDetailsApi Url: $url');
      print('getDoctorDetailsApi Response status: ${response.statusCode}');
      print('getDoctorDetailsApi Response body: ${response.body}');

      if(response.statusCode == 200){
        final json = jsonDecode(response.body);
        result = GetDoctorDetailsModel.fromJson(json);
      }
      else if(response.statusCode == 500) {
        result = ErrorModel(status: "0", message: GwcApi.oopsMessage);
      }
      else{
        result = ErrorModel(status: response.statusCode.toString(), message: response.body);
      }
    }
    catch (e) {
      print(e);
      result = ErrorModel(status: "", message: e.toString());
    }
    return result;
  }

}
