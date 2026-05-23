import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/edit_profile_controller.dart';

class EditProfilePage extends GetView<EditProfileController> {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF8F3),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),

              // ── header ──────────────────────────────────────────────────
              SizedBox(
                height: 40,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        onPressed: controller.goBack,
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          size: 20,
                          color: Color(0xFF8B5A3C),
                        ),
                      ),
                    ),
                    const Text(
                      "Edit Profile",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF8B5A3C),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // ── foto profil ──────────────────────────────────────────────
              Center(
                child: Obx(() {
                  final path = controller.selectedImagePath.value;

                  // FIX: bedakan 3 kondisi:
                  // 1. path kosong          → belum ada foto, tampil initial avatar
                  // 2. path = URL (http)    → foto dari Supabase, pakai Image.network
                  // 3. path = lokal         → foto baru dari galeri, pakai Image.file
                  final isNetworkUrl = path.startsWith('http');
                  final isLocalFile = path.isNotEmpty && !isNetworkUrl;

                  return GestureDetector(
                    onTap: controller.pickImage,
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        // ── lingkaran foto ─────────────────────────────────
                        Container(
                          width: 110,
                          height: 110,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFFD4A574),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: isLocalFile
                                // foto baru dari galeri
                                ? Image.file(
                                    File(path),
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  )
                                : isNetworkUrl
                                    // foto dari Supabase
                                    ? Image.network(
                                        path,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: double.infinity,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          // kalau gagal load, fallback ke initial avatar
                                          return _buildInitialAvatar();
                                        },
                                      )
                                    // belum ada foto → initial avatar (sama seperti profile_page)
                                    : _buildInitialAvatar(),
                          ),
                        ),

                        // ── badge icon kamera ──────────────────────────────
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Color(0xFF8B5A3C),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),

              const SizedBox(height: 40),

              // ── form input ───────────────────────────────────────────────
              _buildInputField("Nama", controller.nameController),
              const SizedBox(height: 20),

              _buildInputField("E-mail", controller.emailController),
              const SizedBox(height: 20),

              _buildInputField("Nomor", controller.phoneController),
              const SizedBox(height: 20),

              _buildInputField("Lokasi", controller.locationController),
              const SizedBox(height: 35),

              // ── tombol simpan ────────────────────────────────────────────
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B5A3C),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: controller.saveChanges,
                  child: const Text(
                    "Simpan Perubahan",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // ── initial avatar (huruf pertama nama) ──────────────────────────────────
  // sama persis dengan yang ada di profile_page
  Widget _buildInitialAvatar() {
    String initial = '?';
    if (controller.nameController.text.isNotEmpty) {
      initial = controller.nameController.text[0].toUpperCase();
    }
    return Container(
      color: const Color(0xFFD4A574),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: const TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  // ── helper: input field dengan label di atas ─────────────────────────────
  Widget _buildInputField(String label, TextEditingController textController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: const Color(0xFF8B5A3C).withOpacity(0.6),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: textController,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2C2C2C),
          ),
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 12),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF8B5A3C), width: 1),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF8B5A3C), width: 2),
            ),
          ),
        ),
      ],
    );
  }
}