import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../model/customers_list_model.dart';
import '../../model/error_model.dart';
import '../../repository/customer_status_repo.dart/customer_status_repo.dart';
import '../../service/api_service.dart';
import '../../service/customer_status_service/customer_status_service.dart';
import '../../utils/constants.dart';
import '../../widgets/common_screen_widgets.dart';
import '../../widgets/customer_list_widgets.dart';
import '../../widgets/widgets.dart';
import '../common_ui/call_chat_icons.dart';
import '../common_ui/show_profile.dart';
import 'customer_status_screen.dart';
import 'package:http/http.dart' as http;

class LinkedCustomerStatus extends StatefulWidget {
  const LinkedCustomerStatus({Key? key}) : super(key: key);

  @override
  State<LinkedCustomerStatus> createState() => _LinkedCustomerStatusState();
}

class _LinkedCustomerStatusState extends State<LinkedCustomerStatus>
    with SingleTickerProviderStateMixin {
  final searchController = TextEditingController();

  int allCustomerListCount = 0;
  bool showProgress = false;
  CustomersList? customersList;
  List<Datum> searchResults = [];
  final ScrollController _scrollController = ScrollController();

  TabController? tabController;

  late final CustomerStatusService customerStatusService =
      CustomerStatusService(customerStatusRepo: repository);

  @override
  void initState() {
    super.initState();
    getAllCustomerCount();
    tabController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );
  }

  getAllCustomerCount() async {
    setState(() {
      showProgress = true;
    });
    callProgressStateOnBuild(true);
    final result = await customerStatusService.getAllCustomerService();
    print("result: $result");

    if (result.runtimeType == CustomersList) {
      print("Ticket List");
      CustomersList model = result as CustomersList;

      customersList = model;

      int? count = customersList?.data.length;

      setState(() {
        allCustomerListCount = count!;
      });
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
  void dispose() async {
    super.dispose();
    tabController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: buildAppBar(() {
          Navigator.pop(context);
        }),
        backgroundColor: whiteTextColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 1.h),
            TabBar(
                controller: tabController,
                labelColor: tapSelectedColor,
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                unselectedLabelColor: tapUnSelectedColor,
                labelStyle: TabBarText().selectedText(),
                unselectedLabelStyle: TabBarText().unSelectedText(),
                isScrollable: false,
                indicatorColor: tapIndicatorColor,
                labelPadding: EdgeInsets.only(
                    right: 7.w, left: 2.w, top: 1.h, bottom: 1.h),
                indicatorPadding: EdgeInsets.only(right: 5.w),
                tabs: [
                  const Text('Linked Customers'),
                  buildTapCount('All Customers', allCustomerListCount),
                ]),
            Container(
              height: 1,
              margin: EdgeInsets.only(left: 0.w, bottom: 1.h),
              color: gGreyColor.withOpacity(0.3),
              width: double.maxFinite,
            ),
            Expanded(
              child: TabBarView(
                  controller: tabController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    const CustomerStatusScreen(),
                    buildAllCustomersList(),
                  ]),
            ),
          ],
        ),
      ),
    );
  }

  buildAllCustomersList() {
    List<Datum> allCustomersList = customersList?.data ?? [];
    return (showProgress)
        ? Center(
            child: buildCircularIndicator(),
          )
        : allCustomersList.isEmpty
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
                              itemCount: allCustomersList.length,
                              itemBuilder: ((context, index) {
                                var data = allCustomersList[index];
                                return Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ShowProfile(
                                                  userId:
                                                      int.parse("${data.id}"),
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
                                                style:
                                                    AllListText().headingText(),
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
                                                style:
                                                    AllListText().otherText(),
                                              ),
                                              // SizedBox(height: 0.5.h),
                                              customerStatusWidget(data.team?.teamPatients?.status ?? ""),
                                              // Row(
                                              //   children: [
                                              //     Text(
                                              //       "Status : ",
                                              //       style: AllListText()
                                              //           .otherText(),
                                              //     ),
                                              //     Text(
                                              //       data.team?.teamPatients
                                              //               ?.status ??
                                              //           "",
                                              //       style: AllListText()
                                              //           .subHeadingText(),
                                              //     ),
                                              //   ],
                                              // ),
                                              Row(
                                                children: [
                                                  Text(
                                                    "Associated Doctor : ",
                                                    style: AllListText()
                                                        .otherText(),
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
                                          kaleyraUserId:
                                              data.kaleyraUserId ?? '',
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
                                      margin:
                                          EdgeInsets.symmetric(vertical: 1.5.h),
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
    customersList?.data.forEach((userDetail) {
      if (userDetail.fname!.toLowerCase().contains(text.toLowerCase()) ||
          userDetail.lname!.toLowerCase().contains(text.toLowerCase())) {
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
                      customerStatusWidget(data.team?.teamPatients?.status ?? ""),
                      // Row(
                      //   children: [
                      //     Text(
                      //       "Status : ",
                      //       style: AllListText().otherText(),
                      //     ),
                      //     Text(
                      //       data.team?.teamPatients?.status ?? "",
                      //       style: AllListText().subHeadingText(),
                      //     ),
                      //   ],
                      // ),
                      Row(
                        children: [
                          Text(
                            "Associated Doctor : ",
                            style: AllListText().otherText(),
                          ),
                          Text(
                            data.team?.teamPatients?.team?.teamMember?[0].user
                                    ?.name ??
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
    );
  }

  final CustomerStatusRepo repository = CustomerStatusRepo(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );
}
