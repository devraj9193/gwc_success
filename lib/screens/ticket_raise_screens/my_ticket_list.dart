import 'package:flutter/material.dart';
import 'package:gwc_success_team/screens/ticket_raise_screens/resolved_list.dart';
import 'package:gwc_success_team/screens/ticket_raise_screens/transferred_list.dart';
import 'package:sizer/sizer.dart';
import '../../../utils/constants.dart';
import '../../../widgets/common_screen_widgets.dart';
import 'answered_list.dart';
import 'closed_list.dart';
import 'open_list.dart';

class MyTicketListScreen extends StatefulWidget {
  const MyTicketListScreen({Key? key}) : super(key: key);

  @override
  State<MyTicketListScreen> createState() => _MyTicketListScreenState();
}

class _MyTicketListScreenState extends State<MyTicketListScreen>
    with SingleTickerProviderStateMixin {

  TabController? tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      initialIndex: 0,
      length: 5,
      vsync: this,
    );
  }

  @override
  void dispose() async {
    super.dispose();
    tabController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: gWhiteColor,
      body: Column(
        children: [
          TabBar(
            controller: tabController,
            labelColor: tapSelectedColor,
            padding: EdgeInsets.symmetric(horizontal: 3.w),
            unselectedLabelColor: tapUnSelectedColor,
            labelStyle: TabBarText().selectedText(),
            unselectedLabelStyle: TabBarText().unSelectedText(),
            isScrollable: true,
            indicatorColor: tapIndicatorColor,
            labelPadding:
                EdgeInsets.only(right: 10.w, left: 2.w, top: 1.h, bottom: 1.h),
            indicatorPadding: EdgeInsets.only(right: 5.w),
            tabs: const [
              Text('Open'),
              Text('Answered'),
              Text('Transferred'),
              Text('Resolved'),
              Text('Closed'),
            ],
          ),
          Container(
            height: 1,
            margin: EdgeInsets.only(left: 0.w, bottom: 1.h),
            color: gGreyColor.withOpacity(0.3),
            width: double.maxFinite,
          ),
          Expanded(
            child:  TabBarView(
                    controller: tabController,
                    children: const [
                      OpenList(),
                      AnsweredList(),
                      TransferredList(),
                      ResolvedList(),
                      ClosedList(),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
