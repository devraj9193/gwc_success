import 'package:flutter/material.dart';
import 'package:gwc_success_team/screens/profile_screens/settings_screen.dart';

import '../../widgets/will_pop_widget.dart';
import '../dashboard/calender_screen.dart';
import '../dashboard/notification_screen.dart';
import '../reports/direct_bridged_screen.dart';
import '../teams/gwc_teams_screen.dart';
import 'bottom_bar.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _bottomNavIndex = 0;

  pageCaller(int index) {
    switch (index) {
      case 0:
        {
          return const CalenderScreen();
        }
      case 1:
        {
          return const GwcTeamsScreen();
        }
      case 2:
        {
          return const DirectBridgedScreen();
        }
      case 3:
        {
          return const NotificationScreen();
        }
      case 4:
        {
          return const SettingsScreen();
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopWidget(
      child: SafeArea(
        child: Scaffold(
          body: pageCaller(_bottomNavIndex),
          bottomNavigationBar: BottomBar(
            index: _bottomNavIndex,
            onChangedTab: onChangedTab,
          ),
        ),
      ),
    );
  }

  void onChangedTab(int index) {
    setState(() {
      _bottomNavIndex = index;
    });
  }
}
