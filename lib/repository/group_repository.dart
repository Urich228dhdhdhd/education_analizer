import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get/get.dart';

class GroupRepository extends GetxService {
  final String url = "http://192.168.100.8:3000/api/groups"; // 192.168.100.8
  final Dio dio = Dio();

  Future<List<Map<String, dynamic>>> getGroupByRole(
      {required int id, required String role}) async {
    try {
      final response = await dio.post(
        "$url/by-role",
        data: {
          "curator_id": id,
          "role": role,
        },
      );

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(response.data);
      } else {
        throw Exception('Ошибка при получении групп: ${response.statusCode}');
      }
    } catch (e) {
      log('Ошибка: $e');
      throw Exception('Не удалось выполнить запрос');
    }
  }
}
