import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import '../../utils/constants.dart';
import '../../widgets/widgets.dart';

class PostCustomerDetails extends StatefulWidget {
  const PostCustomerDetails({Key? key}) : super(key: key);

  @override
  State<PostCustomerDetails> createState() => _PostCustomerDetailsState();
}

class _PostCustomerDetailsState extends State<PostCustomerDetails> {
  List types = ['Do', "Don't Do", 'none'];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: SafeArea(
        child: Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 1.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                child: buildAppBar(() {
                  Navigator.pop(context);
                }),
              ),
              SizedBox(height: 1.h),
              TabBar(
                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                  labelColor: gPrimaryColor,
                  unselectedLabelColor: gTextColor,
                  unselectedLabelStyle: TextStyle(
                      fontFamily: "GothamBook",
                      color: gPrimaryColor,
                      fontSize: 10.sp),
                  isScrollable: true,
                  indicatorColor: gPrimaryColor,
                  labelPadding:
                      EdgeInsets.only(right: 15.w, top: 1.h, bottom: 1.h),
                  indicatorPadding: EdgeInsets.only(right: 10.w),
                  labelStyle: TextStyle(
                      fontFamily: "GothamMedium",
                      color: gPrimaryColor,
                      fontSize: 10.sp),
                  tabs: const [
                    Text('BreakFast'),
                    Text('Lunch'),
                    Text('Dinner'),
                  ]),
              Expanded(
                child: TabBarView(children: [
                  buildBreakFast(),
                  buildLunch(),
                  buildDinner(),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildTile(String lottie, String title, {String? mainText}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
      margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 4.w),
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
      child: Column(
        children: [
          SizedBox(height: 1.h),
          Row(
            children: [
              SizedBox(
                height: 3.h,
                child: Lottie.asset(lottie),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontFamily: "GothamBook",
                    color: gBlackColor,
                    fontSize: 11.sp,
                  ),
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 1.h),
            width: double.maxFinite,
            height: 1,
            color: gGreyColor.withOpacity(0.3),
          ),
          SizedBox(height: 0.5.h),
          Text(
            //  mainText ??
            "Lorem Ipsum is simply dummy text of the printing and typesetting industry.Lorem Ipsum has been the industry's standard dummy text ever since the 1500s,when an unknown printer took a gallery of type and scrambled it to make a type specimen book.",
            style: TextStyle(
              height: 1.5,
              fontSize: 8.sp,
              color: gBlackColor,
              fontFamily: "GothamBook",
            ),
          ),
          SizedBox(height: 1.h),
        ],
      ),
    );
  }

  buildBreakFast() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          Container(
            height: 1,
            color: Colors.grey.withOpacity(0.3),
          ),
          SizedBox(height: 2.h),
          buildTile('assets/lottie/loading_tick.json', types[0], mainText: ""),
          buildTile('assets/lottie/loading_wrong.json', types[1], mainText: ""),
          buildTile('assets/lottie/loading_wrong.json', types[2], mainText: ''),
        ],
      ),
    );
  }

  buildLunch() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          Container(
            height: 1,
            color: Colors.grey.withOpacity(0.3),
          ),
          SizedBox(height: 2.h),
          buildTile('assets/lottie/loading_tick.json', types[0], mainText: ""),
          buildTile('assets/lottie/loading_wrong.json', types[1], mainText: ""),
          buildTile('assets/lottie/loading_wrong.json', types[2], mainText: ''),
        ],
      ),
    );
  }

  buildDinner() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          Container(
            height: 1,
            color: Colors.grey.withOpacity(0.3),
          ),
          SizedBox(height: 2.h),
          buildTile('assets/lottie/loading_tick.json', types[0], mainText: ""),
          buildTile('assets/lottie/loading_wrong.json', types[1], mainText: ""),
          buildTile('assets/lottie/loading_wrong.json', types[2], mainText: ''),
        ],
      ),
    );
  }
}
