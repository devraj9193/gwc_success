import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:sizer/sizer.dart';
import '../../controller/day_progress_controller.dart';
import '../../utils/constants.dart';
import '../../widgets/widgets.dart';
import 'package:get/get.dart';

import 'meal_yoga_plan_details.dart';

class ProgressDetails extends StatefulWidget {
  const ProgressDetails({Key? key}) : super(key: key);

  @override
  State<ProgressDetails> createState() => _ProgressDetailsState();
}

class _ProgressDetailsState extends State<ProgressDetails> {
  Color? textColor;

  DayProgressController dayProgressController =
      Get.put(DayProgressController());
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: dayProgressController.fetchDayProgressList(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            return const Text("");
          } else if (snapshot.hasData) {
            var data = snapshot.data;

            return Column(
              children: [
                Container(
                  height: 1,
                  color: Colors.grey.withOpacity(0.3),
                ),
                SizedBox(height: 2.h),
                ListView.builder(
                  scrollDirection: Axis.vertical,
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: data.length,
                  itemBuilder: ((context, index) {
                    double y = data[index] / 100.toDouble();
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 1.h),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (ct) =>  MealYogaPlanDetails(selectedDay: dailyProgress[index]),
                            ),
                          );
                        },
                        child: LinearPercentIndicator(
                          leading: Text(
                            "Day - ${dailyProgress[index]}",
                            style: TextStyle(
                                fontSize: 10.sp,
                                fontFamily: "GothamMedium",
                                color: gPrimaryColor),
                          ),
                          animation: true,
                          lineHeight: 3.h,
                          animationDuration: 5000,
                          percent: buildBar(y),
                          center: buildCenterText(data[index]),
                          backgroundColor: const Color(0xffECF0FA),
                          progressColor: buildTextColor(data[index]),
                          barRadius: const Radius.circular(10),
                        ),
                      ),
                    );
                  }),
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

  Color? buildTextColor(double value) {
    print("value: $value");
    if (30 > value) {
      textColor = gSecondaryColor;
    } else if (60 > value) {
      textColor = gMainColor;
    } else if (100 >= value) {
      textColor = gPrimaryColor;
    }
    return textColor;
  }

  buildCenterText(double data) {
    if (100 < data) {
      return Text(
        "100 %",
        style: TextStyle(
            fontSize: 8.sp, fontFamily: "GothamBook", color: gMainColor),
      );
    } else {
      return Text(
        "${data.toStringAsFixed(2)} %",
        style: TextStyle(
            fontSize: 8.sp, fontFamily: "GothamBook", color: gMainColor),
      );
    }
  }

  buildBar(double y) {
    if (1.0 < y) {
      return 1.0;
    } else {
      return y;
    }
  }
}
