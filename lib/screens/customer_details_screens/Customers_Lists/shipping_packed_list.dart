import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:get/get.dart';

import '../../../controller/pending_user_list_controller.dart';
import '../../../utils/constants.dart';
import '../../../widgets/common_screen_widgets.dart';
import '../../../widgets/widgets.dart';
import '../shipping_details_screen/approved_order_details.dart';

class ShippingPackedList extends StatefulWidget {
  const ShippingPackedList({Key? key}) : super(key: key);

  @override
  State<ShippingPackedList> createState() => _ShippingPackedListState();
}

class _ShippingPackedListState extends State<ShippingPackedList> {

  PendingUserListController pendingUserListController =
  Get.put(PendingUserListController());

  @override
  Widget build(BuildContext context) {
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
                                      SizedBox(height: 0.7.h),
                                      Text(
                                        "${data[index].appointmentDate.toString()} / ${data[index].appointmentTime.toString()}",
                                        style: AllListText().subHeadingText(),
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
              padding: EdgeInsets.symmetric(vertical: 30.h),
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
