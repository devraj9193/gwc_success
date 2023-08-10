import 'gwc_api.dart';

final _prefs = GwcApi.preferences;

class SuccessMemberStorage{


  static String successMemberName = "successMemberName";
  static String successMemberEmail = "successMemberEmail";
  static String successMemberUvId = "successMemberUvId";
  static String successMemberUvToken = "successMemberUvToken";

  static String uvDeskAccessToken = "${_prefs!.getString(SuccessMemberStorage.successMemberUvToken)}";
      // "KVTKPATJ9NYABQGFGKBMFLF9QROE07ERDMJGR61Q86MEQGPZDKAORJFGV5VG4X18";
}