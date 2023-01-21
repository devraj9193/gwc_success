import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import '../../controller/api_service.dart';
import '../../controller/gwc_team_controller.dart';
import '../../model/chat_repository/message_repo.dart';
import '../../model/chat_service/chat_service.dart';
import '../../model/error_model.dart';
import '../../model/message_model/get_chat_groupid_model.dart';
import '../../model/quick_blox_service/quick_blox_service.dart';
import '../../utils/constants.dart';
import '../../utils/gwc_api.dart';
import '../../widgets/pop_up_menu_widget.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../widgets/widgets.dart';
import '../message_screen/doctor_message_screen.dart';
import '../message_screen/message_screen.dart';

class GwcTeamsScreen extends StatefulWidget {
  const GwcTeamsScreen({Key? key}) : super(key: key);

  @override
  State<GwcTeamsScreen> createState() => _GwcTeamsScreenState();
}

class _GwcTeamsScreenState extends State<GwcTeamsScreen> {
  final SharedPreferences _pref = GwcApi.preferences!;

  GwcTeamController gwcTeamController = Get.put(GwcTeamController());
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: SafeArea(
        child: Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 1.h),
              SizedBox(
                height: 8.h,
                child: const Image(
                  image:
                      AssetImage("assets/images/Gut wellness logo green.png"),
                ),
              ),
              TabBar(
                  labelColor: gPrimaryColor,
                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                  unselectedLabelColor: gTextColor,
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
                    Text('Doctors'),
                    // Text('Success Team'),
                    // Text("Tech Team")
                  ]),
              Expanded(
                child: TabBarView(children: [
                  buildDoctors(),
                  // buildSuccessTeam(),
                  // buildTechTeam(),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildDoctors() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 3.w),
      physics: const BouncingScrollPhysics(),
      child: FutureBuilder(
          future: gwcTeamController.fetchDoctorList(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasError) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 7.h),
                child: Image(
                  image: const AssetImage("assets/images/Group 5294.png"),
                  height: 35.h,
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
                        onTap: () {},
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 2.h,
                                  backgroundImage: NetworkImage(
                                    data[index].profile.toString(),
                                  ),
                                ),
                                SizedBox(width: 2.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        data[index].name ?? "",
                                        style: TextStyle(
                                            fontFamily: "GothamMedium",
                                            color: gTextColor,
                                            fontSize: 10.sp),
                                      ),
                                      SizedBox(height: 0.5.h),
                                      Text(
                                        "${data[index].age ?? ""} ${data[index].gender ?? ""}",
                                        style: TextStyle(
                                            fontFamily: "GothamMedium",
                                            color: gTextColor,
                                            fontSize: 8.sp),
                                      ),
                                      SizedBox(height: 0.5.h),
                                      Text(
                                        "${data[index].signupDate ?? ""} ${data[index].signupDate ?? ""}",
                                        style: TextStyle(
                                            fontFamily: "GothamBook",
                                            color: gTextColor,
                                            fontSize: 8.sp),
                                      ),
                                    ],
                                  ),
                                ),
                                PopUpMenuWidget(
                                  onView: () {},
                                  onCall: () {},
                                  onMessage: () {
                                    saveUserId(data[index].id.toString());
                                    getChatGroupId(data[index].name ?? "",
                                        data[index].profile.toString(),data[index].id.toString(),);
                                  },
                                ),
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

  // buildSuccessTeam() {
  //   return SingleChildScrollView(
  //     physics: const BouncingScrollPhysics(),
  //     padding: EdgeInsets.symmetric(horizontal: 3.w),
  //     child: FutureBuilder(
  //         future: gwcTeamController.fetchSuccessList(),
  //         builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
  //           if (snapshot.hasError) {
  //             return Padding(
  //               padding: EdgeInsets.symmetric(vertical: 7.h),
  //               child: Image(
  //                 image: const AssetImage("assets/images/Group 5294.png"),
  //                 height: 35.h,
  //               ),
  //             );
  //           } else if (snapshot.hasData) {
  //             var data = snapshot.data;
  //             return Column(
  //               children: [
  //                 Container(
  //                   height: 1,
  //                   color: Colors.grey.withOpacity(0.3),
  //                 ),
  //                 SizedBox(height: 2.h),
  //                 ListView.builder(
  //                   scrollDirection: Axis.vertical,
  //                   padding: EdgeInsets.symmetric(horizontal: 1.w),
  //                   physics: const ScrollPhysics(),
  //                   shrinkWrap: true,
  //                   itemCount: data.length,
  //                   itemBuilder: ((context, index) {
  //                     return GestureDetector(
  //                       onTap: () {},
  //                       child: Column(
  //                         children: [
  //                           Row(
  //                             crossAxisAlignment: CrossAxisAlignment.center,
  //                             children: [
  //                               CircleAvatar(
  //                                 radius: 2.h,
  //                                 backgroundImage: NetworkImage(
  //                                   data[index].profile.toString(),
  //                                 ),
  //                               ),
  //                               SizedBox(width: 2.w),
  //                               Expanded(
  //                                 child: Column(
  //                                   crossAxisAlignment:
  //                                       CrossAxisAlignment.start,
  //                                   children: [
  //                                     Text(
  //                                       data[index].name ?? "",
  //                                       style: TextStyle(
  //                                           fontFamily: "GothamMedium",
  //                                           color: gTextColor,
  //                                           fontSize: 10.sp),
  //                                     ),
  //                                     SizedBox(height: 0.5.h),
  //                                     Text(
  //                                       "${data[index].age ?? ""} ${data[index].gender ?? ""}",
  //                                       style: TextStyle(
  //                                           fontFamily: "GothamMedium",
  //                                           color: gTextColor,
  //                                           fontSize: 8.sp),
  //                                     ),
  //                                     SizedBox(height: 0.5.h),
  //                                     Text(
  //                                       "${data[index].signupDate ?? ""} ${data[index].signupDate ?? ""}",
  //                                       style: TextStyle(
  //                                           fontFamily: "GothamBook",
  //                                           color: gTextColor,
  //                                           fontSize: 8.sp),
  //                                     ),
  //                                   ],
  //                                 ),
  //                               ),
  //                               PopUpMenuWidget(
  //                                 onView: () {},
  //                                 onCall: () {},
  //                                 onMessage: () {
  //                                   saveUserId(data[index].id.toString());
  //                                   getChatGroupId(data[index].name ?? "",
  //                                       data[index].profile.toString());
  //                                 },
  //                               ),
  //                             ],
  //                           ),
  //                           Container(
  //                             height: 1,
  //                             margin: EdgeInsets.symmetric(vertical: 1.5.h),
  //                             color: Colors.grey.withOpacity(0.3),
  //                           ),
  //                         ],
  //                       ),
  //                     );
  //                   }),
  //                 ),
  //               ],
  //             );
  //           }
  //           return Padding(
  //             padding: EdgeInsets.symmetric(vertical: 20.h),
  //             child: buildCircularIndicator(),
  //           );
  //         }),
  //   );
  // }
  //
  // buildTechTeam() {
  //   return SingleChildScrollView(
  //     physics: const BouncingScrollPhysics(),
  //     padding: EdgeInsets.symmetric(horizontal: 3.w),
  //     child: Column(
  //       children: [
  //         Container(
  //           height: 1,
  //           color: Colors.grey.withOpacity(0.3),
  //         ),
  //         SizedBox(height: 2.h),
  //         ListView.builder(
  //           scrollDirection: Axis.vertical,
  //           padding: EdgeInsets.symmetric(horizontal: 1.w),
  //           physics: const ScrollPhysics(),
  //           shrinkWrap: true,
  //           itemCount: 10,
  //           itemBuilder: ((context, index) {
  //             return GestureDetector(
  //               onTap: () {},
  //               child: Column(
  //                 children: [
  //                   Row(
  //                     crossAxisAlignment: CrossAxisAlignment.center,
  //                     children: [
  //                       CircleAvatar(
  //                         radius: 2.h,
  //                         backgroundImage:
  //                             const AssetImage("assets/images/Ellipse 232.png"),
  //                       ),
  //                       SizedBox(width: 2.w),
  //                       Expanded(
  //                         child: Column(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //                             Text(
  //                               "Lorem ipsum dadids",
  //                               style: TextStyle(
  //                                   fontFamily: "GothamMedium",
  //                                   color: gTextColor,
  //                                   fontSize: 10.sp),
  //                             ),
  //                             SizedBox(height: 0.5.h),
  //                             Text(
  //                               "24 F",
  //                               style: TextStyle(
  //                                   fontFamily: "GothamMedium",
  //                                   color: gTextColor,
  //                                   fontSize: 8.sp),
  //                             ),
  //                             SizedBox(height: 0.5.h),
  //                             Text(
  //                               "09th Sep 2022 / 08:30 PM",
  //                               style: TextStyle(
  //                                   fontFamily: "GothamBook",
  //                                   color: gTextColor,
  //                                   fontSize: 8.sp),
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                       PopUpMenuWidget(
  //                         onView: () {},
  //                         onCall: () {},
  //                         onMessage: () {},
  //                       ),
  //                     ],
  //                   ),
  //                   Container(
  //                     height: 1,
  //                     margin: EdgeInsets.symmetric(vertical: 1.5.h),
  //                     color: Colors.grey.withOpacity(0.3),
  //                   ),
  //                 ],
  //               ),
  //             );
  //           }),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  saveUserId(String userId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("user_id", userId);
  }

  final MessageRepository chatRepository = MessageRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );

  getChatGroupId(String userName, String profileImage,String userId) async {
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
        .getGwcTeamChatGroupIdService(userId);

    if (res.runtimeType == GetChatGroupIdModel) {
      GetChatGroupIdModel model = res as GetChatGroupIdModel;
      // QuickBloxRepository().init(AppConfig.QB_APP_ID, AppConfig.QB_AUTH_KEY, AppConfig.QB_AUTH_SECRET, AppConfig.QB_ACCOUNT_KEY);
      _pref.setString(GwcApi.doctorGroupId, model.group ?? '');
      print('model.group: ${model.group}');
      Get.to(() => DoctorMessageScreen(
        isGroupId: true,
        userName: userName,
        profileImage: profileImage,
      ));
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (c) => DoctorMessageScreen(
      //               isGroupId: true,
      //               userName: userName,
      //               profileImage: profileImage,
      //             )));
    } else {
      ErrorModel model = res as ErrorModel;
      showSnackbar(context, model.message.toString(), isError: true);
    }
  }
}
