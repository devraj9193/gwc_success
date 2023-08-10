import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../utils/constants.dart';
import 'common_screen_widgets.dart';

String statusText = "";

Row customerStatusWidget(String status) {
  return Row(
    children: [
      Text(
        "Status : ",
        style: AllListText().otherText(),
      ),
      Text(
        buildStatusText(status),
        style: AllListText().subHeadingText(),
      ),
      SizedBox(width: 1.w),
      buildIconWidget(status),
    ],
  );
}

String buildStatusText(String status) {
  print("status status: $status");

  if (status == "consultation_done") {
    return "Consultation Done";
  } else if (status == "consultation_accepted") {
    return "Accepted (MR & CS Pending)";
  } else if (status == "consultation_rejected") {
    return "Consultation Rejected";
  } else if (status == "consultation_waiting") {
    return "Waiting for Reports";
  } else if (status == "pending") {
    return "Pending";
  } else if (status == "wait") {
    return "Requested for Reports";
  } else if (status == "accepted") {
    return "Accepted (MR & CS Pending)";
  } else if (status == "rejected") {
    return "Consultation Rejected";
  } else if (status == "evaluation_done") {
    return "Evaluation Done";
  } else if (status == "declined") {
    return "Declined";
  } else if (status == "check_user_reports") {
    return "Check User Reports";
  } else if (status == "appointment_booked") {
    return "Pending";
  }else if (status == "report_upload") {
    return "MR Upload";
  } else if (status == "meal_plan_completed") {
    return "Meal Plan Completed\n(Shipment Awaited)";
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
  } else if (status == "start_program") {
    return "Started Program";
  }  else if (status == "post_program") {
    return "Post Consultation Pending";
  } else if (status == "post_appointment_booked") {
    return "Post Appointment Booked";
  } else if (status == "post_appointment_done") {
    return "GMG & End Report Pending";
  } else if (status == "protocol_guide") {
    return "Protocol Guide";
  } else if (status == "meal_plan_completed") {
    return "Meal Plan Completed";
  } else if (status == "gmg_submitted") {
    return "Completed";
  }

  return statusText;
}

buildIconWidget(String status) {
  if (status == "consultation_done" ||
      status == "consultation_accepted" ||
      status == "check_user_reports" ||
      status == "prep_meal_plan_completed") {
    return Icon(
      Icons.info_sharp,
      color: gSecondaryColor,
      size: 2.h,
    );
  } else {
    return const SizedBox();
  }
}

