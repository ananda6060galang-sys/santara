import 'package:get/get.dart';
import '../controllers/account_security_controller.dart';

class KeamananAkunBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<KeamananAkunController>(() => KeamananAkunController());
  }
}