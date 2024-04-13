import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:music_streaming_app/services/app_global_db_watcher.dart";
import "package:music_streaming_app/services/app_storage_service.dart";
import "package:music_streaming_app/services/app_users_db_service.dart";

class LoginController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final RxString emailRxString = "".obs;
  final RxString passwordRxString = "".obs;
  final RxBool isPasswordVisible = false.obs;
  final RxBool connected = false.obs;

  @override
  void onReady() {
    super.onReady();

    AppGlobalDBWatcher().connected.listenAndPump(
      (bool event) {
        connected(event);
        connected.refresh();
      },
    );
  }

  void swapPasswordVisiblity() {
    isPasswordVisible(!isPasswordVisible.value);
    return;
  }

  Future<void> functionLogin({
    required Function(String message) successCallback,
    required Function(String message) failureCallback,
  }) async {
    final (bool, Map<String, dynamic>) value = await AppUsersDBService().login(
      emailAddress: emailRxString.value,
      password: passwordRxString.value,
    );

    final bool isAvailable = value.$1;
    final Map<String, dynamic> userInfo = value.$2;

    if (isAvailable) {
      await AppStorageService().setUserData(userInfo);

      successCallback("Credentials found");
    } else {
      failureCallback("Credentials not found");
    }
    return Future<void>.value();
  }
}
