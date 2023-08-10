import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:http/http.dart' as http;
import '../../model/calendar_model.dart';
import '../../model/error_model.dart';
import '../../repository/calendar_repo/calendar_repository.dart';
import '../../service/api_service.dart';
import '../../service/calendar_services/calendar_service.dart';
import '../../utils/constants.dart';
import '../../widgets/common_screen_widgets.dart';
import 'calendar_customer_details.dart';

class CalenderScreen extends StatefulWidget {
  const CalenderScreen({Key? key}) : super(key: key);

  @override
  State<CalenderScreen> createState() => _CalenderScreenState();
}

class _CalenderScreenState extends State<CalenderScreen> {

  String? _subjectText = '',
      _startTimeText = '',
      _endTimeText = '',
      _dateText = '',
      _timeDetails = '',
      _meetingType = '';

  List newList = [];

  bool showProgress = false;
  CalendarModel? calendarModel;

  late final CalendarListService calendarListService =
      CalendarListService(repository: repository);

  @override
  void initState() {
    super.initState();
    getCalendarList();
  }

  getCalendarList() async {
    setState(() {
      showProgress = true;
    });

    callProgressStateOnBuild(true);
    final result = await calendarListService.getCalendarListService();
    print("result: $result");

    if (result.runtimeType == CalendarModel) {
      print("Follow UP Calls List");
      CalendarModel model = result as CalendarModel;

      calendarModel = model;

      List<Meeting> consultation = calendarModel?.data ?? [];
      List<FollowUpSchedule> followUpCalls =
          calendarModel?.followUpSchedule ?? [];

      setState(() {
        newList = List.from(consultation)..addAll(followUpCalls);
      });

      print("newList : $newList");
    } else {
      ErrorModel model = result as ErrorModel;
      print("error: ${model.message}");
    }
    setState(() {
      showProgress = false;
    });
    print(result);
  }

  callProgressStateOnBuild(bool value) {
    Future.delayed(Duration.zero).whenComplete(() {
      setState(() {
        showProgress = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.maxFinite,
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: gWhiteColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: SfCalendar(
        view: CalendarView.week,
        showDatePickerButton: true,
        cellBorderColor: chartBackGroundColor,
        headerHeight: 30,
        onTap: calendarTapped,
        //   headerDateFormat: "yMMMMEEEEd",
        timeSlotViewSettings: const TimeSlotViewSettings(
          startHour: 8,
          endHour: 22,
          nonWorkingDays: <int>[DateTime.friday, DateTime.monday],
        ),
        showWeekNumber: true,
        showNavigationArrow: true,
        showCurrentTimeIndicator: true,
        allowViewNavigation: true,
        allowDragAndDrop: false,
        dataSource: MeetingDataSource(_getDataSource(newList)),
        headerStyle: CalendarHeaderStyle(
          textAlign: TextAlign.center,
          textStyle: TextStyle(
            fontFamily: fontMedium,
            color: newBlackColor,
            fontSize: fontSize10,
          ),
        ),
        viewHeaderStyle: ViewHeaderStyle(
          dayTextStyle: TextStyle(
            fontFamily: fontBold,
            color: newBlackColor,
            fontSize: fontSize09,
          ),
          dateTextStyle: TextStyle(
            fontFamily: fontBook,
            color: newBlackColor,
            fontSize: fontSize09,
          ),
        ),
        todayHighlightColor: gSecondaryColor,
      ),
    );
  }

  // final MessageRepository chatRepository = MessageRepository(
  //   apiClient: ApiClient(
  //     httpClient: http.Client(),
  //   ),
  // );
  //
  // getChatGroupId(String userName, String profileImage, String userId) async {
  //   print(_pref.getInt(GwcApi.getQBSession));
  //   print(_pref.getBool(GwcApi.isQBLogin));
  //
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   var chatUserName = preferences.getString("chatUserName")!;
  //   print("UserName: $chatUserName");
  //
  //   print(_pref.getInt(GwcApi.getQBSession) == null ||
  //       _pref.getBool(GwcApi.isQBLogin) == null ||
  //       _pref.getBool(GwcApi.isQBLogin) == false);
  //   final _qbService = Provider.of<QuickBloxService>(context, listen: false);
  //   print(await _qbService.getSession());
  //   if (_pref.getInt(GwcApi.getQBSession) == null ||
  //       await _qbService.getSession() == true ||
  //       _pref.getBool(GwcApi.isQBLogin) == null ||
  //       _pref.getBool(GwcApi.isQBLogin) == false) {
  //     _qbService.login(chatUserName);
  //   } else {
  //     if (await _qbService.isConnected() == false) {
  //       _qbService.connect(_pref.getInt(GwcApi.qbCurrentUserId)!);
  //     }
  //   }
  //   final res = await ChatService(repository: chatRepository)
  //       .getChatGroupIdService(userId);
  //
  //   if (res.runtimeType == GetChatGroupIdModel) {
  //     GetChatGroupIdModel model = res as GetChatGroupIdModel;
  //     // QuickBloxRepository().init(AppConfig.QB_APP_ID, AppConfig.QB_AUTH_KEY, AppConfig.QB_AUTH_SECRET, AppConfig.QB_ACCOUNT_KEY);
  //     _pref.setString(GwcApi.groupId, model.group ?? '');
  //     print("getModel:$res");
  //     print('model.group: ${model.group}');
  //     Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //             builder: (c) => MessageScreen(
  //                   isGroupId: true,
  //                   userName: userName,
  //                   profileImage: profileImage,
  //                 )));
  //   } else {
  //     ErrorModel model = res as ErrorModel;
  //     showSnackbar(context, model.message.toString(), isError: true);
  //   }
  // }

  // onSearchTextChanged(String text) async {
  //   searchResults.clear();
  //   if (text.isEmpty) {
  //     setState(() {});
  //     return;
  //   }
  //   customersList?.data?.forEach((userDetail) {
  //     if (userDetail.fname!.toLowerCase().contains(text.trim().toLowerCase())) {
  //       searchResults.add(userDetail);
  //     }
  //   });
  //   setState(() {});
  // }

  List _getDataSource(List data) {
    // final List<Meeting> meetings = <Meeting>[];
    // final DateTime today = DateTime.now();
    // final DateTime startTime = DateTime(today.year, today.month, today.day, 9);
    // final DateTime endTime = startTime.add(const Duration(hours: 2));
    // // meetings.add(Meeting(title: data., date: null, start: null, end: null, color: null, allDay: null));
    return data;
  }

  void calendarTapped(CalendarTapDetails details) {
    if (details.targetElement == CalendarElement.appointment ||
        details.targetElement == CalendarElement.agenda) {
      var appointmentDetails = details.appointments![0];
      _subjectText = appointmentDetails.type == "1"
          ? appointmentDetails.title
          : appointmentDetails.type == "2"
              ? appointmentDetails.title
              : appointmentDetails.teamPatients.patient.user.name.toString();
      _meetingType = appointmentDetails.type == "1"
          ? "Pre Consultation"
          : appointmentDetails.type == "2"
              ? "Post Consultation"
              : "Follow_up Call";
      _dateText = appointmentDetails.type == "1"
          ? DateFormat('MMMM dd, yyyy')
              .format(appointmentDetails.start)
              .toString()
          : appointmentDetails.type == "2"
              ? DateFormat('MMMM dd, yyyy')
                  .format(appointmentDetails.start)
                  .toString()
              : DateFormat('MMMM dd, yyyy')
                  .format(DateTime.parse(appointmentDetails.date))
                  .toString();
      _startTimeText = appointmentDetails.type == "1"
          ? DateFormat('hh:mm a').format(appointmentDetails.start).toString()
          : appointmentDetails.type == "2"
              ? DateFormat('hh:mm a')
                  .format(appointmentDetails.start)
                  .toString()
              : DateFormat('hh:mm a')
                  .format(DateTime.parse(
                      "${appointmentDetails.date} ${appointmentDetails.slotStartTime}"))
                  .toString();
      _endTimeText = appointmentDetails.type == "1"
          ? DateFormat('hh:mm a').format(appointmentDetails.end).toString()
          : appointmentDetails.type == "2"
              ? DateFormat('hh:mm a').format(appointmentDetails.end).toString()
              : DateFormat('hh:mm a')
                  .format(DateTime.parse(
                      "${appointmentDetails.date} ${appointmentDetails.slotEndTime}"))
                  .toString();
      _timeDetails = '$_startTimeText - $_endTimeText';
      // if (appointmentDetails.allDay) {
      //   _timeDetails = 'All day';
      // } else {
      //   _timeDetails = '$_startTimeText - $_endTimeText';
      // }
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                '$_meetingType',
                style: TextStyle(
                  fontFamily: fontBold,
                  color: newBlackColor,
                  fontSize: fontSize12,
                ),
              ),
              content: Container(
                height: 80,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: gWhiteColor),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '$_subjectText',
                      style: TextStyle(
                        fontFamily: fontMedium,
                        color: newBlackColor,
                        fontSize: fontSize11,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      '$_dateText',
                      style: TextStyle(
                        fontFamily: fontMedium,
                        color: newBlackColor,
                        fontSize: fontSize10,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      _timeDetails!,
                      style: TextStyle(
                        fontFamily: fontBook,
                        color: newBlackColor,
                        fontSize: fontSize09,
                      ),
                    )
                  ],
                ),
              ),
              actions: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            //     NutriDelightScreen(
                            //   userId: appointmentDetails.userId,
                            //   tabIndex: 0,
                            //   userName: appointmentDetails.title,
                            //   age: '',
                            //   appointmentDetails:
                            //       "$_dateText / $_startTimeText",
                            //   status: '',
                            //   finalDiagnosis: '',
                            //   preparatoryCurrentDay: '',
                            //   transitionCurrentDay: '',
                            //   isPrepCompleted: '',
                            //   isProgramStatus: '',
                            //   programDaysStatus: '',
                            // ),
                            CalendarCustomerScreen(
                          userId: appointmentDetails.type == "1"
                              ? appointmentDetails.userId
                              : appointmentDetails.type == "2"
                                  ? appointmentDetails.userId
                                  : appointmentDetails
                                      .teamPatients.patient.user.id,
                          tabIndex: 0,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
                    decoration: BoxDecoration(
                      color: gSecondaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'View',
                      style: LoginScreen().buttonText(whiteTextColor),
                    ),
                  ),
                ),
                SizedBox(width: 3.w),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
                    decoration: BoxDecoration(
                      color: gSecondaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'close',
                      style: LoginScreen().buttonText(whiteTextColor),
                    ),
                  ),
                ),
              ],
            );
          });
    }
  }

  final CalendarListRepo repository = CalendarListRepo(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List source) {
    print("meeting source : $source");

    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return _getMeetingData(index).type == "1"
        ? _getMeetingData(index).start
        : _getMeetingData(index).type == "2"
            ? _getMeetingData(index).start
            : DateTime.parse(
                "${_getMeetingData(index).date} ${_getMeetingData(index).slotStartTime}");
  }

  @override
  DateTime getEndTime(int index) {
    return _getMeetingData(index).type == "1"
        ? _getMeetingData(index).end
        : _getMeetingData(index).type == "2"
            ? _getMeetingData(index).end
            : DateTime.parse(
                "${_getMeetingData(index).date} ${_getMeetingData(index).slotEndTime}");
  }

  @override
  String getSubject(int index) {
    return _getMeetingData(index).type == "1"
        ? _getMeetingData(index).title
        : _getMeetingData(index).type == "2"
            ? _getMeetingData(index).title
            : _getMeetingData(index).teamPatients.patient.user.name.toString();
  }

  @override
  Color getColor(int index) {
    return _getMeetingData(index).type == "1"
        ? gSecondaryColor.withOpacity(0.7)
        : _getMeetingData(index).type == "2"
            ? Colors.blueAccent
            : gMainColor;
  }

  @override
  bool isAllDay(int index) {
    return _getMeetingData(index).type == "1"
        ? _getMeetingData(index).allDay
        : _getMeetingData(index).type == "2"
            ? _getMeetingData(index).allDay
            : false;
  }

  @override
  set appointments(List? appointments) {
    super.appointments = appointments;
  }

  _getMeetingData(int index) {
    final dynamic meeting = appointments![index];
    late final Meeting meetingData;
    if (meeting is Meeting) {
      meetingData = meeting;
    }

    return meeting;
  }
}
