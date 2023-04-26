import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../controller/terms_conditions_controller.dart';
import '../../utils/constants.dart';
import '../../widgets/widgets.dart';
import 'package:get/get.dart';

class TermsConditionsScreen extends StatefulWidget {
  const TermsConditionsScreen({Key? key}) : super(key: key);

  @override
  State<TermsConditionsScreen> createState() => _TermsConditionsScreenState();
}

class _TermsConditionsScreenState extends State<TermsConditionsScreen> {
  TermsConditionsController termsConditionsController =
      Get.put(TermsConditionsController());
  @override
  Widget build(BuildContext context) {
    return SafeArea(

      child: Scaffold(
        appBar: buildAppBar(() {
          Navigator.pop(context);
        }),
        backgroundColor: whiteTextColor,

        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                SizedBox(height: 1.h),
                Text(
                  "Terms and Conditions",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: "GothamBold",
                      color: gPrimaryColor,
                      fontSize: 11.sp),
                ),
                SizedBox(
                  height: 1.h,
                ),
                FutureBuilder(
                    future: termsConditionsController.fetchTerms(),
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.hasError) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 7.h),
                          child: Image(
                            image: const AssetImage(
                                "assets/images/Group 5294.png"),
                            height: 35.h,
                          ),
                        );
                      } else if (snapshot.hasData) {
                        var data = snapshot.data;
                        return Text(
                          data.data ?? "",
                          //  'Lorem Ipsum is simply dummy text of the printing and typesetting industry.Lorem lpsum has been the industry\'s standard dummy text ever since the 1500s,when an unknown printer took a gallery of type and scrambled it to make a type specimen book.It has survived not only five centuries,but also the leap into electronic typesetting,remaining essentially unchanged.It was popularised in the 1960s with the release of Letraset sheets containing Lorem lpsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem lpsum. long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem lpsum is that it has amore_or_less normal distribution of letters, as opposed to using \'Content here,content here\',making it look like readable english. Many desktop publishing packages and web page editors now use Lorem lpsum as their default model text,and asearch for \'lorem lpsum\' will uncover many web sites still in their infancy.Various versions have evolved over the years,sometimes by accident, sometimes on purpose(injected humour and the like).',
                          style: TextStyle(
                            height: 1.8,
                            fontSize: 9.sp,
                            color: gTextColor,
                            fontFamily: "GothamMedium",
                          ),
                        );
                      }
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.h),
                        child: buildCircularIndicator(),
                      );
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
