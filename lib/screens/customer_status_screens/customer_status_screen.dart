import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../model/claimed_customer_model/claimed_customer_list_model.dart';
import '../../model/consultation_model.dart';
import '../../model/error_model.dart';
import '../../model/maintenance_guide_model.dart';
import '../../model/meal_active_model.dart';
import '../../model/pending_list_model.dart';
import '../../repository/customer_status_repo.dart/customer_status_repo.dart';
import '../../service/api_service.dart';
import '../../service/customer_status_service/customer_status_service.dart';
import '../../utils/constants.dart';
import '../../widgets/common_screen_widgets.dart';
import '../../widgets/widgets.dart';
import '../claimed_customer_screen/claimed_customer_list.dart';
import '../customer_details_screens/Customers_Lists/active_list.dart';
import '../customer_details_screens/Customers_Lists/completed_list_screen.dart';
import '../customer_details_screens/Customers_Lists/consultation_pending_list.dart';
import '../customer_details_screens/Customers_Lists/maintenance_guide_list.dart';
import '../customer_details_screens/Customers_Lists/meal_plan_list_screen.dart';
import '../customer_details_screens/Customers_Lists/pp_consultation_pending_list.dart';
import 'package:http/http.dart' as http;

import '../shipping_details_screen/shipment_details_list.dart';

class CustomerStatusScreen extends StatefulWidget {
  const CustomerStatusScreen({Key? key}) : super(key: key);

  @override
  State<CustomerStatusScreen> createState() => _CustomerStatusScreenState();
}

class _CustomerStatusScreenState extends State<CustomerStatusScreen>  with SingleTickerProviderStateMixin {

  bool isLoading = false;
  bool isError = false;
  int claimedListCount = 0;
  int consultationPendingListCount = 0;
  int shipmentListCount = 0;
  int mealListCount = 0;
  int activeListCount = 0;
  int ppListCount = 0;
  int maintenanceGuideListCount = 0;
  int completedListCount = 0;

  List<String> storiesUrl = [];

  TabController? tabController;
  bool isScrollStory = true;

  late final CustomerStatusService customerStatusService =
  CustomerStatusService(customerStatusRepo: repository);

  ClaimedCustomerListModel? claimedCustomerListModel;
  ConsultationModel? consultationModel;
  PendingUserList? pendingUserList;
  MealActiveModel? mealActiveModel;
  MaintenanceGuideModel? maintenanceGuideModel;

  @override
  void initState() {
    super.initState();
    getClaimedCustomerCount();
    getConsultationPendingCount();
    getShipmentCount();
    getMealActiveCount();
    getPostProgramCount();
    tabController = TabController(
      initialIndex: 0,
      length: 8,
      vsync: this,
    );
  }

  getClaimedCustomerCount() async {
    final result = await customerStatusService.getClaimedCustomerService();
    print("result: $result");

    if (result.runtimeType == ClaimedCustomerListModel) {
      print("Ticket List");
      ClaimedCustomerListModel model = result as ClaimedCustomerListModel;

      claimedCustomerListModel = model;

      int? count = claimedCustomerListModel?.data?.length;

      setState(() {
        claimedListCount = count!;
        print("claimedCount: $claimedListCount");
      });

    } else {
      ErrorModel model = result as ErrorModel;
      print("error: ${model.message}");
    }
    print(result);
  }

  getConsultationPendingCount() async {
    final result = await customerStatusService.getConsultationPendingService();
    print("result: $result");

    if (result.runtimeType == ConsultationModel) {
      print("Ticket List");
      ConsultationModel model = result as ConsultationModel;

      consultationModel = model;

      int? count = consultationModel?.appDetails?.length;

      setState(() {
        consultationPendingListCount = count!;
        print("consultationPendingListCount: $consultationPendingListCount");
      });

    } else {
      ErrorModel model = result as ErrorModel;
      print("error: ${model.message}");
    }
    print(result);
  }

  getShipmentCount() async {
    final result = await customerStatusService.getShipmentService();
    print("result: $result");

    if (result.runtimeType == PendingUserList) {
      print("Ticket List");
      PendingUserList model = result as PendingUserList;

      pendingUserList = model;

      int? pendingListCount = pendingUserList?.data?.pending.length;

      int? pausedListCount = pendingUserList?.data?.paused.length;

      int? packedListCount = pendingUserList?.data?.packed.length;

      setState(() {
        shipmentListCount = pendingListCount! + pausedListCount! + packedListCount!;
        print("Count = ${pendingListCount + pausedListCount + packedListCount}");
      });

      print("shipmentListCount = $shipmentListCount");
    } else {
      ErrorModel model = result as ErrorModel;
      print("error: ${model.message}");
    }
    print(result);
  }

  getMealActiveCount() async {
    final result = await customerStatusService.getMealActiveService();
    print("result: $result");

    if (result.runtimeType == MealActiveModel) {
      print("Ticket List");
      MealActiveModel model = result as MealActiveModel;

      mealActiveModel = model;

      int? mealCount = mealActiveModel?.mealPlanList?.length;

      int? activeCount = mealActiveModel?.activeDetails?.length;

      setState(() {
        mealListCount = mealCount!;
        activeListCount = activeCount!;
        print("mealListCount: $mealListCount");
        print("activeListCount: $activeListCount");
      });

    } else {
      ErrorModel model = result as ErrorModel;
      print("error: ${model.message}");
    }
    print(result);
  }

  getPostProgramCount() async {
    final result = await customerStatusService.getPostProgramService();
    print("result: $result");

    if (result.runtimeType == MaintenanceGuideModel) {
      print("Ticket List");
      MaintenanceGuideModel model = result as MaintenanceGuideModel;

      maintenanceGuideModel = model;

      int? ppCount = maintenanceGuideModel?.postProgramList?.length;
      int? mgCount = maintenanceGuideModel?.gutMaintenanceGuide?.length;
      int? completedCount = maintenanceGuideModel?.gmgSubmitted?.length;

      setState(() {
        ppListCount = ppCount!;
        maintenanceGuideListCount = mgCount!;
        completedListCount = completedCount!;
        print("ppListCount: $ppListCount");
        print("maintenanceGuideListCount: $maintenanceGuideListCount");
      });

    } else {
      ErrorModel model = result as ErrorModel;
      print("error: ${model.message}");
    }
    print(result);
  }

  @override
  void dispose() async {
    super.dispose();
    tabController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 1.h),
        TabBar(
            controller: tabController,
            labelColor: tapSelectedColor,
            padding: EdgeInsets.symmetric(horizontal: 3.w),
            unselectedLabelColor: tapUnSelectedColor,
            labelStyle: TabBarText().selectedText(),
            unselectedLabelStyle: TabBarText().unSelectedText(),
            isScrollable: true,
            indicatorColor: tapIndicatorColor,
            labelPadding: EdgeInsets.only(
                right: 7.w, left: 2.w, top: 1.h, bottom: 1.h),
            indicatorPadding: EdgeInsets.only(right: 5.w),
            tabs:  [
              buildTapCount('Claimed Users', claimedListCount),
              buildTapCount('Consultation Pending', consultationPendingListCount),

              buildTapCount('Meal Plan', mealListCount),
              buildTapCount('Shipment', shipmentListCount),
              buildTapCount('Active', activeListCount),
              buildTapCount('Post Program Consultation', ppListCount),
              buildTapCount('Maintenance Guide', maintenanceGuideListCount),
              buildTapCount('Completed', completedListCount),
            ],),
        Container(
          height: 1,
          margin: EdgeInsets.only(left: 0.w, bottom: 1.h),
          color: gGreyColor.withOpacity(0.3),
          width: double.maxFinite,
        ),
        Expanded(
          child: TabBarView(
              controller: tabController,
              children: const [
                ClaimedCustomerList(),
                ConsultationPendingList(),

                // ShippingPendingList(),
                // ShippingPausedList(),
                // ShippingPackedList(),
                MealPlanListScreen(),
                ShipmentDetailsList(),
                ActiveList(),
                // TransitionList(),
                PPConsultationPendingList(),
                MaintenanceGuideList(),
                CompletedList(),
              ],),
        ),
      ],
    );
  }

  final CustomerStatusRepo repository = CustomerStatusRepo(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );
}
