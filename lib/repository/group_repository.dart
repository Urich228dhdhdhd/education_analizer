import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:education_analizer/model/group.dart';
import 'package:education_analizer/repository/main_url.dart';
import 'package:get/get.dart';

class GroupRepository extends GetxService {
  final String url = "$mainUrl/api/groups"; // 192.168.100.8 localhost
  final Dio dio = Dio();

  // Получение групп по роли
  Future<List<Map<String, dynamic>>> getGroupByRole({
    required int id,
    required String role,
  }) async {
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

// Получение групп по роли
  Future<List<Group>> getGroupByRole2({
    required int id,
    required String role,
  }) async {
    try {
      final response = await dio.post(
        "$url/by-role2",
        data: {
          "curator_id": id,
          "role": role,
        },
      );

      if (response.statusCode == 200) {
        // Преобразуем данные в список объектов Group
        List<Group> groups = (response.data as List)
            .map((item) => Group.fromJson(item))
            .toList();
        // log(groups.toString());
        return groups;
      } else {
        throw Exception('Ошибка при получении групп: ${response.statusCode}');
      }
    } catch (e) {
      log('Ошибка: $e');
      throw Exception('Не удалось выполнить запрос');
    }
  }

  // Создание новой группы
  Future<Map<String, dynamic>> createGroup({
    required String groupName,
    int? curatorId,
    String statusGroup = "ACTIVE",
    int semesterNumber = 1,
  }) async {
    try {
      final response = await dio.post(
        url,
        data: {
          "group_name": groupName,
          "curator_id": curatorId,
          "status_group": statusGroup,
          "semester_number": semesterNumber,
        },
      );

      if (response.statusCode == 201) {
        return Map<String, dynamic>.from(response.data);
      } else {
        throw Exception(response.data['message'] ?? 'Ощибка создания');
      }
    } on DioException catch (e) {
      log(e.toString());
      throw Exception(e.response?.data['message'] ?? 'Ошибка при авторизации');
    }
  }

  // Получение группы по ID
  Future<Map<String, dynamic>> getGroupById(int id) async {
    try {
      final response = await dio.get("$url/$id");

      if (response.statusCode == 200) {
        return Map<String, dynamic>.from(response.data);
      } else {
        throw Exception('Ошибка при получении группы: ${response.statusCode}');
      }
    } catch (e) {
      log('Ошибка: $e');
      throw Exception('Не удалось выполнить запрос');
    }
  }

  // Обновление группы
  Future<Map<String, dynamic>> updateGroup({
    required int id,
    required String groupName,
    int? curatorId,
    String? statusGroup,
    int? semesterNumber,
  }) async {
    try {
      final response = await dio.put(
        "$url/$id",
        data: {
          "group_name": groupName,
          "curator_id": curatorId,
          "status_group": statusGroup,
          "semester_number": semesterNumber,
        },
      );

      if (response.statusCode == 200) {
        return Map<String, dynamic>.from(response.data);
      } else {
        throw Exception('Ошибка при обновлении группы: ${response.statusCode}');
      }
    } catch (e) {
      log('Ошибка: $e');
      throw Exception('Не удалось выполнить запрос');
    }
  }

  // Удаление группы
  Future<void> deleteGroup(int id) async {
    try {
      final response = await dio.delete("$url/$id");

      if (response.statusCode != 204) {
        throw Exception('Ошибка при удалении группы: ${response.statusCode}');
      }
    } catch (e) {
      log('Ошибка: $e');
      throw Exception('Не удалось выполнить запрос');
    }
  }
}
