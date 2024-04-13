import "package:get/get.dart";
import "package:music_streaming_app/controllers/login_controller.dart";

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(LoginController.new);
  }
}
