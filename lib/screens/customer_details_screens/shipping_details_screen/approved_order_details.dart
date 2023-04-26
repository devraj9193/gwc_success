import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:get/get.dart';
import '../../../../controller/customer_order_details_controller.dart';
import '../../../../../model/pending_list_model.dart';
import '../../../../../utils/constants.dart';
import '../../../../../widgets/widgets.dart';

class ApprovedOrderDetails extends StatefulWidget {
  final String userName;
  final List<Order> label;
  final String address;
  final String addressNo;
  final String shipmentId;
  final String orderId;
  final String status;
  final String pickupDate;

  const ApprovedOrderDetails({
    Key? key,
    required this.label,
    required this.userName,
    required this.address,
    required this.shipmentId,
    required this.orderId,
    required this.status,
    required this.addressNo,
    required this.pickupDate,
  }) : super(key: key);

  @override
  State<ApprovedOrderDetails> createState() => _ApprovedOrderDetailsState();
}

class _ApprovedOrderDetailsState extends State<ApprovedOrderDetails> {

  CustomerOrderDetailsController customerOrderDetailsController =
  Get.put(CustomerOrderDetailsController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: buildAppBar(() {
          Navigator.pop(context);
        }),
        backgroundColor: whiteTextColor,

        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 5.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    // GestureDetector(
                    //   onTap: () {
                    //     Navigator.of(context).push(
                    //       MaterialPageRoute(
                    //         builder: (ct) => CookKitTracking(
                    //           currentStage: '',
                    //         ),
                    //       ),
                    //     );
                    //   },
                    //   child: SvgPicture.asset(
                    //     'assets/images/Filter.svg',
                    //     color: gPrimaryColor,
                    //     height: 2.h,
                    //   ),
                    // ),
                  ],
                ),
              ),
              customerDetails(),
              SizedBox(height: 1.h),
              //  buildDetails(),
              // SizedBox(height: 1.h),
              FutureBuilder(
                  future: customerOrderDetailsController.getOrderDetails(),
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.hasError) {
                      return const Text("");
                    } else if (snapshot.hasData) {
                      var data = snapshot.data;
                      return Container(
                        width: double.maxFinite,
                        margin: EdgeInsets.symmetric(
                            vertical: 2.h, horizontal: 4.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: gBlackColor.withOpacity(0.3), width: 1),
                        ),
                        child: DataTable(
                        //  columnSpacing: 50.w,
                          headingTextStyle: TextStyle(
                            color: gBlackColor,
                            fontSize: 8.sp,
                            fontFamily: "GothamBold",
                          ),
                          headingRowHeight: 5.h,
                          dataRowHeight: 5.h,
                          horizontalMargin: 7.w,
                          columns: const <DataColumn>[
                            DataColumn(label: Text('Meal Name')),
                            DataColumn(label: Text('Weight')),
                          ],
                          rows: List.generate(data.length, (index) {
                            return DataRow(
                              cells: [
                                DataCell(
                                  Text(
                                    data[index].mealItem.name.toString(),
                                    style: TextStyle(
                                      color: gBlackColor,
                                      fontSize: 7.sp,
                                      fontFamily: "GothamBook",
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    data[index].itemWeight.toString(),
                                    maxLines: 3,
                                    textAlign: TextAlign.start,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      height: 1.5,
                                      color: gBlackColor,
                                      fontSize: 7.sp,
                                      fontFamily: "GothamBook",
                                    ),
                                  ),
                                  placeholder: true,
                                ),
                              ],
                            );
                          }),
                        ),
                      );
                    }
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      child: buildCircularIndicator(),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }

  customerDetails() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          profileTile("Name : ", widget.userName),
          profileTile("Address : ", "${widget.addressNo}, ${widget.address}"),
          profileTile("Shipment Id : ", widget.shipmentId),
          profileTile("Order Id : ", widget.orderId),
          profileTile("Status : ", widget.status),
          profileTile("Pickup Schedule : ", widget.pickupDate),
        ],
      ),
    );
  }

  profileTile(String title, String subTitle) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              color: gBlackColor,
              fontFamily: 'GothamBold',
              fontSize: 8.sp,
            ),
          ),
          Expanded(
            child: Text(
              subTitle,
              style: TextStyle(
                color: gBlackColor,
                fontFamily: 'GothamMedium',
                fontSize: 7.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
