import 'package:get/get.dart';

class KeamananAkunController extends GetxController {
  // Data aktivitas — bisa diganti fetch dari API/storage
  final String lastLogin    = "Hari ini, 09:42";
  final String loginLocation = "Malang, Indonesia";

  void goBack() => Get.back();

  void ubahPassword() {
    // TODO: navigasi ke halaman ubah password
  }

  void verifikasiDuaLangkah() {
    // TODO: navigasi ke halaman verifikasi dua langkah
  }

  void perangkatTerhubung() {
    // TODO: navigasi ke halaman perangkat terhubung
  }
}