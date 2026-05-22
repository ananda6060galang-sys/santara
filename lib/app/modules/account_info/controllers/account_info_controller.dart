import 'package:get/get.dart';

class InfoAkunController extends GetxController {
  // Data akun — bisa diganti dengan fetch dari API/storage di masa depan
  final String name       = "Floyd Miles";
  final String email      = "felicia.reid@example.com";
  final String phone      = "+62 812-3456-7890";
  final String joinDate   = "12 Januari 2024";
  final String location   = "Malang, Indonesia";
  final String status     = "Aktif";
  final String avatarPath = "assets/profile.png";

  void goBack() => Get.back();
}