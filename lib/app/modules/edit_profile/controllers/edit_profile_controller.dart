import 'package:flutter/material.dart';
import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../modules/profile/controllers/profile_controller.dart';

class EditProfileController extends GetxController {
  final supabase = Supabase.instance.client;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  // path foto yang dipilih dari galeri
  final RxString selectedImagePath = ''.obs;

  // load data profile user
  Future<void> getProfile() async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) return;

      final data = await supabase
          .from('profiles')
          .select()
          .eq('id', user.id)
          .single();

      nameController.text = data['name'] ?? '';
      emailController.text = data['email'] ?? '';
      phoneController.text = data['phone'] ?? '';
      locationController.text = data['location'] ?? '';
      selectedImagePath.value = data['avatar_url'] ?? '';
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  void onInit() {
    super.onInit();
    getProfile();
  }

  // ambil foto dari galeri
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (picked != null) {
      selectedImagePath.value = picked.path;
    }
  }

  // simpan perubahan profile
  Future<void> saveChanges() async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) return;

      String avatarUrl = selectedImagePath.value;

      // upload avatar kalau pilih foto baru (path lokal, bukan URL)
      if (selectedImagePath.value.isNotEmpty &&
          !selectedImagePath.value.startsWith('http')) {
        final file = File(selectedImagePath.value);
        final fileName = '${user.id}.jpg';

        await supabase.storage.from('avatars').upload(
              fileName,
              file,
              fileOptions: const FileOptions(upsert: true),
            );

        avatarUrl = supabase.storage.from('avatars').getPublicUrl(fileName);
      }

      // update database
      await supabase.from('profiles').update({
        'name': nameController.text,
        'email': emailController.text,
        'phone': phoneController.text,
        'location': locationController.text,
        'avatar_url': avatarUrl,
      }).eq('id', user.id);

      // ── FIX: refresh ProfileController supaya data di profile page ikut update ──
      if (Get.isRegistered<ProfileController>()) {
        await Get.find<ProfileController>().getProfile();
      }

      // kembali ke profile page dulu, baru tampilkan snackbar
      Get.back();

      Future.delayed(const Duration(milliseconds: 300), () {
        Get.snackbar(
          'Berhasil',
          'Profile berhasil diubah',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF8B5A3C),
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
      });
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // tombol back
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