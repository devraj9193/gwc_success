import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../utils/constants.dart';
import '../../../widgets/widgets.dart';

class PostProgramProgress extends StatefulWidget {
  const PostProgramProgress({Key? key}) : super(key: key);

  @override
  State<PostProgramProgress> createState() => _PostProgramProgressState();
}

class _PostProgramProgressState extends State<PostProgramProgress> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: buildAppBar(() {
          SystemChrome.setPreferredOrientations(
              [DeviceOrientation.portraitUp]);
          Navigator.pop(context);
        }),
        backgroundColor: whiteTextColor,

        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 1.h),
                ),
              ),
              buildTile(),
            ],
          ),
        ),
      ),
    );
  }

  buildTile() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        children: [
          Text(
            "Score : 380",
            style: TextStyle(
              fontFamily: "GothamBook",
              color: gBlackColor,
              fontSize: 9.sp,
            ),
          ),
          SizedBox(width: 3.w),
          Text(
            "Percentage : 64%",
            style: TextStyle(
              fontFamily: "GothamBook",
              color: gBlackColor,
              fontSize: 9.sp,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              "Lorem Ipsum is simply dummy text of the printing and typesetting industry.Lorem Ipsum has been the industry's standard dummy text ever since the 1500s",
              textAlign: TextAlign.start,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: TextStyle(
                fontFamily: "GothamBook",
                color: gBlackColor,
                fontSize: 9.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
