import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'constants.dart';

class AppConfig {
  static AppConfig? instance;

  factory AppConfig() => instance ??= AppConfig._();

  AppConfig._();

  static String slotErrorText = "Slots Not Available Please select different day";
  static String networkErrorText = "No Internet. Please Check Your Network Connection";
  static String oopsMessage = "OOps ! Something went wrong.";



  final String shipRocketBearer = "ShipToken";
  final String shipRocketEmail = "bhogesh@fembuddy.com";
  final String shipRocketPassword = "adithya7224";

  showSheet(BuildContext context, Widget widget,
      {bool sheetForLogin = false,double? bottomSheetHeight,
        String? circleIcon, Color? topColor, bool isSheetCloseNeeded = false,
        VoidCallback? sheetCloseOnTap, bool isDismissible = false}){
    return showModalBottomSheet(
        isScrollControlled: true,
        isDismissible: isDismissible,
        enableDrag: false,
        context: context,
        backgroundColor: Colors.transparent,
        builder: (ctx) {
          return (sheetForLogin)
              ? AnimatedPadding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            duration: const Duration(milliseconds: 100),
            child: commonBottomSheetView(context, widget,
                bottomSheetHeight: bottomSheetHeight, circleIcon: circleIcon, topColor: topColor, sheetForLogin: true),
          )
              : commonBottomSheetView(context, widget,
              bottomSheetHeight: bottomSheetHeight, circleIcon: circleIcon, topColor: topColor, isSheetCloseNeeded: isSheetCloseNeeded,sheetCloseOnTap: sheetCloseOnTap
          );
        }
    );
  }

  commonBottomSheetView(BuildContext context, Widget widget,
      {bool sheetForLogin = false,double? bottomSheetHeight,
        String? circleIcon, Color? topColor,
        bool isSheetCloseNeeded = false, VoidCallback? sheetCloseOnTap}){
    return Container(
      decoration: const BoxDecoration(
        color: gBackgroundColor,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(22),
            topRight: Radius.circular(22)
        ),
      ),
      padding: (sheetForLogin) ? null : EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      height: bottomSheetHeight ?? 50.h,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            children: [
              Container(
                height: 15.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  color: topColor ?? kBottomSheetHeadYellow,
                ),
                child: Center(
                  child: Image.asset(bsHeadStarsIcon,
                    alignment: Alignment.topRight,
                    fit: BoxFit.scaleDown,
                    width: 30.w,
                    height: 10.h,
                  ),
                ),
              ),
              SizedBox(
                height: 7.h,
              ),
              Flexible(
                child: SingleChildScrollView(
                  child: widget,
                ),
              )

            ],
          ),
          Positioned(
              top: 8.h,
              left: 5,
              right: 5,
              child: Container(
                  decoration: BoxDecoration(
                    // color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(blurRadius: 5, color: gHintTextColor.withOpacity(0.8))
                    ],
                  ),
                  child: CircleAvatar(
                    maxRadius: 40.sp,
                    backgroundColor: kBottomSheetHeadCircleColor,
                    child: Image.asset(circleIcon ?? bsHeadBellIcon,
                      fit: BoxFit.scaleDown,
                      width: 45,
                      height: 45,
                    ),
                  )
              )
          ),
          Visibility(
            visible: isSheetCloseNeeded,
            child: Positioned(
                top: 10,
                right: 10,
                child: GestureDetector(
                    onTap: sheetCloseOnTap ?? (){Navigator.pop(context);},
                    child: Icon(Icons.cancel_outlined, color: gSecondaryColor,size: 28,))),
          )
        ],
      ),
    );
  }

  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    print("hexString:  $hexString");
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    print("buffer.toString(): ${buffer.toString()} ");
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
