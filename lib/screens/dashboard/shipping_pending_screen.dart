import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../utils/constants.dart';
import '../../widgets/common_screen_widgets.dart';
import '../../widgets/widgets.dart';
import '../customer_details_screens/Customers_Lists/shipping_packed_list.dart';
import '../customer_details_screens/Customers_Lists/shipping_paushed_list.dart';
import '../customer_details_screens/Customers_Lists/shipping_pending_list.dart';

class ShippingPendingScreen extends StatefulWidget {
  const ShippingPendingScreen({Key? key}) : super(key: key);

  @override
  State<ShippingPendingScreen> createState() => _ShippingPendingScreenState();
}

class _ShippingPendingScreenState extends State<ShippingPendingScreen> {
   @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
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
                  labelStyle:TabBarText().selectedText(),
                  unselectedLabelStyle: TabBarText().unSelectedText(),
                  isScrollable: true,
                  indicatorColor: tapIndicatorColor,
                  labelPadding:
                  EdgeInsets.only(right: 7.w,left: 2.w, top: 1.h, bottom: 1.h),
                  indicatorPadding: EdgeInsets.only(right: 5.w),
                  tabs: const [
                    Text('Pending'),
                    Text('Paused'),
                    Text('Packed'),
                  ]),
              const Expanded(
                child: TabBarView(children: [
                  ShippingPendingList(),
                  ShippingPausedList(),
                  ShippingPackedList(),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
