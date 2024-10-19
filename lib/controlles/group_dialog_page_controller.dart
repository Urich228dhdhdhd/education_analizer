import 'package:education_analizer/controlles/group_page_controller.dart';
import 'package:education_analizer/repository/group_repository.dart';
import 'package:education_analizer/repository/semester_repository.dart';
import 'package:get/get.dart';

class GroupDialogPageController extends GetxController {
  final GroupRepository groupRepository;
  final SemesterRepository semesterRepository;
  final GroupPageController groupPageController;

  // Параметры редактирования
  bool isEditing = false; // Флаг редактирования
  int? groupId; // ID группы, если редактируем

  GroupDialogPageController(
    this.groupPageController, {
    required this.groupRepository,
    required this.semesterRepository,
  });

  Future<void> createNewGroup(
      {required String groupName, int? curatorId}) async {
    try {
      final newGroup = await groupRepository.createGroup(
        groupName: groupName,
        curatorId: curatorId,
      );

      // Обновляем список групп
      groupPageController.findGroupsByRole();

      Get.snackbar(
        'Успех',
        'Группа успешно создана: ${newGroup['group_name']}',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );

      resetEditingParameters(); // Сбрасываем параметры редактирования
    } catch (e) {
      Get.snackbar(
        'Ошибка',
        'Не удалось создать группу: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }
  }

  // Метод для редактирования группы
  // Метод для редактирования группы
  Future<void> editGroup(
      {required int id, required String groupName, int? curatorId}) async {
    try {
      final updatedGroup = await groupRepository.updateGroup(
        id: id, // Используем параметр id напрямую
        groupName: groupName,
        // curatorId: curatorId, // Если нужно, раскомментируйте эту строку
      );

      // Обновляем список групп
      groupPageController.findGroupsByRole();

      Get.snackbar(
        'Успех',
        'Группа успешно обновлена: ${updatedGroup['group_name']}',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );

      resetEditingParameters(); // Сбрасываем параметры редактирования
    } catch (e) {
      // Обработка ошибок
      Get.snackbar(
        'Ошибка',
        'Не удалось обновить группу: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }
  }

  Future<void> saveGroup(
      {required String groupName, int? id, int? curatorId}) async {
    if (isEditing && id != null) {
      // Проверяем, что id не null
      await editGroup(id: id, groupName: groupName, curatorId: curatorId);
    } else {
      await createNewGroup(groupName: groupName, curatorId: curatorId);
    }
  }

  void setEditingParameters(int id,
      {required String groupName, int? curatorId}) {
    groupId = id; // Устанавливаем ID группы
    isEditing = true; // Устанавливаем флаг редактирования
    // Здесь можно сохранить название группы и ID куратора, если необходимо
  }

  // Метод для сброса параметров редактирования
  void resetEditingParameters() {
    groupId = null;
    isEditing = false;
  }
}
