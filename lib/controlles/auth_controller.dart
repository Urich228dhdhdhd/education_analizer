import 'package:get/get.dart';

class AuthController extends GetxController {
  RxInt id = 0.obs;
  RxString role = "".obs;
  RxString name = "".obs;
  RxString firstName = "".obs;
  RxString middleName = "".obs;
  RxString lastName = "".obs;
  void logout() {
    role.value = '';
    name.value = '';
    id.value = 0;
  }
}
