import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:gwc_success_team/screens/login_screen/success_login.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/quick_blox_service/quick_blox_service.dart';
import '../utils/gwc_api.dart';
import '../widgets/background_widget.dart';
import 'bottom_bar/dashboard_screen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'dashboard/notification_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  static final _notificationsPlugin = FlutterLocalNotificationsPlugin();
  final SharedPreferences _pref = GwcApi.preferences!;
  String deviceToken = "";
  int _currentPage = 0;
  Timer? _timer;
  String loginStatus = "";

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      loginStatus = preferences.getString("token")!;
    });
  }

  @override
  void initState() {
    getPref();
    super.initState();
    startTimer();
    requestPermission();
    //getToken();
    initInfo();
  }

  initInfo() {
    var initializationSettings = const InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/ic_launcher"),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        defaultPresentAlert: true,
        defaultPresentBadge: true,
        defaultPresentSound: true,
      ),
    );
    _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print("---Firebase Message---");
      print("MAP : ${message.toMap()}");
      print(message.data["notification_type"]);
      print(
          "onMessage: ${message.notification?.title}/${message.notification?.body}");
      BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
        message.notification!.body.toString(),
        htmlFormatBigText: true,
        contentTitle: message.notification!.title.toString(),
        htmlFormatContentTitle: true,
      );
      AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        "gwc",
        "gwc",
        importance: Importance.high,
        styleInformation: bigTextStyleInformation,
        priority: Priority.high,
        playSound: true,
      );
      NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: const DarwinNotificationDetails(),
      );
      if (message.data["notification_type"] != "new_chat") {
        await _notificationsPlugin.show(0, message.notification?.title,
            message.notification?.body, platformChannelSpecifics,
            payload: message.data['title']);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) async {
        print("FirebaseMessaging.onMessageOpenedApp.listen");
        if (message.notification != null) {
          print(
              "message.notification!.title : ${message.data["title"].toString()}");
          print(message.notification!.body);
          print(message.toMap());
          print("message.data22 ${message.data['notification_type']}");
          if (message.data != null) {
            if (message.data['notification_type'] == 'new_chat') {
              final accessToken = _pref.getString(GwcApi.kaleyraAccessToken);
              final uId = _pref.getString("kaleyraUserId");

              final qbService =
                  Provider.of<QuickBloxService>(context, listen: false);
              await qbService.openKaleyraChat(
                  "$uId", message.data["title"].toString(), "$accessToken");
            }
          } else {
            await Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (context) => const NotificationScreen(),
              ),
            );
          }
        }
      },
    );
  }

  void onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    print("payload : ${notificationResponse.payload}");
    print("NotificationResponse : $NotificationResponse");
    if (notificationResponse.payload != null) {
      debugPrint('notification payload: $payload');

      await Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (context) => const NotificationScreen(),
        ),
      );
    }
  }

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    await FirebaseMessaging.instance.getToken().then((value) {
      setState(() {
        deviceToken = value!;
        print("Device Token is : $deviceToken");
      });
    });
    _pref.setString("device_token", deviceToken);

    // QuickBloxRepository().init(appId, authKey, authSecret, accountKey);
    //
    // QuickBloxRepository().initSubscription(deviceToken);

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("User Granted Permission");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print("User Granted Provisional Permission");
    } else {
      print("User declined or has not accepted Permission");
    }
  }

  // void getToken() async {
  //   await FirebaseMessaging.instance.getToken().then((value) {
  //     setState(() {
  //       deviceToken = value!;
  //       print("Device Token is : $deviceToken");
  //     });
  //     QuickBloxRepository().init(appId, authKey, authSecret, accountKey);
  //
  //     QuickBloxRepository().initSubscription(value!);
  //   });
  //   _pref?.setString("device_token", deviceToken);
  // }

  startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPage < 1) {
        _currentPage++;
      } else {
        _currentPage = 1;
      }

      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          PageView(
            reverse: false,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            physics: const NeverScrollableScrollPhysics(),
            controller: _pageController,
            children: <Widget>[
              splashImage(),
              (loginStatus.isNotEmpty)
                  ? const DashboardScreen()
                  : const SuccessLogin(),
            ],
          ),
        ],
      ),
    );
  }

  splashImage() {
    return const BackgroundWidget(
      assetName: 'assets/images/splash_bg.png',
      child: Center(
        child: Image(
          image: AssetImage("assets/images/Gut wellness logo green.png"),
        ),
      ),
    );
  }
}
