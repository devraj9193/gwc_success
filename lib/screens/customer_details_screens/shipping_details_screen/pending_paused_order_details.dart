import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:get/get.dart';
import '../../../../utils/constants.dart';
import '../../../../widgets/widgets.dart';
import '../../../../controller/customer_order_details_controller.dart';
import '../../../widgets/common_screen_widgets.dart';

class PendingPausedOrderDetails extends StatefulWidget {
  final String userName;
  final String address;
  final String addressNo;
  const PendingPausedOrderDetails({Key? key, required this.userName, required this.address, required this.addressNo})
      : super(key: key);

  @override
  State<PendingPausedOrderDetails> createState() =>
      _PendingPausedOrderDetailsState();
}

class _PendingPausedOrderDetailsState extends State<PendingPausedOrderDetails> {
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

              profileTile("Name : ", widget.userName),
              profileTile("Address : ", "${widget.addressNo}, ${widget.address}"),
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
                          //columnSpacing: 50.w,
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

  profileTile(String title, String subTitle) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h, horizontal: 5.w),
      child: Row(
        children: [
          Text(
            title,
            style: AllListText().subHeadingText(),

          ),
          Expanded(
            child: Text(
              subTitle,
              style: AllListText().otherText(),

            ),
          ),
        ],
      ),
    );
  }}
