import "dart:async";
import "dart:developer";

import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:like_button/like_button.dart";
import "package:music_streaming_app/common/common_cached_network_image.dart";
import "package:music_streaming_app/models/music_model.dart";
import "package:music_streaming_app/services/app_audio_service.dart";
import "package:music_streaming_app/services/app_global_db_watcher.dart";
import "package:music_streaming_app/utils/app_floating_button.dart";
import "package:music_streaming_app/utils/app_routes.dart";
import "package:music_streaming_app/utils/app_snackbar.dart";

class CustomBottomBar extends StatefulWidget {
  const CustomBottomBar({required this.isForHome, super.key});
  final bool isForHome;

  @override
  State<CustomBottomBar> createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        String id = "";
        MusicModel model = MusicModel();
        id = AppGlobalDBWatcher().getCurrentMusicId();
        model = AppGlobalDBWatcher().getCurrentMusicModel();
        return id.isNotEmpty && model != MusicModel()
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: InkWell(
                    onTap: () async {
                      AppGlobalDBWatcher().connected.value
                          ? await Get.toNamed(AppRoutes().detailsScreen)
                          : AppSnackbar().snackbar("No Internet");
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const SizedBox(height: 16),
                        Row(
                          children: <Widget>[
                            const SizedBox(width: 16),
                            imageWidget(id: id, model: model),
                            const SizedBox(width: 16),
                            Expanded(child: info(id: id, model: model)),
                            const SizedBox(width: 16),
                            button(id: id, model: model),
                            const SizedBox(width: 16),
                            like(id: id, model: model),
                            const SizedBox(width: 16),
                          ],
                        ),
                        const SizedBox(height: 16),
                        linearProgress(id: id, model: model),
                      ],
                    ),
                  ),
                ),
              )
            : const SizedBox();
      },
    );
  }

  Widget imageWidget({required String id, required MusicModel model}) {
    return ClipRRect(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      borderRadius: BorderRadius.circular(8),
      child: CommonCachedNetworkImage(
        imageUrl: model.image ?? "",
        height: 48,
        width: 48,
      ),
    );
  }

  Widget info({required String id, required MusicModel model}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          model.name ?? "",
          style: Theme.of(context).textTheme.titleSmall,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        const SizedBox(height: 2),
        Text(
          model.by ?? "",
          style: Theme.of(context).textTheme.bodySmall,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget button({required String id, required MusicModel model}) {
    return Transform.scale(
      scale: 0.80,
      child: AppFloatingButton(
        iconData:
            AppAudioService().isPlaying.value ? Icons.pause : Icons.play_arrow,
        onPressed: () {
          unawaited(
            AppAudioService().isPlaying.value
                ? AppAudioService().player.pause()
                : AppAudioService().player.play(),
          );
        },
      ),
    );
  }

  Widget like({required String id, required MusicModel model}) {
    return Obx(
      () {
        final bool isLiked = AppGlobalDBWatcher().likedMusic.contains(id);
        return LikeButton(
          isLiked: isLiked,
          size: 32,
          circleSize: 32,
          bubblesSize: 32,
          onTap: (bool value) {
            unawaited(
              value
                  ? AppGlobalDBWatcher().remFav(
                      musicId: id,
                      successCallback: log,
                      failureCallback: AppSnackbar().snackbar,
                    )
                  : AppGlobalDBWatcher().addFav(
                      musicId: id,
                      successCallback: log,
                      failureCallback: AppSnackbar().snackbar,
                    ),
            );
            return Future<bool>.value(!isLiked);
          },
        );
      },
    );
  }

  Widget linearProgress({required String id, required MusicModel model}) {
    return Hero(
      tag: "progress_$id",
      transitionOnUserGestures: true,
      child: LinearProgressIndicator(
        value: (AppAudioService().position.value.inSeconds.toDouble() /
                AppAudioService().duration.value.inSeconds.toDouble())
            .clamp(0.0, 1.0),
      ),
    );
  }
}
