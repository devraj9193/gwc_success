import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
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

class MealPlanListScreen extends StatefulWidget {
  const MealPlanListScreen({Key? key}) : super(key: key);

  @override
  State<MealPlanListScreen> createState() => _MealPlanListScreenState();
}

class _MealPlanListScreenState extends State<MealPlanListScreen> {
  String statusText = "";

  final searchController = TextEditingController();

  bool showProgress = false;
  MealActiveModel? mealActiveModel;
  List<UserDetails> searchResults = [];
  final ScrollController _scrollController = ScrollController();

  TabController? tabController;

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
    List<UserDetails> mealList = mealActiveModel?.mealPlanList ?? [];

    return (showProgress)
        ? Center(
            child: buildCircularIndicator(),
          )
        : mealList.isEmpty
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
                              itemCount: mealList.length,
                              itemBuilder: ((context, index) {
                                var data = mealList[index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            NutriDelightScreen(
                                          tabIndex: 2,
                                          userId: int.parse(
                                              "${data.patient?.user?.id}"),
                                          userName:
                                              data.patient?.user?.name ?? '',
                                          updateTime:
                                              data.updateTime.toString() ?? '',
                                          updateDate:
                                              data.updateDate.toString() ?? '',
                                          age:
                                              "${data.patient?.user?.age ?? ""} ${data.patient?.user?.gender ?? ""}",
                                          appointmentDetails: buildTimeDate(
                                              data.appointments?[0].date ?? '',
                                              data.appointments?[0]
                                                      .slotStartTime ??
                                                  ''),
                                          status: buildStatusText(
                                              data.patient?.status ?? ''),
                                          iconStatus:
                                              data.patient?.status ?? '',
                                          finalDiagnosis: '',
                                          preparatoryCurrentDay: "",
                                          transitionCurrentDay: "",
                                          isPrepCompleted: data
                                                  .patient
                                                  ?.user
                                                  ?.userProgram
                                                  ?.isPreparatoryCompleted
                                                  .toString() ??
                                              '',
                                          isProgramStatus: '',
                                          programDayStatus: '',
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
                                                      userId: int.parse(
                                                          "${data.patient?.user?.id}")),
                                                ),
                                              );
                                            },
                                            child: CircleAvatar(
                                              radius: 3.h,
                                              backgroundImage: NetworkImage(
                                                  data.patient?.user?.profile ??
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
                                                  data.patient?.user?.name ??
                                                      '',
                                                  style: AllListText()
                                                      .headingText(),
                                                ),
                                                Text(
                                                  "${data.patient?.user?.age.toString()} ${data.patient?.user?.gender.toString()}",
                                                  style: AllListText()
                                                      .subHeadingText(),
                                                ),
                                                Text(
                                                  buildTimeDate(
                                                      data.appointments?[0]
                                                              .date ??
                                                          '',
                                                      data.appointments?[0]
                                                              .slotStartTime ??
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
                                                      buildStatusText(data
                                                              .patient
                                                              ?.status ??
                                                          ''),
                                                      style: AllListText()
                                                          .subHeadingText(),
                                                    ),
                                                    SizedBox(width: 1.w),
                                                    buildIconWidget(data
                                                            .patient?.status
                                                            .toString() ??
                                                        ''),
                                                  ],
                                                ),
                                                buildUpdatedTime(
                                                    data.patient?.status
                                                            .toString() ??
                                                        '',
                                                    data.updateDate
                                                            .toString() ??
                                                        '',
                                                    data.updateTime
                                                            .toString() ??
                                                        ''),
                                                // Row(
                                                //   children: [
                                                //     Text(
                                                //       "Final Diagnosis : ",
                                                //       style: AllListText().otherText(),
                                                //     ),
                                                //     Expanded(
                                                //       child: Text(
                                                //         data[index]
                                                //             .userFinalDiagnosis
                                                //             .toString(),
                                                //         maxLines: 1,
                                                //         overflow: TextOverflow.ellipsis,
                                                //         style: AllListText()
                                                //             .subHeadingText(),
                                                //       ),
                                                //     ),
                                                //   ],
                                                // ),
                                                // buildPreparatoryStatus(data[index]
                                                //
                                                //     .patient
                                                //     .user
                                                //     .userProgram
                                                //     .isPrepCompleted),
                                              ],
                                            ),
                                          ),
                                          CallChatIcons(
                                            userId: data.patient?.user?.id
                                                    .toString() ??
                                                '',
                                            kaleyraUserId: data.patient?.user
                                                    ?.kaleyraUserId
                                                    .toString() ??
                                                '',
                                            name: data.patient?.user?.name,
                                            email: data.patient?.user?.email,
                                          ),
                                          // trailIcons(callOnTap: () {
                                          //   dialog(context);
                                          //   saveUserId(
                                          //       data[index]
                                          //           .userDetails
                                          //           .patient
                                          //           .user
                                          //           .id
                                          //           .toString(),
                                          //       data[index]
                                          //           .userDetails
                                          //           .id
                                          //           .toString(),
                                          //       data[index]
                                          //           .userDetails
                                          //           .patient
                                          //           .user
                                          //           .id
                                          //           .toString());
                                          // }, chatOnTap: () {
                                          //   saveUserId(
                                          //       data[index]
                                          //           .userDetails
                                          //           .patient
                                          //           .user
                                          //           .id
                                          //           .toString(),
                                          //       data[index]
                                          //           .userDetails
                                          //           .id
                                          //           .toString(),
                                          //       data[index]
                                          //           .userDetails
                                          //           .patient
                                          //           .user
                                          //           .id
                                          //           .toString());
                                          //   final qbService =
                                          //       Provider.of<QuickBloxService>(
                                          //           context,
                                          //           listen: false);
                                          //   qbService.openKaleyraChat(
                                          //       kaleyraUserId,
                                          //       data[index]
                                          //           .kaleyraUserId
                                          //           .toString(),
                                          //       kaleyraAccessToken);
                                          //   // getChatGroupId(
                                          //   //   data[index].userDetails.patient.user.name ?? "",
                                          //   //   data[index].userDetails.patient.user.profile.toString(),
                                          //   //   data[index].userDetails.patient.user.id,
                                          //   // );
                                          // }),
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
    mealActiveModel?.mealPlanList?.forEach((userDetail) {
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
                builder: (context) => NutriDelightScreen(
                  tabIndex: 2,
                  userId: int.parse("${data.patient?.user?.id}"),
                  userName: data.patient?.user?.name ?? '',
                  updateTime: data.updateTime.toString() ?? '',
                  updateDate: data.updateDate.toString() ?? '',
                  age:
                      "${data.patient?.user?.age ?? ""} ${data.patient?.user?.gender ?? ""}",
                  appointmentDetails: buildTimeDate(
                      data.appointments?[0].date ?? '',
                      data.appointments?[0].slotStartTime ?? ''),
                  status: buildStatusText(data.status ?? ''),
                  finalDiagnosis: '',
                  preparatoryCurrentDay: "",
                  transitionCurrentDay: "",
                  isPrepCompleted: data
                          .patient?.user?.userProgram?.isPreparatoryCompleted
                          .toString() ??
                      '',
                  isProgramStatus: '',
                  programDayStatus: '',
                ),
              ),
            );
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
                              userId: int.parse("${data.patient?.user?.id}")),
                        ),
                      );
                    },
                    child: CircleAvatar(
                      radius: 3.h,
                      backgroundImage:
                          NetworkImage(data.patient?.user?.profile ?? ''),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.patient?.user?.name ?? '',
                          style: AllListText().headingText(),
                        ),
                        Text(
                          "${data.patient?.user?.age.toString()} ${data.patient?.user?.gender.toString()}",
                          style: AllListText().subHeadingText(),
                        ),
                        Text(
                          buildTimeDate(data.appointments?[0].date ?? '',
                              data.appointments?[0].slotStartTime ?? ''),
                          style: AllListText().otherText(),
                        ),
                        Row(crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Status : ",
                              style: AllListText().otherText(),
                            ),
                            Text(
                              buildStatusText(data.patient?.status ?? ''),
                              style: AllListText().subHeadingText(),
                            ),
                          ],
                        ),
                        // Row(
                        //   children: [
                        //     Text(
                        //       "Final Diagnosis : ",
                        //       style: AllListText().otherText(),
                        //     ),
                        //     Expanded(
                        //       child: Text(
                        //         data[index]
                        //             .userFinalDiagnosis
                        //             .toString(),
                        //         maxLines: 1,
                        //         overflow: TextOverflow.ellipsis,
                        //         style: AllListText()
                        //             .subHeadingText(),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        // buildPreparatoryStatus(data[index]
                        //
                        //     .patient
                        //     .user
                        //     .userProgram
                        //     .isPrepCompleted),
                      ],
                    ),
                  ),
                  CallChatIcons(
                    userId: data.patient?.user?.id.toString() ?? '',
                    kaleyraUserId:
                        data.patient?.user?.kaleyraUserId.toString() ?? '',
                    name: data.patient?.user?.name,
                    email: data.patient?.user?.email,
                  ),
                  // trailIcons(callOnTap: () {
                  //   dialog(context);
                  //   saveUserId(
                  //       data[index]
                  //           .userDetails
                  //           .patient
                  //           .user
                  //           .id
                  //           .toString(),
                  //       data[index]
                  //           .userDetails
                  //           .id
                  //           .toString(),
                  //       data[index]
                  //           .userDetails
                  //           .patient
                  //           .user
                  //           .id
                  //           .toString());
                  // }, chatOnTap: () {
                  //   saveUserId(
                  //       data[index]
                  //           .userDetails
                  //           .patient
                  //           .user
                  //           .id
                  //           .toString(),
                  //       data[index]
                  //           .userDetails
                  //           .id
                  //           .toString(),
                  //       data[index]
                  //           .userDetails
                  //           .patient
                  //           .user
                  //           .id
                  //           .toString());
                  //   final qbService =
                  //       Provider.of<QuickBloxService>(
                  //           context,
                  //           listen: false);
                  //   qbService.openKaleyraChat(
                  //       kaleyraUserId,
                  //       data[index]
                  //           .kaleyraUserId
                  //           .toString(),
                  //       kaleyraAccessToken);
                  //   // getChatGroupId(
                  //   //   data[index].userDetails.patient.user.name ?? "",
                  //   //   data[index].userDetails.patient.user.profile.toString(),
                  //   //   data[index].userDetails.patient.user.id,
                  //   // );
                  // }),
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

  String buildStatusText(String status) {
    if (status == "report_upload") {
      return "MR Upload";
    } else if (status == "check_user_reports") {
      return "Check User Reports";
    } else if (status == "meal_plan_completed") {
      return "Meal Plan Completed\n(Shipment Awaited)";
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
    }
    return statusText;
  }

// buildPreparatoryStatus(String isPrepCompleted) {
  //   return (isPrepCompleted == "1")
  //       // && (isPrepCompleted != "null")
  //       ? Text(
  //           "Preparatory Plan Completed by user",
  //           style: TextStyle(
  //               height: 1.3,
  //               fontFamily: fontMedium,
  //               color: gSecondaryColor,
  //               fontSize: fontSize08),
  //         )
  //       : Text(
  //     "Preparatory Program Running",
  //     style: TextStyle(
  //         height: 1.3,
  //         fontFamily: fontMedium,
  //         color: gPrimaryColor,
  //         fontSize: fontSize08),
  //   );
  // }
  //
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
  //   final qbService = Provider.of<QuickBloxService>(context, listen: false);
  //   print(await qbService.getSession());
  //   if (_pref.getInt(GwcApi.getQBSession) == null ||
  //       await qbService.getSession() == true ||
  //       _pref.getBool(GwcApi.isQBLogin) == null ||
  //       _pref.getBool(GwcApi.isQBLogin) == false) {
  //     qbService.login(chatUserName);
  //   } else {
  //     if (await qbService.isConnected() == false) {
  //       qbService.connect(_pref.getInt(GwcApi.qbCurrentUserId)!);
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
  //     Get.to(() =>MessageScreen(
  //       isGroupId: true,
  //       userName: userName,
  //       profileImage: profileImage,
  //     ),);
  //   } else {
  //     ErrorModel model = res as ErrorModel;
  //     showSnackbar(context, model.message.toString(), isError: true);
  //   }
  // }
}
