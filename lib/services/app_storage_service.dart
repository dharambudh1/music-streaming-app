import "dart:convert";
import "dart:developer";

import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:get_storage/get_storage.dart";
import "package:music_streaming_app/models/user_model.dart";

class AppStorageService extends GetxService {
  factory AppStorageService() {
    return _singleton;
  }

  AppStorageService._internal();
  static final AppStorageService _singleton = AppStorageService._internal();

  final GetStorage box = GetStorage();

  final String userDataKey = "userDataKey";
  final String userThemeKey = "userThemeKey";
  final String userPendingTasksKey = "userPendingTasksKey";

  Future<void> init() async {
    final bool hasInitialized = await GetStorage.init();
    log("GetStorage:: init():: hasInitialized:: $hasInitialized");
    return Future<void>.value();
  }

  Future<void> setUserData(Map<String, dynamic> userInfo) async {
    final String value = json.encode(userInfo);
    await box.write(userDataKey, value);
    await box.save();
    return Future<void>.value();
  }

  Map<String, dynamic> getUserData() {
    final String value = box.read(userDataKey) ?? "";
    return value.isEmpty ? <String, dynamic>{} : json.decode(value);
  }

  UserModel getUserModel() {
    UserModel userModel = UserModel();
    final Map<String, dynamic> json = getUserData();
    if (json.isNotEmpty) {
      userModel = UserModel.fromJson(json);
    } else {}
    return userModel;
  }

  Future<void> setUserPendingTasks(Map<String, dynamic> tasks) async {
    final String value = json.encode(tasks);
    await box.write(userPendingTasksKey, value);
    await box.save();
    return Future<void>.value();
  }

  Map<String, dynamic> getUserPendingTasks() {
    final String value = box.read(userPendingTasksKey) ?? "";
    return value.isEmpty ? <String, dynamic>{} : json.decode(value);
  }

  Future<void> setUserTheme(String selectedTheme) async {
    await box.write(userThemeKey, selectedTheme);
    await box.save();
    return Future<void>.value();
  }

  ThemeMode getUserTheme() {
    final String value = box.read(userThemeKey) ?? "";
    final ThemeMode themeMode = value == ThemeMode.system.name
        ? ThemeMode.system
        : value == ThemeMode.light.name
            ? ThemeMode.light
            : value == ThemeMode.dark.name
                ? ThemeMode.dark
                : ThemeMode.system;
    return themeMode;
  }

  Future<void> erase() async {
    await box.erase();
    return Future<void>.value();
  }
}
