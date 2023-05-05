import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../controller/consultation_controller.dart';
import '../../../widgets/common_screen_widgets.dart';
import '../../../widgets/widgets.dart';
import '../../common_ui/call_chat_icons.dart';
import '../../common_ui/show_profile.dart';

class ConsultationPendingList extends StatefulWidget {
  const ConsultationPendingList({Key? key}) : super(key: key);

  @override
  State<ConsultationPendingList> createState() =>
      _ConsultationPendingListState();
}

class _ConsultationPendingListState extends State<ConsultationPendingList> {

  ConsultationController consultationController =
      Get.put(ConsultationController());

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 3.w),
      physics: const BouncingScrollPhysics(),
      child: FutureBuilder(
          future: consultationController.fetchConsultation(),
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
                  if (data.length != 0)
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
                                    saveUserId(
                                      data[index]
                                          .teamPatients
                                          .patient
                                          .user
                                          .id
                                          .toString(),
                                    );
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const ShowProfile(),
                                      ),
                                    );
                                  },
                                  child: CircleAvatar(
                                    radius: 3.h,
                                    backgroundImage: NetworkImage(data[index]
                                        .teamPatients
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
                                        data[index]
                                                .teamPatients
                                                .patient
                                                .user
                                                .name ??
                                            "",
                                        style: AllListText().headingText(),
                                      ),
                                      Text(
                                        "${DateFormat('dd MMM yyyy').format(DateTime.parse((data[index].date.toString()))).toString()} / ${getTime(data[index].slotStartTime.toString(), data[index].date.toString())}",
                                        style: AllListText().otherText(),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Associated Doctor : ",
                                            style: AllListText().otherText(),
                                          ),
                                          Text(
                                            data[index]
                                                .teamPatients
                                                .team
                                                .teamMember[0]
                                                .user
                                                .name
                                                .toString(),
                                            style:
                                                AllListText().subHeadingText(),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                CallChatIcons(
                                  userId: data[index]
                                      .teamPatients
                                      .patient
                                      .user
                                      .id
                                      .toString(),
                                  kaleyraUserId: data[index]
                                      .teamPatients
                                      .patient
                                      .user
                                      .kaleyraUserId
                                      .toString(),
                                ),
                                // trailIcons(callOnTap: () {
                                //   dialog(context);
                                //   saveUserId(
                                //     data[index]
                                //         .teamPatients
                                //         .patient
                                //         .user
                                //         .id
                                //         .toString(),
                                //   );
                                // }, chatOnTap: () {
                                //   saveUserId(
                                //     data[index]
                                //         .teamPatients
                                //         .patient
                                //         .user
                                //         .id
                                //         .toString(),
                                //   );
                                //   final qbService = Provider.of<QuickBloxService>(
                                //       context,
                                //       listen: false);
                                //   qbService.openKaleyraChat(kaleyraUserId,
                                //       data[index].kaleyraUserId.toString(), kaleyraAccessToken);
                                //   // getChatGroupId(
                                //   //   data[index]
                                //   //           .teamPatients
                                //   //           .patient
                                //   //           .user
                                //   //           .name ??
                                //   //       "",
                                //   //   data[index]
                                //   //       .teamPatients
                                //   //       .patient
                                //   //       .user
                                //   //       .profile
                                //   //       .toString(),
                                //   //   data[index]
                                //   //       .teamPatients
                                //   //       .patient
                                //   //       .user
                                //   //       .id
                                //   //       .toString(),
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
                        );
                      }),
                    )
                  else
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      child: Image(
                        image: const AssetImage("assets/images/Group 5294.png"),
                        height: 25.h,
                      ),
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

  getTime(String time, String date) {
    print("isReschedule$time");
    var split = time.split(':');
    print("split:$split");
    String hour = split[0];
    String minute = split[1];
    DateTime timing = DateTime.parse("$date $time");
    String amPm = 'AM';
    if (timing.hour >= 12) {
      amPm = 'PM';
    }
    // int second = int.parse(split[2]);
    return '$hour:$minute $amPm';
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
