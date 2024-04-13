import "dart:developer";

import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:music_streaming_app/models/music_model.dart";
import "package:music_streaming_app/services/app_audio_service.dart";
import "package:music_streaming_app/services/app_global_db_watcher.dart";
import "package:music_streaming_app/services/app_musics_db_service.dart";

class HomeController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final RxString searchRxString = "".obs;

  final RxBool connected = false.obs;
  final RxList<String> likedMusic = <String>[].obs;

  @override
  void onReady() {
    super.onReady();

    AppGlobalDBWatcher().connected.listenAndPump(
      (bool event) {
        connected(event);
        connected.refresh();
      },
    );
    AppGlobalDBWatcher().likedMusic.listenAndPump(
      (List<String> event) {
        likedMusic(event);
        likedMusic.refresh();
      },
    );
  }

  Rx<Query<dynamic>> query() {
    return searchRxString.value.isEmpty
        ? AppMusicsDBService().collectionReference.obs
        : AppMusicsDBService()
            .readMusicBySearch(
              searchQuery: searchRxString.value,
              successCallback: log,
              failureCallback: log,
            )
            .obs;
  }

  String getCurrentMusicId() {
    return AppGlobalDBWatcher().getCurrentMusicId();
  }

  MusicModel getCurrentMusicModel() {
    return AppGlobalDBWatcher().getCurrentMusicModel();
  }

  Future<void> addLike({
    required String musicId,
    required Function(String message) successCallback,
    required Function(String message) failureCallback,
  }) async {
    await AppGlobalDBWatcher().addFav(
      musicId: musicId,
      successCallback: successCallback,
      failureCallback: failureCallback,
    );
    return Future<void>.value();
  }

  Future<void> removeLike({
    required String musicId,
    required Function(String message) successCallback,
    required Function(String message) failureCallback,
  }) async {
    await AppGlobalDBWatcher().remFav(
      musicId: musicId,
      successCallback: successCallback,
      failureCallback: failureCallback,
    );
    return Future<void>.value();
  }

  Future<void> setUrlAndPlay({
    required MusicModel model,
    required String key,
    required Map<String, dynamic> data,
  }) async {
    await AppAudioService().setUrlAndPlay(
      model: model,
      key: key,
      data: data,
    );
    return Future<void>.value();
  }
}
