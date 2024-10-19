import 'package:dio/dio.dart';
import 'package:get/get.dart';

class ListofsubjectRepository extends GetxService {
  final String url =
      "http://192.168.100.8:3000/api/listOfSubjects"; // 192.168.100.8 localhost
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

  // Получение предмета по ID
  Future<dynamic> getListSubjectById(int id) async {
    try {
      final response = await dio.get('$url/$id');
      return response.data;
    } catch (e) {
      throw Exception('Ошибка при получении предмета по ID: $e');
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
  Future<void> deleteListOfSubject(int id) async {
    try {
      await dio.delete('$url/$id');
    } catch (e) {
      throw Exception('Ошибка при удалении предмета: $e');
    }
  }
}
