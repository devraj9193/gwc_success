import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import '../../model/error_model.dart';
import '../../model/login_model/logout_model.dart';
import '../../repository/login_repo/login_otp_repository.dart';
import '../../service/api_service.dart';
import '../../service/login_service/login_otp_service.dart';
import '../../utils/constants.dart';
import '../../utils/gwc_api.dart';
import '../../widgets/common_screen_widgets.dart';
import '../../widgets/widgets.dart';
import '../kaleyra_chat_list_screen/kaleyra_chat_list_screen.dart';
import '../login_screen/success_login.dart';
import 'my_profile_details.dart';
import 'package:http/http.dart' as http;

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final SharedPreferences _pref = GwcApi.preferences!;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: dashboardAppBar(),
        backgroundColor: whiteTextColor,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 5.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "My Profile",
                  textAlign: TextAlign.center,
                  style: ProfileScreenText().headingText(),
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const MyProfileDetails(),
                          ),
                        );
                      },
                      child: CircleAvatar(
                        radius: 3.h,
                        backgroundImage: NetworkImage(
                          "${_pref.getString(GwcApi.successMemberProfile)}",
                        ),
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${_pref.getString(GwcApi.successMemberName)}",
                            style: ProfileScreenText().nameText()),
                        SizedBox(height: 0.6.h),
                        Text(_pref.getString(GwcApi.successMemberAddress) ?? "",
                            style: ProfileScreenText().otherText()),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                profileTile("assets/images/Group 2753.png", "My Profile", () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const MyProfileDetails(),
                    ),
                  );
                }),
                Container(
                  height: 1,
                  color: Colors.grey.withOpacity(0.3),
                ),
                profileTile("assets/images/noun-chat-5153452.png", "Chat Support", () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const KaleyraChatListScreen(),
                    ),
                  );
                }),
                Container(
                  height: 1,
                  color: Colors.grey.withOpacity(0.3),
                ),
                // profileTile("assets/images/Group 2748.png",
                //     "Tickets", () {
                //   Navigator.of(context).push(
                //     MaterialPageRoute(
                //       builder: (context) =>
                //           const AllTicketListScreen(),
                //     ),
                //   );
                // }),
                // Container(
                //   height: 1,
                //   color: Colors.grey.withOpacity(0.3),
                // ),
                profileTile("assets/images/Group 2744.png", "Logout", () {
                  logoutDialog(context);
                }),
                Container(
                  height: 1,
                  color: Colors.grey.withOpacity(0.3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  profileTile(String image, String title, func) {
    return GestureDetector(
      onTap: func,
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 2.h),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: gBlackColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Image(
              image: AssetImage(image),
              height: 4.h,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              title,
              style: ProfileScreenText().subHeadingText(),
            ),
          ),
          GestureDetector(
            onTap: func,
            child: Icon(
              Icons.arrow_forward_ios,
              color: gBlackColor,
              size: 1.8.h,
            ),
          ),
        ],
      ),
    );
  }

  bool showLogoutProgress = false;

  var logoutProgressState;

  final LoginOtpRepository repository = LoginOtpRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );

  void logOut() async {
    logoutProgressState(() {
      showLogoutProgress = true;
    });
    final res =
    await LoginWithOtpService(repository: repository).logoutService();

    if (res.runtimeType == LogoutModel) {
      clearAllUserDetails();
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const SuccessLogin(),
      ));
    } else {
      ErrorModel model = res as ErrorModel;
      Get.snackbar(
        "",
        model.message!,
        colorText: gWhiteColor,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: gSecondaryColor.withOpacity(0.55),
      );
    }

    logoutProgressState(() {
      showLogoutProgress = true;
    });
  }

  clearAllUserDetails() {
    _pref.setBool(GwcApi.isLogin, false);
    _pref.remove("token");

    _pref.remove(GwcApi.successMemberName);
    _pref.remove(GwcApi.kaleyraAccessToken);
    // _pref.remove(AppConfig.User_Profile);
    // _pref.remove(AppConfig.User_Number);
  }

  void logoutDialog(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        barrierColor: gWhiteColor.withOpacity(0.8),
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (_, setstate) {
            logoutProgressState = setstate;
            return Center(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 5.w),
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: gWhiteColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: lightTextColor, width: 1),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      "Log Out ?",
                      style: TextStyle(
                        color: newBlackColor,
                        fontFamily: fontBold,
                        fontSize: fontSize11,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text('Are you sure you want to log out?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: fontBook,
                          color: newBlackColor,
                          fontSize: fontSize10,
                        )),
                    SizedBox(height: 2.5.h),
                    (showLogoutProgress)
                        ? Center(child: buildCircularIndicator())
                        : Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(false),
                          child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 9.w, vertical: 1.h),
                              decoration: BoxDecoration(
                                color: gWhiteColor,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: lightTextColor),
                              ),
                              child: Text("Cancel",
                                  style: TextStyle(
                                    color: newBlackColor,
                                    fontFamily: fontMedium,
                                    fontSize: fontSize09,
                                  ))),
                        ),
                        SizedBox(width: 3.w),
                        GestureDetector(
                          onTap: () async {
                            logOut();
                            // SharedPreferences preferences =
                            //     await SharedPreferences.getInstance();
                            // preferences.clear();
                            // preferences.commit();
                            // Get.to(const DoctorLogin());
                          },
                          child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 9.w, vertical: 1.h),
                              decoration: BoxDecoration(
                                color: gSecondaryColor,
                                borderRadius: BorderRadius.circular(8),
                                // border: Border.all(color: gMainColor),
                              ),
                              child: Text("Log Out",
                                  style: TextStyle(
                                    color: whiteTextColor,
                                    fontFamily: fontMedium,
                                    fontSize: fontSize09,
                                  ))),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }}
