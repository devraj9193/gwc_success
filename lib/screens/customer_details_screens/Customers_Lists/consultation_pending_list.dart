import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import '../../../model/consultation_model.dart';
import '../../../model/error_model.dart';
import '../../../repository/customer_status_repo.dart/customer_status_repo.dart';
import '../../../service/api_service.dart';
import '../../../service/customer_status_service/customer_status_service.dart';
import '../../../utils/constants.dart';
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
  String statusText = "";

  final searchController = TextEditingController();

  bool showProgress = false;
  ConsultationModel? consultationModel;
  List<AppDetails> searchResults = [];
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
    final result = await customerStatusService.getConsultationPendingService();
    print("result: $result");

    if (result.runtimeType == ConsultationModel) {
      print("Ticket List");
      ConsultationModel model = result as ConsultationModel;

      consultationModel = model;
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
     List<AppDetails> consultationList = consultationModel?.appDetails ?? [];

    return (showProgress)
        ? Center(
      child: buildCircularIndicator(),
    )
        : consultationList.isEmpty
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
              itemCount: consultationList.length,
              itemBuilder: ((context, index) {
                var data = consultationList[index];
                return Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    ShowProfile(userId: int.parse("${data.patient?.user?.id}"),),
                              ),
                            );
                          },
                          child: CircleAvatar(
                            radius: 3.h,
                            backgroundImage: NetworkImage("${data.patient?.user?.profile.toString()}"),
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                data.patient?.user?.name ?? "",
                                style: AllListText().headingText(),
                              ),
                              Text(
                                buildTimeDate("${data.appointments?[0].date.toString()}","${data.appointments?[0].slotStartTime.toString()}"),
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
                                        "${data.patient?.status.toString()}"),
                                    style:
                                    AllListText().subHeadingText(),
                                  ),
                                  SizedBox(width: 1.w),
                                  buildIconWidget(data.patient
                                      ?.status
                                      .toString() ??
                                      ''),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Associated Doctor : ",
                                    style: AllListText().otherText(),
                                  ),
                                  Text(
                                    "${data.team?.teamMember?[0].user?.name.toString()}",
                                    style:
                                    AllListText().subHeadingText(),
                                  ),
                                ],
                              ),
                              buildUpdatedTime(
                                  data.patient
                                      ?.status
                                      .toString() ??
                                      '',
                                  data.
                                      updateDate
                                      .toString() ??
                                      '',
                                  data.updateTime
                                      .toString() ??
                                      ''),
                            ],
                          ),
                        ),
                        CallChatIcons(
                          userId: "${data.patient?.user?.id.toString()}",
                          kaleyraUserId: "${data.patient?.user?.kaleyraUserId.toString()}",
                          name:data.patient?.user?.name,
                          email:data.patient?.user?.email,
                        ),
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
    consultationModel?.appDetails?.forEach((userDetail) {
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
        return Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            ShowProfile(userId: int.parse("${data.patient?.user?.id}"),),
                      ),
                    );
                  },
                  child: CircleAvatar(
                    radius: 3.h,
                    backgroundImage: NetworkImage("${data.patient?.user?.profile.toString()}"),
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.patient?.user?.name ?? "",
                        style: AllListText().headingText(),
                      ),
                      Text(
                        buildTimeDate("${data.appointments?[0].date.toString()}","${data.appointments?[0].slotStartTime.toString()}"),
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
                                "${data.patient?.status.toString()}"),
                            style:
                            AllListText().subHeadingText(),
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
                            "${data.team?.teamMember?[0].user?.name.toString()}",
                            style:
                            AllListText().subHeadingText(),
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
    );
  }

  String buildStatusText(String status) {
    print("status status: $status");

    if (status == "consultation_done") {
      return "Consultation Done";
    } else if (status == "consultation_accepted") {
      return "Accepted (MR & CS Pending)";
    } else if (status == "consultation_rejected") {
      return "Consultation Rejected";
    } else if (status == "consultation_waiting") {
      return "Waiting for Reports";
    } else if (status == "pending") {
      return "Pending";
    } else if (status == "wait") {
      return "Requested for Reports";
    } else if (status == "accepted") {
      return "Accepted (MR & CS Pending)";
    } else if (status == "rejected") {
      return "Consultation Rejected";
    } else if (status == "evaluation_done") {
      return "Evaluation Done";
    } else if (status == "declined") {
      return "Declined";
    } else if (status == "check_user_reports") {
      return "Check User Reports";
    }else if (status == "appointment_booked") {
      return "Pending";
    } else if (status == "report_upload") {
      return "MR Upload";
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

  final CustomerStatusRepo repository = CustomerStatusRepo(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );
}
