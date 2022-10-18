import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../../controller/calendar_details_controller.dart';
import '../../model/calendar_model.dart';
import '../../utils/constants.dart';
import '../../widgets/widgets.dart';
import 'consultation_pending_screen.dart';
import 'package:get/get.dart';

class CalenderScreen extends StatefulWidget {
  const CalenderScreen({Key? key}) : super(key: key);

  @override
  State<CalenderScreen> createState() => _CalenderScreenState();
}

class _CalenderScreenState extends State<CalenderScreen> {
  final searchController = TextEditingController();

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
      "title": "Consultations Pending's",
      "image": "assets/images/Group 3009.png",
      "id": "1",
    },
    {
      "title": "Shipping Pending's",
      "image": "assets/images/Group 3371.png",
      "id": "2",
    },
    {
      "title": "Active Consultation",
      "image": "assets/images/Group 3011.png",
      "id": "3",
    },
    {
      "title": "Post\nProgram",
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
        extendBody: true,
        body: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 8.h,
                child: const Image(
                  image:
                      AssetImage("assets/images/Gut wellness logo green.png"),
                ),
              ),
              buildSearchWidget(),
              searchController.text.isEmpty
                  ? Column(
                      children: [
                        SizedBox(height: 2.h),
                        buildCalender(),
                        buildDetails(),
                        SizedBox(height: 1.h)
                      ],
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  buildSearchWidget() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: Colors.white,
        border: Border.all(color: gMainColor, width: 1.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 5,
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 2.w),
      margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 5.w),
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
          //  onSearchTextChanged(value, setState);
        },
      ),
    );
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
            return SizedBox(
              width: double.maxFinite,
              height: 100.h,
              child: SfCalendar(
                view: CalendarView.week,
                showDatePickerButton: true,
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
                    fontSize: 10.sp,
                  ),
                  dateTextStyle: TextStyle(
                    fontFamily: "GothamBook",
                    color: gTextColor,
                    fontSize: 10.sp,
                  ),
                ),
                todayHighlightColor: gSecondaryColor,
              ),
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
          crossAxisSpacing: 15,
          mainAxisSpacing: 13,
          mainAxisExtent: 13.h,
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
                // Navigator.of(context).push(
                //   MaterialPageRoute(
                //     builder: (ct) => const MealPlansScreen(),
                //   ),
                // );
              } else if (doctorDetails[index]["id"] == "3") {
                // Navigator.of(context).push(
                //   MaterialPageRoute(
                //     builder: (ct) => const ActiveScreen(),
                //   ),
                // );
              } else if (doctorDetails[index]["id"] == "4") {
                // Navigator.of(context).push(
                //   MaterialPageRoute(
                //     builder: (ct) => const PostProgramsScreen(),
                //   ),
                // );
              }
            },
            child: Container(
                padding: EdgeInsets.only(
                    top: 1.5.h, left: 4.w, right: 10.w, bottom: 1.h),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image(
                      height: 5.h,
                      image: AssetImage(doctorDetails[index]["image"]),
                      color: gMainColor,
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      doctorDetails[index]["title"],
                      style: TextStyle(
                        height: 1,
                        fontFamily: "GothamMedium",
                        color: gMainColor,
                        fontSize: 11.sp,
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
