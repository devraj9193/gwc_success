import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  static String doctorChatGroupIdUrl =
      "$baseUrl/api/getData/get_doctor_success_chat_group";

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

  static String maintenanceGuideUrl = "$baseUrl/api/listData/post_program_list";

  static String notificationListUrl = "$baseUrl/api/getData/notification_list";

  static String callApiUrl = "$baseUrl/api/getData/call_user";

  static String preparatoryApiUrl =
      "$baseUrl/api/getDataList/user_prep_meal_plan";

  static String preparatoryAnswerApiUrl =
      "$baseUrl/api/getDataList/tracking_prep_meal";

  static String transitionApiUrl =
      "$baseUrl/api/getDataList/user_trans_meal_plan";

  static String transitionAnswerApiUrl =
      "$baseUrl/api/getDataList/trans_meal_tracking_data";


  static String unClaimedCustomerListApiUrl =
      "$baseUrl/api/getDataValue/not_claimed_customer";

  static String claimedCustomerListApiUrl =
      "$baseUrl/api/getDataValue/claimed_customers";

  static String claimCustomerApiUrl =
      "$baseUrl/api/getDataValue/claim_customer";

  static String nutriDelightApiUrl =
      "$baseUrl/api/getData/NutriDelight";

  // selected day, user id, detox = 1, healing = 2 need to pass
  static String dailyProgressMealPlanApiUrl =
      "$baseUrl/api/getDataList/user_day_meal_plan";

  static String allDayTrackerApiUrl =
      "$baseUrl/api/getData/NutriDelightTracker";

  static String getDoctorDetailsApiUrl = "$baseUrl/api/getDataValue/get_doctor_details";

  // SHIP ROCKET
  static String shipRocketLoginApiUrl =
      "https://apiv2.shiprocket.in/v1/external/auth/login";

  static String shippingTrackingApiUrl =
      "https://apiv2.shiprocket.in/v1/external/courier/track/awb";

  // Kaleyra Chat List
  static String KaleyraChatListApiUrl = "https://api.in.bandyer.com/rest/user/GWC_Success/chat/list";

  //uvDesk Urls
  static String uvDeskTicketRaiseApiUrl = "$uvBaseUrl/ticket";
  // static String uvDeskTicketRaiseApiUrl =  "https://fembuddy.uvdesk.com/en/api/tickets.json";

  static String allTicketListApiUrl = "$uvBaseUrl/tickets?status=1|2|3|4|5|6";
  // "https://fembuddy.uvdesk.com/en/api/tickets.json?status=1|2|3|4|5|6";

  static String threadsApiUrl = "$uvBaseUrl/ticket";

  static String openListApiUrl = "$uvBaseUrl/tickets?status=1&agent=";

  static String answeredListApiUrl = "$uvBaseUrl/tickets?status=3&agent=";

  static String resolvedListApiUrl = "$uvBaseUrl/tickets?status=4&agent=";

  static String closedListApiUrl = "$uvBaseUrl/tickets?status=5&agent=";

  static String sendClosedResolvedApiUrl = "$uvBaseUrl/ticket";

  static String sendTransferToDoctorApiUrl = "$uvBaseUrl/ticket";

  static String groupOfListApiUrl = "$uvBaseUrl/groups?search=";


  static const String isLogin = "login";
  static const String groupId = '635fa22932eaaf0030c5ef1e';
  static const String doctorGroupId = '635fa22932eaaf0030c5ef1e';
  static const String qbCurrentUserId = 'curr_userId';
  static const String getQBSession = 'qb_session';
  static const String isQBLogin = 'is_qb_login';
  static const String qbUsername = 'qb_username';

  static const String apiKey = "ak_live_d2ad6702fe931fbeb2fa9cb4";
  static const String appId =
      "mAppId_a4908f3e2fa60c828daff5e875b0af422545696fa0bffa76d614489aae8d";
  static const String kaleyraAccessToken = "kaleyra_access_token";

  static String oopsMessage = "OOps ! Something went wrong.";

  static String successMemberName = "successMemberName";
  static String successMemberProfile = "successMemberProfile";
  static String successMemberAddress = "successMemberAddress";

  static String shipRocketEmail = "disoltech22@gmail.com";
  static String shipRocketPassword = "adithya7224";

      // "HBTCAEHAAAOTTVECVMNJGLWYVXVN3GBJUR0XVZNOJTO4N1Y4LD7LT3LE4PVONODF";

  static SharedPreferences? preferences;
  static Future<String?> getDeviceId() async {
    String? deviceId = await PlatformDeviceId.getDeviceId;
    return deviceId;
  }

  showSnackBar(BuildContext context, String message,{int? duration, bool? isError, SnackBarAction? action, double? bottomPadding}){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor:(isError == null || isError == false) ? gPrimaryColor : gSecondaryColor.withOpacity(0.55),
        content: Text(message),
        margin: (bottomPadding != null) ? EdgeInsets.only(bottom: bottomPadding) : null,
        duration: Duration(seconds: duration ?? 3),
        action: action,
      ),
    );
  }
}


// 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