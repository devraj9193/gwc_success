import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../model/error_model.dart';
import '../../../model/uvDesk_model/sent_reply_model.dart';
import '../../../repository/uvDesk_repo/uvDesk_repository.dart';
import '../../../service/api_service.dart';
import '../../../service/uvDesk_service/uvDesk_service.dart';
import '../../../utils/constants.dart';
import '../../../utils/gwc_api.dart';
import '../../../widgets/common_screen_widgets.dart';
import '../../../widgets/widgets.dart';
import 'package:http/http.dart' as http;

import 'all_ticket_list_screen.dart';

class ReOpenTicket extends StatefulWidget {
  final String ticketId;
  final String status;
  final String value;
  const ReOpenTicket({Key? key, required this.ticketId, required this.status, required this.value}) : super(key: key);

  @override
  State<ReOpenTicket> createState() => _ReOpenTicketState();
}

class _ReOpenTicketState extends State<ReOpenTicket> {

  bool showLogoutProgress = false;

  var logoutProgressState;

  late final UvDeskService _uvDeskService =
  UvDeskService(uvDeskRepo: repository);

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: GestureDetector(
        onTap: () {
          reOpenDialog(widget.status,widget.value,widget.ticketId);
        },
        child: Container(
          // margin: EdgeInsets.symmetric(horizontal: 10.w),
          padding: EdgeInsets.symmetric(vertical: 1.5.h,horizontal: 5.w),
          decoration: BoxDecoration(
            color: gSecondaryColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              'Re - Open',
              style: LoginScreen().buttonText(whiteTextColor),
            ),
          ),
        ),
      ),
    );
  }

  final UvDeskRepo repository = UvDeskRepo(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );

  reOpenDialog(String editType, String value, String threadId) {
    return showDialog(
      context: context,
      builder: (context) => StatefulBuilder(builder: (_, setstate) {
        logoutProgressState = setstate;
        return AlertDialog(
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15.0.sp),
            ),
          ),
          contentPadding: EdgeInsets.only(top: 1.h),
          content: Container(
            // margin: EdgeInsets.symmetric(horizontal: 5.w),
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
            decoration: BoxDecoration(
              color: gWhiteColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: lightTextColor, width: 1),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Are you sure?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: fontBold,
                      color: newBlackColor,
                      fontSize: fontSize11),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 2.h),
                  height: 1,
                  color: lightTextColor,
                ),
                SizedBox(height: 1.h),
                showLogoutProgress
                    ? buildCircularIndicator()
                    : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        sendReOpen(
                            editType, value, widget.ticketId);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 6.w, vertical: 1.h),
                        decoration: BoxDecoration(
                          color: gSecondaryColor,
                          borderRadius: BorderRadius.circular(5),
                          // border: Border.all(color: gMainColor),
                        ),
                        child: Text(
                          "Yes",
                          style: TextStyle(
                            color: whiteTextColor,
                            fontFamily: fontMedium,
                            fontSize: fontSize09,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 5.w),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop(false);
                      },
                      child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 6.w, vertical: 1.h),
                          decoration: BoxDecoration(
                            color: gWhiteColor,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: lightTextColor),
                          ),
                          child: Text("No",
                              style: TextStyle(
                                color: newBlackColor,
                                fontFamily: fontMedium,
                                fontSize: fontSize09,
                              ))),
                    ),
                  ],
                ),
                SizedBox(height: 1.h)
              ],
            ),
          ),
        );
      }),
    );
  }

  sendReOpen(String editType, String value, String threadId) async {
    logoutProgressState(() {
      showLogoutProgress = true;
    });
    print("---------Cancelled Or Resolved---------");

    final result =
    await _uvDeskService.uvDeskCancelledService(editType, value, threadId);

    if (result.runtimeType == SentReplyModel) {
      SentReplyModel model = result as SentReplyModel;
      logoutProgressState(() {
        showLogoutProgress = false;
      });
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) =>
          const AllTicketListScreen(),
        ),
      );
      GwcApi().showSnackBar(context, model.description!, isError: false);
    } else {
      logoutProgressState(() {
        showLogoutProgress = false;
      });
      ErrorModel response = result as ErrorModel;
      GwcApi().showSnackBar(context, response.message!, isError: true);
      // Navigator.of(context).pushReplacement(
      //   MaterialPageRoute(
      //     builder: (context) => const DashboardScreen(),
      //   ),
      // );
    }
    logoutProgressState(() {
      showLogoutProgress = true;
    });
  }

}
