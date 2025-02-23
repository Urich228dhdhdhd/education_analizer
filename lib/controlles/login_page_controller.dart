import 'dart:developer';

import 'package:education_analizer/controlles/auth_controller.dart';
import 'package:education_analizer/model/user.dart';
import 'package:education_analizer/repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

class LoginPageController extends GetxController {
  final AuthController authController;
  final UserRepository userRepository;

  LoginPageController(this.userRepository, {required this.authController});
  var isButtonDisabled = false.obs;
  final isPasswordVisible = false.obs;

  void goAuth({required String login, required String password}) async {
    if (isButtonDisabled.value) return;
    isButtonDisabled.value = true;
    try {
      User user = await userRepository.loginUser(login, password);

      authController.role.value = user.role ?? '';
      authController.name.value = user.username ?? "";
      authController.firstName.value = user.firstName ?? "";
      authController.middleName.value = user.middleName ?? "";
      authController.lastName.value = user.lastName ?? "";
      authController.id.value = user.id ?? 0;
      Get.toNamed("/home");
    } catch (e) {
      Get.snackbar(
        "Ошибка входа",
        duration: const Duration(milliseconds: 1200),
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color.fromRGBO(244, 67, 54, 70),
        colorText: Colors.white,
      );
    } finally {
      Future.delayed(const Duration(seconds: 2), () {
        isButtonDisabled.value = false;
      });
    }
  }

  void launchURL() async {
    const url = 'https://mgkct.minskedu.gov.by/';
    try {
      await launchUrlString(url);
    } catch (e) {
      log('Could not launch $url: $e');
    }
  }
}
