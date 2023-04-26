import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import '../../../controller/linked_customers_controller.dart';
import '../../../utils/gwc_api.dart';
import '../../../widgets/common_screen_widgets.dart';
import '../../../widgets/widgets.dart';
import '../../common_ui/call_chat_icons.dart';
import '../../common_ui/show_profile.dart';

class AllCustomersList extends StatefulWidget {
  const AllCustomersList({Key? key}) : super(key: key);

  @override
  State<AllCustomersList> createState() => _AllCustomersListState();
}

class _AllCustomersListState extends State<AllCustomersList> {
  final SharedPreferences _pref = GwcApi.preferences!;

  String kaleyraAccessToken = "";
  String kaleyraUserId = "";

  @override
  void initState() {
    super.initState();
    getKaleyraDetails();
  }

  void getKaleyraDetails() async {
    kaleyraAccessToken = _pref.getString(GwcApi.kaleyraAccessToken)!;
    kaleyraUserId = _pref.getString("kaleyraUserId")!;
    setState(() {});
    print("kaleyraAccessToken: $kaleyraAccessToken");
  }

  LinkedCustomersController linkedCustomersController =
      Get.put(LinkedCustomersController());

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 3.w),
      child: FutureBuilder(
          future: linkedCustomersController.fetchCustomersList(),
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
                      return Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  saveUserId(data[index].id.toString());
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => const ShowProfile(),
                                    ),
                                  );
                                },
                                child: CircleAvatar(
                                  radius: 3.h,
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
                                      style: AllListText().headingText(),
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
                                      style: AllListText().otherText(),
                                    ),
                                    SizedBox(height: 0.5.h),
                                    // Row(
                                    //   children: [
                                    //     Text(
                                    //       "Associated Doctor : ",
                                    //       style: AllListText().otherText(),
                                    //     ),
                                    //     Text(
                                    //       data[index]
                                    //               .team
                                    //               .teamPatients
                                    //               .team
                                    //               .teamMember[0]
                                    //               .user
                                    //               .name ??
                                    //           "",
                                    //       style: AllListText().subHeadingText(),
                                    //     ),
                                    //   ],
                                    // ),
                                  ],
                                ),
                              ),
                              CallChatIcons(
                                userId: data[index].id.toString(),
                                kaleyraUserId:
                                    data[index].kaleyraUserId.toString(),
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
              );
            }
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h),
              child: buildCircularIndicator(),
            );
          }),
    );
  }

  saveUserId(String userId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
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
  //     print('model.group: ${model.group}');
  //     Get.to(
  //       () => MessageScreen(
  //         isGroupId: true,
  //         userName: userName,
  //         profileImage: profileImage,
  //       ),
  //     );
  //   } else {
  //     ErrorModel model = res as ErrorModel;
  //     showSnackbar(context, model.message.toString(), isError: true);
  //   }
  // }
}
