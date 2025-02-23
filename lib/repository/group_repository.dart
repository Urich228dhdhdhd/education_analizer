import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:education_analizer/model/group.dart';
import 'package:education_analizer/repository/main_url.dart';
import 'package:get/get.dart';

import '../design/widgets/dimentions.dart';

class GroupRepository extends GetxService {
  final String url = "$mainUrl/api/groups"; // 192.168.100.8 localhost
  final Dio dio = Dio();

  Future<List<Group>> getGroups() async {
    try {
      final response = await dio.get(url);
      return response.data.map<Group>((e) => Group.fromJson(e)).toList();
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

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
    } on DioException catch (e) {
      throw handleDioError(e);
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
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  // Создание новой группы
  Future<Map<String, dynamic>> createGroup({required Group group}) async {
    try {
      group.statusGroup = "ACTIVE";
      final groupData = group.toJson();
      log(groupData.toString());
      final response = await dio.post(
        url,
        data: groupData,
      );

      if (response.statusCode == 201) {
        return Map<String, dynamic>.from(response.data);
      } else {
        throw Exception(response.data['message'] ?? 'Ощибка создания');
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  // Получение группы по ID
  Future<Group> getGroupById(int id) async {
    try {
      final response = await dio.get("$url/$id");

      if (response.statusCode == 200) {
        return Group.fromJson(response.data);
      } else {
        throw Exception('Ошибка при получении группы: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  // Обновление группы
  Future<Map<String, dynamic>> updateGroup({required Group group}) async {
    try {
      final groupData = group.toJson();
      final response = await dio.put("$url/${group.id}", data: groupData);

      return Map<String, dynamic>.from(response.data);
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  // Удаление группы
  Future<void> deleteGroup(int id) async {
    try {
      final response = await dio.delete("$url/$id");

      if (response.statusCode != 204) {
        throw Exception('Ошибка при удалении группы: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }
}
