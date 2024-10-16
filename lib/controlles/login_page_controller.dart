import 'dart:developer';

import 'package:education_analizer/controlles/auth_controller.dart';
import 'package:get/get.dart';

class LoginPageController extends GetxController {
  final AuthController authController;
  LoginPageController({required this.authController});

  void goAuth({required String login, required String password}) {
    log(login);
    log(password);
    // authController
  }
}
