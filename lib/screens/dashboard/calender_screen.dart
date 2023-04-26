import 'package:flutter/material.dart';
import 'package:gwc_success_team/screens/dashboard/transition_meal_plan.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../../controller/calendar_details_controller.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../model/calendar_model.dart';
import '../../model/customers_list_model.dart';
import '../../utils/constants.dart';
import '../../utils/gwc_api.dart';
import '../../widgets/common_screen_widgets.dart';
import '../../widgets/widgets.dart';
import '../common_ui/call_chat_icons.dart';
import '../common_ui/show_profile.dart';
import 'meal_plan_screen.dart';
import 'post_programs_screen.dart';
import 'shipping_pending_screen.dart';
import 'active_consultation_screen.dart';
import 'notification_screen.dart';
import 'consultation_pending_screen.dart';

class CalenderScreen extends StatefulWidget {
  const CalenderScreen({Key? key}) : super(key: key);

  @override
  State<CalenderScreen> createState() => _CalenderScreenState();
}

class _CalenderScreenState extends State<CalenderScreen> {
  final searchController = TextEditingController();
  CustomersList? customersList;
  List<Datum> searchResults = [];
  final SharedPreferences _pref = GwcApi.preferences!;

  String? _subjectText = '',
      _startTimeText = '',
      _endTimeText = '',
      _dateText = '',
      _timeDetails = '';
  // Color? _headerColor, _viewHeaderColor, _calendarColor;

  String kaleyraAccessToken = "";
  String kaleyraUserId = "";

  void getKaleyraDetails() async {
    kaleyraAccessToken = _pref.getString(GwcApi.kaleyraAccessToken)!;
    kaleyraUserId = _pref.getString("kaleyraUserId")!;
    setState(() {});
    print("kaleyraAccessToken: $kaleyraAccessToken");
  }

  @override
  void initState() {
    super.initState();
    fetchCustomersList();
    getKaleyraDetails();
    searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  Future<List<Datum>?> fetchCustomersList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString("token")!;
    final response =
        await http.get(Uri.parse(GwcApi.customersListApiUrl), headers: {
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      customersList = customersListFromJson(response.body);
      List<Datum>? arrData = customersList?.data;
      return arrData;
    } else {
      throw Exception();
    }
  }

  List doctorDetails = [
    {
      "title": "Consultations",
      "image": "assets/images/Group 3009.png",
      "id": "1",
    },
    {
      "title": "Shipping",
      "image": "assets/images/Group 3371.png",
      "id": "2",
    },
    {
      "title": "Meal Plan",
      "image": "assets/images/Group 3011.png",
      "id": "5",
    },
    {
      "title": "Active",
      "image": "assets/images/Group 3011.png",
      "id": "3",
    },
    {
      "title": "Transition",
      "image": "assets/images/Group 3011.png",
      "id": "6",
    },
    {
      "title": "Post Program",
      "image": "assets/images/Group 3013.png",
      "id": "4",
    },
  ];

  CalendarDetailsController calendarDetailsController =
      Get.put(CalendarDetailsController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: chartBackGroundColor,
          automaticallyImplyLeading: false,
          centerTitle: false,
          elevation: 0,
          title: Image(
            image: const AssetImage("assets/images/Gut wellness logo.png"),
            height: 5.h,
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
            // GestureDetector(
            //   onTap: () {
            //     buildCalendar(context);
            //   },
            //   child: Padding(
            //     padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.8.h),
            //     child: const Image(
            //       image: AssetImage("assets/images/noun-calendar-5347015.png"),
            //       color: gBlackColor,
            //     ),
            //   ),
            // ),
          ],
        ),
        backgroundColor: chartBackGroundColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 1.h),
            buildSearchWidget(),
            searchController.text.isEmpty
                ? Expanded(child: buildCalender())
                : Expanded(child: buildSearchList()),
            searchController.text.isEmpty ? buildDetails() : Container(),
            SizedBox(height: 1.h)
            //  searchController.text.isEmpty ? buildSearch() : Container(),
          ],
        ),
      ),
    );
  }

  buildSearchWidget() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: Colors.white,
        border: Border.all(color: lightTextColor.withOpacity(0.3), width: 1.0),
        boxShadow: [
          BoxShadow(
            color: lightTextColor.withOpacity(0.3),
            blurRadius: 2,
          ),
        ],
      ),
      //padding: EdgeInsets.symmetric(horizontal: 2.w),
      margin: EdgeInsets.symmetric(horizontal: 3.w),
      child: TextFormField(
        textAlignVertical: TextAlignVertical.center,
        controller: searchController,
        cursorColor: newBlackColor,
        cursorHeight: 2.h,
        textAlign: TextAlign.left,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.search,
            color: newBlackColor,
            size: 2.5.h,
          ),
          hintText: "Search...",
          suffixIcon: searchController.text.isNotEmpty
              ? GestureDetector(
                  child: Icon(Icons.close_outlined,
                      size: 2.h, color: newBlackColor),
                  onTap: () {
                    searchController.clear();
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                )
              : null,
          hintStyle: LoginScreen().hintTextField(),
          border: InputBorder.none,
        ),
        style: LoginScreen().mainTextField(),
        onChanged: (value) {
          onSearchTextChanged(value);
        },
      ),
    );
  }

  buildSearchList() {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 2.w),
        margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
        decoration: BoxDecoration(
          color: gWhiteColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              blurRadius: 2,
              color: Colors.grey.withOpacity(0.5),
            ),
          ],
        ),
        child: Column(
          children: [
            ListView.builder(
              scrollDirection: Axis.vertical,
              padding: EdgeInsets.symmetric(horizontal: 1.w),
              physics: const ScrollPhysics(),
              shrinkWrap: true,
              itemCount: searchResults.length,
              itemBuilder: ((context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        saveUserId(searchResults[index].id.toString(), "", "");
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const ShowProfile(),
                          ),
                        );
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 2.h,
                            backgroundImage: NetworkImage(
                              searchResults[index].profile.toString(),
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${searchResults[index].fname ?? ""} ${searchResults[index].lname ?? ""}",
                                  style: AllListText().headingText(),
                                ),
                                SizedBox(height: 1.h),
                                Text(
                                  "${searchResults[index].date}/${searchResults[index].time}",
                                  style: AllListText().otherText(),
                                ),
                              ],
                            ),
                          ),
                          CallChatIcons(
                            userId: searchResults[index].id.toString(),
                            kaleyraUserId:
                                searchResults[index].kaleyraUserId.toString(),
                          ),
                          // trailIcons(callOnTap: () {
                          //   dialog(context);
                          //   saveUserId(
                          //     "",
                          //     "",
                          //     searchResults[index].id.toString(),
                          //   );
                          // }, chatOnTap: () {
                          //   saveUserId(
                          //       "", "", searchResults[index].id.toString());
                          //   setState(() {
                          //     final qbService = Provider.of<QuickBloxService>(
                          //         context,
                          //         listen: false);
                          //     qbService.openKaleyraChat(
                          //         kaleyraUserId,
                          //         searchResults[index].kaleyraUserId.toString(),
                          //         kaleyraAccessToken);
                          //     // getChatGroupId(
                          //     //   "${searchResults[index].fname ?? ""} ${searchResults[index].lname ?? ""}",
                          //     //   searchResults[index].profile.toString(),
                          //     //   searchResults[index].id.toString(),
                          //     // );
                          //   });
                          // }),
                        ],
                      ),
                    ),
                    Container(
                      height: 1,
                      margin: EdgeInsets.symmetric(vertical: 1.5.h),
                      color: Colors.grey.withOpacity(0.3),
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  onSearchTextChanged(String text) async {
    searchResults.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }
    customersList?.data.forEach((userDetail) {
      if (userDetail.fname!.toLowerCase().contains(text.trim().toLowerCase())) {
        searchResults.add(userDetail);
      }
    });
    setState(() {});
  }

  saveUserId(String patientId, String teamPatientId, String userId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("patient_id", patientId);
    preferences.setString("team_patient_id", teamPatientId);
    preferences.setString("user_id", userId);
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

  buildCalender() {
    return Container(
      height: double.maxFinite,
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: gWhiteColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: FutureBuilder(
          future: calendarDetailsController.fetchCalendarList(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text(""),
                //Text(snapshot.error.toString()),
              );
            } else if (snapshot.hasData) {
              var data = snapshot.data;
              return SfCalendar(
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
                dataSource: MeetingDataSource(_getDataSource(data)),
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
              );
            }
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h),
              child: buildCircularIndicator(),
            );
          }),
    );
  }

  List<Meeting> _getDataSource(List<Meeting> data) {
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
      final Meeting appointmentDetails = details.appointments![0];
      _subjectText = appointmentDetails.title;
      _dateText = DateFormat('MMMM dd, yyyy')
          .format(appointmentDetails.start)
          .toString();
      _startTimeText =
          DateFormat('hh:mm a').format(appointmentDetails.start).toString();
      _endTimeText =
          DateFormat('hh:mm a').format(appointmentDetails.end).toString();
      if (appointmentDetails.allDay) {
        _timeDetails = 'All day';
      } else {
        _timeDetails = '$_startTimeText - $_endTimeText';
      }
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                '$_subjectText',
                style: TextStyle(
                  fontFamily: fontBold,
                  color: newBlackColor,
                  fontSize: fontSize13,
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
                      '$_dateText',
                      style: TextStyle(
                        fontFamily: fontMedium,
                        color: newBlackColor,
                        fontSize: fontSize12,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      _timeDetails!,
                      style: TextStyle(
                        fontFamily: fontBook,
                        color: newBlackColor,
                        fontSize: fontSize11,
                      ),
                    )
                  ],
                ),
              ),
              actions: <Widget>[
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

  buildDetails() {
    return GridView.builder(
        padding: EdgeInsets.symmetric(horizontal: 3.w),
        scrollDirection: Axis.vertical,
        physics: const ScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
          mainAxisExtent: 6.h,
        ),
        itemCount: doctorDetails.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              if (doctorDetails[index]["id"] == "1") {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ct) => const ConsultationPendingScreen(),
                  ),
                );
              } else if (doctorDetails[index]["id"] == "2") {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ct) => const ShippingPendingScreen(),
                  ),
                );
              } else if (doctorDetails[index]["id"] == "3") {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ct) => const ActiveConsultationScreen(),
                  ),
                );
              } else if (doctorDetails[index]["id"] == "4") {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ct) => const PostProgramsScreen(),
                  ),
                );
              } else if (doctorDetails[index]["id"] == "5") {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ct) => const MealPlanScreen(),
                  ),
                );
              } else if (doctorDetails[index]["id"] == "6") {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ct) => const TransitionMealPlanList(),
                  ),
                );
              }
            },
            child: Container(
                padding: EdgeInsets.symmetric(vertical: 1.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: gSecondaryColor,
                  //border: Border.all(color: gMainColor, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 5,
                      offset: const Offset(2, 6),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                      height: 3.h,
                      image: AssetImage(doctorDetails[index]["image"]),
                      color: whiteTextColor,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      doctorDetails[index]["title"],
                      style: DashBoardScreen().gridTextField(),
                    ),
                  ],
                )),
          );
        });
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return _getMeetingData(index).start;
  }

  @override
  DateTime getEndTime(int index) {
    return _getMeetingData(index).end;
  }

  @override
  String getSubject(int index) {
    return _getMeetingData(index).title;
  }

  @override
  Color getColor(int index) {
    return gSecondaryColor;
  }

  @override
  bool isAllDay(int index) {
    return _getMeetingData(index).allDay;
  }

  Meeting _getMeetingData(int index) {
    final dynamic meeting = appointments![index];
    late final Meeting meetingData;
    if (meeting is Meeting) {
      meetingData = meeting;
    }

    return meetingData;
  }
}
