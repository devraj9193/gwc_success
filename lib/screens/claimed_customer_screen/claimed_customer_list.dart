import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../model/claimed_customer_model/claimed_customer_list_model.dart';
import '../../model/error_model.dart';
import '../../repository/customer_status_repo.dart/customer_status_repo.dart';
import '../../service/api_service.dart';
import '../../service/customer_status_service/customer_status_service.dart';
import '../../utils/constants.dart';
import '../../widgets/common_screen_widgets.dart';
import '../../widgets/widgets.dart';
import 'package:http/http.dart' as http;

import '../common_ui/call_chat_icons.dart';
import '../common_ui/show_profile.dart';

class ClaimedCustomerList extends StatefulWidget {
  const ClaimedCustomerList({Key? key}) : super(key: key);

  @override
  State<ClaimedCustomerList> createState() => _ClaimedCustomerListState();
}

class _ClaimedCustomerListState extends State<ClaimedCustomerList> {
  final searchController = TextEditingController();

  bool showProgress = false;
  ClaimedCustomerListModel? claimedCustomerListModel;
  List<ClaimedCustomer> searchResults = [];
  final ScrollController _scrollController = ScrollController();

  TabController? tabController;

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
    final result = await customerStatusService.getClaimedCustomerService();
    print("result: $result");

    if (result.runtimeType == ClaimedCustomerListModel) {
      print("Ticket List");
      ClaimedCustomerListModel model = result as ClaimedCustomerListModel;

      claimedCustomerListModel = model;
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
    List<ClaimedCustomer> claimedList = claimedCustomerListModel?.data ?? [];

    return (showProgress)
        ? Center(
      child: buildCircularIndicator(),
    )
        : claimedList.isEmpty
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
              itemCount: claimedList.length,
              itemBuilder: ((context, index) {
                var data = claimedList[index];
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
                                      userId:
                                      int.parse("${data.id}"),
                                    ),
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
                              Row(
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
                            ],
                          ),
                        ),
                        CallChatIcons(
                          userId: data.id.toString(),
                          kaleyraUserId:
                          data.kaleyraUserId.toString(),
                          name:data.name,email:data.email,
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
    claimedCustomerListModel?.data?.forEach((userDetail) {
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
                  onTap: () {
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
                CallChatIcons(
                  userId: data.id.toString(),
                  kaleyraUserId: data.kaleyraUserId.toString(),
                  name:data.name,email:data.email,
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

  final CustomerStatusRepo repository = CustomerStatusRepo(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );
}
