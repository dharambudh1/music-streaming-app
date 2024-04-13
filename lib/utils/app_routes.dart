import "package:flutter/foundation.dart";
import "package:get/get.dart";
import "package:music_streaming_app/bindings/details_binding.dart";
import "package:music_streaming_app/bindings/home_binding.dart";
import "package:music_streaming_app/bindings/login_binding.dart";
import "package:music_streaming_app/screens/details_screen.dart";
import "package:music_streaming_app/screens/home_screen.dart";
import "package:music_streaming_app/screens/login_screen.dart";
import "package:music_streaming_app/services/app_storage_service.dart";

class AppRoutes extends GetxService {
  factory AppRoutes() {
    return _singleton;
  }

  AppRoutes._internal();
  static final AppRoutes _singleton = AppRoutes._internal();

  final String loginScreen = "/loginScreen";
  final String homeScreen = "/homeScreen";
  final String detailsScreen = "/detailsScreen";
  bool isUserLoggedIn = false;

  List<GetPage<dynamic>> getPages() {
    return <GetPage<dynamic>>[
      GetPage<dynamic>(
        name: loginScreen,
        page: LoginScreen.new,
        binding: LoginBinding(),
      ),
      GetPage<dynamic>(
        name: homeScreen,
        page: HomeScreen.new,
        binding: HomeBinding(),
      ),
      GetPage<dynamic>(
        name: detailsScreen,
        page: DetailsScreen.new,
        binding: DetailsBinding(),
      ),
    ];
  }

  void init() {
    isUserLoggedIn = !mapEquals(
      AppStorageService().getUserData(),
      <String, dynamic>{},
    );
    return;
  }

  String initialRoute() {
    return isUserLoggedIn ? homeScreen : loginScreen;
  }

  Bindings initialBinding() {
    return isUserLoggedIn ? HomeBinding() : LoginBinding();
  }
}
