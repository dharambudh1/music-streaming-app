import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:get/get.dart";
import "package:lottie/lottie.dart";
import "package:music_streaming_app/controllers/login_controller.dart";
import "package:music_streaming_app/utils/app_floating_button.dart";
import "package:music_streaming_app/utils/app_icon_button.dart";
import "package:music_streaming_app/utils/app_routes.dart";
import "package:music_streaming_app/utils/app_snackbar.dart";
import "package:music_streaming_app/utils/app_text_form_field.dart";
import "package:music_streaming_app/utils/custom_lottie_widget.dart";

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Login"),
      ),
      floatingActionButton: AppFloatingButton(
        onPressed: () async {
          final bool res = controller.formKey.currentState?.validate() ?? false;
          if (res) {
            controller.connected.value
                ? await controller.functionLogin(
                    successCallback: (String message) async {
                      await Get.offAllNamed(AppRoutes().homeScreen);
                    },
                    failureCallback: AppSnackbar().snackbar,
                  )
                : AppSnackbar().snackbar("No Internet");
          } else {}
        },
        iconData: Icons.arrow_forward_ios,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Form(
            key: controller.formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CustomLottieWidget(
                  path: "assets/lottie/mirror_ball.json",
                  onLoaded: (LottieComposition lottieComposition) {},
                ),
                const SizedBox(height: 16),
                AppTextFormField(
                  controller: controller.emailController,
                  keyboardType: TextInputType.emailAddress,
                  textCapitalization: TextCapitalization.none,
                  textInputAction: TextInputAction.next,
                  readOnly: false,
                  obscureText: false,
                  maxLines: 1,
                  maxLength: null,
                  onChanged: controller.emailRxString,
                  onTap: () {},
                  validator: (String? value) {
                    return (GetUtils.isNullOrBlank(value) ?? true)
                        ? "Required"
                        : !GetUtils.isEmail(value ?? "")
                            ? "Invalid"
                            : null;
                  },
                  inputFormatters: const <TextInputFormatter>[],
                  enabled: true,
                  autofillHints: const <String>[AutofillHints.email],
                  labelText: "Email Address",
                  hintText: "Email Address",
                  prefixIcon: const Icon(Icons.email_outlined),
                  suffixIcon: const SizedBox(),
                ),
                const SizedBox(height: 16),
                Obx(
                  () {
                    return AppTextFormField(
                      controller: controller.passwordController,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.none,
                      textInputAction: TextInputAction.done,
                      readOnly: false,
                      obscureText: !controller.isPasswordVisible.value,
                      maxLines: 1,
                      maxLength: null,
                      onChanged: controller.passwordRxString,
                      onTap: () {},
                      validator: (String? value) {
                        return (GetUtils.isNullOrBlank(value) ?? true)
                            ? "Required"
                            : null;
                      },
                      inputFormatters: const <TextInputFormatter>[],
                      enabled: true,
                      autofillHints: const <String>[AutofillHints.password],
                      labelText: "Password",
                      hintText: "Password",
                      prefixIcon: const Icon(Icons.password_outlined),
                      suffixIcon: AppIconButton(
                        onPressed: controller.swapPasswordVisiblity,
                        iconData: controller.isPasswordVisible.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
