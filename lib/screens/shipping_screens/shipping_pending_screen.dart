import 'package:flutter/material.dart';
import 'package:gwc_success_team/screens/shipping_screens/pending_paused_order_details.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:get/get.dart';
import '../../controller/pending_user_list_controller.dart';
import '../../utils/constants.dart';
import '../../widgets/widgets.dart';
import 'approved_order_details.dart';

class ShippingPendingScreen extends StatefulWidget {
  const ShippingPendingScreen({Key? key}) : super(key: key);

  @override
  State<ShippingPendingScreen> createState() => _ShippingPendingScreenState();
}

class _ShippingPendingScreenState extends State<ShippingPendingScreen> {
  PendingUserListController pendingUserListController =
      Get.put(PendingUserListController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: SafeArea(
        child: Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 1.h),
              Padding(
                padding: EdgeInsets.only(left: 3.w),
                child: buildAppBar(() {
                  Navigator.pop(context);
                }),
              ),
              TabBar(
                  labelColor: gPrimaryColor,
                  unselectedLabelColor: gTextColor,
                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                  isScrollable: true,
                  indicatorColor: gPrimaryColor,
                  labelPadding:
                      EdgeInsets.only(right: 10.w, top: 1.h, bottom: 1.h),
                  indicatorPadding: EdgeInsets.only(right: 7.w),
                  labelStyle: TextStyle(
                      fontFamily: "GothamMedium",
                      color: gPrimaryColor,
                      fontSize: 10.sp),
                  tabs: const [
                    Text('Pending'),
                    Text('Paused'),
                    Text('Packed'),
                  ]),
              Expanded(
                child: TabBarView(children: [
                  buildPending(),
                  buildPaused(),
                  buildApproved(),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildPending() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 3.w),
      child: FutureBuilder(
          future: pendingUserListController.getPendingUserListData(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasError) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 5.h),
                child: Image(
                  image: const AssetImage("assets/images/Group 5294.png"),
                  height: 25.h,
                ),
              );
            } else if (snapshot.hasData) {
              var data = snapshot.data;
              return Column(
                children: [
                  Container(
                    height: 1,
                    color: gBlackColor.withOpacity(0.5),
                  ),
                  SizedBox(height: 1.5.h),
                  data.length != 0
                      ? ListView.builder(
                          scrollDirection: Axis.vertical,
                          padding: EdgeInsets.symmetric(horizontal: 1.w),
                          physics: const ScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: data.length,
                          itemBuilder: ((context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (ct) => PendingPausedOrderDetails(
                                      userName: data[index]
                                          .patient
                                          .user
                                          .name
                                          .toString(),
                                    ),
                                  ),
                                );
                                saveUserId(
                                  data[index].patient.user.id,
                                );
                              },
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                        radius: 2.5.h,
                                        backgroundImage: NetworkImage(
                                          data[index]
                                              .patient
                                              .user
                                              .profile
                                              .toString(),
                                        ),
                                      ),
                                      SizedBox(width: 3.w),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              data[index]
                                                  .patient
                                                  .user
                                                  .name
                                                  .toString(),
                                              style: TextStyle(
                                                  fontFamily: "GothamMedium",
                                                  color: gTextColor,
                                                  fontSize: 8.sp),
                                            ),
                                            SizedBox(height: 0.7.h),
                                            Text(
                                              "${data[index].appointmentDate.toString()} / ${data[index].appointmentTime.toString()}",
                                              style: TextStyle(
                                                  fontFamily: "GothamBook",
                                                  color: gTextColor,
                                                  fontSize: 6.sp),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        data[index].updateTime.toString(),
                                        style: TextStyle(
                                            fontFamily: "GothamBook",
                                            color: gBlackColor.withOpacity(0.5),
                                            fontSize: 6.sp),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    height: 1,
                                    margin:
                                        EdgeInsets.symmetric(vertical: 2.5.h),
                                    color: gBlackColor.withOpacity(0.5),
                                  ),
                                ],
                              ),
                            );
                          }),
                        )
                      : Image(
                          image:
                              const AssetImage("assets/images/Group 5295.png"),
                          height: 25.h,
                        ),
                ],
              );
            }
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              child: buildCircularIndicator(),
            );
          }),
    );
  }

  buildPaused() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 3.w),
      child: FutureBuilder(
          future: pendingUserListController.getPausedUserListData(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasError) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 5.h),
                child: Image(
                  image: const AssetImage("assets/images/Group 5294.png"),
                  height: 25.h,
                ),
              );
            } else if (snapshot.hasData) {
              var data = snapshot.data;
              return Column(
                children: [
                  Container(
                    height: 1,
                    color: gBlackColor.withOpacity(0.5),
                  ),
                  SizedBox(height: 1.5.h),
                  data.length != 0
                      ? ListView.builder(
                          scrollDirection: Axis.vertical,
                          padding: EdgeInsets.symmetric(horizontal: 1.w),
                          physics: const ScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: data.length,
                          itemBuilder: ((context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (ct) => PendingPausedOrderDetails(
                                      userName: data[index]
                                          .patient
                                          .user
                                          .name
                                          .toString(),
                                    ),
                                  ),
                                );
                                saveUserId(
                                  data[index].patient.user.id,
                                );
                              },
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                        radius: 2.5.h,
                                        backgroundImage: NetworkImage(
                                          data[index]
                                              .patient
                                              .user
                                              .profile
                                              .toString(),
                                        ),
                                      ),
                                      SizedBox(width: 3.w),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              data[index]
                                                  .patient
                                                  .user
                                                  .name
                                                  .toString(),
                                              style: TextStyle(
                                                  fontFamily: "GothamMedium",
                                                  color: gTextColor,
                                                  fontSize: 8.sp),
                                            ),
                                            SizedBox(height: 0.7.h),
                                            Text(
                                              "${data[index].appointmentDate.toString()} / ${data[index].appointmentTime.toString()}",
                                              style: TextStyle(
                                                  fontFamily: "GothamBook",
                                                  color: gTextColor,
                                                  fontSize: 6.sp),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        data[index].updateTime.toString(),
                                        style: TextStyle(
                                            fontFamily: "GothamBook",
                                            color: gBlackColor.withOpacity(0.5),
                                            fontSize: 6.sp),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    height: 1,
                                    margin:
                                        EdgeInsets.symmetric(vertical: 2.5.h),
                                    color: gBlackColor.withOpacity(0.5),
                                  ),
                                ],
                              ),
                            );
                          }),
                        )
                      : Image(
                          image:
                              const AssetImage("assets/images/Group 5295.png"),
                          height: 25.h,
                        ),
                ],
              );
            }
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              child: buildCircularIndicator(),
            );
          }),
    );
  }

  buildApproved() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 3.w),
      child: FutureBuilder(
          future: pendingUserListController.getPackedUserListData(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasError) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 5.h),
                child: Image(
                  image: const AssetImage("assets/images/Group 5294.png"),
                  height: 25.h,
                ),
              );
            } else if (snapshot.hasData) {
              var data = snapshot.data;
              return Column(
                children: [
                  Container(
                    height: 1,
                    color: gBlackColor.withOpacity(0.5),
                  ),
                  SizedBox(height: 1.5.h),
                  data.length != 0
                      ? ListView.builder(
                          scrollDirection: Axis.vertical,
                          padding: EdgeInsets.symmetric(horizontal: 1.w),
                          physics: const ScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: data.length,
                          itemBuilder: ((context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (ct) => ApprovedOrderDetails(
                                      label: data[index].orders,
                                      userName: data[index]
                                          .patient
                                          .user
                                          .name
                                          .toString(),
                                      address: data[index]
                                          .patient
                                          .address2
                                          .toString(),
                                      shipmentId: data[index]
                                          .orders
                                          .first
                                          .shippingId
                                          .toString(),
                                      orderId: data[index]
                                          .orders
                                          .first
                                          .orderId
                                          .toString(),
                                      status: data[index]
                                          .orders
                                          .first
                                          .status
                                          .toString(),
                                      addressNo: data[index]
                                          .patient
                                          .user
                                          .address
                                          .toString(),
                                      pickupDate: data[index]
                                          .orders
                                          .first
                                          .pickupScheduledDate
                                          .toString(),
                                    ),
                                  ),
                                );
                                saveUserId(
                                  data[index].patient.user.id,
                                );
                              },
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                        radius: 2.5.h,
                                        backgroundImage: NetworkImage(
                                          data[index]
                                              .patient
                                              .user
                                              .profile
                                              .toString(),
                                        ),
                                      ),
                                      SizedBox(width: 3.w),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              data[index]
                                                  .patient
                                                  .user
                                                  .name
                                                  .toString(),
                                              style: TextStyle(
                                                  fontFamily: "GothamMedium",
                                                  color: gTextColor,
                                                  fontSize: 8.sp),
                                            ),
                                            SizedBox(height: 0.7.h),
                                            Text(
                                              "${data[index].appointmentDate.toString()} / ${data[index].appointmentTime.toString()}",
                                              style: TextStyle(
                                                  fontFamily: "GothamBook",
                                                  color: gTextColor,
                                                  fontSize: 6.sp),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        data[index].updateTime.toString(),
                                        style: TextStyle(
                                            fontFamily: "GothamBook",
                                            color: gBlackColor.withOpacity(0.5),
                                            fontSize: 6.sp),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    height: 1,
                                    margin:
                                        EdgeInsets.symmetric(vertical: 2.5.h),
                                    color: gBlackColor.withOpacity(0.5),
                                  ),
                                ],
                              ),
                            );
                          }),
                        )
                      : Image(
                          image:
                              const AssetImage("assets/images/Group 5294.png"),
                          height: 25.h,
                        ),
                ],
              );
            }
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              child: buildCircularIndicator(),
            );
          }),
    );
  }

  saveUserId(int userId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt("user_id", userId);
  }
}
