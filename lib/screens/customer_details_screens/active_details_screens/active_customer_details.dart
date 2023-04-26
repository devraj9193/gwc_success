import 'package:flutter/material.dart';
import 'package:gwc_success_team/screens/customer_details_screens/active_details_screens/progress_details.dart';
import 'package:sizer/sizer.dart';
import '../../../utils/constants.dart';
import '../../../widgets/common_screen_widgets.dart';
import '../../../widgets/widgets.dart';
import '../meal_plan_details_screen/preparatory_meal_plans.dart';
import 'meal_plan_details.dart';

class ActiveCustomerDetails extends StatefulWidget {
  final String userName;
  final String age;
  final String appointmentDetails;
  final String status;
  final String finalDiagnosis;
  final String preparatoryCurrentDay;
  final String transitionCurrentDay;
  const ActiveCustomerDetails(
      {Key? key,
      required this.userName,
      required this.age,
      required this.appointmentDetails,
      required this.status, required this.finalDiagnosis, required this.preparatoryCurrentDay, required this.transitionCurrentDay})
      : super(key: key);

  @override
  State<ActiveCustomerDetails> createState() => _ActiveCustomerDetailsState();
}

class _ActiveCustomerDetailsState extends State<ActiveCustomerDetails> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: SafeArea(
        child: Scaffold(
          appBar: buildAppBar(() {
            Navigator.pop(context);
          }),
          backgroundColor: whiteTextColor,

          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  widget.userName,
                  style:
                  AllListText().headingText(),
                ),
                Text(
                  widget.age,
                  style:
                  AllListText().subHeadingText(),
                ),
                Text(
                  widget.appointmentDetails,
                  style:
                  AllListText().otherText(),
                ),
                (widget.status.isEmpty)
                    ? Container()
                    : Row(
                        children: [
                          Text(
                            "Status : ",
                            style:
                            AllListText().otherText(),
                          ),
                          Text(
                            widget.status,
                            style:
                            AllListText().subHeadingText(),
                          ),
                        ],
                      ),
                SizedBox(height: 1.h),
                TabBar(
                    labelColor: tapSelectedColor,
                   // padding: EdgeInsets.symmetric(horizontal: 3.w),
                    unselectedLabelColor: tapUnSelectedColor,
                    labelStyle:TabBarText().selectedText(),
                    unselectedLabelStyle: TabBarText().unSelectedText(),
                    isScrollable: true,
                    indicatorColor: tapIndicatorColor,
                    labelPadding:
                    EdgeInsets.only(right: 7.w,left: 2.w, top: 1.h, bottom: 1.h),
                    indicatorPadding: EdgeInsets.only(right: 5.w),

                    tabs: const [
                      Text('Preparatory'),
                      Text('Daily Progress'),
                      Text("Meal & Yoga Plan"),
                      // Text('Evaluation'),
                      // Text('User Reports'),
                      // Text('Medical Report'),
                      // Text('Case Study'),
                    ]),
                 Expanded(
                  child: TabBarView(children: [
                    PreparatoryMealPlan(
                      preparatoryCurrentDay: widget.preparatoryCurrentDay,
                      ppCurrentDay: widget.preparatoryCurrentDay,
                      presDay: widget.transitionCurrentDay,
                    ),
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
