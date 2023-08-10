import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

import '../../model/customer_order_details_model.dart';
import '../../model/error_model.dart';
import '../../repository/shipment_repo/shipment_repo.dart';
import '../../service/api_service.dart';
import '../../service/shipment_service/shipment_service.dart';
import '../../utils/constants.dart';
import '../../widgets/common_screen_widgets.dart';
import '../../widgets/widgets.dart';

class OrderDetails extends StatefulWidget {
  final String userId;
  const OrderDetails({Key? key, required this.userId}) : super(key: key);

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  bool isLoading = false;
  bool isError = false;

  bool isScrollStory = true;

  late final ShipmentService shipmentService =
  ShipmentService(shipmentRepo: repository);

  CustomerOrderDetails? customerOrderDetails;

  @override
  void initState() {
    super.initState();
    getShipmentList();
  }

  getShipmentList() async {
    setState(() {
      isLoading = true;
    });
    callProgressStateOnBuild(true);
    final result = await shipmentService.getShoppingItemService(widget.userId);
    print("result: $result");

    if (result.runtimeType == CustomerOrderDetails) {
      print("Ticket List");
      CustomerOrderDetails model = result as CustomerOrderDetails;

      customerOrderDetails = model;

    } else {
      ErrorModel model = result as ErrorModel;
      print("error: ${model.message}");
      setState(() {
        isLoading = false;
      });
    }
    setState(() {
      isLoading = false;
    });
    print(result);
  }

  callProgressStateOnBuild(bool value) {
    Future.delayed(Duration.zero).whenComplete(() {
      setState(() {
        isLoading = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List<GetShoppingListElement> shoppingList = customerOrderDetails?.data.shippingProductList ?? [];
    return isLoading ? buildCircularIndicator() : Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border:
        Border.all(color: gBlackColor.withOpacity(0.3), width: 1),
      ),
      child: DataTable(
        // columnSpacing: 50.w,
        headingTextStyle: AllListText().subHeadingText(),
        headingRowHeight: 5.h,
        horizontalMargin: 7.w,
        columns: const <DataColumn>[
          DataColumn(label: Text('Meal Name')),
          DataColumn(label: Text('Weight')),
        ],
        rows: List.generate(shoppingList.length, (index) {
          return DataRow(
            cells: [
              DataCell(
                Text(
                  shoppingList[index].mealItem?.name ?? '',
                  style: AllListText().otherText(),
                ),
              ),
              DataCell(
                Text(
                  shoppingList[index].itemWeight ?? '',
                  maxLines: 3,
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                  style: AllListText().otherText(),
                ),
                placeholder: true,
              ),
            ],
          );
        }),
      ),
    );
  }

  final ShipmentRepo repository = ShipmentRepo(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );
}
