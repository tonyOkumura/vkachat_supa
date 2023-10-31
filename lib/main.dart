import 'package:flutter/material.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vkachat_supa/pages/splash_page.dart';
import 'package:vkachat_supa/utils/constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    // TODO: Replace credentials with your own
    url: 'https://bzthjagjwnamvmuvtwji.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJ6dGhqYWdqd25hbXZtdXZ0d2ppIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTg2MjA1MDYsImV4cCI6MjAxNDE5NjUwNn0.ymLi2d80A7DEjPnjKS9r5gMkIdpWCztpEP3HDLr7OAM',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Chat App',
      theme: appTheme,
      home: const SplashPage(),
    );
  }
}
