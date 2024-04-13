import "dart:async";

import "package:firebase_core/firebase_core.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:google_fonts/google_fonts.dart";
import "package:internet_connection_checker/internet_connection_checker.dart";
import "package:keyboard_dismisser/keyboard_dismisser.dart";
import "package:music_streaming_app/firebase_options.dart";
import "package:music_streaming_app/services/app_global_db_watcher.dart";
import "package:music_streaming_app/services/app_main_services.dart";
import "package:music_streaming_app/services/app_storage_service.dart";
import "package:music_streaming_app/utils/app_routes.dart";
import "package:music_streaming_app/utils/app_snackbar.dart";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseOptions options = DefaultFirebaseOptions.currentPlatform;
  await Firebase.initializeApp(options: options);
  injectDependencies();
  await startStartupServices();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    InternetConnectionChecker().onStatusChange.listen(
      (InternetConnectionStatus status) async {
        final bool value = status == InternetConnectionStatus.connected;
        AppGlobalDBWatcher().connected(value);
        AppSnackbar().snackbar("Internet ${status.name}");
        if (AppGlobalDBWatcher().connected.value) {
          await AppGlobalDBWatcher().onConnected(ack: AppSnackbar().snackbar);
        } else {}
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      child: GetMaterialApp(
        title: "Music Streaming App",
        theme: themeData(brightness: Brightness.light),
        darkTheme: themeData(brightness: Brightness.dark),
        themeMode: AppStorageService().getUserTheme(),
        getPages: AppRoutes().getPages(),
        initialRoute: AppRoutes().initialRoute(),
        initialBinding: AppRoutes().initialBinding(),
        defaultTransition: Transition.rightToLeft,
        transitionDuration: const Duration(seconds: 1),
        debugShowCheckedModeBanner: false,
      ),
    );
  }

  ThemeData themeData({required Brightness brightness}) {
    final ThemeData baseTheme = ThemeData(brightness: brightness);
    final ThemeData themeData = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorSchemeSeed: Colors.blue,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      applyElevationOverlayColor: true,
      textTheme: GoogleFonts.latoTextTheme(baseTheme.textTheme),
    );
    return themeData;
  }
}
