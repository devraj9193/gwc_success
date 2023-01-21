import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gwc_success_team/screens/login_screen/success_login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/quick_blox_repository/quick_blox_repository.dart';
import '../utils/constants.dart';
import '../widgets/background_widget.dart';
import 'bottom_bar/dashboard_screen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dashboard/notification_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  Timer? _timer;
  static final _notificationsPlugin = FlutterLocalNotificationsPlugin();
  String loginStatus = "";
  String deviceToken = "";

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      loginStatus = preferences.getString("token")!;
    });
  }

  @override
  void initState() {
    getPref();
    requestPermission();
    getToken();
    initInfo();
    super.initState();
    startTimer();
  }

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
      await _notificationsPlugin.show(0, message.notification?.title,
          message.notification?.body, platformChannelSpecifics,
          payload: message.data['title']);
    });
  }

  void onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    if (notificationResponse.payload != null) {
      debugPrint('notification payload: $payload');
    }
    await Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => const NotificationScreen(),
      ),
    );
  }

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

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

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((value) {
      setState(() {
        deviceToken = value!;
        print("Device Token is : $deviceToken");
      });
      QuickBloxRepository().init(appId, authKey, authSecret, accountKey);

      QuickBloxRepository().initSubscription(value!);
    });
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
