import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../utils/constants.dart';
import '../../widgets/widgets.dart';

class MyProfileDetails extends StatefulWidget {
  const MyProfileDetails({Key? key}) : super(key: key);

  @override
  State<MyProfileDetails> createState() => _MyProfileDetailsState();
}

class _MyProfileDetailsState extends State<MyProfileDetails> {
  bool photoError = false;
  String profile = '';

  Future? getProfileDetails;

  bool isEdit = false;

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getProfileData();
  }

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
            Padding(
              padding: EdgeInsets.only(left: 3.w),
              child: Text(
                "My Profile",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: "GothamBold",
                    color: gPrimaryColor,
                    fontSize: 11.sp),
              ),
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
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                image: const DecorationImage(
                    image: AssetImage("assets/images/cheerful_profile.png"),
                    fit: BoxFit.fill),
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
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  border: Border.all(width: 1, color: gMainColor)),
              child: Column(
                children: [
                  SizedBox(height: 3.h),
                  profileTile("Name : ", "Gut-wellness Club"),
                  profileTile("Age : ", "34"),
                  profileTile("Gender : ", "Female"),
                  profileTile("Email : ", "gutwellnessclub.com"),
                  profileTile("Mobile Number : ", "1234567890"),
                  profileTile("Email : ", "gutwellnessclub.com"),
                  profileTile("Mobile Number : ", "1234567890"),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  profileTile(String heading, String title) {
    return Column(
      children: [
        Row(
          // mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              heading,
              style: TextStyle(
                color: gPrimaryColor,
                fontFamily: 'GothamMedium',
                fontSize: 10.sp,
              ),
            ),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: gMainColor,
                  fontFamily: 'GothamBook',
                  fontSize: 9.sp,
                ),
              ),
            ),
          ],
        ),
        Container(
          height: 1,
          margin: EdgeInsets.symmetric(vertical: 2.h),
          color: Colors.grey.withOpacity(0.2),
        ),
      ],
    );
  }
}
