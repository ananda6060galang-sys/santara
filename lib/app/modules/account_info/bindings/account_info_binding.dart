import 'package:get/get.dart';
import '../controllers/account_info_controller.dart';

class InfoAkunBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InfoAkunController>(() => InfoAkunController());
  }
}