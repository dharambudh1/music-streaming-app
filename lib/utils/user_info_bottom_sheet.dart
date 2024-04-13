import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:music_streaming_app/common/common_cached_network_image.dart";
import "package:music_streaming_app/services/app_storage_service.dart";
import "package:music_streaming_app/utils/app_icon_button.dart";

class UserInfoBottomSheet extends StatefulWidget {
  const UserInfoBottomSheet({super.key});

  @override
  State<UserInfoBottomSheet> createState() => _UserInfoBottomSheetState();
}

class _UserInfoBottomSheetState extends State<UserInfoBottomSheet> {
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
              iconData: Icons.account_circle_outlined,
              onPressed: () {},
            ),
            const Spacer(),
            Text(
              "Logged-in account information",
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
        ClipOval(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: CommonCachedNetworkImage(
            imageUrl: AppStorageService().getUserModel().image ?? "",
            height: 100,
            width: 100,
          ),
        ),
        const SizedBox(height: 16),
        ListTile(
          dense: true,
          title: Text(AppStorageService().getUserModel().name ?? ""),
          subtitle: const Text("Name"),
          onTap: () {},
        ),
        ListTile(
          dense: true,
          title: Text(AppStorageService().getUserModel().emailAddress ?? ""),
          subtitle: const Text("Email address"),
          onTap: () {},
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
