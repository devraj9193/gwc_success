import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

import '../../../model/error_model.dart';
import '../../../model/uvDesk_model/sent_reply_model.dart';
import '../../../repository/uvDesk_repo/uvDesk_repository.dart';
import '../../../service/api_service.dart';
import '../../../utils/constants.dart';
import '../../../utils/gwc_api.dart';
import '../../../widgets/common_screen_widgets.dart';
import '../../../widgets/widgets.dart';
import '../../model/success_user_model/success_list_model.dart';
import '../../model/uvDesk_model/get_group_list_model.dart';
import '../../repository/gwc_team_repo/gwc_team_repo.dart';
import '../../service/gwc_team_service/gwc_team_service.dart';
import '../../service/uvDesk_service/uvDesk_service.dart';
import '../../utils/success_member_storage.dart';
import 'all_ticket_list_screen.dart';

class TicketPopUpMenu extends StatefulWidget {
  final String ticketId;
  final String incrementId;
  final String? agentId;
  final String associatedDoctorName;
  final bool isAllTicket;
  final bool isTransferred;
  final bool isResolved;

  const TicketPopUpMenu({
    Key? key,
    required this.ticketId,
    required this.incrementId,
    this.agentId,
    this.isAllTicket = false,
    this.isTransferred = false,
    this.isResolved = false,
    required this.associatedDoctorName,
  }) : super(key: key);

  @override
  State<TicketPopUpMenu> createState() => _TicketPopUpMenuState();
}

class _TicketPopUpMenuState extends State<TicketPopUpMenu> {
  bool showLogoutProgress = false;
  final _prefs = GwcApi.preferences;
  String selectedReassignButton = "";
  String selectedTransferToDoctorButton = '';
  String selectedButton = "";
  var logoutProgressState;

  bool showProgress = false;
  SuccessList? successList;
  GroupListModel? groupListModel;

  final ScrollController _scrollController = ScrollController();

  late final GwcTeamService gwcTeamService = GwcTeamService(gwcTeamRepo: repo);

  late final UvDeskService _uvDeskService =
      UvDeskService(uvDeskRepo: repository);

  @override
  void initState() {
    super.initState();
    getSuccessList();
    getGroupList();
  }

  getSuccessList() async {
    setState(() {
      showProgress = true;
    });
    callProgressStateOnBuild(true);
    final result = await gwcTeamService.getSuccessListService();
    print("result: $result");

    if (result.runtimeType == SuccessList) {
      print("Ticket List");
      SuccessList model = result as SuccessList;

      successList = model;
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

  getGroupList() async {
    setState(() {
      showProgress = true;
    });
    callProgressStateOnBuild(true);
    final result = await _uvDeskService.getGroupListService();
    print("result: $result");

    if (result.runtimeType == GroupListModel) {
      print("Ticket List");
      GroupListModel model = result as GroupListModel;

      groupListModel = model;
    } else {
      ErrorModel model = result as ErrorModel;
      print("error: ${model.message}");
    }
    setState(() {
      showProgress = false;
    });
    print(result);
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onSelected: null,
      offset: const Offset(0, 30),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      itemBuilder: (context) => [
        PopupMenuItem(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.isResolved
                  ? GestureDetector(
                      onTap: () {
                        popUpDialog("status", "1", widget.ticketId,
                            isResolvedAndClosed: true);
                        // closeAndResolvedDialog("status", "1", widget.ticketId);
                      },
                      child: Text(
                        "Re-Open",
                        style: AllListText().subHeadingText(),
                      ),
                    )
                  : const SizedBox(),
              widget.isResolved ? SizedBox(height: 0.5.h) : const SizedBox(),
              widget.isAllTicket
                  ? GestureDetector(
                      onTap: () {
                        popUpDialog(
                            "${_prefs!.getString(SuccessMemberStorage.successMemberUvId)}",
                            "",
                            widget.ticketId,
                            isAssignToMyself: true);
                        // assignToMyselfDialog("1797343", widget.incrementId);
                      },
                      child: Text(
                        "Assign to Myself",
                        style: AllListText().subHeadingText(),
                      ),
                    )
                  : const SizedBox(),
              widget.isAllTicket
                  ? Container(
                      margin: EdgeInsets.symmetric(vertical: 0.5.h),
                      height: 1,
                      // color: gGreyColor.withOpacity(0.3),
                    )
                  : const SizedBox(),
              GestureDetector(
                onTap: () {
                  reassignSuccessDialog(widget.ticketId);
                },
                child: Text(
                  "Reassign",
                  style: AllListText().subHeadingText(),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 0.5.h),
                height: 1,
                // color: gGreyColor.withOpacity(0.3),
              ),
              widget.isTransferred
                  ? GestureDetector(
                      onTap: () {
                        popUpDialog("group", "2", widget.ticketId,
                            isTransferAndRemoveFromDoctor: true);
                        // transferAndReassignDialog(
                        //     "group", "16451", widget.ticketId, true);
                      },
                      child: Text(
                        "Remove from Doctor",
                        style: AllListText().subHeadingText(),
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        transferToDoctorDialog(widget.ticketId);
                        // popUpDialog("group", "2", widget.ticketId,
                        //     isTransferAndRemoveFromDoctor: true);
                        // transferAndReassignDialog(
                        //     "group", "2", widget.ticketId, true);
                      },
                      child: Text(
                        "Transfer to Doctor",
                        style: AllListText().subHeadingText(),
                      ),
                    ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 0.5.h),
                height: 1,
                // color: gGreyColor.withOpacity(0.3),
              ),
              GestureDetector(
                onTap: () {
                  popUpDialog("status", "4", widget.ticketId,
                      isResolvedAndClosed: true);
                  // closeAndResolvedDialog("status", "4", widget.ticketId);
                },
                child: Text(
                  "Mark as Resolved",
                  style: AllListText().subHeadingText(),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 0.5.h),
                height: 1,
                // color: gGreyColor.withOpacity(0.3),
              ),
              GestureDetector(
                onTap: () {
                  popUpDialog("status", "5", widget.ticketId,
                      isResolvedAndClosed: true);
                  // closeAndResolvedDialog("status", "5", widget.ticketId);
                },
                child: Text(
                  "Close the Ticket",
                  style: AllListText().subHeadingText(),
                ),
              ),
              SizedBox(height: 0.5.h),
            ],
          ),
        ),
      ],
      child: Container(
        margin: EdgeInsets.only(right: 2.w),
        padding: const EdgeInsets.all(9),
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
        child: const Icon(
          Icons.more_vert_sharp,
          color: gBlackColor,
        ),
      ),
    );
  }

  popUpDialog(
    String editType,
    String value,
    String ticketId, {
    bool isAssignToMyself = false,
    bool isTransferAndRemoveFromDoctor = false,
    bool isResolvedAndClosed = false,
  }) {
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
                SizedBox(height: 1.h),
                showLogoutProgress
                    ? buildCircularIndicator()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: isAssignToMyself
                                ? () {
                                    sendAssignToMyself("", ticketId);
                                  }
                                : isResolvedAndClosed
                                    ? () {
                                        sendClosedResolved(
                                            editType, value, ticketId);
                                      }
                                    : () {},
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

  Future reassignSuccessDialog(String ticketId) async {
    List<SuccessTeam> list = successList?.data ?? [];
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          // logoutProgressState = setstate;
          return Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            width: double.maxFinite,
            height: double.maxFinite,
            child: Column(
              children: <Widget>[
                SizedBox(height: 1.h),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            'Reassign',
                            style: TabBarText().bottomSheetHeadingText(),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(1),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            border:
                                Border.all(color: mediumTextColor, width: 1),
                          ),
                          child: Icon(
                            Icons.clear,
                            color: mediumTextColor,
                            size: 1.6.h,
                          ),
                        ),
                      ),
                      const SizedBox(width: 5)
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 10.w),
                  height: 1,
                  color: lightTextColor,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: ListView.builder(
                      itemCount: list.length,
                      controller: _scrollController,
                      scrollDirection: Axis.vertical,
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        var success = list[index];
                        return RadioListTile(
                          value: success.uvUserId.toString(),
                          groupValue: selectedReassignButton,
                          controlAffinity: ListTileControlAffinity.trailing,
                          onChanged: (value) => setState(
                              () => selectedReassignButton = value.toString()),
                          title: Text(
                            success.name ?? '',
                            style: AllListText().subHeadingText(),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(height: 6.h),
                (selectedReassignButton.isNotEmpty)
                    ? showLogoutProgress
                        ? buildCircularIndicator()
                        : CommonButton.submitButton(() {
                            setState(() {
                              print(
                                  "selectedReassignButton : $selectedReassignButton");
                              sendReassign(
                                  selectedReassignButton, ticketId, setState);
                            });
                          }, "Reassign")
                    : Container(),
              ],
            ),
          );
        }),
      ),
    );
  }

  Future transferToDoctorDialog(String ticketId) async {
    List<Group> list = groupListModel?.collection?.groups ?? [];
    return await showDialog(
      context: context,
      builder: (context) => Material(
        color: Colors.black54,
        child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          // logoutProgressState = setstate;
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 10.h),
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Column(
              children: <Widget>[
                SizedBox(height: 1.h),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            'Transfer To Doctor',
                            style: TabBarText().bottomSheetHeadingText(),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(1),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            border:
                                Border.all(color: mediumTextColor, width: 1),
                          ),
                          child: Icon(
                            Icons.clear,
                            color: mediumTextColor,
                            size: 1.6.h,
                          ),
                        ),
                      ),
                      const SizedBox(width: 5)
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 10.w),
                  height: 1,
                  color: lightTextColor,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: list.length,
                    controller: _scrollController,
                    scrollDirection: Axis.vertical,
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      var success = list[index];
                      selectedButton =
                          success.description == widget.associatedDoctorName
                              ? "${success.id}"
                              : "";

                      selectedTransferToDoctorButton = selectedButton;
                      print(
                          "selectedTransferToDoctorButtonInitial: $selectedTransferToDoctorButton");
                      print("selectedrButtonInitial: $selectedButton");

                      return StatefulBuilder(builder:
                          (BuildContext context, StateSetter setState) {
                        // logoutProgressState = setstate;
                        return RadioListTile(
                          value: success.id.toString(),
                          activeColor: gSecondaryColor,
                          splashRadius: 0,
                          groupValue: selectedTransferToDoctorButton,
                          controlAffinity: ListTileControlAffinity.trailing,
                          onChanged: (value) {
                            setState(() {
                              selectedTransferToDoctorButton = value.toString();
                              selectedButton = "";
                              print(
                                  "selectedTransferToDoctorButton: $selectedTransferToDoctorButton");
                              print("selectedrButton: $selectedButton");
                            });
                          },
                          title: Text(
                            success.name ?? '',
                            style: AllListText().subHeadingText(),
                          ),
                          subtitle:
                              success.description == widget.associatedDoctorName
                                  ? Text(
                                      "Associated Doctor",
                                      style: AllListText()
                                          .deliveryDateText("shipping_paused"),
                                    )
                                  : const SizedBox(),
                        );
                      });
                    },
                  ),
                ),
                SizedBox(height: 2.h),
                (selectedTransferToDoctorButton.isNotEmpty)
                    ? showLogoutProgress
                        ? buildCircularIndicator()
                        : CommonButton.submitButton(() {
                            setState(() {
                              print(
                                  "selectedReassignButton : $selectedTransferToDoctorButton");
                              sendTransferToDoctor(
                                  "group",
                                  selectedTransferToDoctorButton,
                                  ticketId,
                                  setState);
                            });
                          }, "Transfer To Doctor")
                    : Container(),
                SizedBox(height: 2.h),
              ],
            ),
          );
        }),
      ),
    );
  }

  sendReassign(String agentId, String ticketId, state) async {
    state(() {
      showLogoutProgress = true;
    });
    print("---------Reassign---------");

    final result =
        await _uvDeskService.uvDeskReassignService(agentId, ticketId);

    if (result.runtimeType == SentReplyModel) {
      SentReplyModel model = result as SentReplyModel;
      state(() {
        showLogoutProgress = false;
      });
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const AllTicketListScreen(),
        ),
      );
      GwcApi().showSnackBar(context, model.description!, isError: false);
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const AllTicketListScreen(),
        ),
      );
      state(() {
        showLogoutProgress = false;
      });
      ErrorModel response = result as ErrorModel;
      GwcApi().showSnackBar(context, response.message!, isError: true);
    }
    state(() {
      showLogoutProgress = true;
    });
  }

  sendAssignToMyself(String agentId, String ticketId) async {
    logoutProgressState(() {
      showLogoutProgress = true;
    });
    print("---------Reassign---------");

    final result =
        await _uvDeskService.uvDeskReassignService(agentId, ticketId);

    if (result.runtimeType == SentReplyModel) {
      SentReplyModel model = result as SentReplyModel;
      logoutProgressState(() {
        showLogoutProgress = false;
      });
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const AllTicketListScreen(),
        ),
      );
      GwcApi().showSnackBar(context, model.description!, isError: false);
    } else {
      ErrorModel response = result as ErrorModel;
      Navigator.pop(context);
      GwcApi().showSnackBar(context, response.message!, isError: true);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const AllTicketListScreen(),
        ),
      );
    }
    logoutProgressState(() {
      showLogoutProgress = true;
    });
  }

  sendTransferToDoctor(
      String property, String value, String threadId, state) async {
    state(() {
      showLogoutProgress = true;
    });
    print("---------Transfer To Doctor---------");

    final result = await _uvDeskService.uvDeskTransferToDoctorService(
        property, value, threadId);

    if (result.runtimeType == SentReplyModel) {
      SentReplyModel model = result as SentReplyModel;
      state(() {
        showLogoutProgress = false;
      });
      Navigator.pop(context);
      GwcApi().showSnackBar(context, model.description!, isError: false);
    } else {
      Navigator.pop(context);
      state(() {
        showLogoutProgress = false;
      });
      ErrorModel response = result as ErrorModel;
      GwcApi().showSnackBar(context, response.message!, isError: true);
      // Navigator.of(context).pushReplacement(
      //   MaterialPageRoute(
      //     builder: (context) => const DashboardScreen(),
      //   ),
      // );
    }
    state(() {
      showLogoutProgress = true;
    });
  }

  sendClosedResolved(String property, String value, String threadId) async {
    logoutProgressState(() {
      showLogoutProgress = true;
    });
    print("---------Cancelled Or Resolved---------");

    final result =
        await _uvDeskService.uvDeskCancelledService(property, value, threadId);

    if (result.runtimeType == SentReplyModel) {
      SentReplyModel model = result as SentReplyModel;
      logoutProgressState(() {
        showLogoutProgress = false;
      });
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const AllTicketListScreen(),
        ),
      );
      GwcApi().showSnackBar(context, model.description!, isError: false);
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const AllTicketListScreen(),
        ),
      );
      logoutProgressState(() {
        showLogoutProgress = false;
      });
      ErrorModel response = result as ErrorModel;
      GwcApi().showSnackBar(context, response.message!, isError: true);
      // Navigator.of(context).pushReplacement(
      //   MaterialPageRoute(
      //     builder: (context) => const DashboardScreen(),
      //   ),
      // );
    }
    logoutProgressState(() {
      showLogoutProgress = true;
    });
  }

  final UvDeskRepo repository = UvDeskRepo(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );

  final GwcTeamRepo repo = GwcTeamRepo(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );
}
