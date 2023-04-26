import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../utils/constants.dart';
import '../../widgets/common_screen_widgets.dart';
import '../../widgets/widgets.dart';

class MRScreen extends StatefulWidget {
  final String report;
  const MRScreen({Key? key, required this.report}) : super(key: key);

  @override
  State<MRScreen> createState() => _MRScreenState();
}

class _MRScreenState extends State<MRScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: buildAppBar(() {
          Navigator.pop(context);
        }),
        backgroundColor: whiteTextColor,

        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 5.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // SizedBox(height: 1.h),
              Text(
                "MR Report",
                textAlign: TextAlign.center,
                style: MealPlan().headingText(),

              ),
              SizedBox(height: 1.h),
              Expanded(
                child: SfPdfViewer.network(widget.report),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
