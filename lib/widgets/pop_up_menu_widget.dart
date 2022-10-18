import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gwc_success_team/screens/common_ui/show_profile.dart';
import 'package:sizer/sizer.dart';
import '../screens/common_ui/message_screen.dart';
import '../utils/constants.dart';

class PopUpMenuWidget extends StatefulWidget {
  const PopUpMenuWidget({Key? key}) : super(key: key);

  @override
  State<PopUpMenuWidget> createState() => _PopUpMenuWidgetState();
}

class _PopUpMenuWidgetState extends State<PopUpMenuWidget> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
      ),
      child: PopupMenuButton(
        onSelected: null,
        offset: const Offset(0, 30),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5)),
        itemBuilder: (context) => [
          PopupMenuItem(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 1.h),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ct) =>
                        const ShowProfile(),
                      ),
                    ).then((value) => Navigator.pop(context));
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "View",
                          style: TextStyle(
                              fontFamily: "GothamBook",
                              color: gTextColor,
                              fontSize: 9.sp),
                        ),
                        SvgPicture.asset(
                            "assets/images/noun-view-1041859.svg",
                          width: 7.sp,
                          height: 7.sp,
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 1.h),
                  height: 1,
                  color: gGreyColor.withOpacity(0.3),
                ),
                GestureDetector(
                  onTap: () {
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (ct) =>
                    //     const MessageScreen(),
                    //   ),
                    // );
                  },
                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Call",
                        style: TextStyle(
                            fontFamily: "GothamBook",
                            color: gSecondaryColor,
                            fontSize: 9.sp),
                      ),
                      Image(
                        image: const AssetImage(
                            "assets/images/Group 4890.png"),
                        height: 2.h,
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 1.h),
                  height: 1,
                  color: gGreyColor.withOpacity(0.3),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ct) =>
                        const MessageScreen(),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Message",
                        style: TextStyle(
                            fontFamily: "GothamBook",
                            color: gTextColor,
                            fontSize: 9.sp),
                      ),
                      Image(
                        image: const AssetImage(
                            "assets/images/Group 4891.png"),
                        height: 2.h,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 0.5.h),
              ],
            ),
          ),
        ],
        child: Icon(
          Icons.more_vert,
          color: gGreyColor.withOpacity(0.5),
        ),
      ),
    );
  }
}
