import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gwc_success_team/screens/login_screen/success_login.dart';
import 'package:gwc_success_team/screens/profile_screens/terms_conditions_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import '../../controller/user_profile_controller.dart';
import '../../utils/constants.dart';
import '../../widgets/widgets.dart';
import 'faq_screen.dart';
import 'my_profile_details.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  UserProfileController userProfileController =
      Get.put(UserProfileController());
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 5.w),
            child: FutureBuilder(
                future: userProfileController.fetchUserProfile(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.hasError) {
                  } else if (snapshot.hasData) {
                    var data = snapshot.data;
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildAppBar(() {
                          Navigator.pop(context);
                        }),
                        Text(
                          "My Profile",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'GothamBold',
                              color: gPrimaryColor,
                              fontSize: 12.sp),
                        ),
                        SizedBox(height: 2.h),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const MyProfileDetails(),
                                  ),
                                );
                              },
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(
                                  data.data.profile.toString(),
                                ),
                              ),
                            ),
                            SizedBox(width: 2.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data.data.name ?? "",
                                  style: TextStyle(
                                    color: kTextColor,
                                    fontFamily: 'GothamMedium',
                                    fontSize: 10.sp,
                                  ),
                                ),
                                SizedBox(height: 0.6.h),
                                Text(
                                  data.data.address ?? "Bangalore",
                                  style: TextStyle(
                                    color: kTextColor,
                                    fontFamily: 'GothamBook',
                                    fontSize: 9.sp,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 2.h),
                        profileTile(
                            "assets/images/Group 2753.png", "My Profile", () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const MyProfileDetails(),
                            ),
                          );
                        }),
                        // Container(
                        //   height: 1,
                        //   color: Colors.grey.withOpacity(0.3),
                        // ),
                        // profileTile("assets/images/Group 2747.png", "FAQ", () {
                        //   Navigator.of(context).push(
                        //     MaterialPageRoute(
                        //       builder: (context) => const FaqScreen(),
                        //     ),
                        //   );
                        // }),
                        // Container(
                        //   height: 1,
                        //   color: Colors.grey.withOpacity(0.3),
                        // ),
                        // profileTile("assets/images/Group 2748.png",
                        //     "Terms & Conditions", () {
                        //   Navigator.of(context).push(
                        //     MaterialPageRoute(
                        //       builder: (context) =>
                        //           const TermsConditionsScreen(),
                        //     ),
                        //   );
                        // }),
                        Container(
                          height: 1,
                          color: Colors.grey.withOpacity(0.3),
                        ),
                        profileTile("assets/images/Group 2744.png", "Logout",
                            () {
                          dialog(context);
                        }),
                        Container(
                          height: 1,
                          color: Colors.grey.withOpacity(0.3),
                        ),
                      ],
                    );
                  }
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.h),
                    child: buildCircularIndicator(),
                  );
                }),
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
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: gBlackColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Image(
              image: AssetImage(image),
              height: 3.h,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: kTextColor,
                fontFamily: 'GothamMedium',
                fontSize: 10.sp,
              ),
            ),
          ),
          GestureDetector(
            onTap: func,
            child: Icon(
              Icons.arrow_forward_ios,
              color: gBlackColor,
              size: 2.h,
            ),
          ),
        ],
      ),
    );
  }

  void dialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      barrierColor: gWhiteColor.withOpacity(0.8),
      context: context,
      builder: (context) => Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 5.w),
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
          decoration: BoxDecoration(
            color: gWhiteColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: gMainColor, width: 1),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                "Log Out ?",
                style: TextStyle(
                  color: gTextColor,
                  fontFamily: "GothamMedium",
                  fontSize: 11.sp,
                ),
              ),
              SizedBox(height: 2.h),
              Text('Are you sure you want to log out?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "GothamBook",
                    color: gTextColor,
                    fontSize: 11.sp,
                  )),
              SizedBox(height: 2.5.h),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(false),
                    child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 9.w, vertical: 1.h),
                        decoration: BoxDecoration(
                          color: gWhiteColor,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: gMainColor),
                        ),
                        child: Text("Cancel",
                            style: TextStyle(
                              color: gPrimaryColor,
                              fontFamily: "GothamMedium",
                              fontSize: 9.sp,
                            ))),
                  ),
                  SizedBox(width: 3.w),
                  GestureDetector(
                    onTap: () async {
                      SharedPreferences preferences =
                          await SharedPreferences.getInstance();
                      preferences.clear();
                      preferences.commit();
                      Get.to(const SuccessLogin());
                    },
                    child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 9.w, vertical: 1.h),
                        decoration: BoxDecoration(
                          color: gPrimaryColor,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: gMainColor),
                        ),
                        child: Text("Log Out",
                            style: TextStyle(
                              color: gMainColor,
                              fontFamily: "GothamMedium",
                              fontSize: 9.sp,
                            ))),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
