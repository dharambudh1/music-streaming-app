import "package:get/get.dart";
import "package:music_streaming_app/controllers/details_controller.dart";

class DetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(DetailsController.new);
  }
}
