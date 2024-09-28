import 'package:app/Views/aes_file_hashing.dart';
import 'package:app/Views/encryption_page.dart';
import 'package:app/Views/main_page.dart';
import 'package:app/Views/md5_hash_screen.dart';
import 'package:app/Views/sign-in-up/sign_up.dart';
import 'package:flutter/material.dart';
void main() {
  runApp(const MyApp());
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
      home: MainPage()
      );
  }
}
