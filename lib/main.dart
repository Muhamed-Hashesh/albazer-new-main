import 'package:albazar_app/Features/notificatoins/local_notification.dart';
import 'package:albazar_app/Features/notificatoins/logic/cubit/notification_cubit.dart';
import 'package:albazar_app/Features/notificatoins/notification_service.dart';
import 'package:albazar_app/core/di/locator.dart';
import 'package:albazar_app/core/helper/bloc_obsever.dart';
import 'package:albazar_app/core/helper/theme_provider.dart';
import 'package:albazar_app/core/helper/user_helper.dart';
import 'package:albazar_app/core/routes/router.dart';
import 'package:albazar_app/core/routes/routes.dart';
import 'package:albazar_app/core/utils/theme.dart';
import 'package:albazar_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart' show Firebase;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  setupLocator();
  Bloc.observer = AppBlocObserver();
  await UserHelper.init();
  //* FireBase Initialization
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  NotificationService.init();
  LocalNotificationService.init();

  // ✅ Handle terminated state (app opened by tapping notification)
  FirebaseMessaging.instance.getInitialMessage().then((message) {
    if (message != null) {
      // Optional: check message data or notification payload
      navigatorKey.currentState?.pushNamed(AppRoutes.chatHome);
    }
  });

// ✅ Handle background tap
  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    navigatorKey.currentState?.pushNamed(AppRoutes.chatHome);
  });
  // ✅ Handle foreground messages
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    LocalNotificationService.showBasicNotification(message);
  });
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
  // runApp(
  //   DevicePreview(
  //     enabled: true, // Set to false to disable in production
  //     builder: (context) => ChangeNotifierProvider(
  //       create: (_) => ThemeProvider(),
  //       child: const MyApp(),
  //     ),
  //   ),
  // );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return BlocProvider(
      create: (context) => locator<NotificationCubit>(),
      child: Builder(
        builder: (context) {
          return ScreenUtilInit(
            designSize: const Size(375, 812), // iPhone X example
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (context, child) {
              return MaterialApp(
                navigatorKey: navigatorKey,
                title: 'AlBazar App',
                debugShowCheckedModeBanner: false,
                useInheritedMediaQuery: true,
                locale: DevicePreview.locale(context),
                builder: DevicePreview.appBuilder,
                localizationsDelegates: const [
                  GlobalCupertinoLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                ],
                supportedLocales: const [Locale("ar", "AE")],
                theme: MyAppThemes.lightTheme,
                darkTheme: MyAppThemes.darkTheme,
                themeMode: themeProvider.themeMode,
                initialRoute: AppRouter.initialRoute,
                onGenerateRoute: AppRouter.onGenerateRoute,
              );
            },
          );
        },
      ),
    );
  }
}

// ال AppBar
// dashboard
