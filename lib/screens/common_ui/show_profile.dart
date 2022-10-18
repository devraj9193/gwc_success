import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../utils/constants.dart';
import '../../widgets/widgets.dart';

class ShowProfile extends StatefulWidget {
  const ShowProfile({Key? key}) : super(key: key);

  @override
  State<ShowProfile> createState() => _ShowProfileState();
}

class _ShowProfileState extends State<ShowProfile> {
  @override
  Widget build(BuildContext context) {
    // double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 2.h, left: 3.w),
              child: buildAppBar(() {
                Navigator.pop(context);
              }),
            ),
            SizedBox(height: 1.h),
            Expanded(
              child: buildUserDetails(),
            ),
          ],
        ),
      ),
    );
  }

  buildUserDetails() {
    return LayoutBuilder(builder: (context, constraints) {
      return Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 35.h,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(blurRadius: 2, color: Colors.grey.withOpacity(0.5))
                ],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
                image: const DecorationImage(
                    image: AssetImage("assets/images/cheerful_profile.png"),
                    fit: BoxFit.fitWidth),
              ),
            ),
          ),
          Positioned(
            top: 33.h,
            left: 0,
            right: 0,
            child: Container(
              height: 66.h,
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              decoration: BoxDecoration(
                  color: gWhiteColor,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12)),
                  border: Border.all(width: 1, color: gMainColor)),
              child: Column(
                children: [
                  SizedBox(height: 3.h),
                  profileTile("Name : ", "Gut-wellness Club"),
                  profileTile("Age : ", "34"),
                  profileTile("Consultation & time : ", ""),
                  profileTile("Program Name : ", "Detox Program"),
                  profileTile("Meal & Yoga Plan : ", "Detox Meal Plan", showViewText: true, viewText: 'view'),
                  profileTile("MR Report : ", "Uploaded", showViewText: true, viewText: 'view'),
                  profileTile("Case Sheet : ", "Uploaded", showViewText: true,viewText: 'view'),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  profileTile(String heading, String title, {bool showViewText = false, String? viewText}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
      child: Row(
        // mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            heading,
            style: TextStyle(
              color: gMainColor,
              fontFamily: 'GothamBold',
              fontSize: 11.sp,
            ),
          ),
          (!showViewText) ?
          Text(
            title,
            style: TextStyle(
              color: gPrimaryColor,
              fontFamily: 'GothamMedium',
              fontSize: 10.5.sp,
            ),
          ) :
          RichText(
            text: TextSpan(
                text: title,
                style: TextStyle(
                    fontFamily: "GothamBold",
                    color: gPrimaryColor,
                    fontSize: 10.sp
                ),
                children: [
                  TextSpan(
                    text: ' ',
                    style: TextStyle(
                      fontFamily: "GothamBold",
                    ),
                  ),
                  TextSpan(
                    text: viewText,
                    style: TextStyle(
                      fontFamily: "GothamMedium",
                      color: gSecondaryColor,
                      fontSize: 10.sp,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()..onTap = () {
                      print('Tap Here onTap');
                    },

                  )
                ]
            ),
          ),
        ],
      ),
    );
  }


}
