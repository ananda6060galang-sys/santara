import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class InfoAkunController extends GetxController {
  // connect ke supabase
  final supabase = Supabase.instance.client;

  // biar ui langsung update otomatis
  final name = ''.obs;
  final email = ''.obs;
  final phone = ''.obs;
  final joinDate = ''.obs;
  final location = ''.obs;
  final status = ''.obs;
  final avatarUrl = ''.obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    getAccountInfo();
  }

  // ambil data user login
  Future<void> getAccountInfo() async {
    try {
      isLoading.value = true;

      final user = supabase.auth.currentUser;

      if (user == null) {
        _setFallback();
        return;
      }

      final data = await supabase
          .from('profiles')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      if (data == null) {
        _setFallback(emailFallback: user.email ?? '');
        return;
      }

      name.value = _textOrFallback(data['name'], 'User');
      email.value = _textOrFallback(data['email'], user.email ?? '-');
      phone.value = _textOrFallback(data['phone'], '-');
      location.value = _textOrFallback(data['location'], '-');
      avatarUrl.value = _textOrFallback(data['avatar_url'], '');
      joinDate.value = _formatJoinDate(data['created_at']);
      status.value = _textOrFallback(data['role'], '-');
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  // fallback kalau data kosong
  void _setFallback({String emailFallback = ''}) {
    name.value = 'User';
    email.value = emailFallback.isEmpty ? '-' : emailFallback;
    phone.value = '-';
    location.value = '-';
    avatarUrl.value = '';
    joinDate.value = '-';
    status.value = '-';
  }

  String _textOrFallback(dynamic value, String fallback) {
    final text = value?.toString().trim() ?? '';

    return text.isEmpty ? fallback : text;
  }

  String _formatJoinDate(dynamic value) {
    final text = value?.toString().trim() ?? '';

    if (text.isEmpty) return '-';

    final date = DateTime.tryParse(text)?.toLocal();

    if (date == null) return '-';

    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  void goBack() => Get.back();
}
