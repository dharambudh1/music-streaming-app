import "dart:async";

import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:music_streaming_app/common/common_animated_opacity.dart";
import "package:music_streaming_app/common/common_dynamic_text.dart";
import "package:music_streaming_app/functions/app_functions.dart";
import "package:music_streaming_app/services/app_audio_service.dart";
import "package:music_streaming_app/services/app_storage_service.dart";
import "package:music_streaming_app/utils/app_icon_button.dart";
import "package:music_streaming_app/utils/app_routes.dart";
import "package:music_streaming_app/utils/theme_change_bottom_sheet.dart";
import "package:music_streaming_app/utils/user_info_bottom_sheet.dart";

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({required this.isForHome, super.key});
  final bool isForHome;

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  final RxDouble opacity = 0.0.obs;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (Duration timeStamp) async {
        if (mounted) {
          await updateOpacity();
        } else {}
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return AppBar(
          centerTitle: false,
          title: widget.isForHome ? dynamicText() : const Text("Details"),
          surfaceTintColor: Colors.transparent,
          flexibleSpace: SizedBox.expand(
            child: CommonAnimatedOpacityWidget(
              opacity: opacity.value,
              isForTop: true,
            ),
          ),
          actions: widget.isForHome
              ? <Widget>[
                  AppIconButton(
                    onPressed: openUserInfoBottomSheet,
                    iconData: Icons.account_circle_outlined,
                  ),
                  AppIconButton(
                    onPressed: openThemeChangeBottomSheet,
                    iconData: Icons.color_lens_outlined,
                  ),
                  AppIconButton(
                    onPressed: () async {
                      await AppAudioService().stopIfPlaying();
                      await AppStorageService().erase();
                      await Get.offAllNamed(AppRoutes().loginScreen);
                    },
                    iconData: Icons.logout,
                  ),
                ]
              : null,
        );
      },
    );
  }

  Widget dynamicText() {
    return Stack(
      children: <Widget>[
        CommonDynamicText(
          opacity: opacity.value == 0.0 ? 1.0 : 0.0,
          path: "assets/lottie/wave.json",
          title: "Welcome,",
          body: AppStorageService().getUserModel().name ?? "",
        ),
        CommonDynamicText(
          opacity: opacity.value != 0.0 ? 1.0 : 0.0,
          path: "assets/lottie/${lottieJson()}.json",
          title: "Good ${lottieJson()},",
          body: AppStorageService().getUserModel().name ?? "",
        ),
      ],
    );
  }

  Future<void> openThemeChangeBottomSheet() async {
    await Get.bottomSheet(
      const ThemeChangeBottomSheet(),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      isScrollControlled: true,
    );
    return Future<void>.value();
  }

  Future<void> openUserInfoBottomSheet() async {
    await Get.bottomSheet(
      const UserInfoBottomSheet(),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      isScrollControlled: true,
    );
    return Future<void>.value();
  }

  Future<void> updateOpacity() async {
    const int seconds = 3;
    const Duration duration = Duration(seconds: seconds);
    await Future<void>.delayed(duration);
    opacity(1.0);
    return Future<void>.value();
  }
}
