import 'dart:developer';

import 'package:education_analizer/controlles/auth_controller.dart';
import 'package:education_analizer/model/user.dart';
import 'package:education_analizer/repository/user_repository.dart';
import 'package:get/get.dart';

class LoginPageController extends GetxController {
  final AuthController authController;
  final UserRepository userRepository;

  LoginPageController(this.userRepository, {required this.authController});

  void goAuth({required String login, required String password}) async {
    log("Попытка входа с логином: $login и паролем: $password");
    const Duration(seconds: 3);
    try {
      authController.logout();
      User user = await userRepository.loginUser(login, password);
      authController.role.value = user.role ?? '';
      authController.name.value = user.username ?? "";
      authController.id.value = user.id ?? 0;
      log(user.id.toString());
      Get.toNamed("/home");
    } catch (e) {
      log("Ошибка входа goAuth: $e");
    }
  }
}
