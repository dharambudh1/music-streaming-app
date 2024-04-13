import "dart:async";

import "package:get/get.dart";
import "package:just_audio/just_audio.dart";
import "package:music_streaming_app/models/music_model.dart";
import "package:music_streaming_app/services/app_global_db_watcher.dart";

class AppAudioService extends GetxService {
  factory AppAudioService() {
    return _singleton;
  }

  AppAudioService._internal();
  static final AppAudioService _singleton = AppAudioService._internal();

  final AudioPlayer player = AudioPlayer();

  final RxBool isPlaying = false.obs;
  final Rx<Duration> duration = Duration.zero.obs;
  final Rx<Duration> position = Duration.zero.obs;

  void init() {
    player.playerStateStream.listen(
      (PlayerState event) async {
        isPlaying(event.playing);
        if (event.processingState == ProcessingState.completed) {
          await stopIfPlaying();
          await next();
        } else {}
      },
    );

    player.durationStream.listen(duration);
    player.positionStream.listen(position);
    return;
  }

  Future<void> setUrlAndPlay({
    required MusicModel model,
    required String key,
    required Map<String, dynamic> data,
  }) async {
    await player.setUrl(model.link ?? "");
    unawaited(player.play());
    AppGlobalDBWatcher().selMusicData(<String, dynamic>{key: data});
    return Future<void>.value();
  }

  Future<void> stopIfPlaying() async {
    if (player.playing) {
      isPlaying(false);
      await player.stop();
    } else {}
    return Future<void>.value();
  }

  Future<void> next() async {
    final Map<String, dynamic> allMusicData = AppGlobalDBWatcher().allMusicData;
    final int currentIndex = getCurrentIndex(
      musicId: AppGlobalDBWatcher().getCurrentMusicId(),
    );
    if (currentIndex != -1) {
      String key = "";
      Map<String, dynamic> data = <String, dynamic>{};
      if ((currentIndex + 1) >= allMusicData.length) {
        key = allMusicData.keys.elementAt(0);
        data = allMusicData.values.elementAt(0);
      } else {
        key = allMusicData.keys.elementAt(currentIndex + 1);
        data = allMusicData.values.elementAt(currentIndex + 1);
      }

      final MusicModel model = MusicModel.fromJson(data);
      await setUrlAndPlay(model: model, key: key, data: data);
    } else {}
  }

  Future<void> prev() async {
    final Map<String, dynamic> allMusicData = AppGlobalDBWatcher().allMusicData;
    final int currentIndex = getCurrentIndex(
      musicId: AppGlobalDBWatcher().getCurrentMusicId(),
    );
    if (currentIndex != -1) {
      String key = "";
      Map<String, dynamic> data = <String, dynamic>{};
      if ((currentIndex - 1) == -1) {
        key = allMusicData.keys.elementAt(allMusicData.length - 1);
        data = allMusicData.values.elementAt(allMusicData.length - 1);
      } else {
        key = allMusicData.keys.elementAt(currentIndex - 1);
        data = allMusicData.values.elementAt(currentIndex - 1);
      }

      final MusicModel model = MusicModel.fromJson(data);
      await setUrlAndPlay(model: model, key: key, data: data);
    } else {}
  }

  int getCurrentIndex({required String musicId}) {
    int currentIndex = -1;
    for (int i = 0; i < AppGlobalDBWatcher().allMusicData.length; i++) {
      if (AppGlobalDBWatcher().allMusicData.keys.elementAt(i) == musicId) {
        currentIndex = i;
        break;
      } else {}
    }
    return currentIndex;
  }
}
