import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import '../../model/customer_profile_model.dart';
import '../../model/error_model.dart';
import '../../repository/customer_details_repo/customer_profile_repo.dart';
import '../../service/api_service.dart';
import '../../service/customer_details_service/customer_profile_service.dart';
import '../../utils/constants.dart';
import '../../widgets/common_screen_widgets.dart';
import '../../widgets/widgets.dart';
import '../nutri_delight_screens/daily_progress_screens/progress_details.dart';
import '../nutri_delight_screens/nutri_delight_detox.dart';
import '../nutri_delight_screens/nutri_delight_healing.dart';
import '../nutri_delight_screens/nutri_delight_nourish.dart';
import '../nutri_delight_screens/nutri_delight_preparatory.dart';
import '../shipping_details_screen/shipping_details_screen.dart';

class CalendarCustomerScreen extends StatefulWidget {
  final int userId;
  final int tabIndex;

  const CalendarCustomerScreen({
    Key? key,
    required this.userId,
    required this.tabIndex,
  }) : super(key: key);

  @override
  State<CalendarCustomerScreen> createState() => _CalendarCustomerScreenState();
}

class _CalendarCustomerScreenState extends State<CalendarCustomerScreen>
    with SingleTickerProviderStateMixin {
  TabController? tabController;

  GetCustomerModel? getCustomerModel;

  bool showProgress = false;

  late final CustomerProfileService customerProfileService =
      CustomerProfileService(customerProfileRepo: repository);

  @override
  void initState() {
    super.initState();
    getCustomerDetails();
    tabController = TabController(
      initialIndex: widget.tabIndex,
      length: 6,
      vsync: this,
    );
  }

  getCustomerDetails() async {
    setState(() {
      showProgress = true;
    });
    final result = await customerProfileService
        .getCustomerProfileService("${widget.userId}");
    print("result: $result");

    if (result.runtimeType == GetCustomerModel) {
      print("Customer Profile");
      GetCustomerModel model = result as GetCustomerModel;

      getCustomerModel = model;
    } else {
      ErrorModel model = result as ErrorModel;
      print("error: ${model.message}");
    }
    setState(() {
      showProgress = false;
    });
    print(result);
  }

  @override
  void dispose() async {
    super.dispose();
    tabController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: gWhiteColor,
      appBar: buildAppBar(() {
        Navigator.pop(context);
      }),
      body: showProgress
          ? buildCircularIndicator()
          : SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      getCustomerModel?.username ?? '',
                      style: AllListText().headingText(),
                    ),
                    Text(
                      getCustomerModel?.age ?? '',
                      style: AllListText().subHeadingText(),
                    ),
                    Text(
                      buildTimeDate(
                          getCustomerModel?.consultationDateAndTime?.date ?? "",
                          getCustomerModel
                                  ?.consultationDateAndTime?.slotStartTime ??
                              ""),
                      style: AllListText().otherText(),
                    ),
                    TabBar(
                        // padding: EdgeInsets.symmetric(horizontal: 3.w),
                        labelColor: tapSelectedColor,
                        controller: tabController,
                        unselectedLabelColor: tapUnSelectedColor,
                        isScrollable: true,
                        indicatorColor: tapIndicatorColor,
                        labelStyle: TabBarText().selectedText(),
                        unselectedLabelStyle: TabBarText().unSelectedText(),
                        labelPadding: EdgeInsets.only(
                            right: 6.w, left: 2.w, top: 1.h, bottom: 1.h),
                        indicatorPadding: EdgeInsets.only(right: 5.w),
                        tabs: const [
                          // Text('Medical Report'),
                          // Text('Case Sheet'),
                          Text('Shipment'),
                          Text('Progress'),
                          Text('Preparatory'),
                          Text("Detox"),
                          Text('Healing'),
                          Text('Nourish'),
                        ]),
                    Container(
                      height: 1,
                      color: gBlackColor.withOpacity(0.5),
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: tabController,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          // MedicalReportDetails(
                          //     mrUrl: getCustomerModel?.mrReport?.report ?? ''),
                          // CaseStudyDetails(
                          //     csUrl: getCustomerModel?.caseSheet?.report ?? ''),
                          ShippingDetailsScreen(
                            userName: getCustomerModel?.username ?? '',
                            userId: widget.userId.toString(),
                            isTap: true,

                          ),
                           ProgressDetails(userId: widget.userId),
                           NutriDelightPreparatory(userId: widget.userId),
                           NutriDelightDetox(userId: widget.userId),
                           NutriDelightHealing(userId: widget.userId),
                           NutriDelightNourish(userId: widget.userId),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  final CustomerProfileRepo repository = CustomerProfileRepo(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );
}
