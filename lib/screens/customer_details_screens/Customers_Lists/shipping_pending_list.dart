import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:get/get.dart';

import '../../../controller/pending_user_list_controller.dart';
import '../../../utils/constants.dart';
import '../../../widgets/common_screen_widgets.dart';
import '../../../widgets/widgets.dart';

class ShippingPendingList extends StatefulWidget {
  const ShippingPendingList({Key? key}) : super(key: key);

  @override
  State<ShippingPendingList> createState() => _ShippingPendingListState();
}

class _ShippingPendingListState extends State<ShippingPendingList> {
  DateTime initialDate = DateTime.now();
  DateTime? selectedDate;

  PendingUserListController pendingUserListController =
  Get.put(PendingUserListController());

  @override
  Widget build(BuildContext context) {
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
              return data.length != 0
                  ?  Column(
                children: [
                  // Container(
                  //   height: 1,
                  //   color: gBlackColor.withOpacity(0.5),
                  // ),
                  Padding(
                    padding:
                    EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Text(""),
                        selectedDate.isNull
                            ? Text(
                          "All",
                          style: TabBarText().selectedText(),
                        )
                            : Text(
                          DateFormat('dd/MM/yyyy')
                              .format(DateTime.parse(
                              (selectedDate.toString())))
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
                  ListView.builder(
                    scrollDirection: Axis.vertical,
                    padding: EdgeInsets.symmetric(horizontal: 1.w),
                    physics: const ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: data.length,
                    itemBuilder: ((context, index) {
                      return selectedDate.isNull
                          ?  GestureDetector(
                        onTap: () {
                          // Navigator.of(context).push(
                          //   MaterialPageRoute(
                          //     builder: (ct) => PendingPausedOrderDetails(
                          //       userName: data[index]
                          //           .patient
                          //           .user
                          //           .name
                          //           .toString(),
                          //       address: data[index]
                          //           .patient
                          //           .address2
                          //           .toString(),
                          //       addressNo: data[index]
                          //           .patient
                          //           .user
                          //           .address
                          //           .toString(),
                          //     ),
                          //   ),
                          // );
                          // saveUserId(
                          //   data[index].patient.user.id,
                          // );
                        },
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 3.h,
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
                                        style: AllListText().headingText(),
                                      ),
                                      // SizedBox(height: 0.5.h),
                                      Text(
                                        "${data[index].appointmentDate.toString()} / ${data[index].appointmentTime.toString()}",
                                        style: AllListText().subHeadingText(),
                                      ),
                                      data[index]
                                          .patient
                                          .shippingDeliveryDate ==
                                          null
                                          ? const SizedBox()
                                          : Row(
                                        children: [
                                          Text(
                                            "Shipping Delivery Date : ",
                                            style: AllListText()
                                                .deliveryDateOtherText(),
                                          ),
                                          Text(
                                            data[index]
                                                .patient
                                                .shippingDeliveryDate
                                                .toString(),
                                            style: AllListText()
                                                .deliveryDateText("${data?.patient?.status}"),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  data[index].updateTime.toString(),
                                  style: AllListText().otherText(),
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
                      )  : DateFormat('dd/MM/yyyy')
                          .format(DateTime.parse(
                          (selectedDate.toString())))
                          .toString() ==
                          data[index]
                              .patient
                              .shippingDeliveryDate
                              .toString()
                          ? GestureDetector(
                        onTap: () {
                          // Navigator.of(context).push(
                          //   MaterialPageRoute(
                          //     builder: (ct) =>
                          //         // PendingPausedOrderDetails(
                          //         //   userName: data[index]
                          //         //       .patient
                          //         //       .user
                          //         //       .name
                          //         //       .toString(),
                          //         //   address: data[index]
                          //         //       .patient
                          //         //       .address2
                          //         //       .toString(),
                          //         //   addressNo: data[index]
                          //         //       .patient
                          //         //       .user
                          //         //       .address
                          //         //       .toString(),
                          //         // ),
                          //   ),
                          // );
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
                                  radius: 3.h,
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
                                    CrossAxisAlignment
                                        .start,
                                    children: [
                                      Text(
                                        data[index]
                                            .patient
                                            .user
                                            .name
                                            .toString(),
                                        style: AllListText()
                                            .headingText(),
                                      ),
                                      Text(
                                        "${data[index].appointmentDate.toString()} / ${data[index].appointmentTime.toString()}",
                                        style: AllListText()
                                            .subHeadingText(),
                                      ),
                                      data[index]
                                          .patient
                                          .shippingDeliveryDate ==
                                          null
                                          ? const SizedBox()
                                          : Row(
                                        children: [
                                          Text(
                                            "Shipping Delivery Date : ",
                                            style: AllListText()
                                                .deliveryDateOtherText(),
                                          ),
                                          Text(
                                            data[index]
                                                .patient
                                                .shippingDeliveryDate
                                                .toString(),
                                            style: AllListText()
                                                .deliveryDateText("${data?.patient?.status}"),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  data[index]
                                      .updateTime
                                      .toString(),
                                  style:
                                  AllListText().otherText(),
                                ),
                              ],
                            ),
                            Container(
                              height: 1,
                              margin: EdgeInsets.symmetric(
                                  vertical: 2.5.h),
                              color:
                              gBlackColor.withOpacity(0.5),
                            ),
                          ],
                        ),
                      )
                          : const SizedBox();
                    }),
                  ),


                ],
              ): buildNoData();
            }
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 30.h),
              child: buildCircularIndicator(),
            );
          }),
    );
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

  saveUserId(int userId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt("user_id", userId);
  }
}
