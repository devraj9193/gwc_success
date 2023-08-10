import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/multipart/multipart_file.dart';
import 'package:gwc_success_team/screens/ticket_raise_screens/re_open_ticket.dart';
import 'package:gwc_success_team/screens/ticket_raise_screens/ticket_pop_up_menu.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lazy_loading_list/lazy_loading_list.dart';
import 'package:sizer/sizer.dart';
import 'package:grouped_list/grouped_list.dart';
import '../../../model/error_model.dart';
import '../../../model/uvDesk_model/get_ticket_threads_list_model.dart';
import '../../../model/uvDesk_model/sent_reply_model.dart';
import '../../../repository/uvDesk_repo/uvDesk_repository.dart';
import '../../../service/api_service.dart';
import '../../../service/uvDesk_service/uvDesk_service.dart';
import '../../../utils/constants.dart';
import '../../../utils/gwc_api.dart';
import '../../../widgets/common_screen_widgets.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart'
    hide ImageSource;

import '../../../widgets/widgets.dart';
import '../../model/uvDesk_model/get_doctor_details_model.dart';
import '../../utils/success_member_storage.dart';
import 'attachments_view_screen.dart';

class TicketChatScreen extends StatefulWidget {
  final String userName;
  final String userEmail;
  final String thumpNail;
  final String ticketId;
  final String subject;
  final String incrementId;
  final String? agentId;
  final bool isAllTicket;
  final bool isTransferred;
  final bool isClosed;
  final bool isResolved;
  const TicketChatScreen({
    Key? key,
    required this.userName,
    required this.thumpNail,
    required this.ticketId,
    required this.subject,
    this.agentId,
    required this.incrementId,
    this.isAllTicket = false,
    this.isTransferred = false,
    this.isClosed = false,
    this.isResolved = false,
    required this.userEmail,
  }) : super(key: key);

  @override
  State<TicketChatScreen> createState() => _TicketChatScreenState();
}

class _TicketChatScreenState extends State<TicketChatScreen>
    with WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _prefs = GwcApi.preferences;

  TextEditingController commentController = TextEditingController();
  bool showProgress = false;
  bool isLoading = false;
  ThreadsListModel? threadsListModel;
  GetDoctorDetailsModel? getDoctorDetailsModel;
  List<Thread>? threadList;
  final String imageBaseUrl = "https://support.gutandhealth.com/public";
  String associatedDoctorName = "";

  late final UvDeskService _uvDeskService =
      UvDeskService(uvDeskRepo: repository);

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    commentController.addListener(() {
      setState(() {});
    });
    getThreadsList();
    getDoctorDetails();
    _scrollController.addListener(() {
      print("scroll offset");
      print(_scrollController.position.maxScrollExtent ==
          _scrollController.offset);
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.offset) {
        _loadMore();
      }
    });
  }

  bool _hasMore = true;
  _loadMore() {
    if (_fetchedTickets.length != _allTickets.length) {
      if (start + perLoad > _allTickets.length) {
        _fetchedTickets.addAll(_allTickets.getRange(start, _allTickets.length));
        start = start + (_allTickets.length - start);
      } else {
        _fetchedTickets.addAll(_allTickets.getRange(start, perLoad));
        start = start + perLoad;
      }
    } else {
      _hasMore = false;
    }
    Future.delayed(Duration.zero).whenComplete(() {
      setState(() {});
    });
  }

  getThreadsList() async {
    setState(() {
      showProgress = true;
    });
    callProgressStateOnBuild(true);
    final result =
        await _uvDeskService.uvDaskTicketThreadsService(widget.ticketId);
    print("result: $result");

    if (result.runtimeType == ThreadsListModel) {
      print("Threads List");
      ThreadsListModel model = result as ThreadsListModel;
      threadsListModel = model;
      threadList = model.ticket.threads;
      print("threads List : $threadList");
    } else {
      ErrorModel model = result as ErrorModel;
      print("error: ${model.message}");
    }
    setState(() {
      showProgress = false;
    });
    print(result);
  }

  getDoctorDetails() async {
    final result =
        await _uvDeskService.getDoctorDetailsService(widget.userEmail);
    print("result: $result");

    if (result.runtimeType == GetDoctorDetailsModel) {
      print("Threads List");
      GetDoctorDetailsModel model = result as GetDoctorDetailsModel;
      getDoctorDetailsModel = model;
      print("getDoctorDetailsModel : $getDoctorDetailsModel");

      setState(() {
        associatedDoctorName =
            getDoctorDetailsModel?.message?.team?.teamMember?[0].user?.email ??
                '';
        print("associatedDoctorName : $associatedDoctorName");
      });
    } else {
      ErrorModel model = result as ErrorModel;
      print("error: ${model.message}");
    }
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
    return Scaffold(
      backgroundColor: gWhiteColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 1.h, left: 2.w, right: 4.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () async {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: EdgeInsets.only(top: 0.5.h),
                      child: const Icon(
                        Icons.arrow_back_ios,
                        color: gSecondaryColor,
                      ),
                    ),
                  ),
                  widget.thumpNail.isEmpty
                      ? CircleAvatar(
                          radius: 2.h,
                          backgroundColor: kNumberCircleRed,
                          child: Text(
                            getInitials(widget.userName, 2),
                            style: TextStyle(
                              fontSize: 8.sp,
                              fontFamily: "GothamBold",
                              color: gWhiteColor,
                            ),
                          ),
                        )
                      : CircleAvatar(
                          radius: 2.h,
                          backgroundImage: NetworkImage(widget.thumpNail),
                        ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.userName,
                          style: AllListText().headingText(),
                        ),
                        Text(
                          widget.ticketId,
                          style: AllListText().subHeadingText(),
                        ),
                        Text(
                          widget.subject,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AllListText().otherText(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 1.h),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 1.h),
                width: double.maxFinite,
                decoration: BoxDecoration(
                  color: gBackgroundColor,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 5,
                      color: Colors.grey.withOpacity(0.5),
                    ),
                  ],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: RawScrollbar(
                          thumbVisibility: false,
                          thickness: 3,
                          controller: _scrollController,
                          radius: const Radius.circular(3),
                          thumbColor: gMainColor,
                          child: showProgress
                              ? buildCircularIndicator()
                              : threadsListModel?.ticket.threads == null
                                  ? Center(
                                      child: Text(
                                        "Thread List Is Empty",
                                        style: AllListText().headingText(),
                                      ),
                                    )
                                  : buildUI(context)
                          // buildMessageList(
                          //             threadsListModel!.ticket.threads),
                          // StreamBuilder(
                          //   stream: _uvDeskService.stream.asBroadcastStream(),
                          //   builder: (_, snapshot) {
                          //     print("snap.data: ${snapshot.data}");
                          //     if (snapshot.hasData) {
                          //       return buildMessageList();
                          //     } else if (snapshot.hasError) {
                          //       return Center(
                          //         child: Text(snapshot.error.toString()),
                          //       );
                          //     }
                          //     return const Center(
                          //       child: CircularProgressIndicator(),
                          //     );
                          //   },
                          // ),
                          ),
                    ),
                    widget.isClosed
                        ? Center(
                            child: ReOpenTicket(
                              ticketId: widget.ticketId,
                              status: 'status',
                              value: '1',
                            ),
                          )
                        : _buildEnterMessageRow(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnterMessageRow() {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (fileFormatList.isNotEmpty)
            Flexible(
                child: SizedBox(
              height: 70,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: fileFormatList.length,
                  itemBuilder: (_, index) {
                    return _imageListView(fileFormatList[index], index);
                  }),
            )),
          Row(
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 3.w, top: 0.5.h),
                  // padding: EdgeInsets.symmetric(horizontal: 2.w),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 10,
                      ),
                    ],
                    color: gWhiteColor,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Form(
                    key: _scaffoldKey,
                    child: TextFormField(
                      cursorColor: gSecondaryColor,
                      controller: commentController,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        // hintText: "Say Something ...",
                        alignLabelWithHint: true,
                        hintStyle: TextStyle(
                          color: gMainColor,
                          fontSize: 10.sp,
                          fontFamily: "GothamBook",
                        ),
                        border: InputBorder.none,
                        prefixIcon: InkWell(
                          onTap: () {},
                          child: const Icon(
                            Icons.sentiment_satisfied_alt_sharp,
                            color: gBlackColor,
                          ),
                        ),
                        suffixIcon: InkWell(
                          onTap: () {
                            showChooserSheet();
                          },
                          child: const Icon(
                            Icons.attach_file_sharp,
                            color: gBlackColor,
                          ),
                        ),
                      ),
                      style: TextStyle(
                          fontFamily: "GothamBook",
                          color: gBlackColor,
                          fontSize: 10.sp),
                      maxLines: 3,
                      minLines: 1,
                      textInputAction: TextInputAction.none,
                      textAlign: TextAlign.start,
                      keyboardType: TextInputType.text,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 2.w),
              commentController.text.toString().isEmpty
                  ? TicketPopUpMenu(
                      ticketId: widget.ticketId,
                      incrementId: widget.incrementId,
                      isAllTicket: widget.isAllTicket,
                      isTransferred: widget.isTransferred,
                      isResolved: widget.isResolved,
                      agentId: widget.agentId,
                      associatedDoctorName: associatedDoctorName,
                    )
                  : GestureDetector(
                      onTap: () {
                        ticketRaise();
                        // final message = Message(
                        //     text: commentController.text.toString(),
                        //     date: DateTime.now(),
                        //     sendMe: true,
                        //     image:
                        //         "assets/images/closeup-content-attractive-indian-business-lady.png");
                        setState(() {
                          // messages.add(message);
                        });
                        commentController.clear();
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 2.w),
                        padding: const EdgeInsets.only(
                            left: 8, right: 5, top: 5, bottom: 6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(1),
                              blurRadius: 10,
                              offset: const Offset(2, 5),
                            ),
                          ],
                          color: gSecondaryColor,
                        ),
                        child: Icon(
                          Icons.send,
                          color: gWhiteColor,
                          size: 2.5.h,
                        ),
                      ),
                    ),
            ],
          ),
        ],
      ),
    );
  }

  _imageListView(File loc, int index) {
    return Stack(
      children: [
        Container(
          height: 65,
          width: 80,
          decoration:
              BoxDecoration(image: DecorationImage(image: FileImage(loc))),
        ),
        Positioned(
            top: 2,
            right: 2,
            child: IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                setState(() {
                  fileFormatList.removeAt(index);
                });
              },
            ))
      ],
    );
  }

  int start = 0;
  int perLoad = 5;

  List<Thread> _allTickets = [];
  List<Thread> _fetchedTickets = [];

  Widget buildUI(BuildContext context) {
    _allTickets.clear();
    List<Thread> tickets = threadsListModel?.ticket.threads ?? [];
    _allTickets.addAll(tickets);

    if (_fetchedTickets.length != _allTickets.length) {
      if (start + perLoad > _allTickets.length) {
        _fetchedTickets.addAll(_allTickets.getRange(start, _allTickets.length));
        start = start + (_allTickets.length - start);
      } else {
        _fetchedTickets.addAll(_allTickets.getRange(start, perLoad));
        start = start + perLoad;
      }
    }

    if (tickets.isEmpty) {
      return Center(
        child: Text(
          "Click On '+' Icon to Raise a Ticket",
          style: TextStyle(fontSize: fontSize08, fontFamily: kFontBold),
        ),
      );
    } else {
      return buildList(tickets);
    }
  }

  buildList(List<Thread> tickets) {
    return ListView.builder(
      shrinkWrap: true,
      controller: _scrollController,
      itemCount: _fetchedTickets.length + 1,
      itemBuilder: (context, index) {
        // Tickets currentTicket = tickets[index];
        if (index < _fetchedTickets.length) {
          Thread message = _fetchedTickets[index];
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            child: LazyLoadingList(
              initialSizeOfItems: 4,
              loadMore: () => Center(
                child: buildThreeBounceIndicator(),
              ),
              index: index,
              hasMore: true,
              child: Material(
                child: Column(
                  crossAxisAlignment: message.user?.id ==
                          "${_prefs!.getString(SuccessMemberStorage.successMemberUvId)}"
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      // overflow: Overflow.visible,
                      // clipBehavior: Clip.none,
                      children: [
                        IntrinsicWidth(
                          child: Container(
                            padding: EdgeInsets.only(
                                left: 2.w, right: 2.w, bottom: 1.h, top: 1.h),
                            constraints: BoxConstraints(maxWidth: 70.w),
                            margin: message.user?.id ==
                                    "${_prefs!.getString(SuccessMemberStorage.successMemberUvId)}"
                                ? EdgeInsets.only(
                                    top: 0.5.h, bottom: 0.5.h, left: 20.w)
                                : EdgeInsets.only(
                                    top: 0.5.h, bottom: 0.5.h, right: 20.w),
                            // padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.5.h),
                            decoration: BoxDecoration(
                              color: message.user?.id ==
                                      "${_prefs!.getString(SuccessMemberStorage.successMemberUvId)}"
                                  ? gWhiteColor
                                  : (message.createdBy == "customer")
                                      ? kNumberCircleRed
                                      : gChatMeColor,
                              boxShadow: message.user?.id ==
                                      "${_prefs!.getString(SuccessMemberStorage.successMemberUvId)}"
                                  ? [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.3),
                                        offset: const Offset(2, 4),
                                        blurRadius: 10,
                                      ),
                                    ]
                                  : [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.3),
                                        offset: const Offset(2, 4),
                                        blurRadius: 10,
                                      ),
                                    ],
                              borderRadius: BorderRadius.only(
                                topLeft: message.user?.id ==
                                        "${_prefs!.getString(SuccessMemberStorage.successMemberUvId)}"
                                    ? const Radius.circular(15)
                                    : const Radius.circular(0),
                                topRight: const Radius.circular(15),
                                bottomLeft: const Radius.circular(15),
                                bottomRight: message.user?.id ==
                                        "${_prefs!.getString(SuccessMemberStorage.successMemberUvId)}"
                                    ? const Radius.circular(0)
                                    : const Radius.circular(15),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: HtmlWidget(
                                    message.user?.name ?? '',
                                    textStyle: AllListText().otherText(),
                                  ),
                                ),
                                SizedBox(height: 0.5.h),
                                (message.attachments != null)
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ...?message.attachments?.map(
                                            (e) => InkWell(
                                                onTap: () {
                                                  buildAttachmentView(
                                                      imageBaseUrl + e.relativePath!);
                                                },
                                                child: Padding(
                                                  padding:  EdgeInsets.symmetric(vertical: 1.h),
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(10.0),
                                                    child: Image(
                                                      image: NetworkImage(
                                                          imageBaseUrl + e.relativePath!),
                                                      fit: BoxFit.contain,
                                                      height: 15.h,
                                                    ),
                                                  ),
                                                )
                                              // child: Align(
                                              //   alignment: Alignment.topLeft,
                                              //   child: Container(
                                              //     constraints: const BoxConstraints(
                                              //       maxHeight: 120,maxWidth: 70,
                                              //     ),
                                              //     decoration: BoxDecoration(
                                              //         image: DecorationImage(
                                              //             image: NetworkImage(
                                              //                 imageBaseUrl +
                                              //                     e.relativePath!),
                                              //             fit: BoxFit.contain)),
                                              //     // child: Image.network(imageBaseUrl+e.relativePath! ?? ''),
                                              //   ),
                                              // ),
                                            )
                                            //     Container(
                                            //   constraints: BoxConstraints(
                                            //     maxHeight: 120,
                                            //   ),
                                            //   decoration: BoxDecoration(
                                            //       image: DecorationImage(
                                            //           image: NetworkImage(
                                            //               imageBaseUrl +
                                            //                   e.relativePath!),
                                            //           fit: BoxFit.fill)),
                                            //   // child: Image.network(imageBaseUrl+e.relativePath! ?? ''),
                                            // ),
                                          ),
                                          SizedBox(height: 0.5.h),
                                          HtmlWidget(
                                            message.message ?? "",
                                            textStyle: TextStyle(
                                              color:
                                                  message.createdBy == "agent"
                                                      ? (message.cc != null)
                                                          ? gWhiteColor
                                                          : gTextColor
                                                      : gWhiteColor,
                                            ),
                                          )
                                        ],
                                      )
                                    : Align(
                                        alignment: Alignment.topLeft,
                                        child: HtmlWidget(
                                          message.message ?? '',
                                          textStyle:
                                              AllListText().subHeadingText(),
                                        ),
                                      ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: HtmlWidget(
                                    message.createdAt ?? '',
                                    textStyle: AllListText().otherText(),
                                  ),
                                  // Text(
                                  //   message.createdAt,
                                  //   style: AllListText().otherText(),
                                  // ),
                                ),
                                // Align(
                                //   alignment: Alignment.bottomRight,
                                //   child: Padding(
                                //     padding: EdgeInsets.only(top: 0.5.h),
                                //     child: Row(
                                //       mainAxisSize: MainAxisSize.min,
                                //       mainAxisAlignment:
                                //           MainAxisAlignment.spaceBetween,
                                //       children: _buildNameTimeHeader(message),
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        } else {
          print("else");
          return (_hasMore)
              ? Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                    child: CupertinoActivityIndicator(
                      color: gSecondaryColor,
                    ),
                  ),
                )
              : SizedBox();
        }
      },
    );
  }

  buildMessageList(List<Thread> threads) {
    print("threads : ${_fetchedTickets.length}");
    return GroupedListView<Thread, DateTime>(
      elements: _fetchedTickets,
      order: GroupedListOrder.ASC,
      reverse: false,
      floatingHeader: true,
      useStickyGroupSeparators: true,
      padding: EdgeInsets.symmetric(horizontal: 2.w),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      groupBy: (Thread message) {
        // final f = DateFormat(message.formatedCreatedAt.toString());
        // DateTime d = DateTime.parse(message.formatedCreatedAt.toString());
        return DateTime(2023, 7, 17);
      },
      // padding: EdgeInsets.symmetric(horizontal: 0.w),
      groupHeaderBuilder: (Thread message) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 7, bottom: 7),
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
            decoration: const BoxDecoration(
              color: Color(0xffd9e3f7),
              borderRadius: BorderRadius.all(
                Radius.circular(11),
              ),
            ),
            child: Text(
              "Today",
              // _buildHeaderDate(int.parse(message.formatedCreatedAt.toString())),
              style: TextStyle(
                fontFamily: "GothamBook",
                color: gBlackColor,
                fontSize: 8.sp,
              ),
            ),
          ),
        ],
      ),
      itemBuilder: (context, Thread message) => Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Container(
          //     child: message.isIncoming
          //         ? _generateAvatarFromName(message.senderName)
          //         : null),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Column(
                crossAxisAlignment: message.user?.id ==
                        "${_prefs!.getString(SuccessMemberStorage.successMemberUvId)}"
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    // overflow: Overflow.visible,
                    // clipBehavior: Clip.none,
                    children: [
                      IntrinsicWidth(
                        child: Container(
                          padding: EdgeInsets.only(
                              left: 2.w, right: 2.w, bottom: 1.h, top: 1.h),
                          constraints: BoxConstraints(maxWidth: 70.w),
                          margin: message.user?.id ==
                                  "${_prefs!.getString(SuccessMemberStorage.successMemberUvId)}"
                              ? EdgeInsets.only(
                                  top: 0.5.h, bottom: 0.5.h, left: 20.w)
                              : EdgeInsets.only(
                                  top: 0.5.h, bottom: 0.5.h, right: 20.w),
                          // padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.5.h),
                          decoration: BoxDecoration(
                            color: message.user?.id ==
                                    "${_prefs!.getString(SuccessMemberStorage.successMemberUvId)}"
                                ? gWhiteColor
                                : (message.createdBy == "customer")
                                    ? kNumberCircleRed
                                    : gChatMeColor,
                            boxShadow: message.user?.id ==
                                    "${_prefs!.getString(SuccessMemberStorage.successMemberUvId)}"
                                ? [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      offset: const Offset(2, 4),
                                      blurRadius: 10,
                                    ),
                                  ]
                                : [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      offset: const Offset(2, 4),
                                      blurRadius: 10,
                                    ),
                                  ],
                            borderRadius: BorderRadius.only(
                              topLeft: message.user?.id ==
                                      "${_prefs!.getString(SuccessMemberStorage.successMemberUvId)}"
                                  ? const Radius.circular(15)
                                  : const Radius.circular(0),
                              topRight: const Radius.circular(15),
                              bottomLeft: const Radius.circular(15),
                              bottomRight: message.user?.id ==
                                      "${_prefs!.getString(SuccessMemberStorage.successMemberUvId)}"
                                  ? const Radius.circular(0)
                                  : const Radius.circular(15),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: HtmlWidget(
                                  message.user?.name ?? '',
                                  textStyle: AllListText().otherText(),
                                ),
                              ),
                              SizedBox(height: 0.5.h),
                              (message.attachments != null)
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ...?message.attachments?.map(
                                          (e) => Image(
                                            image: NetworkImage(
                                                imageBaseUrl + e.relativePath!),
                                          ),
                                          //     Container(
                                          //   constraints: BoxConstraints(
                                          //     maxHeight: 120,
                                          //   ),
                                          //   decoration: BoxDecoration(
                                          //       image: DecorationImage(
                                          //           image: NetworkImage(
                                          //               imageBaseUrl +
                                          //                   e.relativePath!),
                                          //           fit: BoxFit.fill)),
                                          //   // child: Image.network(imageBaseUrl+e.relativePath! ?? ''),
                                          // ),
                                        ),
                                        SizedBox(height: 0.5.h),
                                        HtmlWidget(
                                          message.message ?? "",
                                          textStyle: TextStyle(
                                            color: message.createdBy == "agent"
                                                ? (message.cc != null)
                                                    ? gWhiteColor
                                                    : gTextColor
                                                : gWhiteColor,
                                          ),
                                        )
                                      ],
                                    )
                                  : Align(
                                      alignment: Alignment.topLeft,
                                      child: HtmlWidget(
                                        message.message ?? '',
                                        textStyle:
                                            AllListText().subHeadingText(),
                                      ),
                                    ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: HtmlWidget(
                                  message.createdAt ?? '',
                                  textStyle: AllListText().otherText(),
                                ),
                                // Text(
                                //   message.createdAt,
                                //   style: AllListText().otherText(),
                                // ),
                              ),
                              // Align(
                              //   alignment: Alignment.bottomRight,
                              //   child: Padding(
                              //     padding: EdgeInsets.only(top: 0.5.h),
                              //     child: Row(
                              //       mainAxisSize: MainAxisSize.min,
                              //       mainAxisAlignment:
                              //           MainAxisAlignment.spaceBetween,
                              //       children: _buildNameTimeHeader(message),
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
      controller: _scrollController,
    );
  }

  String _buildHeaderDate(int? timeStamp) {
    String completedDate = "";
    DateFormat dayFormat = DateFormat("d MMMM");
    DateFormat lastYearFormat = DateFormat("dd.MM.yy");

    DateTime now = DateTime.now();
    var today = DateTime(now.year, now.month, now.day);
    var yesterday = DateTime(now.year, now.month, now.day - 1);

    timeStamp ??= 0;
    DateTime messageTime =
        DateTime.fromMicrosecondsSinceEpoch(timeStamp * 1000);
    DateTime messageDate =
        DateTime(messageTime.year, messageTime.month, messageTime.day);

    if (today == messageDate) {
      completedDate = "Today";
    } else if (yesterday == messageDate) {
      completedDate = "Yesterday";
    } else if (now.year == messageTime.year) {
      completedDate = dayFormat.format(messageTime);
    } else {
      completedDate = lastYearFormat.format(messageTime);
    }

    return completedDate;
  }

  List<Widget> _buildNameTimeHeader(message) {
    return <Widget>[
      // const Padding(padding: EdgeInsets.only(left: 16)),
      // _buildSenderName(message),
      // const Padding(padding: EdgeInsets.only(left: 7)),
      // const Expanded(child: SizedBox.shrink()),
      //  const Padding(padding: EdgeInsets.only(left: 3)),
      _buildDateSent(message),
      Padding(padding: EdgeInsets.only(left: 1.w)),
      message.isIncoming
          ? const SizedBox.shrink()
          : _buildMessageStatus(message),
    ];
  }

  Widget _buildMessageStatus(message) {
    var deliveredIds = message.qbMessage.deliveredIds;
    var readIds = message.qbMessage.readIds;
    // if (_dialogType == QBChatDialogTypes.PUBLIC_CHAT) {
    //   return SizedBox.shrink();
    // }
    if (readIds != null && readIds.length > 1) {
      return const Icon(
        Icons.done_all,
        color: Colors.blue,
        size: 14,
      );
    } else if (deliveredIds != null && deliveredIds.length > 1) {
      return const Icon(Icons.done_all, color: gGreyColor, size: 14);
    } else {
      return const Icon(Icons.done, color: gGreyColor, size: 14);
    }
  }

  Widget _buildDateSent(message) {
    // print("DateTime:${message.qbMessage.dateSent!}");
    return Text(
      _buildTime(message.qbMessage.dateSent!),
      maxLines: 1,
      style: TextStyle(
        fontSize: 7.sp,
        color: gTextColor,
        fontFamily: "GothamBook",
      ),
    );
  }

  String _buildTime(int timeStamp) {
    DateTime dateTime = DateTime.fromMicrosecondsSinceEpoch(timeStamp * 1000);
    String amPm = 'AM';
    if (dateTime.hour >= 12) {
      amPm = 'PM';
    }

    String hour = dateTime.hour.toString();
    if (dateTime.hour > 12) {
      hour = (dateTime.hour - 12).toString();
    }

    String minute = dateTime.minute.toString();
    if (dateTime.minute < 10) {
      minute = '0${dateTime.minute}';
    }
    return '$hour:$minute $amPm';
  }

  Widget _generateAvatarFromName(String? name) {
    name ??= "No name";
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
          color: gMainColor.withOpacity(0.18),
          borderRadius: const BorderRadius.all(Radius.circular(20))),
      child: Center(
        child: Text(
          name.substring(0, 1).toUpperCase(),
          style: const TextStyle(
              color: gPrimaryColor,
              fontWeight: FontWeight.bold,
              fontFamily: 'GothamMedium'),
        ),
      ),
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

  final UvDeskRepo repository = UvDeskRepo(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );

  ticketRaise() async {
    setState(() {
      isLoading = true;
    });
    print("---------Send reply---------");

    Map m = {
      'message': commentController.text,
      'threadType': "reply",
      'actAsType': "agent",
      "status_id": "1",
      'actAsEmail': _prefs!.getString(SuccessMemberStorage.successMemberEmail),
      // 'status': (TicketStatusType.Answered.index+1).toString()
    };

    final result = await _uvDeskService.uvDaskSendReplyService(
        widget.ticketId, m,
        attachments: fileFormatList);

    if (result.runtimeType == SentReplyModel) {
      SentReplyModel model = result as SentReplyModel;
      setState(() {
        isLoading = false;
      });
      // GwcApi().showSnackBar(context, model.message!, isError: true);
      getThreadsList();
      commentController.clear();
    } else {
      setState(() {
        isLoading = false;
      });
      ErrorModel response = result as ErrorModel;
      GwcApi().showSnackBar(context, response.message!, isError: true);
      // Navigator.of(context).pushReplacement(
      //   MaterialPageRoute(
      //     builder: (context) => const DashboardScreen(),
      //   ),
      // );
    }
  }

  /*
  Attachment codes
   */

  showChooserSheet() {
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        enableDrag: false,
        builder: (ctx) {
          return Wrap(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20)),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 2, vertical: 4),
                      child: Text('Choose File Source'),
                      decoration: BoxDecoration(
                          border: Border(
                        bottom: BorderSide(
                          color: gHintTextColor,
                          width: 3.0,
                        ),
                      )),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                            onPressed: () {
                              getImageFromCamera();
                              Navigator.pop(context);
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.camera_enhance_outlined,
                                  color: gMainColor,
                                ),
                                Text('Camera'),
                              ],
                            )),
                        Container(
                          width: 5,
                          height: 10,
                          decoration: BoxDecoration(
                              border: Border(
                            right: BorderSide(
                              color: gHintTextColor,
                              width: 1,
                            ),
                          )),
                        ),
                        TextButton(
                            onPressed: () {
                              pickFromFile();
                              Navigator.pop(context);
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.insert_drive_file,
                                  color: gMainColor,
                                ),
                                Text('File'),
                              ],
                            ))
                      ],
                    ),
                  ],
                ),
              )
            ],
          );
        });
  }

  getFileSize(File file) {
    var size = file.lengthSync();
    num mb = num.parse((size / (1024 * 1024)).toStringAsFixed(2));
    return mb;
  }

  List<MultipartFile> newList = <MultipartFile>[];
  List<File> fileFormatList = [];

  void pickFromFile() async {
    final result = await FilePicker.platform.pickFiles(
      withReadStream: true,
      type: FileType.any,
      // allowedExtensions: ['pdf', 'jpg', 'png', 'jpeg'],
      allowMultiple: true,
    );
    if (result == null) return;

    /// if allowMultiple: true
    List<File> _files = result.paths.map((path) => File(path!)).toList();

    _files.forEach((element) {
      print(element.path.split('.').last);
      if (element.path.split('.').last.toLowerCase().contains("pdf") ||
          element.path.split('.').last.toLowerCase().contains("png") ||
          element.path.split('.').last.toLowerCase().contains("jpg") ||
          element.path.split('.').last.toLowerCase().contains("jpeg")) {
        if (getFileSize(element) <= 12) {
          print("filesize: ${getFileSize(File(result.paths.first!))}Mb");
          print(element.path);
          addFilesToList(element);
          // addToMultipartList();
        } else {
          GwcApi()
              .showSnackBar(context, "File size must be <12Mb", isError: true);
        }
      } else {
        GwcApi().showSnackBar(context, "Please select png/jpg/Pdf files",
            isError: true);
      }
    });

    /// single file select for this  allowMultiple should be false allowMultiple: false
    // if (result.files.first.extension!.contains("pdf") ||
    //     result.files.first.extension!.contains("png") ||
    //     result.files.first.extension!.contains("jpg") ||
    //     result.files.first.extension!.contains("jpeg")) {
    //   if (getFileSize(File(result.paths.first!)) <= 12) {
    //     print("filesize: ${getFileSize(File(result.paths.first!))}Mb");
    //     files.add(result.files.first);
    //     // addFilesToList(File(result.paths.first!));
    //     if (type != null) {
    //       if (reportsObject.isNotEmpty) {
    //         reportsObject.forEach((element) {
    //           if (element.id.toString().contains(type)) {
    //             element.path.add(result.paths.first!);
    //           }
    //         });
    //       }
    //       if (type == "others") {
    //         otherFilesObject.add(result.paths.first ?? '');
    //       }
    //       print("otherFilesObject: $otherFilesObject");
    //     }
    //   }
    //   else {
    //     AppConfig()
    //         .showSnackbar(context, "File size must be <12Mb", isError: true);
    //   }
    // }
    // else {
    //   AppConfig().showSnackbar(context, "Please select png/jpg/Pdf files",
    //       isError: true);
    // }
    setState(() {});
  }

  addFilesToList(File file) async {
    print(
        "contains: ${fileFormatList.any((element) => element.path == file.path)}");

    if (!fileFormatList.any((element) => element.path == file.path)) {
      fileFormatList.add(file);
    }
    setState(() {});
  }

  addToMultipartList() async {
    print("addToMultipartList");
    newList.clear();

    // for (int i = 0; i < fileFormatList.length; i++) {
    //   var length = await fileFormatList[i].length();
    //   print("cleard: $i");
    //   print("newList for: ${newList.length} ${fileFormatList.length}");
    //   var stream =
    //   http.ByteStream(DelegatingStream.typed(fileFormatList[i].openRead()));
    //   var multipartFile = http.MultipartFile("attachments[]", stream, length,
    //       filename: fileFormatList[i].path);
    //   newList.add(multipartFile);
    //   print("newList after: ${newList.length}");
    // }

    print("fileFormatList: ${fileFormatList.length}");

    print("newList: ${newList.length}");
  }

  File? _image;

  Future getImageFromCamera({String? type}) async {
    var image = await ImagePicker.platform
        .pickImage(source: ImageSource.camera, imageQuality: 40);

    setState(() {
      _image = File(image!.path);
      if (getFileSize(_image!) <= 12) {
        print("filesize: ${getFileSize(_image!)}Mb");

        addFilesToList(_image!);
      } else {
        print("filesize: ${getFileSize(_image!)}Mb");

        GwcApi()
            .showSnackBar(context, "File size must be <12Mb", isError: true);
      }
    });
    print("captured image: ${_image} ${_image!.path}");
  }

  isExists(File file) {
    fileFormatList.map((element) {
      if (element.absolute.path == file.absolute.path) {
        print("found :: path exists file: ${file.path} ele: ${element.path}");
        return true;
      } else {
        print(
            "found :: path not exists file: ${file.path} ele: ${element.path}");
        return false;
      }
    });
  }

  Future buildAttachmentView(String attachmentUrl) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15.0.sp),
          ),
        ),
        contentPadding: EdgeInsets.only(top: 1.h),
        content: AttachmentsViewScreen(
          attachmentUrl: attachmentUrl,
        ),
      ),
    );
  }

}

class Message {
  final String text;
  final DateTime date;
  final bool sendMe;
  final String image;

  Message(
      {required this.text,
      required this.date,
      required this.sendMe,
      required this.image});
}
