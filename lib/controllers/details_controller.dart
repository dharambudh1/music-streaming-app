import "dart:async";

import "package:get/get.dart";
import "package:music_streaming_app/models/music_model.dart";
import "package:music_streaming_app/services/app_audio_service.dart";
import "package:music_streaming_app/services/app_global_db_watcher.dart";

class DetailsController extends GetxController {
  final RxBool connected = false.obs;
  final RxList<String> likedMusic = <String>[].obs;

  final RxBool isPlaying = false.obs;
  
  final Rx<Duration> duration = Duration.zero.obs;
  
  final Rx<Duration> position = Duration.zero.obs;

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

    AppAudioService().isPlaying.listenAndPump(
      (bool event) {
        isPlaying(event);
        isPlaying.refresh();
      },
    );
    AppAudioService().duration.listenAndPump(
      (Duration event) {
        duration(event);
        duration.refresh();
      },
    );
    AppAudioService().position.listenAndPump(
      (Duration event) {
        position(event);
        position.refresh();
      },
    );
  }

  String getCurrentMusicId() {
    return AppGlobalDBWatcher().getCurrentMusicId();
  }

  MusicModel getCurrentMusicModel() {
    return AppGlobalDBWatcher().getCurrentMusicModel();
  }

  void playPause() {
    unawaited(
      isPlaying.value
          ? AppAudioService().player.pause()
          : AppAudioService().player.play(),
    );
    return;
  }

  Future<void> onChanged(double value) async {
    final Duration newPosition = Duration(seconds: value.toInt());
    await AppAudioService().player.seek(newPosition);
    unawaited(AppAudioService().player.play());
    return Future<void>.value();
  }

  Future<void> prev() async {
    await AppAudioService().prev();
    return Future<void>.value();
  }

  Future<void> next() async {
    await AppAudioService().next();
    return Future<void>.value();
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
}
