import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../../controller/maintenance_guide_controller.dart';
import '../../../widgets/common_screen_widgets.dart';
import '../../../widgets/widgets.dart';
import '../../common_ui/show_profile.dart';

class PPConsultationPendingList extends StatefulWidget {
  const PPConsultationPendingList({Key? key}) : super(key: key);

  @override
  State<PPConsultationPendingList> createState() => _PPConsultationPendingListState();
}

class _PPConsultationPendingListState extends State<PPConsultationPendingList> {

  MaintenanceGuideController maintenanceGuideController =
  Get.put(MaintenanceGuideController());

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 3.w),
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
      ),
    );
  }

  saveUserId(String userId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("user_id", userId);
  }
}
