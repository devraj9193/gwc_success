import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import '../../../controller/meal_active_list_controller.dart';
import '../../../utils/constants.dart';
import '../../../widgets/common_screen_widgets.dart';
import '../../../widgets/widgets.dart';
import '../../common_ui/call_chat_icons.dart';
import '../../common_ui/show_profile.dart';
import '../meal_plan_details_screen/meal_plan_customer_details_screen.dart';

class MealPlanListScreen extends StatefulWidget {
  const MealPlanListScreen({Key? key}) : super(key: key);

  @override
  State<MealPlanListScreen> createState() => _MealPlanListScreenState();
}

class _MealPlanListScreenState extends State<MealPlanListScreen> {
  String statusText = "";

  MealActiveListController mealActiveListController =
      Get.put(MealActiveListController());

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 3.w),
      physics: const BouncingScrollPhysics(),
      child: FutureBuilder(
          future: mealActiveListController.fetchMealPlanList(),
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
                                    data[index]
                                        .userDetails
                                        .patient
                                        .user
                                        .id
                                        .toString(),
                                    data[index].userDetails.id.toString(),
                                    data[index]
                                        .userDetails
                                        .patient
                                        .user
                                        .id
                                        .toString());
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        MealPlanCustomerDetailsScreen(
                                      userName: data[index]
                                              .userDetails
                                              .patient
                                              .user
                                              .name ??
                                          '',
                                      age:
                                          "${data[index].userDetails.patient.user.age ?? ""} ${data[index].userDetails.patient.user.gender ?? ""}",
                                      appointmentDetails:
                                          "${data[index].userDetails.appointmentDate ?? ""} / ${data[index].userDetails.appointmentTime ?? ""}",
                                      status: buildStatusText(
                                          data[index].userDetails.status),
                                      finalDiagnosis:
                                          data[index].userFinalDiagnosis ?? '',
                                      preparatoryCurrentDay: data[index]
                                              .userDetails
                                              .patient
                                              .user
                                              .userProgram
                                              .ppCurrentDay ??
                                          "",
                                      transitionCurrentDay: data[index]
                                              .userDetails
                                              .patient
                                              .user
                                              .userProgram
                                              .tpCurrentDay ??
                                          "",
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
                                          saveUserId(
                                              data[index]
                                                  .userDetails
                                                  .patient
                                                  .user
                                                  .id
                                                  .toString(),
                                              data[index]
                                                  .userDetails
                                                  .id
                                                  .toString(),
                                              data[index]
                                                  .userDetails
                                                  .patient
                                                  .user
                                                  .id
                                                  .toString());
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const ShowProfile(),
                                            ),
                                          );
                                        },
                                        child: CircleAvatar(
                                          radius: 3.h,
                                          backgroundImage: NetworkImage(
                                              data[index]
                                                  .userDetails
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
                                                  .userDetails
                                                  .patient
                                                  .user
                                                  .name
                                                  .toString(),
                                              style:
                                                  AllListText().headingText(),
                                            ),
                                            Text(
                                              "${data[index].userDetails.patient.user.age.toString()} ${data[index].userDetails.patient.user.gender.toString()}",
                                              style: AllListText()
                                                  .subHeadingText(),
                                            ),
                                            Text(
                                              "${data[index].userDetails.appointmentDate.toString()} / ${data[index].userDetails.appointmentTime.toString()}",
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
                                                  buildStatusText(data[index]
                                                      .userDetails
                                                      .status
                                                      .toString()),
                                                  style: AllListText()
                                                      .subHeadingText(),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  "Final Diagnosis : ",
                                                  style:
                                                      AllListText().otherText(),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    data[index]
                                                        .userFinalDiagnosis
                                                        .toString(),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: AllListText()
                                                        .subHeadingText(),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            buildPreparatoryStatus(
                                                data[index]
                                                    .userDetails
                                                    .patient
                                                    .user
                                                    .userProgram
                                                    .isPrepCompleted),
                                          ],
                                        ),
                                      ),
                                      CallChatIcons(
                                        userId: data[index]
                                            .userDetails
                                            .patient
                                            .user
                                            .id
                                            .toString(),
                                        kaleyraUserId: data[index]
                                            .userDetails
                                            .patient
                                            .user
                                            .kaleyraUserId
                                            .toString(),
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
                                    margin:
                                        EdgeInsets.symmetric(vertical: 1.5.h),
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

  saveUserId(String patientId, String teamPatientId, String userId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("patient_id", patientId);
    preferences.setString("team_patient_id", teamPatientId);
    preferences.setString("user_id", userId);
  }

  String buildStatusText(String status) {
    if (status == "report_upload") {
      return "MR Upload";
    } else if (status == "check_user_reports") {
      return "Check User Reports";
    } else if (status == "meal_plan_completed") {
      return "Meal Plan Completed";
    } else if (status == "shipping_paused") {
      return "Shipping Paused";
    } else if (status == "shipping_packed") {
      return "Shipping Packed";
    } else if (status == "shipping_approved") {
      return "Shipping Approved";
    } else if (status == "shipping_delivered") {
      return "Shipping Delivered";
    } else if (status == "prep_meal_plan_completed") {
      return "Preparatory Meal Plan Completed";
    }
    return statusText;
  }

  buildPreparatoryStatus(String isPrepCompleted) {
    return (isPrepCompleted == "1") &&
        (isPrepCompleted != "null")
        ? Text(
      "Preparatory Plan Completed by user",
      style: TextStyle(
          height: 1.3,
          fontFamily: fontMedium,
          color: gSecondaryColor,
          fontSize: fontSize08),
    )
        : const SizedBox();
  }
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
