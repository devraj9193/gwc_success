import 'package:flutter/material.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

import '../../model/pending_list_model.dart';
import '../../repository/ship_rocket_repository/ship_track_repo.dart';
import '../../service/api_service.dart';
import '../../service/ship_rocket_service/ship_track_service.dart';
import '../../utils/app_confiq.dart';
import '../../utils/constants.dart';
import '../../utils/gwc_api.dart';
import '../../widgets/common_screen_widgets.dart';
import '../../widgets/customer_list_widgets.dart';
import 'order_Details.dart';
import 'tracking/cook_kit_tracking.dart';

class ShippingDetailsScreen extends StatefulWidget {
  final String? userName;
  final List<Order>? label;
  final String? address;
  final String? addressNo;
  final String? status;
  final String? userId;
  final bool isTracking;
  final bool isTap;
  const ShippingDetailsScreen({
    Key? key,
    this.userName,
    this.label,
    this.address,
    this.addressNo,
    this.status,
    this.userId,
    this.isTracking = false,
    this.isTap = false
  }) : super(key: key);

  @override
  State<ShippingDetailsScreen> createState() => _ShippingDetailsScreenState();
}

class _ShippingDetailsScreenState extends State<ShippingDetailsScreen> {
  final _pref = GwcApi.preferences;

  @override
  void initState() {
    super.initState();
    if (_pref!.getString(AppConfig().shipRocketBearer) == null ||
        _pref!.getString(AppConfig().shipRocketBearer)!.isEmpty) {
      getShipRocketToken();
    } else {
      String token = _pref!.getString(AppConfig().shipRocketBearer)!;
      Map<String, dynamic> payload = Jwt.parseJwt(token);
      print('shipRocketToken : $payload');
      var date = DateTime.fromMillisecondsSinceEpoch(payload['exp'] * 1000);
      if (!DateTime.now().difference(date).isNegative) {
        getShipRocketToken();
      }
    }
  }

  void getShipRocketToken() async {
    print("getShipRocketToken called");
    ShipRocketService shipRocketService =
    ShipRocketService(shipRocketRepository: shipTrackRepository);
    final getToken = await shipRocketService.getShipRocketTokenService(
        AppConfig().shipRocketEmail, AppConfig().shipRocketPassword);
    print(getToken);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: gWhiteColor,
      appBar:widget.isTap ? null : AppBar(
        backgroundColor: gWhiteColor,
        centerTitle: false,
        automaticallyImplyLeading: false,
        elevation: 0,
        title:  Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back_ios_new_sharp,
                color: gSecondaryColor,
                size: 2.h,
              ),
            ),
            SizedBox(width: 2.w),
            SizedBox(
              height: 5.h,
              child: const Image(
                image: AssetImage("assets/images/Gut wellness logo.png"),
              ),
            ),
          ],
        ),
        actions: [
          widget.isTracking
              ? GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ct) => CookKitTracking(
                    awbNumber: widget.label?.first.awbCode ?? '',
                    userName: widget.userName ?? '',
                  ),
                ),
              );
            },
            child:const Padding(
              padding:  EdgeInsets.all(8.0),
              child:  Image(
                image: AssetImage(
                  'assets/images/Group 62759.png',
                ),
                color: gBlackColor,
              ),
            ),
          )
              : const SizedBox(),
          SizedBox(width: 2.w),
        ],
      ),
      body: SafeArea(
        child: widget.isTracking
            ? buildPackedAndDeliveredDetails()
            : buildPendingAndPausedDetails(),
      ),
    );
  }

  buildPendingAndPausedDetails() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          profileTile("Name : ", "${widget.userName}"),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 0.5.h, horizontal: 5.w),
            child: Row(
              children: [
                Text(
                  "Status : ",
                  style: AllListText().otherText(),
                ),
                Text(
                  buildStatusText("${widget.status}"),
                  style: AllListText().deliveryDateText("${widget.status}"),
                ),
              ],
            ),
          ),
          profileTile("Address : ", "${widget.addressNo}, ${widget.address}"),
          OrderDetails(
            userId: "${widget.userId}",
          ),
        ],
      ),
    );
  }

  buildPackedAndDeliveredDetails() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          profileTile("Name : ", widget.userName ?? ''),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 0.5.h, horizontal: 5.w),
            child: Row(
              children: [
                Text(
                  "Status : ",
                  style: AllListText().otherText(),
                ),
                Text(
                  buildStatusText("${widget.status}"),
                  style: AllListText().deliveryDateText("${widget.status}"),
                ),
              ],
            ),
          ),
          profileTile("Address : ", "${widget.addressNo}, ${widget.address}"),
          widget.label!.isNotEmpty
              ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              profileTile(
                  "Shipment Id : ", widget.label?.first.shippingId ?? ''),
              profileTile(
                  "Order Id : ", widget.label?.first.orderId ?? ''),
              profileTile("Ship Rocket Status : ",
                  widget.label?.first.status ?? ''),
              profileTile("Pickup Schedule : ",
                  widget.label?.first.pickupScheduledDate ?? ''),
            ],
          )
              : const SizedBox(),
          SizedBox(height: 1.h),
          OrderDetails(
            userId: "${widget.userId}",
          ),
        ],
      ),
    );
  }

  profileTile(String title, String subTitle) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h, horizontal: 5.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AllListText().otherText(),
          ),
          Expanded(
            child: Text(
              subTitle,
              style: AllListText().subHeadingText(),
            ),
          ),
        ],
      ),
    );
  }

  final ShipRocketRepository shipTrackRepository = ShipRocketRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );
}
