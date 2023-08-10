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
              topRight: Radius.circular(8), topLeft: Radius.circular(8)),
          color: gMainColor.withOpacity(0.4)),
     // height: 5.5.h,
      child: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        // color: Colors.white,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            buildTabView1(
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
              image: 'assets/images/Group 3011.png',
            ),
            buildTabView1(
              index: 4,
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
      padding: EdgeInsets.symmetric(vertical:1.h),
      child: InkWell(
        child: Image(
            height: isSelected ? 3.5.h : 3.h,
            image: AssetImage(image),
            color: isSelected ? gSecondaryColor : gBlackColor,
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
      padding: EdgeInsets.symmetric(vertical:1.h),
      child: InkWell(
        child: Image(
            height: isSelected ? 2.5.h : 2.h,
            image: AssetImage(image),
            color: isSelected ? gSecondaryColor : gBlackColor,
            fit: BoxFit.contain),
        onTap: () => widget.onChangedTab(index),
      ),
    );
  }

  Widget buildTabView2({
    required int index,
  }) {
    final isSelected = index == widget.index;
    return Padding(
      padding: EdgeInsets.symmetric(vertical:1.h),
      child: InkWell(
        child: SizedBox(
          height: isSelected ? 3.7.h : 3.2.h,
          child: Icon(
            Icons.notifications_outlined,
            color: isSelected ? gSecondaryColor : gBlackColor,
          ),
        ),
        onTap: () => widget.onChangedTab(index),
      ),
    );
  }

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
