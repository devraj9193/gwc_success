import 'package:flutter/material.dart';
import 'package:gwc_success_team/screens/customer_details_screens/user_reports_details.dart';
import 'package:sizer/sizer.dart';
import '../../utils/constants.dart';
import '../../widgets/common_screen_widgets.dart';
import '../../widgets/widgets.dart';
import 'case_study_details.dart';
import 'evaluation_form_screens/evaluation_details.dart';
import 'active_details_screens/meal_plan_details.dart';
import 'medical_report_details.dart';

class CustomerDetailsScreen extends StatefulWidget {
  const CustomerDetailsScreen({Key? key}) : super(key: key);

  @override
  State<CustomerDetailsScreen> createState() => _CustomerDetailsScreenState();
}

class _CustomerDetailsScreenState extends State<CustomerDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: SafeArea(
        child: Scaffold(
          appBar: buildAppBar(() {
            Navigator.pop(context);
          }),
          backgroundColor: whiteTextColor,

          body: Padding(
            padding: EdgeInsets.only(
              left: 4.w,
              right: 4.w,
              top: 1.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                SizedBox(height: 1.h),
                TabBar(
                    labelColor: tapSelectedColor,
                    padding: EdgeInsets.symmetric(horizontal: 3.w),
                    unselectedLabelColor: tapUnSelectedColor,
                    labelStyle:TabBarText().selectedText(),
                    unselectedLabelStyle: TabBarText().unSelectedText(),
                    isScrollable: true,
                    indicatorColor: tapIndicatorColor,
                    labelPadding:
                    EdgeInsets.only(right: 7.w,left: 2.w, top: 1.h, bottom: 1.h),
                    indicatorPadding: EdgeInsets.only(right: 5.w),

                    tabs: const [
                      Text("Meal & Yoga Plan"),
                      Text('Evaluation'),
                      Text('User Reports'),
                      Text('Medical Report'),
                      Text('Case Study'),
                    ]),
                const Expanded(
                  child: TabBarView(children: [
                    MealPlanDetails(),
                    EvaluationDetails(),
                    UserReportsDetails(),
                    MedicalReportDetails(mrUrl: '',),
                    CaseStudyDetails(csUrl: '',),
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
