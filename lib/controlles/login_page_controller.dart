import 'dart:developer';

import 'package:education_analizer/controlles/auth_controller.dart';
import 'package:education_analizer/model/user.dart';
import 'package:education_analizer/repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

class LoginPageController extends GetxController {
  final AuthController authController;
  final UserRepository userRepository;

  LoginPageController(this.userRepository, {required this.authController});

  void goAuth({required String login, required String password}) async {
    try {
      User user = await userRepository.loginUser(login, password);

      authController.role.value = user.role ?? '';
      authController.name.value = user.username ?? "";
      authController.id.value = user.id ?? 0;

      Get.toNamed("/home");
    } catch (e) {
      log("Ошибка входа: $e");

      Get.snackbar(
        "Ошибка входа",
        duration: const Duration(milliseconds: 1200),
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color.fromRGBO(244, 67, 54, 70),
        colorText: Colors.white,
      );
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
