import 'dart:async';
import 'dart:convert';

import 'package:app/Views/main_page.dart';
import 'package:app/Views/sign-in-up/sign_up.dart';
import 'package:app/components/secrue_fields.dart';
import 'package:app/utils/colors.dart';
import 'package:app/utils/constants.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;  // Loading state for showing the loader

  String? _sanitizeInput(String input) {
    return input.trim(); // Trims leading and trailing whitespace
  }

  Future<int> login(String email, String password) async {
    try {
      // Login function
      Uri url = Uri.parse('${Api.domain}/auth/login'); // Assuming `Api.domain` contains the API endpoint
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      if (response.statusCode == 200) {
        // Parse the response body to extract username
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final String username = responseData['user']['username'];

        // Store email and username in SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('email', email);
        await prefs.setString('username', username);

        print("Data Stored: email = $email, username = $username");
        return 200;
      } else {
        print(response.statusCode);
        print(response.body);
        return response.statusCode; // Return the actual error code for handling
      }
    } on Exception catch (e) {
      print(e);
      return 500;
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [CyberpunkColors.zaffre, CyberpunkColors.oxfordBlue],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Sign In",
                  style: TextStyle(
                    color: CyberpunkColors.fluorescentCyan,
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: screenWidth / 5),
                  child: const Text(
                    'Welcome Back! We missed you. Please log in to continue.',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
                SecureField(
                  publicKeyController: _emailController,
                  labelText: 'Email',
                  prefixIcon: Icons.email,
                  isPassword: false,
                  validator: (value) {
                    String sanitizedValue = _sanitizeInput(value ?? '')!;
                    if (!EmailValidator.validate(sanitizedValue)) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                SecureField(
                  publicKeyController: _passwordController,
                  labelText: 'Password',
                  prefixIcon: Icons.lock,
                  isPassword: true,
                  validator: (value) {
                    String sanitizedValue = _sanitizeInput(value ?? '')!;
                    if (sanitizedValue.isEmpty) {
                      return 'Password cannot be empty';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                _isLoading
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          CyberpunkColors.fluorescentCyan,
                        ),
                      )
                    : SizedBox(
                        width: screenWidth / 2.5,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                _isLoading = true;
                              });

                              String email = _sanitizeInput(_emailController.text)!;
                              String password = _sanitizeInput(_passwordController.text)!;
                              int code = await login(email, password);

                              setState(() {
                                _isLoading = false;
                              });

                              if (code == 200) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MainPage()),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      code == 500
                                          ? 'Server error, please try again later.'
                                          : 'Invalid email or password, please try again.',
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                CyberpunkColors.hollywoodCerise, // Button color
                          ),
                          child: const Text(
                            "Login",
                            style: TextStyle(
                              color: CyberpunkColors.fluorescentCyan,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                const SizedBox(height: 5),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const SignUp()),
                    );
                  },
                  child: const Text(
                    'Want to create an account? Sign-up',
                    style: TextStyle(
                      color: CyberpunkColors.fluorescentCyan,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
