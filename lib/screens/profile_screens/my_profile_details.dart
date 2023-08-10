import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import '../../service/api_service.dart';
import '../../model/success_user_model/success_member_profile_repository.dart';
import '../../model/success_user_model/success_member_service.dart';
import '../../utils/constants.dart';
import '../../utils/gwc_api.dart';
import '../../widgets/common_screen_widgets.dart';
import '../../widgets/widgets.dart';
import 'package:http/http.dart' as http;

class MyProfileDetails extends StatefulWidget {
  const MyProfileDetails({Key? key}) : super(key: key);

  @override
  State<MyProfileDetails> createState() => _MyProfileDetailsState();
}

class _MyProfileDetailsState extends State<MyProfileDetails> {
  final SharedPreferences _pref = GwcApi.preferences!;

  String accessToken = "";
  Future? getProfileDetails;

  @override
  void initState() {
    super.initState();
    getProfileData();
  }

  getProfileData() {
    accessToken = _pref.getString("token")!;
    setState(() {});
    print("accessToken: $accessToken");
    getProfileDetails = SuccessMemberProfileService(repository: userRepository)
        .getSuccessMemberProfileService(accessToken);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: buildAppBar(() {
          Navigator.pop(context);
        }),
        backgroundColor: whiteTextColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 3.w, top: 1.h, bottom: 2.h),
              child: Text(
                "My Profile",
                textAlign: TextAlign.center,
                style: ProfileScreenText().headingText(),
              ),
            ),
            Expanded(
              child: buildUserDetails(),
            ),
          ],
        ),
      ),
    );
  }

  buildUserDetails() {
    return FutureBuilder(
        future: getProfileDetails,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 7.h),
              child: Image(
                image: const AssetImage("assets/images/Group 5294.png"),
                height: 35.h,
              ),
            );
          } else if (snapshot.hasData) {
            var data = snapshot.data;
            return LayoutBuilder(builder: (context, constraints) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 40.h,
                      decoration: BoxDecoration(
                        color: whiteTextColor,
                        border: Border.all(
                            width: 1, color: lightTextColor.withOpacity(0.3)),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                        image: DecorationImage(
                            image: NetworkImage(data.data.profile.toString()),
                            fit: BoxFit.fill),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 38.h,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 66.h,
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      decoration: BoxDecoration(
                          color: gWhiteColor,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12)),
                          border: Border.all(
                              width: 1,
                              color: lightTextColor.withOpacity(0.3))),
                      child: Column(
                        children: [
                          SizedBox(height: 3.h),
                          profileTile("Name : ", data.data.name ?? ""),
                          profileTile("Age : ", data.data.age ?? ""),
                          profileTile("Gender : ", data.data.gender ?? ""),
                          profileTile("Email : ", data.data.email ?? ""),
                          profileTile(
                              "Mobile Number : ", data.data.phone ?? ""),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            });
          }
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h),
            child: buildCircularIndicator(),
          );
        });
  }

  profileTile(String heading, String title) {
    return Column(
      children: [
        Row(
          // mainAxisSize: MainAxisSize.min,
          children: [
            Text(heading, style: ProfileScreenText().nameText()),
            Expanded(
              child: Text(title, style: ProfileScreenText().otherText()),
            ),
          ],
        ),
        Container(
          height: 1,
          margin: EdgeInsets.symmetric(vertical: 2.h),
          color: lightTextColor.withOpacity(0.2),
        ),
      ],
    );
  }

  final SuccessMemberProfileRepository userRepository =
      SuccessMemberProfileRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );
}
