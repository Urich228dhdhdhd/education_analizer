import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

const double radius32 = 32;
const double radius20 = 20;
const double radius10 = 10;
const double radius12 = 12;
const double radius8 = 8;
const double radius6 = 6;
const double padding6 = 6;
const double padding12 = 12;
const double padding10 = 10;
const double padding14 = 14;
const double padding20 = 20;
const double padding32 = 32;
void homeRoute() async {
  Get.toNamed("/home");
}

void showSnackBar({
  required String title,
  required String message,
  Duration duration = const Duration(seconds: 2),
  SnackPosition snackPosition = SnackPosition.BOTTOM,
  Color backgroundColor = const Color.fromRGBO(244, 67, 54, 70),
  Color textColor = Colors.white,
}) {
  Get.snackbar(
    duration: duration,
    title,
    message,
    snackPosition: snackPosition,
    backgroundColor: backgroundColor,
    colorText: textColor,
  );
}

String handleDioError(DioException e) {
  String errorMessage = "";
  if (e.type == DioExceptionType.connectionTimeout ||
      e.type == DioExceptionType.receiveTimeout ||
      e.type == DioExceptionType.sendTimeout) {
    errorMessage = "Превышено время ожидания запроса";
  } else if (e.type == DioExceptionType.connectionError) {
    errorMessage = "Нет подключения к интернету";
    // log("Ошибка: Нет подключения к интернету");
  } else if (e.type == DioExceptionType.cancel) {
    errorMessage = "Запрос был отменен";
    // log("Запрос был отменен");
  } else {
    errorMessage = "${e.response?.data["message"]}";
    // log("Неизвестная ошибка: ${e.message}");
  }
  // Возвращаем строку с ошибкой
  return errorMessage;
}
