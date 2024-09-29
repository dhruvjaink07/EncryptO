import 'package:app/Views/aes_file_hashing.dart';
import 'package:app/Views/encryption_page.dart';
import 'package:app/Views/main_page.dart';
import 'package:app/Views/md5_hash_screen.dart';
import 'package:app/Views/sign-in-up/sign_up.dart';
import 'package:app/Views/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import this

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Ensures that binding is initialized before setting orientation
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, // Lock in portrait mode
    DeviceOrientation.portraitDown, // Optional: allow upside-down portrait
  ]).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SplashScreen(),
    );
  }
}
