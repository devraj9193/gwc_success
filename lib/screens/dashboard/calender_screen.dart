import 'package:flutter/material.dart';
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
import '../../widgets/widgets.dart';
import '../common_ui/show_profile.dart';
import '../post_programs_screens/post_programs_screen.dart';
import '../shipping_screens/shipping_pending_screen.dart';
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
  List searchResults = [];

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
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
      "title": "Active",
      "image": "assets/images/Group 3011.png",
      "id": "3",
    },
    {
      "title": "Post Program",
      "image": "assets/images/Group 3013.png",
      "id": "4",
    },
  ];

  CalendarDetailsController calendarDetailsController =
      Get.put(CalendarDetailsController());

  Future<List<Datum>?> fetchCustomersList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString("token")!;

    final response =
        await http.get(Uri.parse(GwcApi.customersListApiUrl), headers: {
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      print("status: ${response.body}");
      CustomersList jsonData = customersListFromJson(response.body);
      List<Datum>? arrData = jsonData.data;
      return arrData;
    } else {
      throw Exception();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 8.h,
                  child: const Image(
                    image:
                        AssetImage("assets/images/Gut wellness logo green.png"),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ct) => const NotificationScreen(),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.notifications_outlined,
                    color: gMainColor,
                  ),
                ),
              ],
            ),
            buildSearchWidget(),
            SizedBox(height: 1.h),
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
        border: Border.all(color: gMainColor.withOpacity(0.5), width: 1.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 2,
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 2.w),
      margin: EdgeInsets.symmetric(horizontal: 5.w),
      child: TextFormField(
        textAlignVertical: TextAlignVertical.center,
        controller: searchController,
        textAlign: TextAlign.left,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.search,
            color: gMainColor,
            size: 2.5.h,
          ),
          hintText: "Search...",
          suffixIcon: searchController.text.isNotEmpty
              ? GestureDetector(
                  child:
                      Icon(Icons.close_outlined, size: 2.h, color: gMainColor),
                  onTap: () {
                    searchController.clear();
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                )
              : null,
          hintStyle: TextStyle(
            fontFamily: "GothamBook",
            color: gMainColor,
            fontSize: 9.sp,
          ),
          border: InputBorder.none,
        ),
        style: TextStyle(
            fontFamily: "GothamBook", color: gMainColor, fontSize: 11.sp),
        onChanged: (value) {
          onSearchTextChanged(value);
        },
      ),
    );
  }

  buildSearchList() {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.w),
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
            Container(
              height: 1,
              color: Colors.grey.withOpacity(0.3),
            ),
            SizedBox(height: 2.h),
            ListView.builder(
              scrollDirection: Axis.vertical,
              padding: EdgeInsets.symmetric(horizontal: 1.w),
              physics: const ScrollPhysics(),
              shrinkWrap: true,
              itemCount: searchResults.length,
              itemBuilder: ((context, index) {
                print("len: ${searchResults.length}");
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        saveUserId(searchResults[index].id.toString());
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const ShowProfile(),
                          ),
                        );
                      },
                      child: Text(
                        "${searchResults[index].fname ?? ""} ${searchResults[index].lname ?? ""}",
                        style: TextStyle(
                            fontFamily: "GothamMedium",
                            color: gBlackColor,
                            fontSize: 10.sp),
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
    customersList?.data?.forEach((userDetail) {
      if (userDetail.fname!.toLowerCase().contains(text.trim().toLowerCase())) {
        searchResults.add(userDetail);
      }
    });
    setState(() {});
  }

  saveUserId(String userId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("user_id", userId);
  }

  buildCalender() {
    return FutureBuilder(
        future: calendarDetailsController.fetchCalendarList(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else if (snapshot.hasData) {
            var data = snapshot.data;
            return SfCalendar(
              view: CalendarView.week,
              showDatePickerButton: true,
              timeSlotViewSettings: const TimeSlotViewSettings(
                startHour: 8,
                endHour: 22,
                nonWorkingDays: <int>[DateTime.friday, DateTime.monday],
              ),
              showWeekNumber: false,
              showNavigationArrow: true,
              showCurrentTimeIndicator: true,
              allowViewNavigation: true,
              allowDragAndDrop: false,
              dataSource: MeetingDataSource(_getDataSource(data)),
              headerStyle: CalendarHeaderStyle(
                textAlign: TextAlign.center,
                textStyle: TextStyle(
                  fontFamily: "GothamMedium",
                  color: gTextColor,
                  fontSize: 10.sp,
                ),
              ),
              viewHeaderStyle: ViewHeaderStyle(
                dayTextStyle: TextStyle(
                  fontFamily: "GothamBold",
                  color: gTextColor,
                  fontSize: 9.sp,
                ),
                dateTextStyle: TextStyle(
                  fontFamily: "GothamBook",
                  color: gTextColor,
                  fontSize: 9.sp,
                ),
              ),
              todayHighlightColor: gSecondaryColor,
            );
          }
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h),
            child: buildCircularIndicator(),
          );
        });
  }

  List<Meeting> _getDataSource(List<Meeting> data) {
    // final List<Meeting> meetings = <Meeting>[];
    // final DateTime today = DateTime.now();
    // final DateTime startTime = DateTime(today.year, today.month, today.day, 9);
    // final DateTime endTime = startTime.add(const Duration(hours: 2));
    // // meetings.add(Meeting(title: data., date: null, start: null, end: null, color: null, allDay: null));
    return data;
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
          mainAxisSpacing: 10,
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
              }
            },
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: gPrimaryColor,
                  border: Border.all(color: gMainColor, width: 1),
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
                      color: gMainColor,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      doctorDetails[index]["title"],
                      style: TextStyle(
                        fontFamily: "GothamMedium",
                        color: gMainColor,
                        fontSize: 10.sp,
                      ),
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
