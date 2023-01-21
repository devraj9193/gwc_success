import 'package:platform_device_id/platform_device_id.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';

class GwcApi {
  static String loginApiUrl = "$baseUrl/api/login";

  static String logoutApiUrl = "$baseUrl/api/logout";

  static String calendarUrl = "$baseUrl/api/listData/calendar";

  static String linkedListApiUrl = "$baseUrl/api/getDataValue/linked_customers";

  static String customersListApiUrl =
      "$baseUrl/api/getDataValue/customers_list";

  static String doctorsListApiUrl = "$baseUrl/api/getDataValue/doctors_list";

  static String successTeamListApiUrl =
      "$baseUrl/api/getDataValue/success_team_list";

  static String termsAndConditionsApiUrl =
      "$baseUrl/api/list/terms_and_conditions";

  static String getUserProfileApiUrl = "$baseUrl/api/user";

  static String getCustomerProfileApiUrl =
      "$baseUrl/api/getDataValue/customer_profile";

  static String chatGroupIdUrl = "$baseUrl/api/getData/get_chat_team_group";

  static String doctorChatGroupIdUrl = "$baseUrl/api/getData/get_doctor_success_chat_group";

 // static String doctorChatGroupIdUrl ="$baseUrl/api/getData/get_chat_messages_list/success_team_chat";

  static String customerChatListApiUrl =
      "$baseUrl/api/getData/get_chat_messages_group";

  static String dayMealListUrl = "$baseUrl/api/getDataList/user_day_meal_plan";

  static String pendingUserListApiUrl =
      "$baseUrl/api/getshippingData/shipping_customer_list";

  static String evaluationUrl =

      "$baseUrl/api/listData/customer_evaluation_form";

  static String customerMRReport = "$baseUrl/api/listData/customer_profile";

  static String mealPlanListUrl = "$baseUrl/api/listData/meal_plan_list";

  static String dayProgressListUrl = "$baseUrl/api/listData/progress";

  static String userOrderDetailsApiUrl =
      "$baseUrl/api/getshippingData/customer_order_details";

  static String consultationUrl = "$baseUrl/api/listData/consultation";

  static String maintenanceGuideUrl =
      "$baseUrl/api/listData/post_program_list";

  static String notificationListUrl = "$baseUrl/api/getData/notification_list";

  static String callApiUrl = "$baseUrl/api/getData/call_user";


  static const String groupId = '635fa22932eaaf0030c5ef1e';
  static const String doctorGroupId = '635fa22932eaaf0030c5ef1e';
  static const String qbCurrentUserId = 'curr_userId';
  static const String getQBSession = 'qb_session';
  static const String isQBLogin = 'is_qb_login';
  static const String qbUsername = 'qb_username';

  static SharedPreferences? preferences;
  static Future<String?> getDeviceId() async {
    String? deviceId = await PlatformDeviceId.getDeviceId;
    return deviceId;
  }
}
