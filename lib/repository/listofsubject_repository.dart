import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:education_analizer/model/list_of_subject.dart';
import 'package:education_analizer/model/subject.dart';
import 'package:education_analizer/repository/main_url.dart';
import 'package:get/get.dart';

class ListofsubjectRepository extends GetxService {
  final String url = "$mainUrl/api/listOfSubjects"; // 192.168.100.8 localhost
  final Dio dio = Dio();

  // Получение всех предметов
  Future<List<dynamic>> getListOfSubjects() async {
    try {
      final response = await dio.get(url);
      return response.data;
    } catch (e) {
      throw Exception('Ошибка при получении списка предметов: $e');
    }
  }

  Future<List<dynamic>> getListOfSubjectsByGroupId(int groupId) async {
    try {
      final response = await dio.get("$url/group/$groupId");
      return response.data;
    } catch (e) {
      throw Exception('Ошибка при получении списка предметов по grooup_id: $e');
    }
  }

  Future<List<ListOfSubject>> getListOfSubjectsBySubjectGroupId(
      int groupId, int subjectId) async {
    try {
      final response = await dio.get("$url/group/$groupId/subject/$subjectId");

      // Преобразуем данные в List<ListOfSubject>
      List<dynamic> data =
          response.data; // Получаем данные в виде List<dynamic>
      return data
          .map((item) => ListOfSubject.fromJson(item))
          .toList(); // Преобразуем в List<ListOfSubject>
    } catch (e) {
      throw Exception('Ошибка при получении списка предметов по group_id: $e');
    }
  }

  // Получение предмета по ID
  Future<dynamic> getListSubjectById(int id) async {
    try {
      final response = await dio.get('$url/$id');
      return response.data;
    } catch (e) {
      throw Exception('Ошибка при получении предмета по ID: $e');
    }
  }

  Future<List<Subject>> getSubjectsByGroupId(int groupId) async {
    try {
      final response = await dio.get('$url/subjectIds/$groupId');

      // Извлекаем данные из вложенного объекта subject
      List<dynamic> data = response.data;
      final subjects = data.map((item) {
        return Subject.fromJson({
          'id': item['subject_id'],
          'subject_name_short': item['subject']?['subject_name_short'],
          'subject_name_long': item['subject']?['subject_name_long'],
        });
      }).toList();

      return subjects;
    } catch (e) {
      throw Exception(
          'Ошибка при получении списка предметов с краткими именами по group_id: $e');
    }
  }

  // Создание нового предмета
  Future<dynamic> createListOfSubject(Map<String, dynamic> subjectData) async {
    try {
      final response = await dio.post(url, data: subjectData);
      return response.data;
    } catch (e) {
      throw Exception('Ошибка при создании предмета: $e');
    }
  }

  // Обновление предмета по ID
  Future<dynamic> updateListOfSubject(
      int id, Map<String, dynamic> subjectData) async {
    try {
      final response = await dio.put('$url/$id', data: subjectData);
      return response.data;
    } catch (e) {
      throw Exception('Ошибка при обновлении предмета: $e');
    }
  }

  // Удаление предмета по ID
  Future<void> delete1ListOfSubject(int id) async {
    try {
      await dio.delete('$url/$id');
    } catch (e) {
      throw Exception('Ошибка при удалении предмета: $e');
    }
  }

  // Проверка существования предмета
  Future<bool> checkListOfSubjectExists(
      int subjectId, int groupId, int semesterNumber) async {
    try {
      final response = await dio.post("$url/isexist", data: {
        "subject_id": subjectId,
        "group_id": groupId,
        "semester_number": semesterNumber,
      });
      return response.statusCode == 200; // Если статус 200, запись существует
    } catch (e) {
      throw Exception('Ошибка при проверке существования предмета: $e');
    }
  }

  Future<void> deleteListOfSubjectbyAllParams(
      int subjectId, int groupId, int semesterNumber) async {
    try {
      await dio.delete(
          "$url/group/$groupId/subject/$subjectId/semester_number/$semesterNumber",
          data: {
            "group_id": groupId,
            "subject_id": subjectId,
            "semester_number": semesterNumber,
          });
    } catch (e) {
      throw Exception('Ошибка при удалении семестра: $e');
    }
  }
}
