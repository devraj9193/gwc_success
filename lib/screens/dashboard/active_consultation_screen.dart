import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../utils/constants.dart';
import '../../widgets/common_screen_widgets.dart';
import '../../widgets/widgets.dart';
import '../customer_details_screens/Customers_Lists/active_list.dart';
import '../customer_details_screens/Customers_Lists/all_customers_list.dart';

class ActiveConsultationScreen extends StatefulWidget {
  const ActiveConsultationScreen({Key? key}) : super(key: key);

  @override
  State<ActiveConsultationScreen> createState() =>
      _ActiveConsultationScreenState();
}

class _ActiveConsultationScreenState extends State<ActiveConsultationScreen> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: SafeArea(
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
                    Text('Linked Customers'),
                    Text('All Customers'),
                  ]),
               const Expanded(
                child: TabBarView(children: [
                  ActiveList(),
                  AllCustomersList(),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
