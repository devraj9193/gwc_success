import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../model/customers_list_model.dart';
import '../../../model/error_model.dart';
import '../../../repository/customer_status_repo.dart/customer_status_repo.dart';
import '../../../service/api_service.dart';
import '../../../service/customer_status_service/customer_status_service.dart';
import '../../../widgets/common_screen_widgets.dart';
import '../../../widgets/widgets.dart';
import '../../common_ui/call_chat_icons.dart';
import '../../common_ui/show_profile.dart';
import 'package:http/http.dart' as http;

class AllCustomersList extends StatefulWidget {
  const AllCustomersList({Key? key}) : super(key: key);

  @override
  State<AllCustomersList> createState() => _AllCustomersListState();
}

class _AllCustomersListState extends State<AllCustomersList> {
  bool showProgress = false;
  CustomersList? customersList;

  final ScrollController _scrollController = ScrollController();

  late final CustomerStatusService customerStatusService =
      CustomerStatusService(customerStatusRepo: repository);

  @override
  void initState() {
    super.initState();
    getAllCustomerCount();
  }

  getAllCustomerCount() async {
    setState(() {
      showProgress = true;
    });
    callProgressStateOnBuild(true);
    final result = await customerStatusService.getAllCustomerService();
    print("result: $result");

    if (result.runtimeType == CustomersList) {
      print("All Customers List");
      CustomersList model = result as CustomersList;

      customersList = model;
    } else {
      ErrorModel model = result as ErrorModel;
      print("error: ${model.message}");
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
    List<Datum> allCustomersList = customersList?.data ?? [];

    return (showProgress)
        ? Center(
            child: buildCircularIndicator(),
          )
        : allCustomersList.isEmpty
            ? buildNoData()
            : Column(
                children: [

                  Expanded(
                    child: SingleChildScrollView(
                      child: ListView.builder(
                        controller: _scrollController,
                        scrollDirection: Axis.vertical,
                        padding: EdgeInsets.symmetric(horizontal: 1.w),
                        physics: const ScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: allCustomersList.length,
                        itemBuilder: ((context, index) {
                          var data = allCustomersList[index];
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                              data.team?.teamPatients?.status ??
                                                  "",
                                              style: AllListText()
                                                  .subHeadingText(),
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
                                              data
                                                      .team
                                                      ?.teamPatients
                                                      ?.team
                                                      ?.teamMember?[0]
                                                      .user
                                                      ?.name ??
                                                  "",
                                              style: AllListText()
                                                  .subHeadingText(),
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
                    ),
                  ),
                ],
              );
  }

  final CustomerStatusRepo repository = CustomerStatusRepo(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );

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
