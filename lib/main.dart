import 'dart:io';
import 'package:catcher/catcher.dart';

import 'package:device_preview/device_preview.dart' hide DeviceType;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_sim_country_code/flutter_sim_country_code.dart';
import 'package:get/get.dart';
import 'package:gwc_success_team/screens/dashboard/notification_screen.dart';
import 'package:gwc_success_team/utils/constants.dart';
import 'package:gwc_success_team/utils/gwc_api.dart';
import 'package:gwc_success_team/utils/http_override.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'model/quick_blox_repository/quick_blox_repository.dart';
import 'model/quick_blox_service/quick_blox_service.dart';
import 'screens/splash_screen.dart';
import '../model/quick_blox_repository/quick_blox_repository.dart';
import '../utils/constants.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> backgroundHandler(RemoteMessage message) async {
  print(message.data.toString());
  print(message.notification);
}

// cacheManager() {
//   CatcherOptions debugOptions =
//       CatcherOptions(DialogReportMode(), [ConsoleHandler()]);
//
//   /// Release configuration. Same as above, but once user accepts dialog, user will be prompted to send email with crash to support.
//   CatcherOptions releaseOptions = CatcherOptions(DialogReportMode(), [
//     EmailManualHandler(["support@email.com"])
//   ]);
//
//   /// STEP 2. Pass your root widget (MyApp) along with Catcher configuration:
//   // Catcher(
//   //     rootWidget: MyApp(),
//   //     debugConfig: debugOptions,
//   //     releaseConfig: releaseOptions);
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.getInitialMessage();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  HttpOverrides.global = MyHttpOverrides();
  GwcApi.preferences = await SharedPreferences.getInstance();
 // cacheManager();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.black26),
  );
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );
  // CatcherOptions debugOptions =
  // CatcherOptions(DialogReportMode(), [ConsoleHandler()]);
  //
  // /// Release configuration. Same as above, but once user accepts dialog, user will be prompted to send email with crash to support.
  // CatcherOptions releaseOptions = CatcherOptions(DialogReportMode(), [
  //   EmailManualHandler(["support@email.com"])
  // ]);
  //
  // /// STEP 2. Pass your root widget (MyApp) along with Catcher configuration:
  // Catcher(rootWidget: MyApp(), debugConfig: debugOptions, releaseConfig: releaseOptions);

  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
  //     overlays: [SystemUiOverlay.bottom]);
  // SystemChrome.setSystemUIOverlayStyle(
  //   const SystemUiOverlayStyle(statusBarColor: Colors.black26),
  // );
  // await SystemChrome.setPreferredOrientations(
  //   [DeviceOrientation.portraitUp],
  // );
  // //***** firebase notification ******
  // await Firebase.initializeApp();
  //
  // await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
  //   alert: true,
  //   badge: true,
  //   sound: true,
  // );
  //
  // await FirebaseMessaging.instance.getToken();
  //
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // final fcmToken = await FirebaseMessaging.instance.getToken();
  //
  // LocalNotificationService.initialize();
  //
  // print("fcmToken: $fcmToken");

  // *****  end *************
  runApp(const MyApp());

  // QuickBloxRepository().init(appId, authKey, authSecret, accountKey);
}

// void main() {
//   SystemChrome.setSystemUIOverlayStyle(
//     const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
//   );
//   runApp(
//     DevicePreview(
//       enabled: !kReleaseMode,
//       builder: (context) => const MyApp(), // Wrap your app
//     ),
//   );
// }

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  getDeviceId() async {
    final _pref = GwcApi.preferences;
    await GwcApi.getDeviceId().then((id) {
      print("deviceId: $id");
      if (id != null) {
        _pref!.setString("deviceId", id);
      }
    });

    // this is for getting the state and city name
    // this was not using currently
    String? n = await FlutterSimCountryCode.simCountryCode;
    if (n != null) _pref!.setString("COUNTRY_CODE", n);
    // print("country_code:${n}");

    String? fcmToken = await FirebaseMessaging.instance.getToken();
    _pref!.setString("fcm_token", fcmToken!);
  }

  @override
  void initState() {
    super.initState();
    getDeviceId();
      }

  @override
  Widget build(BuildContext context) {
    return Sizer(builder:
        (BuildContext context, Orientation orientation, DeviceType deviceType) {
      return MultiProvider(
        providers: [
          ListenableProvider<QuickBloxService>.value(value: QuickBloxService()),
        ],
        child: const GetMaterialApp(
          debugShowCheckedModeBanner: false,
          home: SplashScreen(),
        ),
      );
    });
  }
}
