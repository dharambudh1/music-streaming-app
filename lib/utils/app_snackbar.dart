import "package:get/get.dart";

class AppSnackbar {
  factory AppSnackbar() {
    return _singleton;
  }

  AppSnackbar._internal();

  static final AppSnackbar _singleton = AppSnackbar._internal();

  void snackbar(String message) {
    final String msg = message;
    const Duration dur = Duration(seconds: 4);
    final GetSnackBar snackbar = GetSnackBar(message: msg, duration: dur);
    Get.showSnackbar(snackbar);
    return;
  }
}
