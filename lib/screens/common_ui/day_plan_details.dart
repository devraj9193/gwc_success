import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../utils/constants.dart';
import '../../widgets/widgets.dart';
import 'meal_plan_data.dart';


class DayPlanDetails extends StatefulWidget {
  const DayPlanDetails({Key? key}) : super(key: key);

  @override
  State<DayPlanDetails> createState() => _DayPlanDetailsState();
}

class _DayPlanDetailsState extends State<DayPlanDetails> {
  Color? textColor;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 1.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              child: buildAppBar(() {
                Navigator.pop(context);
              }),
            ),
            SizedBox(height: 1.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              child: Text(
                'Day 01 Meal Plan',
                style: TextStyle(
                    fontSize: 11.sp,
                    fontFamily: "GothamMedium",
                    color: gPrimaryColor),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: buildMealPlan(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildMealPlan() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(2, 10),
              ),
            ],
          ),
          child: Stack(
            children: [
              Container(
                height: 5.h,
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8)),
                  gradient: LinearGradient(colors: [
                    Color(0xffE06666),
                    Color(0xff93C47D),
                    Color(0xffFFD966),
                  ], begin: Alignment.topLeft, end: Alignment.topRight),
                ),
              ),
              DataTable(
                headingTextStyle: TextStyle(
                  color: gWhiteColor,
                  fontSize: 10.sp,
                  fontFamily: "GothamMedium",
                ),
                headingRowHeight: 5.h,
                horizontalMargin: 2.w,
                columnSpacing: 30,
                dataRowHeight: 7.5.h,
                // headingRowColor:
                //     MaterialStateProperty.all(const Color(0xffE06666)),
                columns: const <DataColumn>[
                  DataColumn(
                    label: Text('Time')
                  ),
                  DataColumn(
                    label: Text('Meal/Yoga')
                  ),
                  DataColumn(
                    label: Text('  Status  ')
                  ),
                ],
                rows: mealPlanData
                    .map(
                      (s) => DataRow(
                        cells: [
                          DataCell(
                            Text(
                              s["time"].toString(),
                              style: TextStyle(
                                height: 1.5,
                                color: gTextColor,
                                fontSize: 8.sp,
                                fontFamily: "GothamBold",
                              ),
                            ),
                          ),
                          DataCell(
                            Row(
                              children: [
                                s["id"] == 1
                                    ? Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () {},
                                            child: Image(
                                              image: const AssetImage(
                                                  "assets/images/noun-play-1832840.png"),
                                              height: 2.h,
                                            ),
                                          ),
                                          SizedBox(width: 2.w),
                                        ],
                                      )
                                    : Container(),
                                Expanded(
                                  child: Text(
                                    s["title"].toString(),
                                    maxLines: 3,
                                    textAlign: TextAlign.start,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      height: 1.5,
                                      color: gTextColor,
                                      fontSize: 8.sp,
                                      fontFamily: "GothamBook",
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            placeholder: true,
                          ),
                          DataCell(
                            Container(
                              width: 18.w,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 2.w, vertical: 0.5.h),
                              decoration: BoxDecoration(
                                color: gWhiteColor,
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: gMainColor, width: 1),
                              ),
                              child: Text(
                                s["status"].toString(),
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontFamily: "GothamBook",
                                    color:
                                        buildTextColor(s["status"].toString()),
                                    fontSize: 8.sp),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 3.w),
          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(2, 10),
              ),
            ],
          ),
          child: Text(
            'Lorem ipsum is simply dummy text of the printing and typesetting industry.Lorem ipsum has been the industry\'s standard dummy text ever since the 1500s,when an unknown printer took a gallery of type.',
            style: TextStyle(
                fontSize: 10.sp,
                height: 1.3,
                fontFamily: "GothamBook",
                color: gTextColor),
          ),
        ),
      ],
    );
  }

  Color? buildTextColor(String status) {
    if (status == "Followed") {
      textColor = gPrimaryColor;
    } else if (status == "UnFollowed") {
      textColor = gSecondaryColor;
    } else if (status == "Alternative without Doctor") {
      textColor = gMainColor;
    } else if (status == "Alternative with Doctor") {
      textColor = gTextColor;
    }
    return textColor!;
  }
}
