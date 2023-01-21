import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../utils/constants.dart';
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
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 5.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildAppBar(() {
                Navigator.pop(context);
              }),
              // SizedBox(height: 1.h),
              Text(
                "MR Report",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'GothamBold',
                    color: gPrimaryColor,
                    fontSize: 11.sp),
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
