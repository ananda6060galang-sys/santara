import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProfileController extends GetxController {
  final TextEditingController nameController =
      TextEditingController(text: "Floyd Miles");

  final TextEditingController emailController =
      TextEditingController(text: "felicia.reid@example.com");

  final TextEditingController phoneController =
      TextEditingController(text: "(217) 555–0113");

  final TextEditingController locationController =
      TextEditingController(text: "Jl. Kenanga Raya 15, Bandung");

  void saveChanges() {
    Get.back();
  }

  void goBack() {
    Get.back();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    locationController.dispose();
    super.onClose();
  }
}