import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:im_animations/im_animations.dart';
import 'package:sizer/sizer.dart';
import 'package:get/get.dart';
import '../controller/customer_call_controller.dart';
import '../screens/dashboard/notification_screen.dart';
import '../utils/constants.dart';
import 'common_screen_widgets.dart';

CustomerCallController callController = Get.put(CustomerCallController());

Center buildLoadingBar() {
  return Center(
    child: Container(
      decoration: BoxDecoration(
        color: gPrimaryColor,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: gMainColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(2, 3),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
      child: SizedBox(
        height: 2.5.h,
        width: 5.w,
        child: const CircularProgressIndicator(
          color: gMainColor,
          strokeWidth: 2.5,
        ),
      ),
    ),
  );
}

SnackbarController buildSnackBar(String title, String subTitle) {
  return Get.snackbar(
    title,
    subTitle,
    titleText: Text(
      title,
      style: TextStyle(
        fontFamily: "PoppinsSemiBold",
        color: kWhiteColor,
        fontSize: 13.sp,
      ),
    ),
    messageText: Text(
      subTitle,
      style: TextStyle(
        fontFamily: "PoppinsMedium",
        color: kWhiteColor,
        fontSize: 12.sp,
      ),
    ),
    backgroundColor: kPrimaryColor.withOpacity(0.5),
    snackPosition: SnackPosition.BOTTOM,
    colorText: kWhiteColor,
    margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.w),
    borderRadius: 10,
    duration: const Duration(seconds: 2),
    isDismissible: true,
    dismissDirection: DismissDirection.horizontal,
    forwardAnimationCurve: Curves.decelerate,
  );
}

AppBar dashboardAppBar() {
  return AppBar(
    automaticallyImplyLeading: false,
    centerTitle: false,
    elevation: 0,
    backgroundColor: gWhiteColor,
    title: SizedBox(
      height: 5.h,
      child: const Image(
        image: AssetImage("assets/images/Gut wellness logo.png"),
      ),
    ),
    actions: [
      Padding(
        padding: EdgeInsets.only(right: 3.w),
        child: InkWell(
          child: const Icon(
            Icons.notifications_none_sharp,
            color: gBlackColor,
          ),
          onTap: () {
            Get.to(() => const NotificationScreen());
          },
        ),
      )
    ],
  );
}


AppBar buildAppBar(VoidCallback func) {
  return AppBar(
    backgroundColor: gWhiteColor,
    centerTitle: false,
    automaticallyImplyLeading: false,
    elevation: 0,
    title: Row(
      children: [
        GestureDetector(
          onTap: func,
          child: Icon(
            Icons.arrow_back_ios_new_sharp,
            color: gSecondaryColor,
            size: 2.h,
          ),
        ),
        SizedBox(width: 2.w),
        SizedBox(
          height: 5.h,
          child: const Image(
            image: AssetImage("assets/images/Gut wellness logo.png"),
          ),
        ),
      ],
    ),
  );
}

buildLabelTextField(String name) {
  return RichText(
      text: TextSpan(
          text: name,
          style: EvaluationText().questionText(),
          children: [
            TextSpan(
              text: ' *',
              style: TextStyle(
                height: 1.5,
                fontSize: fontSize09,
                color: newSecondaryColor,
                fontFamily: fontMedium,
              ),
            )
          ]));
  // return Text(
  //   'Full Name:*',
  //   style: TextStyle(
  //     fontSize: 9.sp,
  //     color: kTextColor,
  //     fontFamily: "PoppinsSemiBold",
  //   ),
  // );
}


Center buildCircularIndicator() {
  return Center(
    child: HeartBeat(
        child: Image.asset(
      'assets/images/progress_logo.png',
      width: 75,
      height: 75,
    )),
  );
}

buildThreeBounceIndicator({Color? color}) {
  return Center(
    child: SpinKitThreeBounce(
      color: color ?? gMainColor,
      size: 25,
    ),
  );
}

showSnackbar(BuildContext context, String message,
    {int? duration, bool? isError}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: (isError == null || isError == false)
          ? gPrimaryColor
          : gSecondaryColor.withOpacity(0.55),
      content: Text(message),
      duration: Duration(seconds: duration ?? 2),
    ),
  );
}

fixedSnackbar(BuildContext context, String message, String btnName, onPress,
    {Duration? duration, bool? isError}) {
  ScaffoldMessenger.of(context).showMaterialBanner(
    MaterialBanner(
      backgroundColor: (isError == null || isError == false)
          ? gPrimaryColor
          : Colors.redAccent,
      content: Text(message),
      actions: [TextButton(onPressed: onPress, child: Text(btnName))],
    ),
  );
}

trailIcons(
    {required VoidCallback callOnTap, required VoidCallback chatOnTap}) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      GestureDetector(
        onTap: callOnTap,
        child: Image.asset(
          'assets/images/Group 4890.png',
          height: 2.h,
          width: 2.h,
          color: gBlackColor,
        ),
      ),
      SizedBox(width: 4.w),
      GestureDetector(
        onTap: chatOnTap,
        child: Image.asset(
          'assets/images/Group 4891.png',
          height: 2.5.h,
          width: 2.5.h,
          color: gBlackColor,
        ),
      ),
    ],
  );
}

Padding buildNoData() {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 15.h),
    child: Image(
      image: const AssetImage("assets/images/Group 5294.png"),
      height: 25.h,
    ),
  );
}

class CommonButton {

  static ElevatedButton submitButton(func, String title) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: gPrimaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        padding: EdgeInsets.symmetric(vertical: 1.h,horizontal: 5.w),
      ),
      onPressed: func,
      child: Text(
        title,
        style: TextStyle(
          fontFamily: "PoppinsRegular",
          color: Colors.white,
          fontSize: 13.sp,
        ),
      ),
    );
  }
}


List<String> dailyProgress = [
  "1",
  "2",
  "3",
  "4",
  "5",
  "6",
  "7",
  // "8",
  // "9",
  // "10",
  // "11",
  // "12",
  // "13",
  // "14",
  // "15",
];
