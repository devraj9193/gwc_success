import 'package:flutter/material.dart';
import 'package:gwc_success_team/screens/post_programs_screens/post_customer_details.dart';
import 'package:gwc_success_team/screens/post_programs_screens/post_program_progress.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../controller/maintenance_guide_controller.dart';
import '../../utils/constants.dart';
import '../../widgets/widgets.dart';
import '../message_screen/message_screen.dart';

class PostProgramsScreen extends StatefulWidget {
  const PostProgramsScreen({Key? key}) : super(key: key);

  @override
  State<PostProgramsScreen> createState() => _PostProgramsScreenState();
}

class _PostProgramsScreenState extends State<PostProgramsScreen> {
  MaintenanceGuideController maintenanceGuideController =
      Get.put(MaintenanceGuideController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Scaffold(
          body: Padding(
            padding: EdgeInsets.only(
              left: 4.w,
              right: 4.w,
              top: 1.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildAppBar(() {
                  Navigator.pop(context);
                }),
                SizedBox(height: 2.h),
                TabBar(
                    labelColor: gPrimaryColor,
                    unselectedLabelColor: gTextColor,
                    unselectedLabelStyle: TextStyle(
                        fontFamily: "GothamBook",
                        color: gPrimaryColor,
                        fontSize: 10.sp),
                    isScrollable: true,
                    indicatorColor: gPrimaryColor,
                    labelPadding:
                        EdgeInsets.only(right: 10.w, top: 1.h, bottom: 1.h),
                    indicatorPadding: EdgeInsets.only(right: 7.w),
                    labelStyle: TextStyle(
                        fontFamily: "GothamMedium",
                        color: gPrimaryColor,
                        fontSize: 10.sp),
                    tabs: const [
                      Text('Consultation'),
                      Text('Maintenance Guide'),
                    ]),
                Expanded(
                  child: TabBarView(children: [
                    buildConsultation(),
                    buildDocuments(),
                  ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  buildConsultation() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: FutureBuilder(
          future: maintenanceGuideController.fetchPostProgramList(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasError) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 7.h),
                child: Image(
                  image: const AssetImage("assets/images/Group 5294.png"),
                  height: 35.h,
                ),
              );
            } else if (snapshot.hasData) {
              var data = snapshot.data;
              return Column(
                children: [
                  Container(
                    height: 1,
                    color: Colors.grey.withOpacity(0.3),
                  ),
                  SizedBox(height: 2.h),
                  ListView.builder(
                    scrollDirection: Axis.vertical,
                    padding: EdgeInsets.symmetric(horizontal: 1.w),
                    physics: const ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: data.length,
                    itemBuilder: ((context, index) {
                      return GestureDetector(
                        onTap: () {},
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 2.h,
                                  backgroundImage: NetworkImage(data[index]
                                      .patient
                                      .user
                                      .profile
                                      .toString()),
                                ),
                                SizedBox(width: 2.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        data[index]
                                            .patient
                                            .user
                                            .name
                                            .toString(),
                                        style: TextStyle(
                                            fontFamily: "GothamMedium",
                                            color: gTextColor,
                                            fontSize: 10.sp),
                                      ),
                                      SizedBox(height: 0.5.h),
                                      Text(
                                        "${data[index].patient.user.age.toString()} ${data[index].patient.user.gender.toString()}",
                                        style: TextStyle(
                                            fontFamily: "GothamMedium",
                                            color: gTextColor,
                                            fontSize: 9.sp),
                                      ),
                                      SizedBox(height: 0.5.h),
                                      Text(
                                        "${data[index].appointmentDate.toString()} / ${data[index].appointmentTime.toString()}",
                                        style: TextStyle(
                                            fontFamily: "GothamBook",
                                            color: gTextColor,
                                            fontSize: 8.sp),
                                      ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    // Navigator.of(context).push(
                                    //   MaterialPageRoute(
                                    //     builder: (ct) => const PostCustomerDetails(),
                                    //   ),
                                    // );
                                  },
                                  child: SvgPicture.asset(
                                      "assets/images/noun-view-1041859.svg"),
                                ),
                              ],
                            ),
                            Container(
                              height: 1,
                              margin: EdgeInsets.symmetric(vertical: 1.5.h),
                              color: Colors.grey.withOpacity(0.3),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ],
              );
            }
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              child: buildCircularIndicator(),
            );
          }),
    );
  }

  buildDocuments() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: FutureBuilder(
          future: maintenanceGuideController.fetchMaintenanceGuideList(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasError) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 7.h),
                child: Image(
                  image: const AssetImage("assets/images/Group 5294.png"),
                  height: 35.h,
                ),
              );
            } else if (snapshot.hasData) {
              var data = snapshot.data;
              return Column(
                children: [
                  Container(
                    height: 1,
                    color: Colors.grey.withOpacity(0.3),
                  ),
                  SizedBox(height: 2.h),
                  ListView.builder(
                    scrollDirection: Axis.vertical,
                    physics: const ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: data.length,
                    itemBuilder: ((context, index) {
                      return GestureDetector(
                        onTap: () {},
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 2.h,
                                  backgroundImage: NetworkImage(data[index]
                                      .patient
                                      .user
                                      .profile
                                      .toString()),
                                ),
                                SizedBox(width: 2.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        data[index]
                                            .patient
                                            .user
                                            .name
                                            .toString(),
                                        style: TextStyle(
                                            fontFamily: "GothamMedium",
                                            color: gTextColor,
                                            fontSize: 10.sp),
                                      ),
                                      SizedBox(height: 0.5.h),
                                      Text(
                                        "${data[index].patient.user.age.toString()} ${data[index].patient.user.gender.toString()}",
                                        style: TextStyle(
                                            fontFamily: "GothamMedium",
                                            color: gTextColor,
                                            fontSize: 9.sp),
                                      ),
                                      SizedBox(height: 0.5.h),
                                      Text(
                                        "${data[index].appointmentDate.toString()} / ${data[index].appointmentTime.toString()}",
                                        style: TextStyle(
                                            fontFamily: "GothamBook",
                                            color: gTextColor,
                                            fontSize: 8.sp),
                                      ),
                                    ],
                                  ),
                                ),
                                PopupMenuButton(
                                  offset: const Offset(0, 30),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 1.h),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (ct) =>
                                                      const PostCustomerDetails(),
                                                ),
                                              );
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "View",
                                                  style: TextStyle(
                                                      fontFamily: "GothamBook",
                                                      color: gTextColor,
                                                      fontSize: 8.sp),
                                                ),
                                                SizedBox(width: 10.w),
                                                SvgPicture.asset(
                                                    "assets/images/noun-view-1041859.svg")
                                              ],
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.symmetric(
                                                vertical: 1.h),
                                            height: 1,
                                            color: gGreyColor.withOpacity(0.3),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (ct) =>
                                                      const PostProgramProgress(),
                                                ),
                                              );
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "Progress",
                                                  style: TextStyle(
                                                      fontFamily: "GothamBook",
                                                      color: gTextColor,
                                                      fontSize: 8.sp),
                                                ),
                                                SizedBox(width: 10.w),
                                                Image(
                                                  image: const AssetImage(
                                                      "assets/images/Group 4895.png"),
                                                  height: 2.h,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.symmetric(
                                                vertical: 1.h),
                                            height: 1,
                                            color: gGreyColor.withOpacity(0.3),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (ct) =>
                                                       MessageScreen(userName: '', profileImage: '',),
                                                ),
                                              );
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "Message",
                                                  style: TextStyle(
                                                      fontFamily: "GothamBook",
                                                      color: gTextColor,
                                                      fontSize: 8.sp),
                                                ),
                                                SizedBox(width: 10.w),
                                                Image(
                                                  image: const AssetImage(
                                                      "assets/images/Group 4891.png"),
                                                  height: 2.h,
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 0.5.h),
                                        ],
                                      ),
                                    ),
                                  ],
                                  child: Icon(
                                    Icons.more_vert,
                                    color: gGreyColor.withOpacity(0.5),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              height: 1,
                              margin: EdgeInsets.symmetric(vertical: 1.5.h),
                              color: Colors.grey.withOpacity(0.3),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ],
              );
            }
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              child: buildCircularIndicator(),
            );
          }),
    );
  }
}
