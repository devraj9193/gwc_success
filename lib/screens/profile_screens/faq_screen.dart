import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../utils/constants.dart';
import '../../widgets/widgets.dart';


class FaqScreen extends StatefulWidget {
  const FaqScreen({Key? key}) : super(key: key);

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: buildAppBar(() {
          Navigator.pop(context);
        }),
        backgroundColor: whiteTextColor,

        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 5.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                SizedBox(height: 1.h),
                Text(
                  "FAQ",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: "GothamBold",
                      color: gPrimaryColor,
                      fontSize: 11.sp),
                ),
                SizedBox(
                  height: 3.h,
                ),
                buildQuestions("Lorem lpsum is simply dummy text of the printing ?"),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 2.h),
                  height: 1,
                  color: Colors.grey.withOpacity(0.4),
                ),
                SizedBox(height: 1.5.h),
                buildQuestions("Lorem lpsum is simply dummy text of the printing ?"),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 2.h),
                  height: 1,
                  color: Colors.grey.withOpacity(0.4),
                ),
                SizedBox(height: 1.5.h),
                buildQuestions("Lorem lpsum is simply dummy text of the printing ?"),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 2.h),
                  height: 1,
                  color: Colors.grey.withOpacity(0.4),
                ),
                SizedBox(height: 1.5.h),
                buildQuestions("Lorem lpsum is simply dummy text of the printing ?"),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 2.h),
                  height: 1,
                  color: Colors.grey.withOpacity(0.4),
                ),
                SizedBox(height: 1.5.h),
                buildQuestions("Lorem lpsum is simply dummy text of the printing ?"),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 2.h),
                  height: 1,
                  color: Colors.grey.withOpacity(0.4),
                ),
                SizedBox(height: 1.5.h),
                buildQuestions("Lorem lpsum is simply dummy text of the printing ?"),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 2.h),
                  height: 1,
                  color: Colors.grey.withOpacity(0.4),
                ),
                SizedBox(height: 1.5.h),
                buildQuestions("Lorem lpsum is simply dummy text of the printing ?"),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 2.h),
                  height: 1,
                  color: Colors.grey.withOpacity(0.4),
                ),
                SizedBox(height: 1.5.h),
                buildQuestions("Lorem lpsum is simply dummy text of the printing ?"),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 2.h),
                  height: 1,
                  color: Colors.grey.withOpacity(0.4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  buildQuestions(String title) {
    return Text(
      title,
      style: TextStyle(
        color: gTextColor,
        fontFamily: 'GothamMedium',
        fontSize: 8.sp,
      ),
    );
  }
}
