import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import '../../../controller/maintenance_guide_controller.dart';
import '../../../widgets/common_screen_widgets.dart';
import '../../../widgets/widgets.dart';
import '../../common_ui/show_profile.dart';

class MaintenanceGuideList extends StatefulWidget {
  const MaintenanceGuideList({Key? key}) : super(key: key);

  @override
  State<MaintenanceGuideList> createState() => _MaintenanceGuideListState();
}

class _MaintenanceGuideListState extends State<MaintenanceGuideList> {
  MaintenanceGuideController maintenanceGuideController =
      Get.put(MaintenanceGuideController());

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 3.w),
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
                                  GestureDetector(
                                    onTap: () {
                                      saveUserId(
                                        data[index]
                                            .patient
                                            .user
                                            .id
                                            .toString(),
                                      );
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                          const ShowProfile(),
                                        ),
                                      );
                                    },
                                    child: CircleAvatar(
                                      radius: 3.h,
                                      backgroundImage: NetworkImage(data[index]
                                          .patient
                                          .user
                                          .profile
                                          .toString()),
                                    ),
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
                                          style: AllListText().headingText(),
                                        ),
                                        SizedBox(height: 0.5.h),
                                        Text(
                                          "${data[index].patient.user.age.toString()} ${data[index].patient.user.gender.toString()}",
                                          style: AllListText().subHeadingText(),
                                        ),
                                        SizedBox(height: 0.5.h),
                                        Text(
                                          "${data[index].appointmentDate.toString()} / ${data[index].appointmentTime.toString()}",
                                          style: AllListText().otherText(),
                                        ),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      // Navigator.of(context).push(
                                      //   MaterialPageRoute(
                                      //     builder: (ct) =>
                                      //         const PostCustomerDetails(),
                                      //   ),
                                      // );
                                    },
                                    child: SvgPicture.asset(
                                        "assets/images/noun-view-1041859.svg"),
                                  ),
                                  // PopupMenuButton(
                                  //   offset: const Offset(0, 30),
                                  //   shape: RoundedRectangleBorder(
                                  //       borderRadius: BorderRadius.circular(5)),
                                  //   itemBuilder: (context) => [
                                  //     PopupMenuItem(
                                  //       child: Column(
                                  //         crossAxisAlignment:
                                  //         CrossAxisAlignment.start,
                                  //         children: [
                                  //           SizedBox(height: 1.h),
                                  //           GestureDetector(
                                  //             onTap: () {
                                  //               Navigator.of(context).push(
                                  //                 MaterialPageRoute(
                                  //                   builder: (ct) =>
                                  //                   const PostCustomerDetails(),
                                  //                 ),
                                  //               );
                                  //             },
                                  //             child: Row(
                                  //               mainAxisAlignment:
                                  //               MainAxisAlignment
                                  //                   .spaceBetween,
                                  //               children: [
                                  //                 Text(
                                  //                   "View",
                                  //                   style: TextStyle(
                                  //                       fontFamily: "GothamBook",
                                  //                       color: gTextColor,
                                  //                       fontSize: 8.sp),
                                  //                 ),
                                  //                 SizedBox(width: 10.w),
                                  //                 SvgPicture.asset(
                                  //                     "assets/images/noun-view-1041859.svg")
                                  //               ],
                                  //             ),
                                  //           ),
                                  //           Container(
                                  //             margin: EdgeInsets.symmetric(
                                  //                 vertical: 1.h),
                                  //             height: 1,
                                  //             color: gGreyColor.withOpacity(0.3),
                                  //           ),
                                  //           GestureDetector(
                                  //             onTap: () {
                                  //               Navigator.of(context).push(
                                  //                 MaterialPageRoute(
                                  //                   builder: (ct) =>
                                  //                   const PostProgramProgress(),
                                  //                 ),
                                  //               );
                                  //             },
                                  //             child: Row(
                                  //               mainAxisAlignment:
                                  //               MainAxisAlignment
                                  //                   .spaceBetween,
                                  //               children: [
                                  //                 Text(
                                  //                   "Progress",
                                  //                   style: TextStyle(
                                  //                       fontFamily: "GothamBook",
                                  //                       color: gTextColor,
                                  //                       fontSize: 8.sp),
                                  //                 ),
                                  //                 SizedBox(width: 10.w),
                                  //                 Image(
                                  //                   image: const AssetImage(
                                  //                       "assets/images/Group 4895.png"),
                                  //                   height: 2.h,
                                  //                 ),
                                  //               ],
                                  //             ),
                                  //           ),
                                  //           Container(
                                  //             margin: EdgeInsets.symmetric(
                                  //                 vertical: 1.h),
                                  //             height: 1,
                                  //             color: gGreyColor.withOpacity(0.3),
                                  //           ),
                                  //           GestureDetector(
                                  //             onTap: () {
                                  //               Navigator.of(context).push(
                                  //                 MaterialPageRoute(
                                  //                   builder: (ct) =>
                                  //                       MessageScreen(
                                  //                         userName: '',
                                  //                         profileImage: '',
                                  //                       ),
                                  //                 ),
                                  //               );
                                  //             },
                                  //             child: Row(
                                  //               mainAxisAlignment:
                                  //               MainAxisAlignment
                                  //                   .spaceBetween,
                                  //               children: [
                                  //                 Text(
                                  //                   "Message",
                                  //                   style: TextStyle(
                                  //                       fontFamily: "GothamBook",
                                  //                       color: gTextColor,
                                  //                       fontSize: 8.sp),
                                  //                 ),
                                  //                 SizedBox(width: 10.w),
                                  //                 Image(
                                  //                   image: const AssetImage(
                                  //                       "assets/images/Group 4891.png"),
                                  //                   height: 2.h,
                                  //                 ),
                                  //               ],
                                  //             ),
                                  //           ),
                                  //           SizedBox(height: 0.5.h),
                                  //         ],
                                  //       ),
                                  //     ),
                                  //   ],
                                  //   child: Icon(
                                  //     Icons.more_vert,
                                  //     color: gGreyColor.withOpacity(0.5),
                                  //   ),
                                  // ),
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
      ),
    );
  }

  saveUserId(String userId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("user_id", userId);
  }
}
