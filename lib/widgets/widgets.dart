import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:im_animations/im_animations.dart';
import 'package:sizer/sizer.dart';
import 'package:get/get.dart';
import '../controller/customer_call_controller.dart';
import '../utils/constants.dart';

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

Row buildAppBar(VoidCallback func) {
  return Row(
    children: [
      SizedBox(
        height: 2.h,
        child: InkWell(
          onTap: func,
          child: const Image(
            image: AssetImage("assets/images/Icon ionic-ios-arrow-back.png"),
          ),
        ),
      ),
      SizedBox(
        height: 8.h,
        child: const Image(
          image: AssetImage("assets/images/Gut wellness logo green.png"),
        ),
      ),
    ],
  );
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

void dialog(BuildContext context) {
  showDialog(
    barrierDismissible: false,
    barrierColor: gWhiteColor.withOpacity(0.8),
    context: context,
    builder: (context) => Center(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5.w),
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
        decoration: BoxDecoration(
          color: gWhiteColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: gMainColor, width: 1),
        ),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              "Call",
              style: TextStyle(
                color: gPrimaryColor,
                fontFamily: "GothamMedium",
                fontSize: 11.sp,
              ),
            ),
            SizedBox(height: 2.h),
            Align(
              alignment: Alignment.topLeft,
              child: Text('Are you sure you want to call?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "GothamBook",
                    color: gMainColor,
                    fontSize: 11.sp,
                  )),
            ),
            SizedBox(height: 4.h),
            Row(
              children: [
                GestureDetector(
                  onTap: () async {
                    callController.fetchCustomersCall();
                    Get.back();
                  },
                  child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 9.w, vertical: 1.h),
                      decoration: BoxDecoration(
                        color: gPrimaryColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: gMainColor),
                      ),
                      child: Text("Call",
                          style: TextStyle(
                            color: gMainColor,
                            fontFamily: "GothamMedium",
                            fontSize: 9.sp,
                          ))),
                ),
                SizedBox(width: 3.w),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(false),
                  child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 9.w, vertical: 1.h),
                      decoration: BoxDecoration(
                        color: gWhiteColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: gMainColor),
                      ),
                      child: Text("Cancel",
                          style: TextStyle(
                            color: gPrimaryColor,
                            fontFamily: "GothamMedium",
                            fontSize: 9.sp,
                          ))),
                ),
              ],
            ),
          ],
        ),
      ),
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
  "8",
  "9",
  "10",
  "11",
  "12",
  "13",
  "14",
  "15",
];
