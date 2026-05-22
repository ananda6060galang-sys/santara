import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/services/supabase_service.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SupabaseService.init();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final event = data.event;

      if (event == AuthChangeEvent.signedIn) {
        Get.offAllNamed('/home');
      }

      if (event == AuthChangeEvent.signedOut) {
        Get.offAllNamed('/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Santara',

      theme: ThemeData(fontFamily: 'Roboto', useMaterial3: false),

      initialRoute: AppPages.INITIAL,

      getPages: AppPages.routes,
    );
  }
}
