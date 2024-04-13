import "package:get/get.dart";
import "package:music_streaming_app/controllers/home_controller.dart";

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(HomeController.new);
  }
}
