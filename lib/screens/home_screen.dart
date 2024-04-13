import "dart:developer";

import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_ui_firestore/firebase_ui_firestore.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:get/get.dart";
import "package:music_streaming_app/common/common_image_widget.dart";
import "package:music_streaming_app/common/common_info_widget.dart";
import "package:music_streaming_app/common/common_like_button.dart";
import "package:music_streaming_app/controllers/home_controller.dart";
import "package:music_streaming_app/functions/app_functions.dart";
import "package:music_streaming_app/models/music_model.dart";
import "package:music_streaming_app/screens/app_bar.dart";
import "package:music_streaming_app/screens/bottom_bar.dart";
import "package:music_streaming_app/utils/app_icon_button.dart";
import "package:music_streaming_app/utils/app_routes.dart";
import "package:music_streaming_app/utils/app_snackbar.dart";
import "package:music_streaming_app/utils/app_text_form_field.dart";

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(isForHome: true),
      bottomNavigationBar: const CustomBottomBar(isForHome: true),
      body: SafeArea(
        child: Obx(
          () {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                search(),
                Expanded(child: firestoreListView()),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget search() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: AppTextFormField(
        controller: controller.searchController,
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.words,
        textInputAction: TextInputAction.done,
        readOnly: false,
        obscureText: false,
        maxLines: 1,
        maxLength: null,
        onChanged: controller.searchRxString,
        onTap: () {},
        validator: (String? value) {
          return null;
        },
        inputFormatters: const <TextInputFormatter>[],
        enabled: true,
        autofillHints: const <String>[],
        labelText: "Search",
        hintText: "Search",
        prefixIcon: const Icon(Icons.search),
        suffixIcon: controller.searchRxString.value.isNotEmpty
            ? AppIconButton(
                onPressed: () {
                  controller.searchController.clear();
                  controller.searchRxString("");
                },
                iconData: Icons.close,
              )
            : const SizedBox(),
      ),
    );
  }

  Widget firestoreListView() {
    return FirestoreListView<dynamic>.separated(
      // ignore: avoid_redundant_argument_values
      pageSize: 10,
      shrinkWrap: true,
      query: controller.query().value,
      showFetchingIndicator: true,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      physics: const BouncingScrollPhysics(),
      separatorBuilder: (BuildContext context, int index) {
        return const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Divider(height: 0),
        );
      },
      itemBuilder: (BuildContext context, QueryDocumentSnapshot<dynamic> snap) {
        return firestoreListViewAdapter(snap: snap);
      },
    );
  }

  Widget firestoreListViewAdapter({
    required QueryDocumentSnapshot<dynamic> snap,
  }) {
    final String id = getId(docsData: snap);
    final Map<String, dynamic> data = getData(docsData: snap);
    final MusicModel model = MusicModel.fromJson(data);
    return InkWell(
      onTap: () async {
        if (controller.connected.value) {
          if (id != controller.getCurrentMusicId()) {
            await controller.setUrlAndPlay(model: model, key: id, data: data);
          } else {}

          await Get.toNamed(AppRoutes().detailsScreen);
        } else {
          AppSnackbar().snackbar("No Internet");
        }
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
              like(id: id, model: model),
              const SizedBox(width: 16),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget imageWidget({required String id, required MusicModel model}) {
    return CommonImageWidget(
      id: id,
      model: model,
      height: 48,
      width: 48,
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
}
