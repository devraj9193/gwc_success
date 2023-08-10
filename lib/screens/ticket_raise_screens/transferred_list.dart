import 'package:flutter/material.dart';
import 'package:gwc_success_team/screens/ticket_raise_screens/ticket_chat_screen.dart';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';

import '../../../model/error_model.dart';
import '../../../model/uvDesk_model/get_ticket_list_model.dart';
import '../../../repository/uvDesk_repo/uvDesk_repository.dart';
import '../../../service/api_service.dart';
import '../../../service/uvDesk_service/uvDesk_service.dart';
import '../../../utils/constants.dart';
import '../../../widgets/common_screen_widgets.dart';
import '../../../widgets/widgets.dart';

class TransferredList extends StatefulWidget {
  const TransferredList({Key? key}) : super(key: key);

  @override
  State<TransferredList> createState() => _TransferredListState();
}

class _TransferredListState extends State<TransferredList> {

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
  }

  @override
  Widget build(BuildContext context) {
    List<Tickets> tickets = getTicketListModel?.tickets ?? [];

    return (showProgress)
        ? Center(
      child: buildCircularIndicator(),
    ) : ListView.builder(
      shrinkWrap: true,
      controller: _scrollController,
      itemCount: tickets.length,
      itemBuilder: (context, index) {
        Tickets currentTicket = tickets[index];
        return currentTicket.group == "null" ? const SizedBox() : Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              margin: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              decoration: BoxDecoration(
                color:  gWhiteColor,
                borderRadius: BorderRadius.circular(10),
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
                        subject: currentTicket.subject ?? '',
                        incrementId: currentTicket.id.toString(),
                        isTransferred: true,
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
                    // Row(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    //     Text(
                    //       "Replied By : ",
                    //       style: AllListText().otherText(),
                    //     ),
                    //     Expanded(
                    //       child: Text(
                    //         "currentTicket.lastThreadUserType",
                    //         style: AllListText().subHeadingText(),
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
                              currentTicket.customer?.smallThumbnail ==  null
                                  ? CircleAvatar(
                                radius: 1.h,
                                backgroundColor: kNumberCircleRed,
                                child: Text(
                                  getInitials(
                                      currentTicket.customer?.name ?? '', 2),
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
                                  currentTicket.customer?.smallThumbnail ?? '',
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
                            : Icon(Icons.check,
                            color: gGreyColor, size: 2.h)
                      ],
                    ),

                  ],
                ),
              ),
            ),
            Container(
              height: 1,
              color: Colors.grey.withOpacity(0.3),
            ),
          ],
        );
      },
    );
  }

  final UvDeskRepo repository = UvDeskRepo(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );
}
