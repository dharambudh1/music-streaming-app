import "dart:async";
import "dart:developer";

import "package:cloud_firestore/cloud_firestore.dart";
import "package:get/get.dart";
import "package:music_streaming_app/functions/app_functions.dart";
import "package:music_streaming_app/models/music_model.dart";
import "package:music_streaming_app/services/app_musics_db_service.dart";
import "package:music_streaming_app/services/app_storage_service.dart";
import "package:music_streaming_app/services/app_users_db_service.dart";

class AppGlobalDBWatcher extends GetxService {
  factory AppGlobalDBWatcher() {
    return _singleton;
  }

  AppGlobalDBWatcher._internal();
  static final AppGlobalDBWatcher _singleton = AppGlobalDBWatcher._internal();

  final RxBool connected = false.obs;

  final RxMap<String, dynamic> allMusicData = <String, dynamic>{}.obs;
  final RxMap<String, dynamic> selMusicData = <String, dynamic>{}.obs;
  final RxList<String> likedMusic = <String>[].obs;

  String getCurrentMusicId() {
    final String musicId =
        selMusicData.isNotEmpty ? selMusicData.keys.first : "";
    return musicId;
  }

  MusicModel getCurrentMusicModel() {
    final MusicModel musicModel = selMusicData.isNotEmpty
        ? MusicModel.fromJson(selMusicData.values.first)
        : MusicModel();
    return musicModel;
  }

  void init() {
    AppUsersDBService()
        .readUserByUserId(
      id: AppStorageService().getUserModel().userId ?? "",
      successCallback: log,
      failureCallback: log,
    )
        .listen(
      (QuerySnapshot<dynamic> event) {
        if (event.docs.isNotEmpty) {
          QueryDocumentSnapshot<dynamic>? queryDocumentSnapshot;
          queryDocumentSnapshot = getListItem(index: 0, snapshotData: event);
          Map<String, dynamic> tempMap = <String, dynamic>{};
          tempMap = getData(docsData: queryDocumentSnapshot);
          List<String> tempList = <String>[];
          tempList = List<String>.from(tempMap["liked_music"] ?? <dynamic>[]);
          bool containsKey = false;
          containsKey = tempMap.containsKey("liked_music");
          if (containsKey) {
            likedMusic
              ..clear()
              ..addAll(tempList);
          } else {}
        } else {}
      },
    );

    AppMusicsDBService()
        .readMusics(
      successCallback: log,
      failureCallback: log,
    )
        .listen(
      (QuerySnapshot<dynamic> event) {
        final List<QueryDocumentSnapshot<dynamic>> tempList = event.docs;
        if (tempList.isNotEmpty) {
          allMusicData.clear();
          for (final dynamic element in tempList) {
            allMusicData.addAll(
              <String, dynamic>{
                getId(docsData: element): getData(docsData: element),
              },
            );
          }
        } else {}
      },
    );
  }

  Future<void> addFav({
    required String musicId,
    required Function(String message) successCallback,
    required Function(String message) failureCallback,
  }) async {
    if (!likedMusic.contains(musicId)) {
      likedMusic.add(musicId);
    } else {}
    if (connected.value) {
      await AppUsersDBService().updateUser(
        id: AppStorageService().getUserModel().userId ?? "",
        data: <String, dynamic>{"liked_music": likedMusic},
        successCallback: successCallback,
        failureCallback: failureCallback,
      );
    } else {
      await onDisconnected(musicId: musicId, type: "addFav");
    }
    return Future<void>.value();
  }

  Future<void> remFav({
    required String musicId,
    required Function(String message) successCallback,
    required Function(String message) failureCallback,
  }) async {
    if (likedMusic.contains(musicId)) {
      likedMusic.remove(musicId);
    } else {}
    if (connected.value) {
      await AppUsersDBService().updateUser(
        id: AppStorageService().getUserModel().userId ?? "",
        data: <String, dynamic>{"liked_music": likedMusic},
        successCallback: successCallback,
        failureCallback: failureCallback,
      );
    } else {
      await onDisconnected(musicId: musicId, type: "remFav");
    }
    return Future<void>.value();
  }

  Future<void> onConnected({required Function(String message) ack}) async {
    AppStorageService().getUserPendingTasks().forEach(
      // ignore: avoid_annotating_with_dynamic
      (String key, dynamic value) {
        switch (value) {
          case "addFav":
            likedMusic.add(key);
            break;
          case "remFav":
            likedMusic.remove(key);
            break;
          default:
            break;
        }
      },
    );
    await AppUsersDBService().updateUser(
      id: AppStorageService().getUserModel().userId ?? "",
      data: <String, dynamic>{"liked_music": likedMusic},
      successCallback: (String message) async {
        log(message);
        await AppStorageService().setUserPendingTasks(<String, dynamic>{});
      },
      failureCallback: log,
    );
    return Future<void>.value();
  }

  Future<void> onDisconnected({
    required String musicId,
    required String type,
  }) async {
    final Map<String, dynamic> tasks = <String, dynamic>{
      ...AppStorageService().getUserPendingTasks(),
      ...<String, dynamic>{musicId: type},
    };
    await AppStorageService().setUserPendingTasks(tasks);
    return Future<void>.value();
  }
}
