import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gwc_success_team/screens/ticket_raise_screens/raise_a_ticket.dart';
import 'package:gwc_success_team/screens/ticket_raise_screens/ticket_chat_screen.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

import '../../../model/error_model.dart';
import '../../../model/uvDesk_model/get_ticket_list_model.dart';
import '../../../repository/uvDesk_repo/uvDesk_repository.dart';
import '../../../service/api_service.dart';
import '../../../service/uvDesk_service/uvDesk_service.dart';
import '../../../utils/constants.dart';
import '../../../widgets/common_screen_widgets.dart';
import '../../../widgets/widgets.dart';
import '../../utils/gwc_api.dart';
import '../../utils/success_member_storage.dart';
import 'my_ticket_list.dart';
import 'package:lazy_loading_list/lazy_loading_list.dart';

class AllTicketListScreen extends StatefulWidget {
  const AllTicketListScreen({Key? key}) : super(key: key);

  @override
  State<AllTicketListScreen> createState() => _AllTicketListScreenState();
}

class _AllTicketListScreenState extends State<AllTicketListScreen>
    with SingleTickerProviderStateMixin {
  final _prefs = GwcApi.preferences;

  TabController? tabController;
  final searchController = TextEditingController();
  List<Tickets> searchResults = [];
  bool isOpenStatus = false;
  bool isResolvedStatus = false;
  bool isTransferredStatus = false;

  int allTicketCount = 0;

  bool showProgress = false;
  GetTicketListModel? getTicketListModel;

  final ScrollController _scrollController = ScrollController();

  late final UvDeskService _uvDeskService =
      UvDeskService(uvDeskRepo: repository);

  getTickets() async {
    setState(() {
      showProgress = true;
    });
    callProgressStateOnBuild(true);
    final result = await _uvDeskService.getAllListService();
    print("result: $result");

    if (result.runtimeType == GetTicketListModel) {
      print("Ticket List");
      GetTicketListModel model = result as GetTicketListModel;

      getTicketListModel = model;

      int? count = getTicketListModel?.tickets?.length;

      setState(() {
        allTicketCount = count!;
        print("allTicketCount: $allTicketCount");
      });
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
  void initState() {
    super.initState();
    getTickets();
    tabController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );
    _scrollController.addListener(() {
      print("scroll offset");
      print(_scrollController.position.maxScrollExtent == _scrollController.offset);
      if(_scrollController.position.maxScrollExtent == _scrollController.offset){
        _loadMore();
      }
    });
  }

  bool _hasMore = true;
  _loadMore(){
    if(_fetchedTickets.length != _allTickets.length){
      if(start+perLoad > _allTickets.length){
        _fetchedTickets.addAll(_allTickets.getRange(start, _allTickets.length));
        start = start + (_allTickets.length-start);
      }
      else{
        _fetchedTickets.addAll(_allTickets.getRange(start, perLoad));
        start = start + perLoad;
      }
    }
    else{
      _hasMore = false;
    }
    Future.delayed(Duration.zero).whenComplete(() {
      setState(() {

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
        appBar: AppBar(
            backgroundColor: gWhiteColor,
            centerTitle: false,
            automaticallyImplyLeading: false,
            elevation: 0,
            title: Row(
              children: [
                // GestureDetector(
                //   onTap: () {
                //     Navigator.pop(context);
                //   },
                //   child: Icon(
                //     Icons.arrow_back_ios_new_sharp,
                //     color: gSecondaryColor,
                //     size: 2.h,
                //   ),
                // ),
                // SizedBox(width: 2.w),
                SizedBox(
                  height: 5.h,
                  child: const Image(
                    image: AssetImage("assets/images/Gut wellness logo.png"),
                  ),
                ),
              ],
            ),
            actions: [
              GestureDetector(
                child: const Icon(
                  Icons.add,
                  color: gHintTextColor,
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const RaiseATicket())).then((value) {
                    if (true) {
                      setState(() {});
                    }
                  });
                },
              ),
              SizedBox(width: 2.w),
            ]),
        backgroundColor: whiteTextColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 0.h),
            TabBar(
                controller: tabController,
                labelColor: tapSelectedColor,
                padding: EdgeInsets.symmetric(horizontal: 0.w),
                unselectedLabelColor: tapUnSelectedColor,
                labelStyle: TabBarText().selectedText(),
                unselectedLabelStyle: TabBarText().unSelectedText(),
                isScrollable: false,
                indicatorColor: tapIndicatorColor,
                labelPadding: EdgeInsets.only(
                    right: 0.w, left: 0.w, top: 1.h, bottom: 1.h),
                indicatorPadding: EdgeInsets.only(right: 0.w),
                tabs: [
                  buildTapCount('All', allTicketCount),
                  const Text('My Tickets'),
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
                  buildAllTickets(context),
                  const MyTicketListScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildAllTickets(BuildContext context) {
    List<Tickets> tickets = getTicketListModel?.tickets ?? [];

    return (showProgress)
        ? Center(
            child: buildCircularIndicator(),
          )
        : tickets.isEmpty
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
                    child: searchController.text.isEmpty
                        ? buildUI(context)
                        : buildSearchList(),
                  ),
                ],
              );
  }

  int start = 0;
  int perLoad = 10;

  List<Tickets> _allTickets = [];
  List<Tickets> _fetchedTickets = [];

  Widget buildUI(BuildContext context) {
    _allTickets.clear();
    List<Tickets> tickets = getTicketListModel?.tickets ?? [];
    _allTickets.addAll(tickets);

    if(_fetchedTickets.length != _allTickets.length){
      if(start+perLoad > _allTickets.length){
        _fetchedTickets.addAll(_allTickets. getRange(start, _allTickets.length));
        start = start + (_allTickets.length-start);
      }
      else{
        _fetchedTickets.addAll(_allTickets.getRange(start, perLoad));
        start = start + perLoad;
      }
    }

    if(tickets.isEmpty){
      return Center(
        child: Text("Click On '+' Icon to Raise a Ticket",
          style: TextStyle(
              fontSize: fontSize08,
              fontFamily: kFontBold
          ),),
      );
    }
    else{
      return buildList(tickets);
    }
  }

  buildList(List<Tickets> tickets) {
    return ListView.builder(
      shrinkWrap: true,
      controller: _scrollController,
      itemCount: _fetchedTickets.length + 1,
      itemBuilder: (context, index) {
        // Tickets currentTicket = tickets[index];
         if(index < _fetchedTickets.length){
          Tickets currentTicket = _fetchedTickets[index];
          return LazyLoadingList(
            initialSizeOfItems: 4,
            loadMore: () => Center(
              child: buildThreeBounceIndicator(),
            ),
            index: index,
            hasMore: true,
            child: Material(
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => TicketChatScreen(
                        userName: currentTicket.customer?.name ?? '',
                        userEmail: currentTicket.customer?.email ?? '',
                        thumpNail: currentTicket.customer?.smallThumbnail ?? '',
                        ticketId: currentTicket.id.toString(),
                        agentId: currentTicket.agent?.id.toString(),
                        subject: currentTicket.subject ?? '',
                        incrementId: currentTicket.id.toString(),
                        isAllTicket: true,
                        isClosed:
                        buildIsOpenStatus("${currentTicket.status?.code}"),
                        isResolved: buildIsResolvedStatus(
                            "${currentTicket.status?.code}"),
                        isTransferred:
                        buildIsTransferredStatus("${currentTicket.group}"),
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
                  margin: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
                  decoration: BoxDecoration(
                    color: (currentTicket.agent?.email ==
                        "${_prefs!.getString(SuccessMemberStorage.successMemberEmail)}")
                        ? kNumberCircleRed.withOpacity(0.3)
                        : gWhiteColor,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: (currentTicket.agent?.email ==
                        "${_prefs!.getString(SuccessMemberStorage.successMemberEmail)}")
                        ? null
                        : [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 5,
                        offset: const Offset(2, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            currentTicket.id.toString(),
                            style: AllListText().otherText(),
                          ),
                          Text(
                            currentTicket.formatedCreatedAt ?? '',
                            style: AllListText().otherText(),
                          ),
                        ],
                      ),
                      SizedBox(height: 0.3.h),
                      (currentTicket.subject != null)
                          ? Text(
                        currentTicket.subject ?? '',
                        style: AllListText().headingText(),
                      )
                          : const SizedBox(),
                      SizedBox(height: 0.3.h),
                      currentTicket.agent?.name == null
                          ? const SizedBox()
                          : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Agent : ",
                            style: AllListText().otherText(),
                          ),
                          Expanded(
                            child: Text(
                              currentTicket.agent?.name ?? '',
                              style: AllListText().subHeadingText(),
                            ),
                          ),
                        ],
                      ),
                      // SizedBox(height: 0.3.h),
                      // Row(
                      //   crossAxisAlignment:
                      //       CrossAxisAlignment.start,
                      //   children: [
                      //     Text(
                      //       "Replied By : ",
                      //       style:
                      //           AllListText().otherText(),
                      //     ),
                      //     Expanded(
                      //       child: Text(
                      //         "currentTicket.lastThreadUserType",
                      //         style: AllListText()
                      //             .subHeadingText(),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // SizedBox(height: 0.3.h),
                      // Text(
                      //   "currentTicket.lastReplyAgentTime",
                      //   style: AllListText().otherText(),
                      // ),
                      SizedBox(height: 0.5.h),
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                currentTicket.customer?.smallThumbnail == null
                                    ? CircleAvatar(
                                  radius: 1.h,
                                  backgroundColor: kNumberCircleRed,
                                  child: Text(
                                    getInitials(
                                        currentTicket.customer?.name ?? '',
                                        2),
                                    style: TextStyle(
                                      fontSize: 7.sp,
                                      fontFamily: "GothamMedium",
                                      color: gWhiteColor,
                                    ),
                                  ),
                                )
                                    : CircleAvatar(
                                  radius: 1.h,
                                  backgroundImage: NetworkImage(
                                    currentTicket
                                        .customer?.smallThumbnail ??
                                        '',
                                  ),
                                ),
                                SizedBox(width: 1.w),
                                Text(
                                  currentTicket.customer?.name ?? '',
                                  style: AllListText().subHeadingText(),
                                  maxLines: 2,
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(width: 3.w),
                                currentTicket.status?.code == "open"
                                    ? Image(
                                  image: const AssetImage(
                                      "assets/images/open-source.png"),
                                  height: 2.h,
                                )
                                    : currentTicket.status?.code == "resolved"
                                    ? Image(
                                  image: const AssetImage(
                                      "assets/images/resolved.png"),
                                  height: 2.h,
                                )
                                    : currentTicket.status?.code == "closed"
                                    ? Image(
                                  image: const AssetImage(
                                      "assets/images/check-list.png"),
                                  height: 2.h,
                                )
                                    : const SizedBox(),
                                SizedBox(width: 1.w),
                                Text(
                                  currentTicket.status?.code ?? '',
                                  style: AllListText().otherText(),
                                ),
                                SizedBox(width: 2.w),
                                Icon(
                                  Icons.circle,
                                  size: 12,
                                  color: currentTicket.priority?.code == "low"
                                      ? kBottomSheetHeadGreen
                                      : currentTicket.priority?.code == "high"
                                      ? kNumberCircleRed
                                      : gWhiteColor,
                                  // AppConfig.fromHex(
                                  //     currentTicket.priority!.color ?? ''),
                                ),
                              ],
                            ),
                          ),
                          currentTicket.isCustomerView == true
                              ? Icon(Icons.check_circle,
                              color: gPrimaryColor, size: 2.h)
                              : Icon(Icons.check, color: gGreyColor, size: 2.h)
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
        else{
          print("else");
          return (_hasMore)
              ? Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Center(child: CupertinoActivityIndicator(color: gSecondaryColor,),),
          )
              : SizedBox();
        }

      },
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
    getTicketListModel?.tickets?.forEach((userDetail) {
      if (userDetail.customer!.name
          .toLowerCase()
          .contains(text.toLowerCase())) {
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
        Tickets currentTicket = searchResults[index];
        return Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
              margin: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
              decoration: BoxDecoration(
                color: (currentTicket.agent?.email ==
                        "${_prefs!.getString(SuccessMemberStorage.successMemberEmail)}")
                    ? kNumberCircleRed.withOpacity(0.3)
                    : gWhiteColor,
                borderRadius: BorderRadius.circular(10),
                boxShadow: (currentTicket.agent?.email ==
                        "${_prefs!.getString(SuccessMemberStorage.successMemberEmail)}")
                    ? null
                    : [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          blurRadius: 5,
                          offset: const Offset(2, 3),
                        ),
                      ],
              ),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => TicketChatScreen(
                        userName: currentTicket.customer?.name ?? '',
                        userEmail: currentTicket.customer?.email ?? '',
                        thumpNail: currentTicket.customer?.smallThumbnail ?? '',
                        ticketId: currentTicket.id.toString(),
                        agentId: currentTicket.agent?.id.toString(),
                        subject: currentTicket.subject ?? '',
                        incrementId: currentTicket.id.toString(),
                        isAllTicket: true,
                        isClosed:
                            buildIsOpenStatus("${currentTicket.status?.code}"),
                        isResolved: buildIsResolvedStatus(
                            "${currentTicket.status?.code}"),
                        isTransferred:
                            buildIsTransferredStatus("${currentTicket.group}"),
                      ),
                    ),
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          currentTicket.id.toString(),
                          style: AllListText().otherText(),
                        ),
                        Text(
                          currentTicket.formatedCreatedAt ?? '',
                          style: AllListText().otherText(),
                        ),
                      ],
                    ),
                    SizedBox(height: 0.3.h),
                    (currentTicket.subject != null)
                        ? Text(
                            currentTicket.subject ?? '',
                            style: AllListText().headingText(),
                          )
                        : const SizedBox(),
                    SizedBox(height: 0.3.h),
                    currentTicket.agent?.name == null
                        ? const SizedBox()
                        : Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Agent : ",
                                style: AllListText().otherText(),
                              ),
                              Expanded(
                                child: Text(
                                  currentTicket.agent?.name ?? '',
                                  style: AllListText().subHeadingText(),
                                ),
                              ),
                            ],
                          ),
                    // SizedBox(height: 0.3.h),
                    // Row(
                    //   crossAxisAlignment:
                    //       CrossAxisAlignment.start,
                    //   children: [
                    //     Text(
                    //       "Replied By : ",
                    //       style:
                    //           AllListText().otherText(),
                    //     ),
                    //     Expanded(
                    //       child: Text(
                    //         "currentTicket.lastThreadUserType",
                    //         style: AllListText()
                    //             .subHeadingText(),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    // SizedBox(height: 0.3.h),
                    // Text(
                    //   "currentTicket.lastReplyAgentTime",
                    //   style: AllListText().otherText(),
                    // ),
                    SizedBox(height: 0.5.h),
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              currentTicket.customer?.smallThumbnail == null
                                  ? CircleAvatar(
                                      radius: 1.h,
                                      backgroundColor: kNumberCircleRed,
                                      child: Text(
                                        getInitials(
                                            currentTicket.customer?.name ?? '',
                                            2),
                                        style: TextStyle(
                                          fontSize: 7.sp,
                                          fontFamily: "GothamMedium",
                                          color: gWhiteColor,
                                        ),
                                      ),
                                    )
                                  : CircleAvatar(
                                      radius: 1.h,
                                      backgroundImage: NetworkImage(
                                        currentTicket
                                                .customer?.smallThumbnail ??
                                            '',
                                      ),
                                    ),
                              SizedBox(width: 1.w),
                              Text(
                                currentTicket.customer?.name ?? '',
                                style: AllListText().subHeadingText(),
                                maxLines: 2,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(width: 3.w),
                              currentTicket.status?.code == "open"
                                  ? Image(
                                      image: const AssetImage(
                                          "assets/images/open-source.png"),
                                      height: 2.h,
                                    )
                                  : currentTicket.status?.code == "resolved"
                                      ? Image(
                                          image: const AssetImage(
                                              "assets/images/resolved.png"),
                                          height: 2.h,
                                        )
                                      : currentTicket.status?.code == "closed"
                                          ? Image(
                                              image: const AssetImage(
                                                  "assets/images/check-list.png"),
                                              height: 2.h,
                                            )
                                          : const SizedBox(),
                              SizedBox(width: 1.w),
                              Text(
                                currentTicket.status?.code ?? '',
                                style: AllListText().otherText(),
                              ),
                              SizedBox(width: 2.w),
                              Icon(
                                Icons.circle,
                                size: 12,
                                color: currentTicket.priority?.code == "low"
                                    ? kBottomSheetHeadGreen
                                    : currentTicket.priority?.code == "high"
                                        ? kNumberCircleRed
                                        : gWhiteColor,
                                // AppConfig.fromHex(
                                //     currentTicket.priority!.color ?? ''),
                              ),
                            ],
                          ),
                        ),
                        currentTicket.isCustomerView == true
                            ? Icon(Icons.check_circle,
                                color: gPrimaryColor, size: 2.h)
                            : Icon(Icons.check, color: gGreyColor, size: 2.h)
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Container(
            //   height: 1,
            //   color: Colors.grey.withOpacity(0.3),
            // ),
          ],
        );
      }),
    );
  }

  final UvDeskRepo repository = UvDeskRepo(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );

  buildIsOpenStatus(String closedStatus) {
    if (closedStatus == "Closed") {
      isOpenStatus = true;
    } else {
      isOpenStatus = false;
    }
    return isOpenStatus;
  }

  buildIsResolvedStatus(String resolvedStatus) {
    if (resolvedStatus == "Resolved") {
      isResolvedStatus = true;
    } else {
      isResolvedStatus = false;
    }
    return isResolvedStatus;
  }

  buildIsTransferredStatus(String transferredStatus) {
    if (transferredStatus == "null") {
      isTransferredStatus = false;
    } else {
      isTransferredStatus = true;
    }
    return isTransferredStatus;
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
}
