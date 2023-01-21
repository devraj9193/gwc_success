import 'package:flutter/material.dart';
import 'package:gwc_success_team/screens/customer_details_screens/progress_details.dart';
import 'package:sizer/sizer.dart';
import '../../utils/constants.dart';
import '../../widgets/widgets.dart';
import 'meal_plan_details.dart';

class ActiveCustomerDetails extends StatefulWidget {
  final String userName;
  final String age;
  final String appointmentDetails;
  final String status;
  const ActiveCustomerDetails(
      {Key? key,
      required this.userName,
      required this.age,
      required this.appointmentDetails,
      required this.status})
      : super(key: key);

  @override
  State<ActiveCustomerDetails> createState() => _ActiveCustomerDetailsState();
}

class _ActiveCustomerDetailsState extends State<ActiveCustomerDetails> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Scaffold(
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 1.h),
                buildAppBar(() {
                  Navigator.pop(context);
                }),
                Text(
                  widget.userName,
                  style: TextStyle(
                      fontFamily: "GothamMedium",
                      color: gTextColor,
                      fontSize: 10.sp),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  widget.age,
                  style: TextStyle(
                      fontFamily: "GothamMedium",
                      color: gTextColor,
                      fontSize: 8.sp),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  widget.appointmentDetails,
                  style: TextStyle(
                      fontFamily: "GothamBook",
                      color: gTextColor,
                      fontSize: 8.sp),
                ),
                SizedBox(height: 0.5.h),
                (widget.status.isEmpty)
                    ? Container()
                    : Row(
                        children: [
                          Text(
                            "Status : ",
                            style: TextStyle(
                                fontFamily: "GothamBook",
                                color: gBlackColor,
                                fontSize: 8.sp),
                          ),
                          Text(
                            widget.status,
                            style: TextStyle(
                                fontFamily: "GothamMedium",
                                color: gPrimaryColor,
                                fontSize: 8.sp),
                          ),
                        ],
                      ),
                SizedBox(height: 1.h),
                TabBar(
                    // padding: EdgeInsets.symmetric(horizontal: 3.w),
                    labelColor: gPrimaryColor,
                    unselectedLabelColor: gTextColor,
                    isScrollable: true,
                    indicatorColor: gPrimaryColor,
                    labelPadding:
                        EdgeInsets.only(right: 6.w, top: 1.h, bottom: 1.h),
                    indicatorPadding: EdgeInsets.only(right: 5.w),
                    labelStyle: TextStyle(
                        fontFamily: "GothamMedium",
                        color: gPrimaryColor,
                        fontSize: 10.sp),
                    tabs: const [
                      Text('Daily Progress'),
                      Text("Meal & Yoga Plan"),
                      // Text('Evaluation'),
                      // Text('User Reports'),
                      // Text('Medical Report'),
                      // Text('Case Study'),
                    ]),
                const Expanded(
                  child: TabBarView(children: [
                    ProgressDetails(),
                    MealPlanDetails(),
                    // EvaluationDetails(),
                    // UserReportsDetails(),
                    // MedicalReportDetails(),
                    // CaseStudyDetails(),
                  ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
