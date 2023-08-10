import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:get/get.dart';
import '../../../controller/mr_reports_controller.dart';
import '../../utils/constants.dart';

class MedicalReportDetails extends StatefulWidget {
  final String mrUrl;
  const MedicalReportDetails({Key? key, required this.mrUrl}) : super(key: key);

  @override
  State<MedicalReportDetails> createState() => _MedicalReportDetailsState();
}

class _MedicalReportDetailsState extends State<MedicalReportDetails> {
  MRReportsController mrReportsController = Get.put(MRReportsController());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 1,
          color: Colors.grey.withOpacity(0.3),
        ),
        SizedBox(height: 3.h),
        (widget.mrUrl.isEmpty)
            ? Column(
          children: [
            SizedBox(height: 5.h),
            const Image(
              image: AssetImage("assets/images/5358621.png"),
            ),
            SizedBox(height: 3.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 7.w),
              child: Text(
                "Case Study & Medical Report are not yet Completed.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  height: 1.5,
                  fontSize: 12.sp,
                  color: newBlackColor,
                  fontFamily: "GothamMedium",
                ),
              ),
            )
          ],
        )
            : Expanded(
          child: SfPdfViewer.network(
            widget.mrUrl.toString(),
          ),
        ),
      ],
    );
  }
}
