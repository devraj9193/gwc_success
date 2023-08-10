import 'package:flutter/material.dart';
import 'package:gwc_success_team/screens/dashboard/transition_meal_plan.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../model/customers_list_model.dart';
import '../../model/error_model.dart';
import '../../repository/customer_status_repo.dart/customer_status_repo.dart';
import '../../service/api_service.dart';
import '../../service/customer_status_service/customer_status_service.dart';
import '../../utils/constants.dart';
import '../../utils/gwc_api.dart';
import '../../utils/success_member_storage.dart';
import '../../widgets/common_screen_widgets.dart';
import '../common_ui/call_chat_icons.dart';
import '../common_ui/show_profile.dart';
import '../customer_status_screens/linked_customer_status.dart';
import '../dashboard/meal_plan_screen.dart';
import '../post_program_screens.dart/post_programs_screen.dart';
import '../dashboard/shipping_pending_screen.dart';
import '../dashboard/active_consultation_screen.dart';
import '../dashboard/notification_screen.dart';
import '../dashboard/consultation_pending_screen.dart';
import 'calender_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SharedPreferences _pref = GwcApi.preferences!;
  final searchController = TextEditingController();
  CustomersList? customersList;
  List<Datum> searchResults = [];
  String accessToken = "";

  late final CustomerStatusService customerStatusService =
      CustomerStatusService(customerStatusRepo: repository);

  @override
  void initState() {
    super.initState();
    accessToken = _pref.getString("token")!;
    getAllCustomerCount();
    searchController.addListener(() {
      setState(() {});
    });
  }

  getAllCustomerCount() async {
    final result = await customerStatusService.getAllCustomerService();
    print("result: $result");

    if (result.runtimeType == CustomersList) {
      print("Ticket List");
      CustomersList model = result as CustomersList;

      customersList = model;
    } else {
      ErrorModel model = result as ErrorModel;
      print("error: ${model.message}");
    }
    print(result);
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
            Padding(
              padding: EdgeInsets.only(left: 3.w),
              child: Text(
                "Hi, ${_pref.getString(SuccessMemberStorage.successMemberName) ?? ""}",
                style: DashBoardScreen().headingTextField(),
              ),
            ),
            SizedBox(height: 1.h),
            buildSearchWidget(),
            searchController.text.isEmpty
                ? const Expanded(child: CalenderScreen())
                : Expanded(child: buildSearchList()),
            searchController.text.isEmpty
                ? Center(
                    child: IntrinsicWidth(
                      child: GestureDetector(
                        onTap: () {
                          Get.to(
                            () => const LinkedCustomerStatus(),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 1.h, horizontal: 3.w),
                          margin: EdgeInsets.only(bottom: 0.h, left: 3.w),
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
                                image: const AssetImage(
                                    "assets/images/Group 3011.png"),
                                color: whiteTextColor,
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                "Customer Status",
                                style: DashBoardScreen().gridTextField(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                // buildDetails()
                : Container(),
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
                var data = searchResults[index];
                return Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ShowProfile(
                                  userId: int.parse("${data.id}"),
                                ),
                              ),
                            );
                          },
                          child: CircleAvatar(
                            radius: 3.h,
                            backgroundImage: NetworkImage(
                              data.profile ?? '',
                            ),
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${data.fname ?? ""} ${data.lname ?? ""}",
                                style: AllListText().headingText(),
                              ),
                              // SizedBox(height: 1.h),
                              // Text(
                              //   "24 F",
                              //   style: TextStyle(
                              //       fontFamily: "GothamMedium",
                              //       color: gTextColor,
                              //       fontSize: 8.sp),
                              // ),
                              // SizedBox(height: 0.5.h),
                              Text(
                                "${data.date}/${data.time}",
                                style: AllListText().otherText(),
                              ),
                              // SizedBox(height: 0.5.h),
                              Row(
                                children: [
                                  Text(
                                    "Status : ",
                                    style: AllListText().otherText(),
                                  ),
                                  Text(
                                    data.team?.teamPatients?.status ?? "",
                                    style: AllListText().subHeadingText(),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Associated Doctor : ",
                                    style: AllListText().otherText(),
                                  ),
                                  Text(
                                    data.team?.teamPatients?.team
                                            ?.teamMember?[0].user?.name ??
                                        "",
                                    style: AllListText().subHeadingText(),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        CallChatIcons(
                          userId: data.id.toString(),
                          kaleyraUserId: data.kaleyraUserId ?? '',
                          chat: true,
                        ),
                        // trailIcons(callOnTap: () {
                        //   dialog(context);
                        //   saveUserId(
                        //     data[index].id.toString(),
                        //   );
                        // }, chatOnTap: () {
                        //   saveUserId(data[index].id.toString());
                        //   final qbService = Provider.of<QuickBloxService>(
                        //       context,
                        //       listen: false);
                        //   qbService.openKaleyraChat(kaleyraUserId,
                        //       data[index].kaleyraUserId.toString(), kaleyraAccessToken);
                        //   // getChatGroupId(
                        //   //     data[index].fname ?? "",
                        //   //     data[index].profile.toString(),
                        //   //     data[index].id.toString());
                        // }),
                      ],
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
      if (userDetail.fname!.toLowerCase().contains(text.toLowerCase()) ||
          userDetail.lname!.toLowerCase().contains(text.toLowerCase())) {
        searchResults.add(userDetail);
      }
    });
    setState(() {});
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

  final CustomerStatusRepo repository = CustomerStatusRepo(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );
}
