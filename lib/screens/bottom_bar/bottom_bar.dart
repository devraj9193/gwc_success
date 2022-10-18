import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../utils/constants.dart';

class BottomBar extends StatefulWidget {
  final int index;
  final ValueChanged<int> onChangedTab;
  const BottomBar({
    Key? key,
    required this.index,
    required this.onChangedTab,
  }) : super(key: key);

  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(8),
          topLeft: Radius.circular(8)
        ),
        color: gMainColor.withOpacity(0.4)
      ),
      height: 7.5.h,
      child: BottomAppBar(
        shape: CircularNotchedRectangle(),
        // color: Colors.white,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            buildTabView(
              index: 0,
              image: 'assets/images/dashboard.png',
            ),
            buildTabView(
              index: 1,
              image: 'assets/images/teams_bottom.png',
            ),
            buildTabView(
              index: 2,
              image: 'assets/images/chat_bottom.png',
            ),
            buildTabView(
              index: 3,
              image: 'assets/images/profile_bottom.png',
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTabView({
    required int index,
    required String image,
  }) {
    final isSelected = index == widget.index;

    return Padding(
      padding: EdgeInsets.all(1.h),
      child: InkWell(
        child: Image(
            height: isSelected ? 3.h : 2.5.h,
            image: AssetImage(image),
            color: isSelected ? gPrimaryColor : gBlackColor,
            fit: BoxFit.contain),
        onTap: () => widget.onChangedTab(index),
      ),
    );
  }

  Widget buildTabView1({
    required int index,
    required String image,
  }) {
    final isSelected = index == widget.index;

    return Padding(
      padding: EdgeInsets.all(1.h),
      child: InkWell(
        child: Image(
            height: 2.h,
            image: AssetImage(image),
            color: isSelected ? gPrimaryColor : gBlackColor,
            fit: BoxFit.contain),
        onTap: () => widget.onChangedTab(index),
      ),
    );
  }

// Widget buildTabView1({
//   required int index,
//   required String image,
// }) {
//   return Padding(
//     padding: const EdgeInsets.all(15),
//     child: InkWell(
//       child: SizedBox(
//         height: 3.2.h,
//         child:  (notificationFlag?.data.notificationUnreadCount == 1)
//             ? buildCustomBadge(
//                 child: SvgPicture.asset(
//                   image,
//                 ),
//               )
//             : SvgPicture.asset(
//                 image,
//               ),
//       ),
//       onTap: () => widget.onChangedTab(index),
//     ),
//   );
// }

// buildCustomBadge({required Widget child}) {
//   return Stack(
//     clipBehavior: Clip.none,
//     children: [
//       child,
//       const Positioned(
//         top: 0,
//         right: 5,
//         child: CircleAvatar(
//           radius: 5,
//           backgroundColor: Colors.red,
//         ),
//       ),
//     ],
//   );
// }
}
