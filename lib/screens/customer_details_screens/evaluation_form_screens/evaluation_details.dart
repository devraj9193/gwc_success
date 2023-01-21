import 'package:flutter/material.dart';
import 'package:gwc_success_team/screens/customer_details_screens/evaluation_form_screens/personal_details.dart';
import 'package:sizer/sizer.dart';
import 'bowel_type_details.dart';
import 'food_habits_details.dart';
import 'health_details.dart';
import '../../../utils/constants.dart';

import 'lifestyle_details.dart';

class EvaluationDetails extends StatefulWidget {
  const EvaluationDetails({Key? key}) : super(key: key);

  @override
  State<EvaluationDetails> createState() => _EvaluationDetailsState();
}

class _EvaluationDetailsState extends State<EvaluationDetails> {
  int _bottomNavIndex = 0;

  List<String> userDetails = [
    "Personal\nDetails",
    "Health",
    "Food\nHabits",
    "Lifestyle",
    "Bowel\nType"
  ];

  pageCaller(int index) {
    switch (index) {
      case 0:
        {
          return const PersonalDetails();
        }
      case 1:
        {
          return const HealthDetails();
        }
      case 2:
        {
          return const FoodHabitsDetails();
        }
      case 3:
        {
          return const LifestyleDetails();
        }
      case 4:
        {
          return const BowelTypeDetails();
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 1,
          color: Colors.grey.withOpacity(0.3),
        ),
        SizedBox(height: 2.h),
        Row(
          children: [
            buildArrowDesign(index: 0, title: userDetails[0]),
            buildArrowDesign(index: 1, title: userDetails[1]),
            buildArrowDesign(index: 2, title: userDetails[2]),
            buildArrowDesign(index: 3, title: userDetails[3]),
            buildArrowDesign(index: 4, title: userDetails[4]),
          ],
        ),
        SizedBox(height: 2.h),
        pageCaller(_bottomNavIndex),
      ],
    );
  }

  void onChangedTab(int index) {
    setState(() {
      _bottomNavIndex = index;
    });
  }

  Widget buildArrowDesign({required String title, required int index}) {
    return GestureDetector(
      onTap: () {
        onChangedTab(index);
      },
      child: Container(
        height: 5.h,
        width: 18.w,
        padding: EdgeInsets.only(left: 1.w),
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: (_bottomNavIndex == index)
                ? const ColorFilter.mode(gPrimaryColor, BlendMode.modulate)
                : null,
            image: const AssetImage(
              "assets/images/Path 12972.png",
            ),
          ),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              height: 1,
              fontSize: 7.sp,
              fontFamily: "GothamMedium",
              color: (_bottomNavIndex == index) ? gMainColor : gBlackColor,
            ),
          ),
        ),
      ),
    );
  }
}
