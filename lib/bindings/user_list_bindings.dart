import 'package:education_analizer/controlles/user_list_controller.dart';
import 'package:education_analizer/repository/group_repository.dart';
import 'package:education_analizer/repository/user_repository.dart';
import 'package:get/get.dart';

import '../controlles/auth_controller.dart';

class UserListBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
    Get.lazyPut<UserRepository>(() => UserRepository());
    Get.lazyPut<GroupRepository>(() => GroupRepository());
    Get.lazyPut<UserListController>(() => UserListController(
        authController: Get.find<AuthController>(),
        userRepository: Get.find<UserRepository>(),
        groupRepository: Get.find<GroupRepository>()));
  }
}
