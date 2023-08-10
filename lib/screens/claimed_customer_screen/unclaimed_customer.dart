import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import '../../model/claim_customer_model.dart';
import '../../model/claimed_customer_model/unclaimed_customer_list_model.dart';
import '../../model/error_model.dart';
import '../../repository/customer_status_repo.dart/customer_status_repo.dart';
import '../../service/api_service.dart';
import '../../service/customer_status_service/customer_status_service.dart';
import '../../utils/constants.dart';
import '../../utils/gwc_api.dart';
import '../../widgets/common_screen_widgets.dart';
import 'package:get/get.dart';
import '../../widgets/widgets.dart';
import 'package:http/http.dart' as http;

import '../bottom_bar/dashboard_screen.dart';
import '../common_ui/show_profile.dart';

class UnclaimedCustomer extends StatefulWidget {
  const UnclaimedCustomer({Key? key}) : super(key: key);

  @override
  State<UnclaimedCustomer> createState() => _UnclaimedCustomerState();
}

class _UnclaimedCustomerState extends State<UnclaimedCustomer> {
  ClaimCustomerModel? claimCustomerModel;

  final searchController = TextEditingController();
  var logoutProgressState;
  bool showLogoutProgress = false;

  bool showProgress = false;
  UnClaimedCustomerList? unClaimedCustomerList;
  List<NotClaimedCustomer> searchResults = [];
  final ScrollController _scrollController = ScrollController();

  TabController? tabController;

  late final CustomerStatusService customerStatusService =
      CustomerStatusService(customerStatusRepo: repository);

  @override
  void initState() {
    super.initState();
    getUnClaimedCustomerList();
  }

  getUnClaimedCustomerList() async {
    setState(() {
      showProgress = true;
    });
    callProgressStateOnBuild(true);
    final result = await customerStatusService.getUnClaimedCustomerService();
    print("result: $result");

    if (result.runtimeType == UnClaimedCustomerList) {
      print("Ticket List");
      UnClaimedCustomerList model = result as UnClaimedCustomerList;

      unClaimedCustomerList = model;
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
    return DefaultTabController(
      length: 1,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: false,
            elevation: 0,
            backgroundColor: gWhiteColor,
            title: searchBarTitle,
            actions: [
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
                      searchBarTitle = SizedBox(
                        height: 5.h,
                        child: const Image(
                          image:
                              AssetImage("assets/images/Gut wellness logo.png"),
                        ),
                      );
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
              SizedBox(width: 3.w),
            ],
          ),
          backgroundColor: whiteTextColor,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TabBar(
                  labelColor: tapSelectedColor,
                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                  unselectedLabelColor: tapUnSelectedColor,
                  labelStyle: TabBarText().selectedText(),
                  unselectedLabelStyle: TabBarText().unSelectedText(),
                  isScrollable: true,
                  indicatorColor: tapIndicatorColor,
                  labelPadding: EdgeInsets.only(
                      right: 7.w, left: 2.w, top: 1.h, bottom: 1.h),
                  indicatorPadding: EdgeInsets.only(right: 5.w),
                  tabs: const [
                    Text('Unclaimed Customer'),
                    // Text('Bridged'),
                  ]),
              Container(
                height: 1,
                margin: EdgeInsets.only(left: 0.w, bottom: 1.h),
                color: gGreyColor.withOpacity(0.3),
                width: double.maxFinite,
              ),
              Expanded(
                child: TabBarView(children: [
                  buildUnclaimedCustomer(),
                  // buildBridged(),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildUnclaimedCustomer() {
    List<NotClaimedCustomer> unClaimedList =
        unClaimedCustomerList?.notClaimedCustomer ?? [];

    return (showProgress)
        ? Center(
            child: buildCircularIndicator(),
          )
        : unClaimedList.isEmpty
            ? buildNoData()
            : Column(
                children: [
                  // Padding(
                  //   padding:
                  //   EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
                  //   child: Row(
                  //     // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       Expanded(
                  //         child: searchBarTitle,
                  //       ),
                  //       GestureDetector(
                  //         onTap: () {
                  //           setState(() {
                  //             if (searchIcon.icon == Icons.search) {
                  //               searchIcon = Icon(
                  //                 Icons.close,
                  //                 color: gBlackColor,
                  //                 size: 2.5.h,
                  //               );
                  //               searchBarTitle = buildSearchWidget();
                  //             } else {
                  //               searchIcon = Icon(
                  //                 Icons.search,
                  //                 color: gBlackColor,
                  //                 size: 2.5.h,
                  //               );
                  //               searchBarTitle = const Text('');
                  //               // filteredNames = names;
                  //               searchController.clear();
                  //             }
                  //           });
                  //         },
                  //         child: Container(
                  //           padding: const EdgeInsets.all(5),
                  //           decoration: BoxDecoration(
                  //             color: gWhiteColor,
                  //             shape: BoxShape.circle,
                  //             boxShadow: [
                  //               BoxShadow(
                  //                 color: Colors.grey.withOpacity(0.5),
                  //                 blurRadius: 8,
                  //                 offset: const Offset(2, 3),
                  //               ),
                  //             ],
                  //           ),
                  //           child: searchIcon,
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: searchController.text.isEmpty
                          ? ListView.builder(
                              controller: _scrollController,
                              scrollDirection: Axis.vertical,
                              padding: EdgeInsets.symmetric(horizontal: 1.w),
                              physics: const ScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: unClaimedList.length,
                              itemBuilder: ((context, index) {
                                var data = unClaimedList[index];
                                return Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ShowProfile(
                                                        userId: int.parse(
                                                            "${data.userId}")),
                                              ),
                                            );
                                          },
                                          child: CircleAvatar(
                                            radius: 3.h,
                                            backgroundColor: kNumberCircleRed,
                                            child: Text(
                                              getInitials("${data.name}", 2),
                                              style: TextStyle(
                                                fontSize: 10.sp,
                                                fontFamily: "GothamBold",
                                                color: gWhiteColor,
                                              ),
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
                                                data.name ?? "",
                                                style:
                                                    AllListText().headingText(),
                                              ),
                                              Text(
                                                "${data.age ?? ""} ${data.gender ?? ""}",
                                                style: AllListText()
                                                    .subHeadingText(),
                                              ),
                                              data.signupDate == null ? const SizedBox() : Row(
                                                children: [
                                                  Text(
                                                    "Sign up Date : ",
                                                    style: AllListText()
                                                        .otherText(),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      data.signupDate ?? "",
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: AllListText()
                                                          .subHeadingText(),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    "Status : ",
                                                    style: AllListText()
                                                        .otherText(),
                                                  ),
                                                  Text(
                                                    data.patient?.status ?? "",
                                                    style: AllListText()
                                                        .subHeadingText(),
                                                  ),
                                                  SizedBox(width: 1.w),
                                                  buildIconStatus("${data.patient?.status}")
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            claimDialog(
                                              data.userId.toString(),
                                            );
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 1.h, horizontal: 2.w),
                                            decoration: BoxDecoration(
                                              color: gSecondaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Center(
                                              child: Text(
                                                'Claim',
                                                style: TextStyle(
                                                  fontFamily: fontMedium,
                                                  color: gWhiteColor,
                                                  fontSize: fontSize08,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
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

  buildIconStatus(String status) {
    print("status : $status");
    if (status == "appointment_booked") {
      return Icon(
        Icons.info_sharp,
        color: gSecondaryColor,
        size: 2.h,
      );
    } else{
      return const SizedBox();
    }
  }


  Icon searchIcon = Icon(
    Icons.search,
    color: gBlackColor,
    size: 2.5.h,
  );
  Widget searchBarTitle = SizedBox(
    height: 5.h,
    child: const Image(
      image: AssetImage("assets/images/Gut wellness logo.png"),
    ),
  );

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
        margin: EdgeInsets.only(right: 1.w),
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
    unClaimedCustomerList?.notClaimedCustomer?.forEach((userDetail) {
      if (userDetail.name!.toLowerCase().contains(text.toLowerCase())) {
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
                            ShowProfile(userId: int.parse("${data.userId}")),
                      ),
                    );
                  },
                  child: CircleAvatar(
                    radius: 3.h,
                    backgroundColor: kNumberCircleRed,
                    child: Text(
                      getInitials("${data.name}", 2),
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontFamily: "GothamBold",
                        color: gWhiteColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.name ?? "",
                        style: AllListText().headingText(),
                      ),
                      Text(
                        "${data.age ?? ""} ${data.gender ?? ""}",
                        style: AllListText().subHeadingText(),
                      ),
                      Row(
                        children: [
                          Text(
                            "Sign up Date : ",
                            style: AllListText().otherText(),
                          ),
                          Expanded(
                            child: Text(
                              data.signupDate ?? "",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AllListText().subHeadingText(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    claimDialog(
                      data.userId.toString(),
                    );
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.w),
                    decoration: BoxDecoration(
                      color: gSecondaryColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                      child: Text(
                        'Claim',
                        style: TextStyle(
                          fontFamily: fontMedium,
                          color: gWhiteColor,
                          fontSize: fontSize08,
                        ),
                      ),
                    ),
                  ),
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

  static String getInitials(String string, int limitTo) {
    var buffer = StringBuffer();
    var wordList = string.trim().split(' ');

    if (string.isEmpty) {
      return string;
    }

    if (wordList.length <= 1) {
      return string.characters.first;
    }

    if (limitTo > wordList.length) {
      for (var i = 0; i < wordList.length; i++) {
        buffer.write(wordList[i][0]);
      }
      return buffer.toString();
    }

    // Handle all other cases
    for (var i = 0; i < (limitTo); i++) {
      buffer.write(wordList[i][0]);
    }
    return buffer.toString();
  }

  claimDialog(String userId) {
    return showDialog(
      context: context,
      builder: (context) => StatefulBuilder(builder: (_, setstate) {
        logoutProgressState = setstate;
        return AlertDialog(
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15.0.sp),
            ),
          ),
          contentPadding: EdgeInsets.only(top: 1.h),
          content: Container(
            // margin: EdgeInsets.symmetric(horizontal: 5.w),
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
            decoration: BoxDecoration(
              color: gWhiteColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: lightTextColor, width: 1),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Are you sure?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: fontBold,
                      color: newBlackColor,
                      fontSize: fontSize11),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 2.h),
                  height: 1,
                  color: lightTextColor,
                ),
                Text(
                  'Do you want to Claim?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: fontBook,
                      color: newBlackColor,
                      fontSize: fontSize10),
                ),
                SizedBox(height: 3.h),
                showLogoutProgress
                    ? buildCircularIndicator()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              customersCall(userId);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 6.w, vertical: 1.h),
                              decoration: BoxDecoration(
                                color: gSecondaryColor,
                                borderRadius: BorderRadius.circular(5),
                                // border: Border.all(color: gMainColor),
                              ),
                              child: Text(
                                "Yes",
                                style: TextStyle(
                                  color: whiteTextColor,
                                  fontFamily: fontMedium,
                                  fontSize: fontSize09,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 5.w),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop(false);
                            },
                            child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 6.w, vertical: 1.h),
                                decoration: BoxDecoration(
                                  color: gWhiteColor,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: lightTextColor),
                                ),
                                child: Text("No",
                                    style: TextStyle(
                                      color: newBlackColor,
                                      fontFamily: fontMedium,
                                      fontSize: fontSize09,
                                    ))),
                          ),
                        ],
                      ),
                SizedBox(height: 1.h)
              ],
            ),
          ),
        );
      }),
    );
  }

  customersCall(String userId) async {
    logoutProgressState(() {
      showLogoutProgress = true;
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString("token")!;

    final response = await http
        .get(Uri.parse("${GwcApi.claimCustomerApiUrl}/$userId"), headers: {
      'Authorization': 'Bearer $token',
    });
    print("Claim Customer Response:${response.body}");
    print("Claim Customer Url:${GwcApi.callApiUrl}/$userId");
    print("Claim Customer UserId:$userId");

    Map<String, dynamic> responseData = jsonDecode(response.body);
    claimCustomerModel = ClaimCustomerModel.fromJson(responseData);

    if (response.statusCode == 200) {
      logoutProgressState(() {
        showLogoutProgress = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: gPrimaryColor,
          // margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
          // padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
          content: Text("${claimCustomerModel?.message}"),
        ),
      );
      // Navigator.pop(context);
      Get.to(
        () => const DashboardScreen(),
      );
    } else {
      logoutProgressState(() {
        showLogoutProgress = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: gSecondaryColor,
          // margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
          // padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
          content: Text("${claimCustomerModel?.message}"),
        ),
      );
      throw Exception();
    }
  }

  final CustomerStatusRepo repository = CustomerStatusRepo(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );
}
