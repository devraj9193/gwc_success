import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import '../../model/customer_profile_model.dart';
import '../../utils/constants.dart';
import '../../utils/gwc_api.dart';
import '../../widgets/common_screen_widgets.dart';
import '../../widgets/widgets.dart';
import '../customer_details_screens/active_details_screens/meal_plan_details.dart';
import 'case_sheet.dart';
import 'mr_screen.dart';

class ShowProfile extends StatefulWidget {
  const ShowProfile({Key? key}) : super(key: key);

  @override
  State<ShowProfile> createState() => _ShowProfileState();
}

class _ShowProfileState extends State<ShowProfile> {
  bool circular = true;
  GetCustomerModel? getCustomerModel;

  @override
  void initState() {
    super.initState();
    getProfileData();
  }

  void getProfileData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    var token = preferences.getString("token")!;
    var userId = preferences.getString("user_id");

    var response = await http
        .get(Uri.parse("${GwcApi.getCustomerProfileApiUrl}/$userId"), headers: {
      'Authorization': 'Bearer $token',
    });
    print("showUserProfileUrl : ${GwcApi.getCustomerProfileApiUrl}/$userId");
    print("showUserProfileResponse : ${response.body}");

    var data = jsonDecode(response.body);

    setState(() {
      getCustomerModel = GetCustomerModel.fromJson(data);
    });
    circular = false;
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
            SizedBox(height: 1.h),
            Expanded(
              child: buildUserDetails(),
            ),
          ],
        ),
      ),
    );
  }

  buildUserDetails() {
    return circular
        ? buildCircularIndicator()
        : LayoutBuilder(builder: (context, constraints) {
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
                      color: Colors.white,
                      border: Border.all(
                          width: 1, color: lightTextColor.withOpacity(0.3)),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                      image: DecorationImage(
                          image: NetworkImage(
                              getCustomerModel!.profile.toString()),
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
                        color: lightTextColor.withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 2.h),
                        profileTile(
                            "Name : ", getCustomerModel?.username ?? ""),
                        profileTile("Age : ", getCustomerModel?.age ?? ""),
                        getCustomerModel?.consultationDateAndTime == null
                            ? const SizedBox()
                            : profileTile(
                                "Consultation & time : ",
                                buildTimeDate(
                                    getCustomerModel
                                            ?.consultationDateAndTime?.date ??
                                        "",
                                    getCustomerModel?.consultationDateAndTime
                                            ?.slotStartTime ??
                                        ""),
                              ),
                        getCustomerModel?.programName == null
                            ? const SizedBox()
                            : profileTile("Program Name : ",
                                getCustomerModel?.programName?.name ?? ""),
                        getCustomerModel?.mealAndYogaPlan == null
                            ? const SizedBox()
                            : profileTile("Meal & Yoga Plan : ",
                                getCustomerModel?.mealAndYogaPlan?.name ?? "",
                                showViewText:
                                    getCustomerModel?.mealAndYogaPlan == null
                                        ? false
                                        : true,
                                viewText: 'view', func: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const MealPlanDetails(
                                      isFromProfile: true,
                                    ),
                                  ),
                                );
                              }),
                        getCustomerModel?.mrReport == null
                            ? const SizedBox()
                            : profileTile("MR Report : ", "Uploaded",
                                showViewText: getCustomerModel?.mrReport == null
                                    ? false
                                    : true,
                                viewText: 'view', func: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => MRScreen(
                                      report:
                                          "${getCustomerModel?.mrReport?.report}",
                                    ),
                                  ),
                                );
                              }),
                        getCustomerModel?.caseSheet == null
                            ? const SizedBox()
                            : profileTile("Case Sheet : ", "Uploaded",
                                showViewText:
                                    getCustomerModel?.caseSheet == null
                                        ? false
                                        : true,
                                viewText: 'view', func: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => CaseSheetDetails(
                                      report:
                                          "${getCustomerModel?.caseSheet?.report}",
                                    ),
                                  ),
                                );
                              }),
                      ],
                    ),
                  ),
                ),
              ],
            );
          });
  }

  profileTile(String heading, String title,
      {bool showViewText = false, String? viewText, func}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.5.h),
      child: Row(
        // mainAxisSize: MainAxisSize.min,
        children: [
          Text(heading, style: ProfileScreenText().nameText()),
          (!showViewText)
              ? Text(title, style: ProfileScreenText().otherText())
              : RichText(
                  text: TextSpan(
                      text: title,
                      style: ProfileScreenText().otherText(),
                      children: [
                        const TextSpan(
                          text: ' ',
                          style: TextStyle(
                            fontFamily: "GothamBold",
                          ),
                        ),
                        TextSpan(
                          text: viewText,
                          style: TextStyle(
                            fontFamily: fontBook,
                            color: gSecondaryColor,
                            fontSize: fontSize08,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()..onTap = func,
                        ),
                      ]),
                ),
        ],
      ),
    );
  }

  buildTimeDate(String date, String time) {
    var split = time.split(':');
    String hour = split[0];
    String minute = split[1];
    DateTime timing = DateTime.parse("$date $time");
    String amPm = 'AM';
    if (timing.hour >= 12) {
      amPm = 'PM';
    }
    return "${DateFormat('dd MMMM yyyy').format(DateTime.parse("$date $time"))} / $hour : $minute $amPm";
  }
}
