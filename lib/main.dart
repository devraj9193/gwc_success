import 'dart:async';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gwc_success_team/utils/gwc_api.dart';
import 'package:gwc_success_team/utils/http_override.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'model/internet_connection/dependency_injecion.dart';
import 'screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:upgrader/upgrader.dart';
import 'package:store_redirect/store_redirect.dart';

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
  await Upgrader.clearSavedSettings();

  DependencyInjection.init();
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
  @override
  void initState() {
    getDeviceId();
    super.initState();
  }

  getDeviceId() async {
    final pref = GwcApi.preferences;
    await GwcApi.getDeviceId().then((id) {
      print("deviceId: $id");
      if (id != null) {
        pref!.setString("deviceId", id);
      }
    });

    String? fcmToken = await FirebaseMessaging.instance.getToken();
    pref!.setString("fcm_token", fcmToken!);
  }

  @override
  Widget build(BuildContext context) {
    // const appCastURL =
    //     'https://raw.githubusercontent.com/larryaasen/upgrader/master/test/testappcast.xml';
    // final cfg = AppcastConfiguration(url: appCastURL, supportedOS: ['android']);

    return Sizer(builder:
        (BuildContext context, Orientation orientation, DeviceType deviceType) {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        home: UpgradeAlert(
          upgrader: Upgrader(
            // appcastConfig: cfg,
            durationUntilAlertAgain: const Duration(days: 1),
            dialogStyle: Platform.isIOS
                ? UpgradeDialogStyle.cupertino
                : UpgradeDialogStyle.material,
            shouldPopScope: () => true,
            messages: UpgraderMessages(code: 'en'),
            onIgnore: () {
              SystemNavigator.pop();
              throw UnsupportedError('_');
            },
            onUpdate: () {
              launchURL();
              return true;
            },
            onLater: () {
              SystemNavigator.pop();
              throw UnsupportedError('_');
            },
          ),
          child: const SplashScreen(),
        ),
      );
    });
  }

  launchURL() async {
    StoreRedirect.redirect(
        androidAppId: "com.fembuddy.success",
        // iOSAppId: "284882215",
    );
  }
}
