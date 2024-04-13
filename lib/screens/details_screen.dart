import "dart:developer";

import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:music_streaming_app/common/common_image_widget.dart";
import "package:music_streaming_app/common/common_info_widget.dart";
import "package:music_streaming_app/common/common_like_button.dart";
import "package:music_streaming_app/controllers/details_controller.dart";
import "package:music_streaming_app/functions/app_functions.dart";
import "package:music_streaming_app/models/music_model.dart";
import "package:music_streaming_app/screens/app_bar.dart";
import "package:music_streaming_app/utils/app_floating_button.dart";
import "package:music_streaming_app/utils/app_icon_button.dart";
import "package:music_streaming_app/utils/app_snackbar.dart";
import "package:wave/config.dart";
import "package:wave/wave.dart";

class DetailsScreen extends GetView<DetailsController> {
  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(isForHome: false),
      body: SafeArea(
        child: Obx(
          () {
            String id = "";
            MusicModel model = MusicModel();
            id = controller.getCurrentMusicId();
            model = controller.getCurrentMusicModel();
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Spacer(),
                imageWidget(id: id, model: model),
                const Spacer(),
                infoRow(id: id, model: model),
                const Spacer(),
                slider(id: id, model: model),
                const Spacer(),
                duration(id: id, model: model),
                const Spacer(),
                button(id: id, model: model),
                const Spacer(),
                botttomWidget(id: id, model: model),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget imageWidget({required String id, required MusicModel model}) {
    return CommonImageWidget(
      id: id,
      model: model,
      height: Get.width * 0.92,
      width: Get.width * 0.92,
    );
  }

  Widget info({required String id, required MusicModel model}) {
    return CommonInfoWidget(id: id, model: model);
  }

  Widget like({required String id, required MusicModel model}) {
    return Obx(
      () {
        final bool isLiked = controller.likedMusic.contains(id);
        return CommonLikeWidget(
          id: id,
          isLiked: isLiked,
          addLike: () async {
            await controller.addLike(
              musicId: id,
              successCallback: log,
              failureCallback: AppSnackbar().snackbar,
            );
          },
          removeLike: () async {
            await controller.removeLike(
              musicId: id,
              successCallback: log,
              failureCallback: AppSnackbar().snackbar,
            );
          },
        );
      },
    );
  }

  Widget infoRow({required String id, required MusicModel model}) {
    return Row(
      children: <Widget>[
        const SizedBox(width: 16),
        Expanded(child: info(id: id, model: model)),
        like(id: id, model: model),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget slider({required String id, required MusicModel model}) {
    return Row(
      children: <Widget>[
        const SizedBox(width: 16),
        Expanded(
          child: SliderTheme(
            data: SliderThemeData(
              overlayShape: SliderComponentShape.noOverlay,
              showValueIndicator: ShowValueIndicator.always,
            ),
            child: Hero(
              tag: "progress_$id",
              transitionOnUserGestures: true,
              child: Material(
                child: Slider(
                  value: controller.position.value.inSeconds.toDouble(),
                  max: controller.duration.value.inSeconds.toDouble(),
                  onChanged: controller.onChanged,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget duration({required String id, required MusicModel model}) {
    return Builder(
      builder: (BuildContext context) {
        return Row(
          children: <Widget>[
            const SizedBox(width: 16),
            Text(
              formatString(controller.position.value.toString()),
              style: Theme.of(context).textTheme.bodySmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            Text(
              formatString(controller.duration.value.toString()),
              style: Theme.of(context).textTheme.bodySmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(width: 16),
          ],
        );
      },
    );
  }

  Widget button({required String id, required MusicModel model}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        AppIconButton(
          iconData: Icons.arrow_back_ios,
          onPressed: controller.prev,
        ),
        AppFloatingButton(
          iconData: controller.isPlaying.value ? Icons.pause : Icons.play_arrow,
          onPressed: controller.playPause,
        ),
        AppIconButton(
          iconData: Icons.arrow_forward_ios,
          onPressed: controller.next,
        ),
      ],
    );
  }

  Widget botttomWidget({required String id, required MusicModel model}) {
    return SizedBox(
      height: 100,
      width: double.infinity,
      child: AnimatedOpacity(
        opacity: controller.isPlaying.value ? 1.0 : 0.0,
        duration: const Duration(seconds: 1),
        child: Builder(
          builder: (BuildContext context) {
            return WaveWidget(
              config: CustomConfig(
                colors: <Color>[
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).scaffoldBackgroundColor.withOpacity(0.250),
                ],
                durations: <int>[5000, 4000],
                heightPercentages: <double>[0.65, 0.66],
              ),
              size: Size.infinite,
            );
          },
        ),
      ),
    );
  }
}
