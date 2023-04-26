import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../controller/meal_plan_controller.dart';
import '../../model/meal_plan_model.dart';
import '../../utils/constants.dart';
import '../../widgets/common_screen_widgets.dart';
import '../../widgets/widgets.dart';
import 'package:get/get.dart';

import '../customer_details_screens/meal_pdf.dart';

class DayPlanDetails extends StatefulWidget {
  const DayPlanDetails({Key? key}) : super(key: key);

  @override
  State<DayPlanDetails> createState() => _DayPlanDetailsState();
}

class _DayPlanDetailsState extends State<DayPlanDetails> {
  Color? textColor;
  String selectedDay = "1";

  Map<String, List<DayPlan>> mealPlanData1 = {};

  DayPlanListController dayPlanListController =
      Get.put(DayPlanListController());

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
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Day $selectedDay Meal Plan',
                    style: MealPlan().headingText(),
                  ),
                  DropdownButton(
                    value: selectedDay,
                    style: TextStyle(
                        fontSize: 8.sp,
                        fontFamily: "GothamBook",
                        color: gBlackColor),
                    items: dailyProgress.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text("Day $items"),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedDay = newValue!;
                      });
                    },
                  ),
                ],
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
    return FutureBuilder(
        future: dayPlanListController.fetchDayPlanList(selectedDay),
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
            mealPlanData1 = data.data;
            return Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 1.w),
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
                          color: gSecondaryColor,
                        ),
                      ),
                      DataTable(
                        headingTextStyle: MealPlan().subHeadingText(),
                        headingRowHeight: 5.h,
                        horizontalMargin: 2.w,
                        dataRowHeight: getRowHeight(),
                        columns: const <DataColumn>[
                          DataColumn(label: Text('Time')),
                          DataColumn(label: Text('Meal/Yoga')),
                          DataColumn(label: Text('  Status  ')),
                        ],
                        rows: dataRowWidget(),
                        // mealPlanData
                        //     .map(
                        //       (s) => DataRow(
                        //         cells: [
                        //           DataCell(
                        //             Text(
                        //               s["time"].toString(),
                        //               style: TextStyle(
                        //                 height: 1.5,
                        //                 color: gTextColor,
                        //                 fontSize: 8.sp,
                        //                 fontFamily: "GothamBold",
                        //               ),
                        //             ),
                        //           ),
                        //           DataCell(
                        //             Row(
                        //               children: [
                        //                 s["id"] == 1
                        //                     ? Row(
                        //                         children: [
                        //                           GestureDetector(
                        //                             onTap: () {},
                        //                             child: Image(
                        //                               image: const AssetImage(
                        //                                   "assets/images/noun-play-1832840.png"),
                        //                               height: 2.h,
                        //                             ),
                        //                           ),
                        //                           SizedBox(width: 2.w),
                        //                         ],
                        //                       )
                        //                     : Container(),
                        //                 Expanded(
                        //                   child: Text(
                        //                     s["title"].toString(),
                        //                     maxLines: 3,
                        //                     textAlign: TextAlign.start,
                        //                     overflow: TextOverflow.ellipsis,
                        //                     style: TextStyle(
                        //                       height: 1.5,
                        //                       color: gTextColor,
                        //                       fontSize: 8.sp,
                        //                       fontFamily: "GothamBook",
                        //                     ),
                        //                   ),
                        //                 ),
                        //               ],
                        //             ),
                        //             placeholder: true,
                        //           ),
                        //           DataCell(
                        //             Container(
                        //               width: 18.w,
                        //               padding: EdgeInsets.symmetric(
                        //                   horizontal: 2.w, vertical: 0.5.h),
                        //               decoration: BoxDecoration(
                        //                 color: gWhiteColor,
                        //                 borderRadius: BorderRadius.circular(5),
                        //                 border: Border.all(
                        //                     color: gMainColor, width: 1),
                        //               ),
                        //               child: Text(
                        //                 s["status"].toString(),
                        //                 overflow: TextOverflow.ellipsis,
                        //                 style: TextStyle(
                        //                     fontFamily: "GothamBook",
                        //                     color: buildTextColor(
                        //                         s["status"].toString()),
                        //                     fontSize: 8.sp),
                        //               ),
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //     )
                        //   .toList(),
                      ),
                    ],
                  ),
                ),
                (data.comment == "")
                    ? const SizedBox()
                    : Container(
                        width: double.maxFinite,
                        margin: EdgeInsets.symmetric(
                            horizontal: 1.w, vertical: 1.h),
                        padding: EdgeInsets.symmetric(
                            horizontal: 3.w, vertical: 1.h),
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Comments : ",
                              // 'Lorem ipsum is simply dummy text of the printing and typesetting industry.Lorem ipsum has been the industry\'s standard dummy text ever since the 1500s,when an unknown printer took a gallery of type.',
                              style: MealPlan().mealText(),
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              data.comment ?? "",
                              // 'Lorem ipsum is simply dummy text of the printing and typesetting industry.Lorem ipsum has been the industry\'s standard dummy text ever since the 1500s,when an unknown printer took a gallery of type.',
                              style: MealPlan().subHeadingText(),
                            ),
                          ],
                        ),
                      ),
              ],
            );
          }
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h),
            child: buildCircularIndicator(),
          );
        });
  }

  List<DataRow> dataRowWidget() {
    List<DataRow> data = [];
    mealPlanData1.forEach((dayTime, value) {
      data.add(
        DataRow(
          cells: [
            DataCell(
              Text(
                dayTime,
                style: MealPlan().timeText(),
              ),
            ),
            DataCell(
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ...value
                      .map((e) => GestureDetector(
                            onTap: () => MealPdf(pdfLink: e.url!, heading: '',),
                            child: Expanded(
                              child: Text(
                                " ${e.name.toString()}",
                                maxLines: 3,
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                                style: MealPlan().mealText(),
                              ),
                            ),
                          ))
                      .toList()
                ],
              ),
              placeholder: true,
            ),
            DataCell(
              // (widget.isCompleted == null) ?
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                // shrinkWrap: true,
                children: [
                  ...value.map((e) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                      ),
                      child: Container(
                        width: 18.w,
                        margin: EdgeInsets.symmetric(vertical: 0.2.h),
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: gWhiteColor,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                              color: lightTextColor, width: 1),
                        ),
                        child: Text(
                          e.status.toString(),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontFamily: fontBook,
                              color: buildTextColor(e.status.toString()),
                              fontSize: fontSize08),
                        ),
                      ),
                    );
                  }).toList()
                ],
              ),
            ),
          ],
        ),
      );
    });
    return data;
  }

  Color? buildTextColor(String status) {
    if (status == "followed") {
      return textColor = gPrimaryColor;
    } else if (status == "unfollowed") {
      return textColor = gSecondaryColor;
    } else if (status == "Alternative without Doctor") {
      return textColor = gMainColor;
    } else if (status == "Alternative with Doctor") {
      return textColor = gTextColor;
    }
    return textColor;
  }

  getRowHeight() {
    if (mealPlanData1.values.length > 1) {
      return 8.h;
    } else {
      return 6.h;
    }
  }
}
