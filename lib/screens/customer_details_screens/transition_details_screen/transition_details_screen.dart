import 'package:flutter/material.dart';
import 'package:gwc_success_team/screens/customer_details_screens/transition_details_screen/transition_meal_plan.dart';
import 'package:sizer/sizer.dart';
import '../../../utils/constants.dart';
import '../../../widgets/common_screen_widgets.dart';
import '../../../widgets/widgets.dart';
import '../../nutri_delight_screens/daily_progress_screens/progress_details.dart';
import '../active_details_screens/meal_plan_details.dart';
import '../meal_plan_details_screen/preparatory_meal_plans.dart';

class TransitionDetailsScreen extends StatefulWidget {
  final String userName;
  final String age;
  final String appointmentDetails;
  final String status;
  final String startDate;
  final String presentDay;
  final String finalDiagnosis;
  final String preparatoryCurrentDay;
  final String transitionCurrentDay;
  final String transitionDays;
  final String prepDays;
  final String isPrepCompleted;

  const TransitionDetailsScreen({
    Key? key,
    required this.userName,
    required this.age,
    required this.appointmentDetails,
    required this.status,
    required this.transitionCurrentDay,
    required this.finalDiagnosis,
    required this.preparatoryCurrentDay,
    required this.isPrepCompleted,
    required this.startDate,
    required this.presentDay,
    required this.transitionDays,
    required this.prepDays,
  }) : super(key: key);

  @override
  State<TransitionDetailsScreen> createState() =>
      _TransitionDetailsScreenState();
}

class _TransitionDetailsScreenState extends State<TransitionDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
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
                  style: AllListText().headingText(),
                ),
                Text(
                  widget.age,
                  style: AllListText().subHeadingText(),
                ),
                Text(
                  widget.appointmentDetails,
                  style: AllListText().otherText(),
                ),
                (widget.status.isEmpty)
                    ? Container()
                    : Row(
                        children: [
                          Text(
                            "Status : ",
                            style: AllListText().otherText(),
                          ),
                          Text(
                            widget.status,
                            style: AllListText().subHeadingText(),
                          ),
                        ],
                      ),
                Row(
                  children: [
                    Text(
                      "Start Date : ",
                      style: AllListText().otherText(),
                    ),
                    Text(
                      widget.startDate,
                      style: AllListText().subHeadingText(),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "Meal Plan Present Day : ",
                      style: AllListText().otherText(),
                    ),
                    Text(
                      "${widget.presentDay} / 7 Days",
                      style: AllListText().subHeadingText(),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "Transition Present Day : ",
                      style: AllListText().otherText(),
                    ),
                    Text(
                      "${buildCurrentDay(widget.transitionCurrentDay)} / ${widget.transitionDays} Days",
                      style: AllListText().subHeadingText(),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Final Diagnosis : ",
                      style: AllListText().otherText(),
                    ),
                    Expanded(
                      child: Text(
                        widget.finalDiagnosis,
                        style: AllListText().subHeadingText(),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                TabBar(
                    labelColor: tapSelectedColor,
                    // padding: EdgeInsets.symmetric(horizontal: 3.w),
                    unselectedLabelColor: tapUnSelectedColor,
                    labelStyle: TabBarText().selectedText(),
                    unselectedLabelStyle: TabBarText().unSelectedText(),
                    isScrollable: true,
                    indicatorColor: tapIndicatorColor,
                    labelPadding: EdgeInsets.only(
                        right: 7.w, left: 2.w, top: 1.h, bottom: 1.h),
                    indicatorPadding: EdgeInsets.only(right: 5.w),
                    tabs: const [
                      Text('Daily Progress'),
                      Text('Preparatory'),
                      Text("Meal & Yoga Plan"),
                      Text('Transition'),
                      // Text('User Reports'),
                      // Text('Medical Report'),
                      // Text('Case Study'),
                    ]),
                Expanded(
                  child: TabBarView(children: [
                    const ProgressDetails(userId: 542,),
                    PreparatoryMealPlan(
                      preparatoryCurrentDay: widget.preparatoryCurrentDay,
                      ppCurrentDay: widget.preparatoryCurrentDay,
                      presDay: widget.transitionCurrentDay,
                      isPrepCompleted: widget.isPrepCompleted,
                    ),
                    const MealPlanDetails(),
                    TransitionMealPlan(
                      transitionCurrentDay: widget.transitionCurrentDay,
                      isTransition: true,
                    ),
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

  buildCurrentDay(String transition) {
    print("TTT : $transition");
    if (transition == "null") {
      return "0";
    } else {
      return transition;
    }
  }
}
