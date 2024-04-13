import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:music_streaming_app/services/app_storage_service.dart";
import "package:music_streaming_app/utils/app_icon_button.dart";

class ThemeChangeBottomSheet extends StatefulWidget {
  const ThemeChangeBottomSheet({super.key});

  @override
  State<ThemeChangeBottomSheet> createState() => _ThemeChangeBottomSheetState();
}

class _ThemeChangeBottomSheetState extends State<ThemeChangeBottomSheet> {
  final Rx<ThemeMode> tempMode = ThemeMode.system.obs;

  @override
  void initState() {
    super.initState();
    tempMode(AppStorageService().getUserTheme());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const SizedBox(height: 16),
        Row(
          children: <Widget>[
            const SizedBox(width: 16),
            AppIconButton(
              iconData: Icons.color_lens_outlined,
              onPressed: () {},
            ),
            const Spacer(),
            Text(
              "Select theme",
              style: Theme.of(context).textTheme.titleMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            AppIconButton(
              iconData: Icons.close,
              onPressed: Get.back,
            ),
            const SizedBox(width: 16),
          ],
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          itemCount: ThemeMode.values.length,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            final ThemeMode themeMode = ThemeMode.values[index];
            return Obx(
              () {
                return RadioListTile<ThemeMode>(
                  dense: true,
                  title: Text(themeMode.name.capitalize ?? ""),
                  value: themeMode,
                  groupValue: tempMode.value,
                  onChanged: (ThemeMode? themeMode) async {
                    tempMode(themeMode);
                    Get.changeThemeMode(tempMode.value);
                    await AppStorageService().setUserTheme(tempMode.value.name);
                    Get.back();
                  },
                );
              },
            );
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
