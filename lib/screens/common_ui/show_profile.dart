import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import '../../model/customer_profile_model.dart';
import '../../utils/constants.dart';
import '../../utils/gwc_api.dart';
import '../../widgets/widgets.dart';
import 'day_plan_details.dart';

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

    var response = await http.get(
        Uri.parse("${GwcApi.getCustomerProfileApiUrl}/$userId"),
        headers: {
          'Authorization': 'Bearer $token',
        });

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
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 2.h, left: 3.w),
              child: buildAppBar(() {
                Navigator.pop(context);
              }),
            ),
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
    return   circular
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
                      height: 35.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 2,
                              color: Colors.grey.withOpacity(0.5))
                        ],
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                        image: DecorationImage(
                            image: NetworkImage(getCustomerModel!.profile.toString()),
                            fit: BoxFit.fill),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 33.h,
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
                        border: Border.all(width: 1, color: gMainColor),
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 2.h),
                          profileTile("Name : ", getCustomerModel?.username ?? ""),
                          profileTile("Age : ", getCustomerModel?.age ?? ""),
                          profileTile(
                              "Consultation & time : ",
                              "${getCustomerModel?.consultationDateAndTime?.appointmentDate} / ${getCustomerModel?.consultationDateAndTime?.appointmentStartTime}" ??
                                  ""),
                          profileTile(
                              "Program Name : ", getCustomerModel?.programName?.name ?? ""),
                          profileTile("Meal & Yoga Plan : ",
                              getCustomerModel?.mealAndYogaPlan?.name ?? "",
                              showViewText:
                              getCustomerModel?.mealAndYogaPlan == null ? false : true,
                              viewText: 'view', func: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const DayPlanDetails(),
                              ),
                            );
                          }),
                          // profileTile("MR Report : ", "Uploaded",
                          //     showViewText:
                          //         data.mrReport == null ? false : true,
                          //     viewText: 'view', func: () {
                          //   Navigator.of(context).push(
                          //     MaterialPageRoute(
                          //       builder: (context) => MRScreen(
                          //         report: data.mrReport.report,
                          //       ),
                          //     ),
                          //   );
                          // }),
                          // profileTile("Case Sheet : ", "Uploaded",
                          //     showViewText:
                          //         data.caseSheet == null ? false : true,
                          //     viewText: 'view', func: () {
                          //   Navigator.of(context).push(
                          //     MaterialPageRoute(
                          //       builder: (context) => CaseSheetDetails(
                          //         report: data.caseSheet.report,
                          //       ),
                          //     ),
                          //   );
                          // }),
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
          Text(
            heading,
            style: TextStyle(
              color: gMainColor,
              fontFamily: 'GothamBold',
              fontSize: 10.sp,
            ),
          ),
          (!showViewText)
              ? Text(
                  title,
                  style: TextStyle(
                    color: gPrimaryColor,
                    fontFamily: 'GothamMedium',
                    fontSize: 9.sp,
                  ),
                )
              : RichText(
                  text: TextSpan(
                      text: title,
                      style: TextStyle(
                          fontFamily: "GothamMedium",
                          color: gPrimaryColor,
                          fontSize: 9.sp),
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
                            fontFamily: "GothamBook",
                            color: gSecondaryColor,
                            fontSize: 9.sp,
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
}
