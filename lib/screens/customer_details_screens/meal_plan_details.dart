import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../controller/meal_plan_controller.dart';
import '../../model/meal_plan_model.dart';
import '../../utils/constants.dart';
import '../../widgets/widgets.dart';
import 'package:get/get.dart';

import 'meal_pdf.dart';

class MealPlanDetails extends StatefulWidget {
  const MealPlanDetails({Key? key}) : super(key: key);

  @override
  State<MealPlanDetails> createState() => _MealPlanDetailsState();
}

class _MealPlanDetailsState extends State<MealPlanDetails> {
  Color? textColor;
  String selectedDay = "1";

  Map<String, List<DayPlan>> mealPlanData1 = {};

  DayPlanListController dayPlanListController =
      Get.put(DayPlanListController());

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 1,
          color: Colors.grey.withOpacity(0.3),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Day $selectedDay Meal Plan',
              style: TextStyle(
                  fontSize: 10.sp,
                  fontFamily: "GothamMedium",
                  color: gPrimaryColor),
            ),
            DropdownButton(
              value: selectedDay,
              style: TextStyle(
                  fontSize: 8.sp, fontFamily: "GothamBook", color: gBlackColor),
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
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: buildMealPlan(),
          ),
        ),
      ],
    );
  }

  buildMealPlan() {
    return FutureBuilder(
        future: dayPlanListController.fetchDayPlanList(selectedDay),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            return const Text("");
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
                          fontSize: 9.sp,
                          fontFamily: "GothamMedium",
                        ),
                        headingRowHeight: 5.h,
                        horizontalMargin: 2.w,
                        // columnSpacing: 7.w,
                        dataRowHeight: getRowHeight(),
                        columns: const <DataColumn>[
                          DataColumn(label: Text('Time')),
                          DataColumn(label: Text('Meal/Yoga')),
                          DataColumn(label: Text('Status')),
                        ],
                        rows: dataRowWidget(),
                        // List.generate(data.data.length, (index) {
                        //   print(
                        //       "Plan ${data.data[index]["mealTime"].toString()}");
                        //   return DataRow(
                        //     cells: [
                        //       DataCell(
                        //         Text(
                        //           data.data["B/W 6-8am"][index].mealTime
                        //               .toString(),
                        //           style: TextStyle(
                        //             height: 1.5,
                        //             color: gTextColor,
                        //             fontSize: 8.sp,
                        //             fontFamily: "GothamBold",
                        //           ),
                        //         ),
                        //       ),
                        //       DataCell(
                        //           Row(
                        //             children: [
                        //               data.data["B/W 6-8am"][index].type ==
                        //                       "yoga"
                        //                   ? Row(
                        //                       children: [
                        //                         GestureDetector(
                        //                           onTap: () {},
                        //                           child: Image(
                        //                             image: const AssetImage(
                        //                                 "assets/images/noun-play-1832840.png"),
                        //                             height: 2.h,
                        //                           ),
                        //                         ),
                        //                         SizedBox(width: 2.w),
                        //                       ],
                        //                     )
                        //                   : Container(),
                        //               Expanded(
                        //                 child: Text(
                        //                   data.data["B/W 6-8am"][index].name
                        //                       .toString(),
                        //                   maxLines: 3,
                        //                   textAlign: TextAlign.start,
                        //                   overflow: TextOverflow.ellipsis,
                        //                   style: TextStyle(
                        //                     height: 1.5,
                        //                     color: gTextColor,
                        //                     fontSize: 8.sp,
                        //                     fontFamily: "GothamBook",
                        //                   ),
                        //                 ),
                        //               ),
                        //             ],
                        //           ),
                        //           placeholder: true, onTap: () {
                        //         Navigator.of(context).push(
                        //           MaterialPageRoute(
                        //             builder: (ct) => MealPdf(
                        //               pdfLink: data.data["B/W 6-8am"][index].url
                        //                   .toString(),
                        //             ),
                        //           ),
                        //         );
                        //       }),
                        //       DataCell(
                        //         Container(
                        //           width: 18.w,
                        //           padding: EdgeInsets.symmetric(
                        //               horizontal: 2.w, vertical: 0.5.h),
                        //           decoration: BoxDecoration(
                        //             color: gWhiteColor,
                        //             borderRadius: BorderRadius.circular(5),
                        //             border:
                        //                 Border.all(color: gMainColor, width: 1),
                        //           ),
                        //           child: Text(
                        //             data.data["B/W 6-8am"][index].status
                        //                 .toString(),
                        //             overflow: TextOverflow.ellipsis,
                        //             style: TextStyle(
                        //                 fontFamily: "GothamBook",
                        //                 // color: buildTextColor(
                        //                 //     data[index].status.toString()),
                        //                 fontSize: 8.sp),
                        //           ),
                        //         ),
                        //       ),
                        //     ],
                        //   );
                        // }).toList(),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: (data.comment == null )? 0 : double.maxFinite,
                  margin: EdgeInsets.symmetric(horizontal: 1.w, vertical: 1.h),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      (data.comment == null) ?  Container() : Text(
                        "Comments : ",
                        // 'Lorem ipsum is simply dummy text of the printing and typesetting industry.Lorem ipsum has been the industry\'s standard dummy text ever since the 1500s,when an unknown printer took a gallery of type.',
                        style: TextStyle(
                            fontSize: 10.sp,
                            height: 1.3,
                            fontFamily: "GothamBook",
                            color: gPrimaryColor),
                      ) ,
                      (data.comment == null) ? Container(): SizedBox(height: 1.h),
                      Text(
                        data.comment ?? "",
                        // 'Lorem ipsum is simply dummy text of the printing and typesetting industry.Lorem ipsum has been the industry\'s standard dummy text ever since the 1500s,when an unknown printer took a gallery of type.',
                        style: TextStyle(
                            fontSize: 10.sp,
                            height: 1.3,
                            fontFamily: "GothamBook",
                            color: gTextColor),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h),
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
                style: TextStyle(
                  height: 1.5,
                  color: gTextColor,
                  fontSize: 8.sp,
                  fontFamily: "GothamBold",
                ),
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
                            onTap: e.url == null
                                ? null
                                : e.type == 'item'
                                    ? () => MealPdf(
                                          pdfLink: e.url!,
                                        )
                                    : () {},
                            child: Row(
                              children: [
                                e.type == 'yoga'
                                    ? GestureDetector(
                                        onTap: () {},
                                        child: Image(
                                          image: const AssetImage(
                                              "assets/images/noun-play-1832840.png"),
                                          height: 2.h,
                                        ),
                                      )
                                    : const SizedBox(),
                                if (e.type == 'yoga') SizedBox(width: 2.w),
                                Expanded(
                                  child: Text(
                                    " ${e.name.toString()}",
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
                          border: Border.all(color: gMainColor, width: 1),
                        ),
                        child: Text(
                          e.status.toString(),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontFamily: "GothamBook",
                              color: buildTextColor(e.status.toString()),
                              fontSize: 8.sp),
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
