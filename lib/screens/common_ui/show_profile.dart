import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import '../../model/customer_profile_model.dart';
import '../../model/error_model.dart';
import '../../repository/customer_details_repo/customer_profile_repo.dart';
import '../../service/api_service.dart';
import '../../service/customer_details_service/customer_profile_service.dart';
import '../../utils/constants.dart';
import '../../widgets/common_screen_widgets.dart';
import '../../widgets/widgets.dart';
import '../calendar_screen/calendar_customer_details.dart';
import '../nutri_delight_screens/nutri_delight_screen.dart';

class ShowProfile extends StatefulWidget {
  final int userId;
  const ShowProfile({Key? key, required this.userId}) : super(key: key);

  @override
  State<ShowProfile> createState() => _ShowProfileState();
}

class _ShowProfileState extends State<ShowProfile> {
  GetCustomerModel? getCustomerModel;

  bool showProgress = false;

  late final CustomerProfileService customerProfileService =
  CustomerProfileService(customerProfileRepo: repository);

  @override
  void initState() {
    super.initState();
    getCustomerDetails();
  }

  getCustomerDetails() async {
    setState(() {
      showProgress = true;
    });
    final result = await customerProfileService.getCustomerProfileService("${widget.userId}");
    print("result: $result");

    if (result.runtimeType == GetCustomerModel) {
      print("Customer Profile");
      GetCustomerModel model = result as GetCustomerModel;

      getCustomerModel = model;
    } else {
      ErrorModel model = result as ErrorModel;
      print("error: ${model.message}");
    }
    setState(() {
      showProgress = false;
    });
    print(result);
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
    return showProgress
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
                            : profileTile(
                                "Meal & Yoga Plan : ",
                                getCustomerModel?.mealAndYogaPlan?.name ?? "",
                                //   showViewText:
                                //       getCustomerModel?.mealAndYogaPlan == null
                                //           ? false
                                //           : true,
                                //   viewText: 'view', func: () {
                                //   Navigator.of(context).push(
                                //     MaterialPageRoute(
                                //       builder: (context) => NutriDelightScreen(
                                //         isDetox: false,
                                //         userName: getCustomerModel?.username ?? "",
                                //         age: getCustomerModel?.age ?? "",
                                //         appointmentDetails: buildTimeDate(
                                //             getCustomerModel
                                //                 ?.consultationDateAndTime?.date ??
                                //                 "",
                                //             getCustomerModel?.consultationDateAndTime
                                //                 ?.slotStartTime ??
                                //                 ""),
                                //         status: getCustomerModel?.mealAndYogaPlan?.name ?? '',
                                //         finalDiagnosis: '',
                                //         preparatoryCurrentDay: '',
                                //         transitionCurrentDay: '',
                                //         isPrepCompleted: '', isProgramStatus: '', programDayStatus: '',
                                //       ),
                                //     ),
                                //   );
                                // }
                              ),
                        getCustomerModel?.mrReport == null
                            ? const SizedBox()
                            : profileTile(
                                "MR Report : ", "Uploaded",
                                //   showViewText: getCustomerModel?.mrReport == null
                                //       ? false
                                //       : true,
                                //   viewText: 'view', func: () {
                                //   Navigator.of(context).push(
                                //     MaterialPageRoute(
                                //       builder: (context) => MRScreen(
                                //         report:
                                //             "${getCustomerModel?.mrReport?.report}",
                                //       ),
                                //     ),
                                //   );
                                // }
                              ),
                        getCustomerModel?.caseSheet == null
                            ? const SizedBox()
                            : profileTile(
                                "Case Sheet : ", "Uploaded",
                                //   showViewText:
                                //       getCustomerModel?.caseSheet == null
                                //           ? false
                                //           : true,
                                //   viewText: 'view', func: () {
                                //   Navigator.of(context).push(
                                //     MaterialPageRoute(
                                //       builder: (context) => CaseSheetDetails(
                                //         report:
                                //             "${getCustomerModel?.caseSheet?.report}",
                                //       ),
                                //     ),
                                //   );
                                // }
                              ),
                        SizedBox(height: 2.h),
                        GestureDetector(
                          onTap: () {
                            // saveUserId("", "", appointmentDetails.userId);
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    NutriDelightScreen(
                                      userId: widget.userId,
                                      tabIndex: 1,
                                      userName: getCustomerModel?.username ?? "",
                                      age:getCustomerModel?.age ?? "",
                                      appointmentDetails: buildTimeDate(
                                    getCustomerModel
                                        ?.consultationDateAndTime?.date ??
                                    "",
                                    getCustomerModel?.consultationDateAndTime
                                        ?.slotStartTime ??
                                        ""),
                                      status: "",
                                      finalDiagnosis: '',
                                      preparatoryCurrentDay: '',
                                      transitionCurrentDay: '',
                                      isPrepCompleted: '',
                                      isProgramStatus: '',programDayStatus: '', updateTime: '', updateDate: '',
                                    ),
                                //     CalendarCustomerScreen(
                                //   userId: widget.userId,
                                //   tabIndex: 0,
                                // ),
                              ),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 1.h, horizontal: 3.w),
                            decoration: BoxDecoration(
                              color: gSecondaryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              'View',
                              style: LoginScreen().buttonText(whiteTextColor),
                            ),
                          ),
                        ),
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

  final CustomerProfileRepo repository = CustomerProfileRepo(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );
}
