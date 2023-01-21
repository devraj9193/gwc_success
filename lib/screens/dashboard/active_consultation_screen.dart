import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import '../../controller/api_service.dart';
import '../../controller/linked_customers_controller.dart';
import '../../controller/meal_active_list_controller.dart';
import '../../model/chat_repository/message_repo.dart';
import '../../model/chat_service/chat_service.dart';
import '../../model/error_model.dart';
import '../../model/message_model/get_chat_groupid_model.dart';
import '../../model/quick_blox_service/quick_blox_service.dart';
import '../../utils/constants.dart';
import '../../utils/gwc_api.dart';
import '../../widgets/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../message_screen/message_screen.dart';
import '../common_ui/show_profile.dart';
import '../customer_details_screens/active_customer_details.dart';

class ActiveConsultationScreen extends StatefulWidget {
  const ActiveConsultationScreen({Key? key}) : super(key: key);

  @override
  State<ActiveConsultationScreen> createState() =>
      _ActiveConsultationScreenState();
}

class _ActiveConsultationScreenState extends State<ActiveConsultationScreen> {
  final SharedPreferences _pref = GwcApi.preferences!;
  String statusText = "";

  MealActiveListController mealActiveListController =
      Get.put(MealActiveListController());

  LinkedCustomersController linkedCustomersController =
      Get.put(LinkedCustomersController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 1.h),
              Padding(
                padding: EdgeInsets.only(left: 3.w),
                child: buildAppBar(() {
                  Navigator.pop(context);
                }),
              ),
              TabBar(
                  labelColor: gPrimaryColor,
                  unselectedLabelColor: gTextColor,
                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                  isScrollable: true,
                  indicatorColor: gPrimaryColor,
                  labelPadding:
                      EdgeInsets.only(right: 10.w, top: 1.h, bottom: 1.h),
                  indicatorPadding: EdgeInsets.only(right: 7.w),
                  labelStyle: TextStyle(
                      fontFamily: "GothamMedium",
                      color: gPrimaryColor,
                      fontSize: 10.sp),
                  tabs: const [
                    Text('Linked Customers'),
                    Text('All Customers'),
                  ]),
              Expanded(
                child: TabBarView(children: [
                  buildLinkedCustomers(),
                  buildAllCustomers(),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildLinkedCustomers() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 3.w),
      physics: const BouncingScrollPhysics(),
      child: FutureBuilder(
          future: mealActiveListController.fetchActiveList(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasError) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 20.h),
                child: Image(
                  image: const AssetImage("assets/images/Group 5294.png"),
                  height: 25.h,
                ),
              );
            } else if (snapshot.hasData) {
              var data = snapshot.data;
              return Column(
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
                    itemCount: data.length,
                    itemBuilder: ((context, index) {
                      return GestureDetector(
                        onTap: () {
                          saveUserId(
                              data[index].patientId.toString(),
                              data[index].id.toString(),
                              data[index].patient.user.id.toString());
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ActiveCustomerDetails(
                                userName: data[index].patient.user.name ?? "",
                                age:
                                    "${data[index].patient.user.age ?? ""} ${data[index].patient.user.gender ?? ""}",
                                appointmentDetails:
                                    "${data[index].appointmentDate ?? ""} / ${data[index].appointmentTime ?? ""}",
                                status:
                                    buildStatusText(data[index].status) ?? "",
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
                                    saveUserId(
                                        data[index].patientId.toString(),
                                        data[index].id.toString(),
                                        data[index].patient.user.id.toString());
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => ShowProfile(),
                                      ),
                                    );
                                  },
                                  child: CircleAvatar(
                                    radius: 2.5.h,
                                    backgroundImage: NetworkImage(data[index]
                                        .patient
                                        .user
                                        .profile
                                        .toString()),
                                  ),
                                ),
                                SizedBox(width: 2.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        data[index].patient.user.name ?? "",
                                        style: TextStyle(
                                            fontFamily: "GothamMedium",
                                            color: gTextColor,
                                            fontSize: 10.sp),
                                      ),
                                      SizedBox(height: 1.h),
                                      Text(
                                        "${data[index].appointmentDate}/${data[index].appointmentTime}",
                                        style: TextStyle(
                                            fontFamily: "GothamBook",
                                            color: gTextColor,
                                            fontSize: 8.sp),
                                      ),
                                      SizedBox(height: 0.5.h),
                                      Row(
                                        children: [
                                          Text(
                                            "Status : ",
                                            style: TextStyle(
                                                fontFamily: "GothamBook",
                                                color: gBlackColor,
                                                fontSize: 8.sp),
                                          ),
                                          Text(
                                            buildStatusText(
                                                data[index].status.toString()),
                                            style: TextStyle(
                                                fontFamily: "GothamMedium",
                                                color: gPrimaryColor,
                                                fontSize: 8.sp),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                trailIcons(callOnTap: () {
                                  dialog(context);
                                  saveUserId(
                                      data[index].patientId.toString(),
                                      data[index].id.toString(),
                                      data[index].patient.user.id.toString());
                                }, chatOnTap: () {
                                  saveUserId(
                                      data[index].patientId.toString(),
                                      data[index].id.toString(),
                                      data[index].patient.user.id.toString());
                                  getChatGroupId(
                                    data[index].patient.user.name ?? "",
                                    data[index].patient.user.profile.toString(),
                                    data[index].patient.user.id,
                                  );
                                }),
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
                  ),
                ],
              );
            }
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h),
              child: buildCircularIndicator(),
            );
          }),
    );
  }

  buildAllCustomers() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 3.w),
      child: FutureBuilder(
          future: linkedCustomersController.fetchCustomersList(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasError) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: Image(
                  image: const AssetImage("assets/images/Group 5294.png"),
                  height: 25.h,
                ),
              );
            } else if (snapshot.hasData) {
              var data = snapshot.data;
              return Column(
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
                    itemCount: data.length,
                    itemBuilder: ((context, index) {
                      return Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  saveUserId("", "", data[index].id.toString());
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => const ShowProfile(),
                                    ),
                                  );
                                },
                                child: CircleAvatar(
                                  radius: 2.5.h,
                                  backgroundImage: NetworkImage(
                                    data[index].profile.toString(),
                                  ),
                                ),
                              ),
                              SizedBox(width: 2.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${data[index].fname ?? ""} ${data[index].lname ?? ""}",
                                      style: TextStyle(
                                          fontFamily: "GothamMedium",
                                          color: gBlackColor,
                                          fontSize: 10.sp),
                                    ),
                                    SizedBox(height: 1.h),
                                    // Text(
                                    //   "24 F",
                                    //   style: TextStyle(
                                    //       fontFamily: "GothamMedium",
                                    //       color: gTextColor,
                                    //       fontSize: 8.sp),
                                    // ),
                                    // SizedBox(height: 0.5.h),
                                    Text(
                                      "${data[index].date}/${data[index].time}",
                                      style: TextStyle(
                                          fontFamily: "GothamBook",
                                          color: gTextColor,
                                          fontSize: 8.sp),
                                    ),
                                  ],
                                ),
                              ),
                              trailIcons(callOnTap: () {
                                dialog(context);
                                saveUserId(
                                  "",
                                  "",
                                  data[index].id.toString(),
                                );
                              }, chatOnTap: () {
                                saveUserId("", "", data[index].id.toString());
                                setState(() {
                                  getChatGroupId(
                                    "${data[index].fname ?? ""} ${data[index].lname ?? ""}",
                                    data[index].profile.toString(),
                                    data[index].id.toString(),
                                  );
                                });
                              }),
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
              );
            }
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h),
              child: buildCircularIndicator(),
            );
          }),
    );
  }

  trailIcons(
      {required VoidCallback callOnTap, required VoidCallback chatOnTap}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: callOnTap,
          child: Image.asset(
            'assets/images/Group 4890.png',
            height: 2.h,
            width: 2.h,
            color: gBlackColor,
          ),
        ),
        SizedBox(width: 4.w),
        GestureDetector(
          onTap: chatOnTap,
          child: Image.asset(
            'assets/images/Group 4891.png',
            height: 2.5.h,
            width: 2.5.h,
            color: gBlackColor,
          ),
        ),
      ],
    );
  }

  saveUserId(String patientId, String teamPatientId, String userId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("patient_id", patientId);
    preferences.setString("team_patient_id", teamPatientId);
    preferences.setString("user_id", userId);
  }

  final MessageRepository chatRepository = MessageRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );

  getChatGroupId(String userName, String profileImage, String userId) async {
    print(_pref.getInt(GwcApi.getQBSession));
    print(_pref.getBool(GwcApi.isQBLogin));

    SharedPreferences preferences = await SharedPreferences.getInstance();
    var chatUserName = preferences.getString("chatUserName")!;
    print("UserName: $chatUserName");

    print(_pref.getInt(GwcApi.getQBSession) == null ||
        _pref.getBool(GwcApi.isQBLogin) == null ||
        _pref.getBool(GwcApi.isQBLogin) == false);
    final _qbService = Provider.of<QuickBloxService>(context, listen: false);
    print(await _qbService.getSession());
    if (_pref.getInt(GwcApi.getQBSession) == null ||
        await _qbService.getSession() == true ||
        _pref.getBool(GwcApi.isQBLogin) == null ||
        _pref.getBool(GwcApi.isQBLogin) == false) {
      _qbService.login(chatUserName);
    } else {
      if (await _qbService.isConnected() == false) {
        _qbService.connect(_pref.getInt(GwcApi.qbCurrentUserId)!);
      }
    }
    final res = await ChatService(repository: chatRepository)
        .getChatGroupIdService(userId);

    if (res.runtimeType == GetChatGroupIdModel) {
      GetChatGroupIdModel model = res as GetChatGroupIdModel;
      // QuickBloxRepository().init(AppConfig.QB_APP_ID, AppConfig.QB_AUTH_KEY, AppConfig.QB_AUTH_SECRET, AppConfig.QB_ACCOUNT_KEY);
      _pref.setString(GwcApi.groupId, model.group ?? '');
      print("getModel:$res");
      print('model.group: ${model.group}');
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (c) => MessageScreen(
                    isGroupId: true,
                    userName: userName,
                    profileImage: profileImage,
                  )));
    } else {
      ErrorModel model = res as ErrorModel;
      showSnackbar(context, model.message.toString(), isError: true);
    }
  }

  String buildStatusText(String status) {
    if (status == "start_program") {
      return "Started Program";
    }
    return statusText;
  }
}
