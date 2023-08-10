import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../model/error_model.dart';
import '../../../model/meal_active_model.dart';
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

class ActiveList extends StatefulWidget {
  const ActiveList({Key? key}) : super(key: key);

  @override
  State<ActiveList> createState() => _ActiveListState();
}

class _ActiveListState extends State<ActiveList> {
  String statusText = "";
  String programStatus = "";
  String programDayStatus = "";

  final searchController = TextEditingController();

  bool showProgress = false;
  MealActiveModel? mealActiveModel;
  List<UserDetails> searchResults = [];
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
    final result = await customerStatusService.getMealActiveService();
    print("result: $result");

    if (result.runtimeType == MealActiveModel) {
      print("Ticket List");
      MealActiveModel model = result as MealActiveModel;

      mealActiveModel = model;
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

    List<UserDetails> activeList = mealActiveModel?.activeDetails ?? [];

    return (showProgress)
        ? Center(
      child: buildCircularIndicator(),
    )
        : activeList.isEmpty
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
              itemCount: activeList.length,
              itemBuilder: ((context, index) {
                var data = activeList[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => NutriDelightScreen(
                          tabIndex: 1,
                          userName:
                          data.patient?.user?.name ?? '',updateTime: '', updateDate: '',
                          age:
                          "${data.patient?.user?.age ?? ""} ${data.patient?.user?.gender ?? ""}",
                          appointmentDetails: buildTimeDate(
                              data.appointments?[0].date ?? '',
                              data.appointments?[0].slotStartTime ?? "",),
                          status:
                          buildStatusText(data.patient?.status ?? ""),
                          finalDiagnosis: '',
                          preparatoryCurrentDay: "",
                          transitionCurrentDay: "",
                          isPrepCompleted: data.patient?.user?.userProgram?.isPreparatoryCompleted.toString() ?? '',
                          isProgramStatus: getProgramStatus(
                            data.patient?.user?.userProgram?.preparatoryProgram.toString() ?? '',
                            data.patient?.user?.userProgram?.detoxProgram.toString() ?? '',
                            data.patient?.user?.userProgram?.healingProgram.toString() ?? '',
                            data.patient?.user?.userProgram?.nourishProgram.toString() ?? '',
                            data.patient?.user?.userProgram?.isNourishCompleted.toString() ?? '',
                          ),
                          programDayStatus: getProgramDayStatus(
                            getProgramStatus(
                              data.patient?.user?.userProgram?.preparatoryProgram.toString() ?? '',
                              data.patient?.user?.userProgram?.detoxProgram.toString() ?? '',
                              data.patient?.user?.userProgram?.healingProgram.toString() ?? '',
                              data.patient?.user?.userProgram?.nourishProgram.toString() ?? '',
                              data.patient?.user?.userProgram?.isNourishCompleted.toString() ?? '',
                            ),
                            data.patient?.user?.userProgram?.preparatoryTotalDays.toString() ?? '',
                            data.patient?.user?.userProgram?.preparatoryPresentDay.toString() ?? '',
                            data.patient?.user?.userProgram?.detoxTotalDays.toString() ?? '',
                            data.patient?.user?.userProgram?.detoxPresentDay.toString() ?? '',
                            data.patient?.user?.userProgram?.healingTotalDays.toString() ?? '',
                            data.patient?.user?.userProgram?.healingPresentDay.toString() ?? '',
                            data.patient?.user?.userProgram?.nourishTotalDays.toString() ?? '',
                            data.patient?.user?.userProgram?.nourishPresentDay.toString() ?? '',
                          ),
                          userId: int.parse("${data.patient?.user?.id}"),
                          userProgram: data.patient?.user?.userProgram,
                        ),
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
                                  builder: (context) => ShowProfile(
                                      userId: int.parse("${data.patient?.user?.id}"),
                                ),
                              ),);
                            },
                            child: CircleAvatar(
                              radius: 3.h,
                              backgroundImage: NetworkImage(
                                  data.patient?.user?.profile ?? ''),
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data.patient?.user?.name ??
                                      "",
                                  style:
                                  AllListText().headingText(),
                                ),
                                Text(
                                  buildTimeDate(
                                      data.appointments?[0].date ?? '',
                                      data.appointments?[0].slotStartTime ?? "",),
                                  style: AllListText().otherText(),
                                ),
                                Row(crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Status : ",
                                      style:
                                      AllListText().otherText(),
                                    ),
                                    Column(crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          getProgramStatus(
                                            data.patient?.user?.userProgram?.preparatoryProgram.toString() ?? '',
                                            data.patient?.user?.userProgram?.detoxProgram.toString() ?? '',
                                            data.patient?.user?.userProgram?.healingProgram.toString() ?? '',
                                            data.patient?.user?.userProgram?.nourishProgram.toString() ?? '',
                                            data.patient?.user?.userProgram?.isNourishCompleted.toString() ?? '',
                                          ),
                                          style: AllListText()
                                              .getProgramStatus(),
                                        ),
                                        Text(
                                          getProgramDayStatus(
                                            getProgramStatus(
                                              data.patient?.user?.userProgram?.preparatoryProgram.toString() ?? '',
                                              data.patient?.user?.userProgram?.detoxProgram.toString() ?? '',
                                              data.patient?.user?.userProgram?.healingProgram.toString() ?? '',
                                              data.patient?.user?.userProgram?.nourishProgram.toString() ?? '',
                                              data.patient?.user?.userProgram?.isNourishCompleted.toString() ?? '',
                                            ),
                                            data.patient?.user?.userProgram?.preparatoryTotalDays.toString() ?? '',
                                            data.patient?.user?.userProgram?.preparatoryPresentDay.toString() ?? '',
                                            data.patient?.user?.userProgram?.detoxTotalDays.toString() ?? '',
                                            data.patient?.user?.userProgram?.detoxPresentDay.toString() ?? '',
                                            data.patient?.user?.userProgram?.healingTotalDays.toString() ?? '',
                                            data.patient?.user?.userProgram?.healingPresentDay.toString() ?? '',
                                            data.patient?.user?.userProgram?.nourishTotalDays.toString() ?? '',
                                            data.patient?.user?.userProgram?.nourishPresentDay.toString() ?? '',
                                          ),
                                          style: AllListText()
                                              .getProgramStatus(),
                                        ),
                                      ],),
                                    // Text(
                                    //   buildStatusText(data.patient?.status ?? ''),
                                    //   style: AllListText()
                                    //       .subHeadingText(),
                                    // ),
                                    buildActiveIconWidget(
                                      data
                                         .patient
                                          ?.user
                                          ?.userProgram
                                          ?.isPreparatoryCompleted
                                          .toString() ??
                                          '',
                                      data
                                          .patient
                                          ?.user
                                          ?.userProgram
                                          ?.detoxProgram
                                          .toString() ??
                                          '',
                                      data
                                         .patient
                                          ?.user
                                          ?.userProgram
                                          ?.isDetoxCompleted
                                          .toString() ??
                                          '',
                                      data
                                         .patient
                                          ?.user
                                          ?.userProgram
                                          ?.healingProgram
                                          .toString() ??
                                          '',
                                      data
                                          .patient
                                          ?.user
                                          ?.userProgram
                                          ?.isHealingCompleted
                                          .toString() ??
                                          '',
                                      data
                                          .patient
                                          ?.user
                                          ?.userProgram
                                          ?.nourishProgram
                                          .toString() ??
                                          '',
                                    )
                                  ],
                                ),
                                // Row(
                                //   children: [
                                //     Text(
                                //       "Start Date : ",
                                //       style:
                                //           AllListText().otherText(),
                                //     ),
                                //     Text(
                                //       data[index]
                                //           .userProgramStartDate
                                //           .toString(),
                                //       style: AllListText()
                                //           .subHeadingText(),
                                //     ),
                                //   ],
                                // ),
                                // SizedBox(height: 0.5.h),
                                // Row(
                                //   children: [
                                //     Text(
                                //       "Present Day : ",
                                //       style: TextStyle(
                                //           fontFamily: "GothamBook",
                                //           color: gBlackColor,
                                //           fontSize: 8.sp),
                                //     ),
                                //     Text(
                                //       data[index]
                                //           .userPresentDay
                                //           .toString(),
                                //       style: TextStyle(
                                //           fontFamily: "GothamMedium",
                                //           color: gPrimaryColor,
                                //           fontSize: 8.sp),
                                //     ),
                                //   ],
                                // ),

                                // Row(
                                //   children: [
                                //     Text(
                                //       "Final Diagnosis : ",
                                //       style:
                                //           AllListText().otherText(),
                                //     ),
                                //     Expanded(
                                //       child: Text(
                                //         data[index]
                                //             .userFinalDiagnosis
                                //             .toString(),
                                //         maxLines: 1,
                                //         overflow:
                                //             TextOverflow.ellipsis,
                                //         style: AllListText()
                                //             .subHeadingText(),
                                //       ),
                                //     ),
                                //   ],
                                // ),

                              ],
                            ),
                          ),
                          CallChatIcons(
                            userId: data.patient?.user?.id.toString() ?? '',
                            kaleyraUserId: data.patient?.user?.kaleyraUserId.toString() ?? '',
                            name:data.patient?.user?.name,
                            email:data.patient?.user?.email,
                          ),
                        ],
                      ),
                      Container(
                        height: 1,
                        margin:
                        EdgeInsets.symmetric(vertical: 1.5.h),
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
    mealActiveModel?.activeDetails?.forEach((userDetail) {
      if (userDetail.patient!.user!.name!.toLowerCase().contains(text.toLowerCase())) {
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
                builder: (context) => NutriDelightScreen(
                  tabIndex: 1,
                  userName:
                  data.patient?.user?.name ?? '',updateTime: '', updateDate: '',
                  age:
                  "${data.patient?.user?.age ?? ""} ${data.patient?.user?.gender ?? ""}",
                  appointmentDetails: buildTimeDate(
                    data.appointments?[0].date ?? '',
                    data.appointments?[0].slotStartTime ?? "",),
                  status:
                  buildStatusText(data.patient?.status ?? ""),
                  finalDiagnosis: '',
                  preparatoryCurrentDay: "",
                  transitionCurrentDay: "",
                  isPrepCompleted: data.patient?.user?.userProgram?.isPreparatoryCompleted.toString() ?? '',
                  isProgramStatus: getProgramStatus(
                    data.patient?.user?.userProgram?.preparatoryProgram.toString() ?? '',
                    data.patient?.user?.userProgram?.detoxProgram.toString() ?? '',
                    data.patient?.user?.userProgram?.healingProgram.toString() ?? '',
                    data.patient?.user?.userProgram?.nourishProgram.toString() ?? '',
                    data.patient?.user?.userProgram?.isNourishCompleted.toString() ?? '',
                  ),
                  programDayStatus: getProgramDayStatus(
                    getProgramStatus(
                      data.patient?.user?.userProgram?.preparatoryProgram.toString() ?? '',
                      data.patient?.user?.userProgram?.detoxProgram.toString() ?? '',
                      data.patient?.user?.userProgram?.healingProgram.toString() ?? '',
                      data.patient?.user?.userProgram?.nourishProgram.toString() ?? '',
                      data.patient?.user?.userProgram?.isNourishCompleted.toString() ?? '',
                    ),
                    data.patient?.user?.userProgram?.preparatoryTotalDays.toString() ?? '',
                    data.patient?.user?.userProgram?.preparatoryPresentDay.toString() ?? '',
                    data.patient?.user?.userProgram?.detoxTotalDays.toString() ?? '',
                    data.patient?.user?.userProgram?.detoxPresentDay.toString() ?? '',
                    data.patient?.user?.userProgram?.healingTotalDays.toString() ?? '',
                    data.patient?.user?.userProgram?.healingPresentDay.toString() ?? '',
                    data.patient?.user?.userProgram?.nourishTotalDays.toString() ?? '',
                    data.patient?.user?.userProgram?.nourishPresentDay.toString() ?? '',
                  ),
                  userId: int.parse("${data.patient?.user?.id}"),
                  userProgram: data.patient?.user?.userProgram,
                ),
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
                          builder: (context) => ShowProfile(
                            userId: int.parse("${data.patient?.user?.id}"),
                          ),
                        ),);
                    },
                    child: CircleAvatar(
                      radius: 3.h,
                      backgroundImage: NetworkImage(
                          data.patient?.user?.profile ?? ''),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.patient?.user?.name ??
                              "",
                          style:
                          AllListText().headingText(),
                        ),
                        Text(
                          buildTimeDate(
                            data.appointments?[0].date ?? '',
                            data.appointments?[0].slotStartTime ?? "",),
                          style: AllListText().otherText(),
                        ),
                        Row(
                          children: [
                            Text(
                              "Status : ",
                              style:
                              AllListText().otherText(),
                            ),
                            Text(
                              buildStatusText(data.patient?.status ?? ''),
                              style: AllListText()
                                  .subHeadingText(),
                            ),
                            buildActiveIconWidget(
                              data
                                  .patient
                                  ?.user
                                  ?.userProgram
                                  ?.isPreparatoryCompleted
                                  .toString() ??
                                  '',
                              data
                                  .patient
                                  ?.user
                                  ?.userProgram
                                  ?.detoxProgram
                                  .toString() ??
                                  '',
                              data
                                  .patient
                                  ?.user
                                  ?.userProgram
                                  ?.isDetoxCompleted
                                  .toString() ??
                                  '',
                              data
                                  .patient
                                  ?.user
                                  ?.userProgram
                                  ?.healingProgram
                                  .toString() ??
                                  '',
                              data
                                  .patient
                                  ?.user
                                  ?.userProgram
                                  ?.isHealingCompleted
                                  .toString() ??
                                  '',
                              data
                                  .patient
                                  ?.user
                                  ?.userProgram
                                  ?.nourishProgram
                                  .toString() ??
                                  '',
                            )
                          ],
                        ),
                        // Row(
                        //   children: [
                        //     Text(
                        //       "Start Date : ",
                        //       style:
                        //           AllListText().otherText(),
                        //     ),
                        //     Text(
                        //       data[index]
                        //           .userProgramStartDate
                        //           .toString(),
                        //       style: AllListText()
                        //           .subHeadingText(),
                        //     ),
                        //   ],
                        // ),
                        // SizedBox(height: 0.5.h),
                        // Row(
                        //   children: [
                        //     Text(
                        //       "Present Day : ",
                        //       style: TextStyle(
                        //           fontFamily: "GothamBook",
                        //           color: gBlackColor,
                        //           fontSize: 8.sp),
                        //     ),
                        //     Text(
                        //       data[index]
                        //           .userPresentDay
                        //           .toString(),
                        //       style: TextStyle(
                        //           fontFamily: "GothamMedium",
                        //           color: gPrimaryColor,
                        //           fontSize: 8.sp),
                        //     ),
                        //   ],
                        // ),

                        // Row(
                        //   children: [
                        //     Text(
                        //       "Final Diagnosis : ",
                        //       style:
                        //           AllListText().otherText(),
                        //     ),
                        //     Expanded(
                        //       child: Text(
                        //         data[index]
                        //             .userFinalDiagnosis
                        //             .toString(),
                        //         maxLines: 1,
                        //         overflow:
                        //             TextOverflow.ellipsis,
                        //         style: AllListText()
                        //             .subHeadingText(),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        Text(
                          getProgramStatus(
                            data.patient?.user?.userProgram?.preparatoryProgram.toString() ?? '',
                            data.patient?.user?.userProgram?.detoxProgram.toString() ?? '',
                            data.patient?.user?.userProgram?.healingProgram.toString() ?? '',
                            data.patient?.user?.userProgram?.nourishProgram.toString() ?? '',
                            data.patient?.user?.userProgram?.isNourishCompleted.toString() ?? '',
                          ),
                          style: AllListText()
                              .getProgramStatus(),
                        ),
                        Text(
                          getProgramDayStatus(
                            getProgramStatus(
                              data.patient?.user?.userProgram?.preparatoryProgram.toString() ?? '',
                              data.patient?.user?.userProgram?.detoxProgram.toString() ?? '',
                              data.patient?.user?.userProgram?.healingProgram.toString() ?? '',
                              data.patient?.user?.userProgram?.nourishProgram.toString() ?? '',
                              data.patient?.user?.userProgram?.isNourishCompleted.toString() ?? '',
                            ),
                            data.patient?.user?.userProgram?.preparatoryTotalDays.toString() ?? '',
                            data.patient?.user?.userProgram?.preparatoryPresentDay.toString() ?? '',
                            data.patient?.user?.userProgram?.detoxTotalDays.toString() ?? '',
                            data.patient?.user?.userProgram?.detoxPresentDay.toString() ?? '',
                            data.patient?.user?.userProgram?.healingTotalDays.toString() ?? '',
                            data.patient?.user?.userProgram?.healingPresentDay.toString() ?? '',
                            data.patient?.user?.userProgram?.nourishTotalDays.toString() ?? '',
                            data.patient?.user?.userProgram?.nourishPresentDay.toString() ?? '',
                          ),
                          style: AllListText()
                              .getProgramStatus(),
                        ),
                      ],
                    ),
                  ),
                  CallChatIcons(
                    userId: data.patient?.user?.id.toString() ?? '',
                    kaleyraUserId: data.patient?.user?.kaleyraUserId.toString() ?? '',
                    name:data.patient?.user?.name,
                    email:data.patient?.user?.email,
                  ),
                ],
              ),
              Container(
                height: 1,
                margin:
                EdgeInsets.symmetric(vertical: 1.5.h),
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

  buildPreparatoryStatus(String isPrepCompleted) {
    return (isPrepCompleted == "1")
        // && (isPrepCompleted != "null")
        ? Text(
            "Preparatory Plan Completed by user",
            style: TextStyle(
                height: 1.3,
                fontFamily: fontMedium,
                color: gSecondaryColor,
                fontSize: fontSize08),
          )
        : Text(
            "Preparatory Program Running",
            style: TextStyle(
                height: 1.3,
                fontFamily: fontMedium,
                color: gPrimaryColor,
                fontSize: fontSize08),
          );
  }

  String buildStatusText(String status) {
    if (status == "start_program") {
      return "Started Program";
    } else if (status == "shipping_delivered") {
      return "Shipment Delivered";
    } else if (status == "prep") {
      return "Preparatory";
    } else if (status == "detox") {
      return "Detox";
    } else if (status == "healing") {
      return "Healing";
    } else if (status == "nourish") {
      return "Nourish";
    }
    return statusText;
  }

  String getProgramStatus(String prepProgram, String detoxProgram,
      String healingProgram, String nourishProgram, String nourishCompleted) {
    print("programStatus Prep : $prepProgram == 1");
    print("programStatus Detox : $detoxProgram == 1");
    print("programStatus Healing : $healingProgram == 1");
    print("programStatus Nourish : $nourishProgram == 1");

    if (nourishCompleted == "1" &&
        nourishProgram == "1" &&
        detoxProgram == "1" &&
        prepProgram == "1" &&
        healingProgram == "1") {
      return "Program Completed";
    } else if (nourishProgram == "1" &&
        detoxProgram == "1" &&
        prepProgram == "1" &&
        healingProgram == "1") {
      return "Nourish Program Running";
    } else if (detoxProgram == "1" &&
        prepProgram == "1" &&
        healingProgram == "1") {
      return "Healing Program Running";
    } else if (prepProgram == "1" && detoxProgram == "1") {
      return "Detox Program Running";
    } else if (prepProgram == "1") {
      return "Preparatory Program Running";
    }
    print("programStatus : $programStatus");
    return programStatus;
  }

  String getProgramDayStatus(
    String programStatus,
    String prepTotalDays,
    String prepCurrentDay,
    String detoxTotalDays,
    String detoxCurrentDay,
    String healingTotalDays,
    String healingCurrentDay,
    String nourishTotalDays,
    String nourishCurrentDay,
  ) {
    if (programStatus == "Preparatory Program Running") {
      return "Preparatory days : $prepCurrentDay/$prepTotalDays";
    } else if (programStatus == "Detox Program Running") {
      return "Detox days : $detoxCurrentDay/$detoxTotalDays";
    } else if (programStatus == "Healing Program Running") {
      return "Healing days : $healingCurrentDay/$healingTotalDays";
    } else if (programStatus == "Nourish Program Running") {
      return "Nourish days : $nourishCurrentDay/$nourishTotalDays";
    }
    return programDayStatus;
  }

}
