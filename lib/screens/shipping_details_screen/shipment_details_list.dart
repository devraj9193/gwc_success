import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gwc_success_team/screens/shipping_details_screen/shipping_details_screen.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import '../../../utils/constants.dart';
import '../../../widgets/common_screen_widgets.dart';
import '../../controller/ship_rocket_login_controller.dart';
import '../../model/error_model.dart';
import '../../model/pending_list_model.dart';
import '../../repository/shipment_repo/shipment_repo.dart';
import '../../service/api_service.dart';
import 'package:http/http.dart' as http;

import '../../service/shipment_service/shipment_service.dart';
import '../../widgets/widgets.dart';
import '../common_ui/call_chat_icons.dart';

class ShipmentDetailsList extends StatefulWidget {
  const ShipmentDetailsList({Key? key}) : super(key: key);

  @override
  State<ShipmentDetailsList> createState() => _ShipmentDetailsListState();
}

class _ShipmentDetailsListState extends State<ShipmentDetailsList> {
  String statusText = "";
  DateTime initialDate = DateTime.now();
  DateTime? selectedDate;

  bool showProgress = false;
  PendingUserList? pendingUserList;

  final ScrollController _scrollController = ScrollController();

  late final ShipmentService shipmentService =
      ShipmentService(shipmentRepo: repository);

  @override
  void initState() {
    super.initState();
    getShipmentList();
  }

  getShipmentList() async {
    setState(() {
      showProgress = true;
    });
    callProgressStateOnBuild(true);
    final result = await shipmentService.getShipmentService();
    print("result: $result");

    if (result.runtimeType == PendingUserList) {
      print("Ticket List");
      PendingUserList model = result as PendingUserList;

      pendingUserList = model;

      // pendingList = pendingUserList.data.pending;
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

  ShipRocketLoginController shipRocketLoginController =
      Get.put(ShipRocketLoginController());

  @override
  Widget build(BuildContext context) {
    return (showProgress)
        ? Center(
            child: buildCircularIndicator(),
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Text(""),
                    selectedDate == null
                        ? Text(
                            "All",
                            style: TabBarText().selectedText(),
                          )
                        : Text(
                            DateFormat('dd/MM/yyyy')
                                .format(
                                    DateTime.parse((selectedDate.toString())))
                                .toString(),
                            style: TabBarText().selectedText(),
                          ),
                    GestureDetector(
                      onTap: () => _selectDate(context), // Refer step 3
                      child: Icon(
                        Icons.calendar_month_outlined,
                        color: gBlackColor,
                        size: 3.h,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      buildPackedList(),
                      buildPausedList(),
                      buildPendingList(),
                      buildDeliveredList(),
                    ],
                  ),
                ),
              ),
            ],
          );
  }

  buildPendingList() {
    if (pendingUserList?.data?.pending.length != 0) {
      return ListView.builder(
        scrollDirection: Axis.vertical,
        controller: _scrollController,
        padding: EdgeInsets.symmetric(horizontal: 1.w),
        physics: const ScrollPhysics(),
        shrinkWrap: true,
        itemCount: pendingUserList?.data?.pending.length,
        itemBuilder: ((context, index) {
          var data = pendingUserList?.data?.pending[index];
          return selectedDate == null
              ? GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ct) => ShippingDetailsScreen(
                          userName: data?.patient?.user?.name ?? '',
                          address: data?.patient?.address2 ?? '',
                          addressNo: data?.patient?.user?.address ?? '',
                          userId: data?.patient?.user?.id.toString() ?? '',
                          status: data?.patient?.status ?? '',
                        ),
                      ),
                    );
                    saveUserId(
                      int.parse("${data?.patient?.user?.id}"),
                    );
                  },
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 3.h,
                            backgroundImage: NetworkImage(
                              "${data?.patient?.user?.profile}",
                            ),
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data?.patient?.user?.name ?? '',
                                  style: AllListText().headingText(),
                                ),
                                // SizedBox(height: 0.5.h),
                                // Text(
                                //   "${data?.appointmentDate} / ${data?.appointmentTime}",
                                //   style: AllListText().subHeadingText(),
                                // ),
                                Row(
                                  children: [
                                    Text(
                                      "Status : ",
                                      style: AllListText().otherText(),
                                    ),
                                    Text(
                                      buildStatusText(
                                          "${data?.patient?.status}"),
                                      style: AllListText().deliveryDateText(
                                          "${data?.patient?.status}"),
                                    ),
                                  ],
                                ),
                                data?.patient?.shippingDeliveryDate == null
                                    ? const SizedBox()
                                    : Row(
                                        children: [
                                          Text(
                                            "Requested Delivery Date : ",
                                            style: AllListText().otherText(),
                                          ),
                                          Text(
                                            data?.patient
                                                    ?.shippingDeliveryDate ??
                                                '',
                                            style:
                                                AllListText().subHeadingText(),
                                          ),
                                        ],
                                      ),
                              ],
                            ),
                          ),
                          Text(
                            data?.updateTime ?? '',
                            style: AllListText().otherText(),
                          ),
                        ],
                      ),
                      Container(
                        height: 1,
                        margin: EdgeInsets.symmetric(vertical: 2.5.h),
                        color: gBlackColor.withOpacity(0.5),
                      ),
                    ],
                  ),
                )
              : DateFormat('dd/MM/yyyy')
                          .format(DateTime.parse((selectedDate.toString())))
                          .toString() ==
                      data?.patient?.shippingDeliveryDate.toString()
                  ? GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ct) => ShippingDetailsScreen(
                              userName: data?.patient?.user?.name ?? '',
                              address: data?.patient?.address2 ?? '',
                              addressNo: data?.patient?.user?.address ?? '',
                              userId: data?.patient?.user?.id.toString() ?? '',
                              status: data?.patient?.status ?? '',
                            ),
                          ),
                        );
                        saveUserId(
                          int.parse("${data?.patient?.user?.id}"),
                        );
                      },
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 3.h,
                                backgroundImage: NetworkImage(
                                  "${data?.patient?.user?.profile}",
                                ),
                              ),
                              SizedBox(width: 3.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data?.patient?.user?.name ?? '',
                                      style: AllListText().headingText(),
                                    ),
                                    // Text(
                                    //   "${data?.appointmentDate} / ${data?.appointmentTime}",
                                    //   style: AllListText().subHeadingText(),
                                    // ),
                                    Row(
                                      children: [
                                        Text(
                                          "Status : ",
                                          style: AllListText().otherText(),
                                        ),
                                        Text(
                                          buildStatusText(
                                              "${data?.patient?.status}"),
                                          style: AllListText().deliveryDateText(
                                              "${data?.patient?.status}"),
                                        ),
                                      ],
                                    ),
                                    data?.patient?.shippingDeliveryDate == null
                                        ? const SizedBox()
                                        : Row(
                                            children: [
                                              Text(
                                                "Requested Delivery Date : ",
                                                style:
                                                    AllListText().otherText(),
                                              ),
                                              Text(
                                                data?.patient
                                                        ?.shippingDeliveryDate ??
                                                    '',
                                                style: AllListText()
                                                    .subHeadingText(),
                                              ),
                                            ],
                                          ),
                                  ],
                                ),
                              ),
                              Text(
                                data?.updateTime ?? '',
                                style: AllListText().otherText(),
                              ),
                            ],
                          ),
                          Container(
                            height: 1,
                            margin: EdgeInsets.symmetric(vertical: 2.5.h),
                            color: gBlackColor.withOpacity(0.5),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox();
        }),
      );
    } else {
      return const SizedBox();
    }
  }

  buildPausedList() {
    if (pendingUserList?.data?.paused.length != 0) {
      return ListView.builder(
        scrollDirection: Axis.vertical,
        controller: _scrollController,
        padding: EdgeInsets.symmetric(horizontal: 1.w),
        physics: const ScrollPhysics(),
        shrinkWrap: true,
        itemCount: pendingUserList?.data?.paused.length,
        itemBuilder: ((context, index) {
          var data = pendingUserList?.data?.paused[index];
          return selectedDate == null
              ? GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ct) => ShippingDetailsScreen(
                          userName: data?.patient?.user?.name ?? '',
                          address: data?.patient?.address2 ?? '',
                          addressNo: data?.patient?.user?.address ?? '',
                          userId: data?.patient?.user?.id.toString() ?? '',
                          status: data?.patient?.status ?? '',
                        ),
                      ),
                    );
                    saveUserId(
                      int.parse("${data?.patient?.user?.id}"),
                    );
                  },
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 3.h,
                            backgroundImage: NetworkImage(
                              "${data?.patient?.user?.profile}",
                            ),
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data?.patient?.user?.name ?? '',
                                  style: AllListText().headingText(),
                                ),
                                // SizedBox(height: 0.5.h),
                                // Text(
                                //   "${data?.appointmentDate} / ${data?.appointmentTime}",
                                //   style: AllListText().subHeadingText(),
                                // ),
                                Row(
                                  children: [
                                    Text(
                                      "Status : ",
                                      style: AllListText().otherText(),
                                    ),
                                    Text(
                                      buildStatusText(
                                          "${data?.patient?.status}"),
                                      style: AllListText().deliveryDateText(
                                          "${data?.patient?.status}"),
                                    ),
                                  ],
                                ),
                                data?.patient?.shippingDeliveryDate == null
                                    ? const SizedBox()
                                    : Row(
                                        children: [
                                          Text(
                                            "Requested Delivery Date : ",
                                            style: AllListText().otherText(),
                                          ),
                                          Text(
                                            data?.patient
                                                    ?.shippingDeliveryDate ??
                                                '',
                                            style:
                                                AllListText().subHeadingText(),
                                          ),
                                        ],
                                      ),
                              ],
                            ),
                          ),
                          Text(
                            data?.updateTime ?? '',
                            style: AllListText().otherText(),
                          ),
                        ],
                      ),
                      Container(
                        height: 1,
                        margin: EdgeInsets.symmetric(vertical: 2.5.h),
                        color: gBlackColor.withOpacity(0.5),
                      ),
                    ],
                  ),
                )
              : DateFormat('dd/MM/yyyy')
                          .format(DateTime.parse((selectedDate.toString())))
                          .toString() ==
                      data?.patient?.shippingDeliveryDate.toString()
                  ? GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ct) =>ShippingDetailsScreen(
                              userName: data?.patient?.user?.name ?? '',
                              address: data?.patient?.address2 ?? '',
                              addressNo: data?.patient?.user?.address ?? '',
                              userId: data?.patient?.user?.id.toString() ?? '',
                              status: data?.patient?.status ?? '',
                            ),
                          ),
                        );
                        saveUserId(
                          int.parse("${data?.patient?.user?.id}"),
                        );
                      },
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 3.h,
                                backgroundImage: NetworkImage(
                                  "${data?.patient?.user?.profile}",
                                ),
                              ),
                              SizedBox(width: 3.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data?.patient?.user?.name ?? '',
                                      style: AllListText().headingText(),
                                    ),
                                    // Text(
                                    //   "${data?.appointmentDate} / ${data?.appointmentTime}",
                                    //   style: AllListText().subHeadingText(),
                                    // ),
                                    Row(
                                      children: [
                                        Text(
                                          "Status : ",
                                          style: AllListText().otherText(),
                                        ),
                                        Text(
                                          buildStatusText(
                                              "${data?.patient?.status}"),
                                          style: AllListText().deliveryDateText(
                                              "${data?.patient?.status}"),
                                        ),
                                      ],
                                    ),
                                    data?.patient?.shippingDeliveryDate == null
                                        ? const SizedBox()
                                        : Row(
                                            children: [
                                              Text(
                                                "Requested Delivery Date : ",
                                                style:
                                                    AllListText().otherText(),
                                              ),
                                              Text(
                                                data?.patient
                                                        ?.shippingDeliveryDate ??
                                                    '',
                                                style: AllListText()
                                                    .subHeadingText(),
                                              ),
                                            ],
                                          ),
                                  ],
                                ),
                              ),
                              Text(
                                data?.updateTime ?? '',
                                style: AllListText().otherText(),
                              ),
                            ],
                          ),
                          Container(
                            height: 1,
                            margin: EdgeInsets.symmetric(vertical: 2.5.h),
                            color: gBlackColor.withOpacity(0.5),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox();
        }),
      );
    } else {
      return const SizedBox();
    }
  }

  buildPackedList() {
    if (pendingUserList?.data?.packed.length != 0) {
      return ListView.builder(
        scrollDirection: Axis.vertical,
        controller: _scrollController,
        padding: EdgeInsets.symmetric(horizontal: 1.w),
        physics: const ScrollPhysics(),
        shrinkWrap: true,
        reverse: true,
        itemCount: pendingUserList?.data?.packed.length,
        itemBuilder: ((context, index) {
          var data = pendingUserList?.data?.packed[index];
          return selectedDate == null
              ? GestureDetector(
                  onTap: () {
                    shipRocketLoginController.shipRocketLogin();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ct) => ShippingDetailsScreen(
                          isTracking: true,
                          label: data?.orders ?? [],
                          userId: data?.patient?.user?.id.toString() ?? "",
                          userName: data?.patient?.user?.name ?? "",
                          address: data?.patient?.address2 ?? "",
                          status: data?.patient?.status ?? "",
                          addressNo: data?.patient?.user?.address ?? "",
                        ),
                      ),
                    );
                    saveUserId(
                      int.parse("${data?.patient?.user?.id}"),
                    );
                  },
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 3.h,
                            backgroundImage: NetworkImage(
                              "${data?.patient?.user?.profile}",
                            ),
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data?.patient?.user?.name ?? '',
                                  style: AllListText().headingText(),
                                ),
                                // SizedBox(height: 0.5.h),
                                // Text(
                                //   "${data?.appointmentDate} / ${data?.appointmentTime}",
                                //   style: AllListText().subHeadingText(),
                                // ),
                                Row(
                                  children: [
                                    Text(
                                      "Status : ",
                                      style: AllListText().otherText(),
                                    ),
                                    Text(
                                      buildStatusText(
                                          "${data?.patient?.status}"),
                                      style: AllListText().deliveryDateText(
                                          "${data?.patient?.status}"),
                                    ),
                                  ],
                                ),
                                data?.patient?.shippingDeliveryDate == null
                                    ? const SizedBox()
                                    : Row(
                                        children: [
                                          Text(
                                            "Requested Delivery Date : ",
                                            style: AllListText().otherText(),
                                          ),
                                          Text(
                                            data?.patient
                                                    ?.shippingDeliveryDate ??
                                                '',
                                            style:
                                                AllListText().subHeadingText(),
                                          ),
                                        ],
                                      ),
                              ],
                            ),
                          ),
                          Text(
                            data?.updateTime ?? '',
                            style: AllListText().otherText(),
                          ),
                        ],
                      ),
                      Container(
                        height: 1,
                        margin: EdgeInsets.symmetric(vertical: 2.5.h),
                        color: gBlackColor.withOpacity(0.5),
                      ),
                    ],
                  ),
                )
              : DateFormat('dd/MM/yyyy')
                          .format(DateTime.parse((selectedDate.toString())))
                          .toString() ==
                      data?.patient?.shippingDeliveryDate.toString()
                  ? GestureDetector(
                      onTap: () {
                        shipRocketLoginController.shipRocketLogin();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ct) => ShippingDetailsScreen(
                              isTracking: true,
                              label: data?.orders ?? [],
                              userId: data?.patient?.user?.id.toString() ?? "",
                              userName: data?.patient?.user?.name ?? "",
                              address: data?.patient?.address2 ?? "",
                              status: data?.patient?.status ?? "",
                              addressNo: data?.patient?.user?.address ?? "",
                            ),
                          ),
                        );
                        saveUserId(
                          int.parse("${data?.patient?.user?.id}"),
                        );
                      },
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 3.h,
                                backgroundImage: NetworkImage(
                                  "${data?.patient?.user?.profile}",
                                ),
                              ),
                              SizedBox(width: 3.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data?.patient?.user?.name ?? '',
                                      style: AllListText().headingText(),
                                    ),
                                    // Text(
                                    //   "${data?.appointmentDate} / ${data?.appointmentTime}",
                                    //   style: AllListText().subHeadingText(),
                                    // ),
                                    Row(
                                      children: [
                                        Text(
                                          "Status : ",
                                          style: AllListText().otherText(),
                                        ),
                                        Text(
                                          buildStatusText(
                                              "${data?.patient?.status}"),
                                          style: AllListText().deliveryDateText(
                                              "${data?.patient?.status}"),
                                        ),
                                      ],
                                    ),
                                    data?.patient?.shippingDeliveryDate == null
                                        ? const SizedBox()
                                        : Row(
                                            children: [
                                              Text(
                                                "Requested Delivery Date : ",
                                                style:
                                                    AllListText().otherText(),
                                              ),
                                              Text(
                                                data?.patient
                                                        ?.shippingDeliveryDate ??
                                                    '',
                                                style: AllListText()
                                                    .subHeadingText(),
                                              ),
                                            ],
                                          ),
                                  ],
                                ),
                              ),
                              CallChatIcons(
                                userId: "${data?.patient?.user?.id}",
                                kaleyraUserId:
                                    "${data?.patient?.user?.kaleyraUserId.toString()}",
                              ),
                              // Text(
                              //   data?.updateTime ?? '',
                              //   style: AllListText().otherText(),
                              // ),
                            ],
                          ),
                          Container(
                            height: 1,
                            margin: EdgeInsets.symmetric(vertical: 2.5.h),
                            color: gBlackColor.withOpacity(0.5),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox();
        }),
      );
    } else {
      return const SizedBox();
    }
  }

  buildDeliveredList() {
    if (pendingUserList?.data?.delivered.length != 0) {
      return ListView.builder(
        scrollDirection: Axis.vertical,
        controller: _scrollController,
        padding: EdgeInsets.symmetric(horizontal: 1.w),
        physics: const ScrollPhysics(),
        shrinkWrap: true,
        reverse: true,
        itemCount: pendingUserList?.data?.delivered.length,
        itemBuilder: ((context, index) {
          var data = pendingUserList?.data?.delivered[index];
          return selectedDate == null
              ? GestureDetector(
                  onTap: () {
                    shipRocketLoginController.shipRocketLogin();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ct) => ShippingDetailsScreen(
                          isTracking: true,
                          label: data?.orders ?? [],
                          userId: data?.patient?.user?.id.toString() ?? "",
                          userName: data?.patient?.user?.name ?? "",
                          address: data?.patient?.address2 ?? "",
                          status: data?.patient?.status ?? "",
                          addressNo: data?.patient?.user?.address ?? "",
                        ),
                        //     ApprovedOrderDetails(
                        //   label: data?.orders ?? [],
                        //   userName: data?.patient?.user?.name ?? '',
                        //   address: data?.patient?.address2 ?? '',
                        //   shipmentId: data?.orders?.first.shippingId ?? '',
                        //   orderId: data?.orders?.first.orderId ?? '',
                        //   status: data?.orders?.first.status ?? '',
                        //   addressNo: data?.patient?.user?.address ?? '',
                        //   pickupDate:
                        //       data?.orders?.first.pickupScheduledDate ?? '',
                        //   awbNumber: data?.orders?.first.awbCode ?? '',
                        // ),
                      ),
                    );
                    saveUserId(
                      int.parse("${data?.patient?.user?.id}"),
                    );
                  },
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 3.h,
                            backgroundImage: NetworkImage(
                              "${data?.patient?.user?.profile}",
                            ),
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data?.patient?.user?.name ?? '',
                                  style: AllListText().headingText(),
                                ),
                                // SizedBox(height: 0.5.h),
                                // Text(
                                //   "${data?.appointmentDate} / ${data?.appointmentTime}",
                                //   style: AllListText().subHeadingText(),
                                // ),
                                Row(
                                  children: [
                                    Text(
                                      "Status : ",
                                      style: AllListText().otherText(),
                                    ),
                                    Text(
                                      buildStatusText(
                                          "${data?.patient?.status}"),
                                      style: AllListText().deliveryDateText(
                                          "${data?.patient?.status}"),
                                    ),
                                  ],
                                ),
                                data?.patient?.shippingDeliveryDate == null
                                    ? const SizedBox()
                                    : Row(
                                        children: [
                                          Text(
                                            "Requested Delivery Date : ",
                                            style: AllListText().otherText(),
                                          ),
                                          Text(
                                            data?.patient
                                                    ?.shippingDeliveryDate ??
                                                '',
                                            style:
                                                AllListText().subHeadingText(),
                                          ),
                                        ],
                                      ),
                              ],
                            ),
                          ),
                          Text(
                            data?.updateTime ?? '',
                            style: AllListText().otherText(),
                          ),
                        ],
                      ),
                      Container(
                        height: 1,
                        margin: EdgeInsets.symmetric(vertical: 2.5.h),
                        color: gBlackColor.withOpacity(0.5),
                      ),
                    ],
                  ),
                )
              : DateFormat('dd/MM/yyyy')
                          .format(DateTime.parse((selectedDate.toString())))
                          .toString() ==
                      data?.patient?.shippingDeliveryDate.toString()
                  ? GestureDetector(
                      onTap: () {
                        shipRocketLoginController.shipRocketLogin();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ct) => ShippingDetailsScreen(
                              isTracking: true,
                              label: data?.orders ?? [],
                              userId: data?.patient?.user?.id.toString() ?? "",
                              userName: data?.patient?.user?.name ?? "",
                              address: data?.patient?.address2 ?? "",
                              status: data?.patient?.status ?? "",
                              addressNo: data?.patient?.user?.address ?? "",
                            ),
                            //     ApprovedOrderDetails(
                            //   label: data?.orders ?? [],
                            //   userName: data?.patient?.user?.name ?? '',
                            //   address: data?.patient?.address2 ?? '',
                            //   shipmentId: data?.orders?.first.shippingId ?? '',
                            //   orderId: data?.orders?.first.orderId ?? '',
                            //   status: data?.orders?.first.status ?? '',
                            //   addressNo: data?.patient?.user?.address ?? '',
                            //   pickupDate:
                            //       data?.orders?.first.pickupScheduledDate ?? '',
                            //   awbNumber: data?.orders?.first.awbCode ?? '',
                            // ),
                          ),
                        );
                        saveUserId(
                          int.parse("${data?.patient?.user?.id}"),
                        );
                      },
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 3.h,
                                backgroundImage: NetworkImage(
                                  "${data?.patient?.user?.profile}",
                                ),
                              ),
                              SizedBox(width: 3.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data?.patient?.user?.name ?? '',
                                      style: AllListText().headingText(),
                                    ),
                                    // Text(
                                    //   "${data?.appointmentDate} / ${data?.appointmentTime}",
                                    //   style: AllListText().subHeadingText(),
                                    // ),
                                    Row(
                                      children: [
                                        Text(
                                          "Status : ",
                                          style: AllListText().otherText(),
                                        ),
                                        Text(
                                          buildStatusText(
                                              "${data?.patient?.status}"),
                                          style: AllListText().deliveryDateText(
                                              "${data?.patient?.status}"),
                                        ),
                                      ],
                                    ),
                                    data?.patient?.shippingDeliveryDate == null
                                        ? const SizedBox()
                                        : Row(
                                            children: [
                                              Text(
                                                "Requested Delivery Date : ",
                                                style:
                                                    AllListText().otherText(),
                                              ),
                                              Text(
                                                data?.patient
                                                        ?.shippingDeliveryDate ??
                                                    '',
                                                style: AllListText()
                                                    .subHeadingText(),
                                              ),
                                            ],
                                          ),
                                  ],
                                ),
                              ),
                              CallChatIcons(
                                userId: "${data?.patient?.user?.id}",
                                kaleyraUserId:
                                    "${data?.patient?.user?.kaleyraUserId.toString()}",
                              ),
                              // Text(
                              //   data?.updateTime ?? '',
                              //   style: AllListText().otherText(),
                              // ),
                            ],
                          ),
                          Container(
                            height: 1,
                            margin: EdgeInsets.symmetric(vertical: 2.5.h),
                            color: gBlackColor.withOpacity(0.5),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox();
        }),
      );
    } else {
      return const SizedBox();
    }
  }

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate, // Refer step 1
      firstDate: DateTime(1000),
      lastDate: DateTime(3000),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  String buildStatusText(String status) {
    if (status == "report_upload") {
      return "MR Upload";
    } else if (status == "check_user_reports") {
      return "Check User Reports";
    } else if (status == "meal_plan_completed") {
      return "Meal Plan Completed";
    } else if (status == "shipping_paused") {
      return "Shipment Paused";
    } else if (status == "shipping_packed") {
      return "Shipment Packed";
    } else if (status == "shipping_approved") {
      return "Shipment Approved";
    } else if (status == "shipping_delivered") {
      return "Shipment Delivered";
    } else if (status == "prep_meal_plan_completed") {
      return "Meal Plan Pending";
    }
    return statusText;
  }

  saveUserId(int userId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt("user_id", userId);
  }

  final ShipmentRepo repository = ShipmentRepo(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );
}
