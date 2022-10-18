import 'constants.dart';

class GwcApi {
  static String loginApiUrl = "$baseUrl/api/login";

  static String logoutApiUrl = "$baseUrl/api/logout";

  static String calendarUrl = "$baseUrl/api/listData/calendar";

  static String linkedListApiUrl =
      "$baseUrl/api/getDataValue/linked_customers";

  static String customersListApiUrl =
      "$baseUrl/api/getDataValue/customers_list";

  static String doctorsListApiUrl =
      "$baseUrl/api/getDataValue/doctors_list";

  static String successTeamListApiUrl =
      "$baseUrl/api/getDataValue/success_team_list";

  static String termsAndConditionsApiUrl =
      "$baseUrl/api/list/terms_and_conditions";

  static String getUserProfileApiUrl = "$baseUrl/api/user";

  static String getCustomerProfileApiUrl =
      "$baseUrl/api/getDataValue/customer_profile";

  static String customerChatListApiUrl =
      "$baseUrl/api/getData/get_chat_messages_list/success_team_chat";
}
