import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class KeamananAkunController extends GetxController {
  // connect ke supabase auth
  final supabase = Supabase.instance.client;

  // biar ui update sendiri pas data keload
  final email = ''.obs;
  final loginProvider = '-'.obs;
  final lastLogin = '-'.obs;
  final loginLocation = '-'.obs;
  final isEmailLogin = false.obs;
  final isEmailVerified = false.obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadSecurityInfo();
  }

  // ambil data keamanan dari user login
  void loadSecurityInfo() {
    isLoading.value = true;

    final user = supabase.auth.currentUser;

    if (user == null) {
      _setFallback();
      isLoading.value = false;
      return;
    }

    final provider = _getLoginProvider(user);

    email.value = user.email ?? '-';
    loginProvider.value = provider;
    isEmailLogin.value = provider == 'email';
    isEmailVerified.value = user.emailConfirmedAt != null;
    lastLogin.value = _formatDate(user.lastSignInAt);
    loginLocation.value = '-';
    isLoading.value = false;
  }

  // cek login dari email/google/facebook
  String _getLoginProvider(User user) {
    final provider = user.appMetadata['provider']?.toString();

    if (provider != null && provider.isNotEmpty) {
      return provider;
    }

    final providers = user.appMetadata['providers'];

    if (providers is List && providers.isNotEmpty) {
      return providers.first.toString();
    }

    return 'email';
  }

  String _formatDate(String? value) {
    if (value == null || value.trim().isEmpty) return '-';

    final date = DateTime.tryParse(value)?.toLocal();

    if (date == null) return '-';

    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  // fallback kalau user auth belum kebaca
  void _setFallback() {
    email.value = '-';
    loginProvider.value = '-';
    lastLogin.value = '-';
    loginLocation.value = '-';
    isEmailLogin.value = false;
    isEmailVerified.value = false;
  }

  void goBack() => Get.back();

  Future<void> ubahPassword() async {
    final userEmail = email.value;

    if (!isEmailLogin.value) {
      Get.snackbar(
        'Info',
        'Password akun ini diatur lewat ${loginProvider.value}.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (userEmail == '-' || userEmail.isEmpty) {
      Get.snackbar(
        'Info',
        'Email akun belum kebaca.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      // kirim link reset password ke email user
      await supabase.auth.resetPasswordForEmail(userEmail);

      Get.snackbar(
        'Berhasil',
        'Link reset password sudah dikirim ke email kamu.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }

  void verifikasiDuaLangkah() {
    // MFA belum dipasang, jadi kasih info dulu biar ga zonk
    Get.snackbar(
      'Info',
      'Verifikasi dua langkah belum tersedia di aplikasi ini.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void perangkatTerhubung() {
    // Supabase client belum kasih list device lengkap
    Get.snackbar(
      'Info',
      'Daftar perangkat terhubung belum tersedia.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
