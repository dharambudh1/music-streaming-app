import "dart:async";

import "package:get/get.dart";
import "package:music_streaming_app/services/app_audio_service.dart";
import "package:music_streaming_app/services/app_global_db_watcher.dart";
import "package:music_streaming_app/services/app_musics_db_service.dart";
import "package:music_streaming_app/services/app_storage_service.dart";
import "package:music_streaming_app/services/app_users_db_service.dart";
import "package:music_streaming_app/utils/app_routes.dart";

void injectDependencies() {
  Get
    ..put(AppStorageService.new)
    ..put(AppRoutes.new)
    ..put(AppUsersDBService.new)
    ..put(AppMusicsDBService.new)
    ..put(AppGlobalDBWatcher.new)
    ..put(AppAudioService.new);
  return;
}

Future<void> startStartupServices() async {
  await AppStorageService().init();
  AppRoutes().init();
  AppUsersDBService().init();
  AppMusicsDBService().init();
  AppGlobalDBWatcher().init();
  AppAudioService().init();
  return Future<void>.value();
}
