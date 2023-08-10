import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import '../../../model/error_model.dart';
import '../../../model/maintenance_guide_model.dart';
import '../../../repository/customer_status_repo.dart/customer_status_repo.dart';
import '../../../service/api_service.dart';
import '../../../service/customer_status_service/customer_status_service.dart';
import '../../../utils/constants.dart';
import '../../../widgets/common_screen_widgets.dart';
import '../../../widgets/widgets.dart';
import '../../common_ui/call_chat_icons.dart';
import '../../common_ui/show_profile.dart';
import '../../nutri_delight_screens/nutri_delight_screen.dart';
import 'package:http/http.dart' as http;

class CompletedList extends StatefulWidget {
  const CompletedList({Key? key}) : super(key: key);

  @override
  State<CompletedList> createState() => _CompletedListState();
}

class _CompletedListState extends State<CompletedList> {
  String statusText = "";

  final searchController = TextEditingController();

  bool showProgress = false;
  MaintenanceGuideModel? maintenanceGuideModel;
  List<GutMaintenanceGuide> searchResults = [];
  final ScrollController _scrollController = ScrollController();

  late final CustomerStatusService customerStatusService =
  CustomerStatusService(customerStatusRepo: repository);

  @override
  void initState() {
    super.initState();
    getClaimedCustomerList();
  }

  getClaimedCustomerList() async {
    setState(() {
      showProgress = true;
    });
    callProgressStateOnBuild(true);
    final result = await customerStatusService.getPostProgramService();
    print("result: $result");

    if (result.runtimeType == MaintenanceGuideModel) {
      print("Ticket List");
      MaintenanceGuideModel model = result as MaintenanceGuideModel;

      maintenanceGuideModel = model;
    } else {
      ErrorModel model = result as ErrorModel;
      print("error: ${model.message}");
      setState(() {
        showProgress = false;
      });
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
    List<GutMaintenanceGuide> mgList =
        maintenanceGuideModel?.gmgSubmitted ?? [];

    return (showProgress)
        ? Center(
      child: buildCircularIndicator(),
    )
        : mgList.isEmpty
        ? buildNoData()
        : Column(
      children: [
        Padding(
          padding:
          EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: searchBarTitle,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    if (searchIcon.icon == Icons.search) {
                      searchIcon = Icon(
                        Icons.close,
                        color: gBlackColor,
                        size: 2.5.h,
                      );
                      searchBarTitle = buildSearchWidget();
                    } else {
                      searchIcon = Icon(
                        Icons.search,
                        color: gBlackColor,
                        size: 2.5.h,
                      );
                      searchBarTitle = const Text('');
                      // filteredNames = names;
                      searchController.clear();
                    }
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: gWhiteColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 8,
                        offset: const Offset(2, 3),
                      ),
                    ],
                  ),
                  child: searchIcon,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: searchController.text.isEmpty
                ? ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.vertical,
              padding: EdgeInsets.symmetric(horizontal: 1.w),
              physics: const ScrollPhysics(),
              shrinkWrap: true,
              itemCount: mgList.length,
              itemBuilder: ((context, index) {
                var data = mgList[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            NutriDelightScreen(
                              userId: int.parse(
                                  "${data.patient?.user?.id}"),
                              tabIndex: 1,
                              userName:
                              data.patient?.user?.name ?? '',updateTime: '', updateDate: '',
                              age:
                              "${data.patient?.user?.age.toString()} ${data.patient?.user?.gender.toString()}",
                              appointmentDetails: buildTimeDate(
                                  data.appointments?[0].date
                                      .toString() ??
                                      '',
                                  data.appointments?[0]
                                      .slotStartTime ??
                                      ''),
                              status: buildStatusText(
                                data.patient?.status ?? '',
                                data.patient?.user
                                    ?.medicalFeedback ??
                                    '',
                              ),
                              finalDiagnosis: '',
                              preparatoryCurrentDay: '',
                              transitionCurrentDay: '',
                              isPrepCompleted: '',
                              isProgramStatus: '',
                              programDayStatus: '',
                            ),
                        //     CalendarCustomerScreen(
                        //   userId: data[index].patient.user.id,
                        //   tabIndex: 0,
                        // ),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment:
                        CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ShowProfile(
                                        userId: int.parse(
                                            "${data.patient?.user?.id}"),
                                      ),
                                ),
                              );
                            },
                            child: CircleAvatar(
                              radius: 3.h,
                              backgroundImage: NetworkImage(data
                                  .patient?.user?.profile
                                  .toString() ??
                                  ''),
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data.patient?.user?.name
                                      .toString() ??
                                      '',
                                  style: AllListText()
                                      .headingText(),
                                ),
                                SizedBox(height: 0.5.h),
                                Text(
                                  "${data.patient?.user?.age.toString()} ${data.patient?.user?.gender.toString()}",
                                  style: AllListText()
                                      .subHeadingText(),
                                ),
                                Text(
                                  buildTimeDate(
                                      data.appointments?[0].date
                                          .toString() ??
                                          '',
                                      data.appointments?[0]
                                          .slotStartTime
                                          .toString() ??
                                          ''),
                                  style:
                                  AllListText().otherText(),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Status : ",
                                      style: AllListText()
                                          .otherText(),
                                    ),
                                    Text(
                                      buildStatusText(
                                        data.patient?.status ??
                                            '',
                                        data.patient?.user
                                            ?.medicalFeedback ??
                                            '',
                                      ),
                                      style: AllListText()
                                          .subHeadingText(),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          CallChatIcons(
                            userId: "${data.patient?.user?.id.toString()}",
                            kaleyraUserId: "${data.patient?.user?.kaleyraUserId.toString()}",
                            name:data.patient?.user?.name,
                            email:data.patient?.user?.email,
                          ),
                          // GestureDetector(
                          //   onTap: () {
                          //     // Navigator.of(context).push(
                          //     //   MaterialPageRoute(
                          //     //     builder: (ct) =>
                          //     //         const PostCustomerDetails(),
                          //     //   ),
                          //     // );
                          //   },
                          //   child: SvgPicture.asset(
                          //       "assets/images/noun-view-1041859.svg"),
                          // ),
                          // PopupMenuButton(
                          //   offset: const Offset(0, 30),
                          //   shape: RoundedRectangleBorder(
                          //       borderRadius: BorderRadius.circular(5)),
                          //   itemBuilder: (context) => [
                          //     PopupMenuItem(
                          //       child: Column(
                          //         crossAxisAlignment:
                          //         CrossAxisAlignment.start,
                          //         children: [
                          //           SizedBox(height: 1.h),
                          //           GestureDetector(
                          //             onTap: () {
                          //               Navigator.of(context).push(
                          //                 MaterialPageRoute(
                          //                   builder: (ct) =>
                          //                   const PostCustomerDetails(),
                          //                 ),
                          //               );
                          //             },
                          //             child: Row(
                          //               mainAxisAlignment:
                          //               MainAxisAlignment
                          //                   .spaceBetween,
                          //               children: [
                          //                 Text(
                          //                   "View",
                          //                   style: TextStyle(
                          //                       fontFamily: "GothamBook",
                          //                       color: gTextColor,
                          //                       fontSize: 8.sp),
                          //                 ),
                          //                 SizedBox(width: 10.w),
                          //                 SvgPicture.asset(
                          //                     "assets/images/noun-view-1041859.svg")
                          //               ],
                          //             ),
                          //           ),
                          //           Container(
                          //             margin: EdgeInsets.symmetric(
                          //                 vertical: 1.h),
                          //             height: 1,
                          //             color: gGreyColor.withOpacity(0.3),
                          //           ),
                          //           GestureDetector(
                          //             onTap: () {
                          //               Navigator.of(context).push(
                          //                 MaterialPageRoute(
                          //                   builder: (ct) =>
                          //                   const PostProgramProgress(),
                          //                 ),
                          //               );
                          //             },
                          //             child: Row(
                          //               mainAxisAlignment:
                          //               MainAxisAlignment
                          //                   .spaceBetween,
                          //               children: [
                          //                 Text(
                          //                   "Progress",
                          //                   style: TextStyle(
                          //                       fontFamily: "GothamBook",
                          //                       color: gTextColor,
                          //                       fontSize: 8.sp),
                          //                 ),
                          //                 SizedBox(width: 10.w),
                          //                 Image(
                          //                   image: const AssetImage(
                          //                       "assets/images/Group 4895.png"),
                          //                   height: 2.h,
                          //                 ),
                          //               ],
                          //             ),
                          //           ),
                          //           Container(
                          //             margin: EdgeInsets.symmetric(
                          //                 vertical: 1.h),
                          //             height: 1,
                          //             color: gGreyColor.withOpacity(0.3),
                          //           ),
                          //           GestureDetector(
                          //             onTap: () {
                          //               Navigator.of(context).push(
                          //                 MaterialPageRoute(
                          //                   builder: (ct) =>
                          //                       MessageScreen(
                          //                         userName: '',
                          //                         profileImage: '',
                          //                       ),
                          //                 ),
                          //               );
                          //             },
                          //             child: Row(
                          //               mainAxisAlignment:
                          //               MainAxisAlignment
                          //                   .spaceBetween,
                          //               children: [
                          //                 Text(
                          //                   "Message",
                          //                   style: TextStyle(
                          //                       fontFamily: "GothamBook",
                          //                       color: gTextColor,
                          //                       fontSize: 8.sp),
                          //                 ),
                          //                 SizedBox(width: 10.w),
                          //                 Image(
                          //                   image: const AssetImage(
                          //                       "assets/images/Group 4891.png"),
                          //                   height: 2.h,
                          //                 ),
                          //               ],
                          //             ),
                          //           ),
                          //           SizedBox(height: 0.5.h),
                          //         ],
                          //       ),
                          //     ),
                          //   ],
                          //   child: Icon(
                          //     Icons.more_vert,
                          //     color: gGreyColor.withOpacity(0.5),
                          //   ),
                          // ),
                        ],
                      ),
                      Container(
                        height: 1,
                        margin: EdgeInsets.symmetric(
                            vertical: 1.5.h),
                        color: Colors.grey.withOpacity(0.3),
                      ),
                    ],
                  ),
                );
              }),
            )
                : buildSearchList(),
          ),
        ),
      ],
    );
  }

  Icon searchIcon = Icon(
    Icons.search,
    color: gBlackColor,
    size: 2.5.h,
  );
  Widget searchBarTitle = const Text('');

  Widget buildSearchWidget() {
    return StatefulBuilder(builder: (_, setstate) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.white,
          border:
          Border.all(color: lightTextColor.withOpacity(0.3), width: 1.0),
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
    });
  }

  onSearchTextChanged(String text) async {
    searchResults.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }
    maintenanceGuideModel?.gutMaintenanceGuide?.forEach((userDetail) {
      if (userDetail.patient!.user!.name!
          .toLowerCase()
          .contains(text.toLowerCase())) {
        searchResults.add(userDetail);
      }
    });
    print("searchResults : $searchResults");
    setState(() {});
  }

  buildSearchList() {
    return ListView.builder(
      controller: _scrollController,
      scrollDirection: Axis.vertical,
      padding: EdgeInsets.symmetric(horizontal: 1.w),
      physics: const ScrollPhysics(),
      shrinkWrap: true,
      itemCount: searchResults.length,
      itemBuilder: ((context, index) {
        var data = searchResults[index];
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ct) => NutriDelightScreen(
                  userId: int.parse("${data.patient?.user?.id}"),
                  tabIndex: 1,
                  userName: data.patient?.user?.name ?? '',updateTime: '', updateDate: '',
                  age:
                  "${data.patient?.user?.age.toString()} ${data.patient?.user?.gender.toString()}",
                  appointmentDetails: buildTimeDate(
                    data.appointments?[0].date ?? '',
                    data.appointments?[0].slotStartTime.toString() ?? '',
                  ),
                  status: buildStatusText(
                    data.patient?.status.toString() ?? '',
                    data.patient?.user?.medicalFeedback.toString() ?? '',
                  ),
                  finalDiagnosis: '',
                  preparatoryCurrentDay: '',
                  transitionCurrentDay: '',
                  isPrepCompleted: '',
                  isProgramStatus: '',
                  programDayStatus: '',
                ),
                // PostCustomerDetails(
                // userId: data[index].patient.user.id),
              ),
            );
            // Navigator.of(context).push(
            //   MaterialPageRoute(
            //     builder: (context) => CalendarCustomerScreen(
            //       userId: data[index].patient.user.id,
            //       tabIndex: 0,
            //     ),
            //   ),
            // );
          },
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ShowProfile(
                            userId: int.parse("${data.patient?.user?.id}"),
                          ),
                        ),
                      );
                    },
                    child: CircleAvatar(
                      radius: 3.h,
                      backgroundImage: NetworkImage(
                          data.patient?.user?.profile.toString() ?? ''),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.patient?.user?.name.toString() ?? '',
                          style: AllListText().headingText(),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          "${data.patient?.user?.age.toString()} ${data.patient?.user?.gender.toString()}",
                          style: AllListText().subHeadingText(),
                        ),
                        Text(
                          buildTimeDate(
                            data.appointments?[0].date.toString() ?? '',
                            data.appointments?[0].slotStartTime.toString() ??
                                '',
                          ),
                          style: AllListText().otherText(),
                        ),
                        Row(
                          children: [
                            Text(
                              "Status : ",
                              style: AllListText().otherText(),
                            ),
                            Text(
                              buildStatusText(
                                data.patient?.status.toString() ?? '',
                                data.patient?.user?.medicalFeedback
                                    .toString() ??
                                    '',
                              ),
                              style: AllListText().subHeadingText(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  CallChatIcons(
                    userId: "${data.patient?.user?.id}",
                    kaleyraUserId:
                    data.patient?.user?.kaleyraUserId.toString() ?? '',
                    name:data.patient?.user?.name,
                    email:data.patient?.user?.email,
                  ),
                  // GestureDetector(
                  //   onTap: () {
                  //     // Navigator.of(context).push(
                  //     //   MaterialPageRoute(
                  //     //     builder: (ct) => const PostCustomerDetails(),
                  //     //   ),
                  //     // );
                  //   },
                  //   child: SvgPicture.asset(
                  //       "assets/images/noun-view-1041859.svg"),
                  // ),
                ],
              ),
              Container(
                height: 1,
                margin: EdgeInsets.symmetric(vertical: 1.5.h),
                color: Colors.grey.withOpacity(0.3),
              ),
            ],
          ),
        );
      }),
    );
  }

  final CustomerStatusRepo repository = CustomerStatusRepo(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );

  buildTimeDate(String date, String time) {
    var split = time.split(':');
    String hour = split[0];
    String minute = split[1];
    DateTime timing = DateTime.parse("$date $time");
    String amPm = 'AM';
    if (timing.hour >= 12) {
      amPm = 'PM';
    }
    return "${DateFormat('dd MMMM yyyy').format(DateTime.parse("$date $time"))} / $hour : $minute $amPm";
  }

  String buildStatusText(String status, String medicalFeedback) {
    print("status : $status");
    if (status == "post_program") {
      return "Post Consultation Pending";
    } else if (status == "post_appointment_booked") {
      return "Post Appointment Booked";
    } else if (status == "post_appointment_done") {
      return "GMG & End Report Pending";
    } else if (status == "protocol_guide") {
      return "Protocol Guide";
    } else if (status == "meal_plan_completed") {
      return "Meal Plan Completed";
    } else if (status == "shipping_paused") {
      return "Shipment Paused";
    } else if (status == "shipping_packed") {
      return "Shipment Packed";
    } else if (status == "shipping_approved") {
      return "Shipment Approved";
    } else if (status == "shipping_delivered") {
      return "Shipment Delivered";
    } else if (status == "prep_meal_plan_completed") {
      return "Meal Plan Pending";
    }else if (status == "gmg_submitted") {
      return "Completed";
    }
    return statusText;
  }
}
