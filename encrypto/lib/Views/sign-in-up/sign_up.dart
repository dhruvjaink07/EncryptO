import 'package:app/Views/sign-in-up/sign_in.dart';
import 'package:app/components/secrue_fields.dart';
import 'package:app/components/text_input_field.dart';
import 'package:app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String? _sanitizeInput(String input) {
    return input.trim(); // Trims leading and trailing whitespace
  }

  bool _isPasswordStrong(String password) {
    // Password validation: at least 8 characters, contains uppercase, lowercase, number, and special character
    final RegExp passwordRegex = RegExp(
      r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#\$&*~])[A-Za-z\d!@#\$&*~]{8,}$',
    );
    return passwordRegex.hasMatch(password);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        height: screenHeight,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              CyberpunkColors.zaffre,
              CyberpunkColors.oxfordBlue
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter
          ),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Text(
                  "Sign Up",
                  style: TextStyle(
                    color: CyberpunkColors.fluorescentCyan,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: screenWidth / 7),
                  child: const Text(
                    'Create your account to get started! Join us and explore the possibilities.',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      SecureField(
                        publicKeyController: _usernameController,
                        labelText: 'Username',
                        prefixIcon: Icons.person,
                        isPassword: false,
                        validator: (value) {
                          String sanitizedValue = _sanitizeInput(value ?? '')!;
                          if (sanitizedValue.isEmpty) {
                            return 'Username cannot be empty';
                          }
                          return null;
                        },
                      ),
                      SecureField(
                        publicKeyController: _nameController,
                        labelText: 'Name',
                        prefixIcon: Icons.person_add,
                        isPassword: false,
                        validator: (value) {
                          String sanitizedValue = _sanitizeInput(value ?? '')!;
                          if (sanitizedValue.isEmpty) {
                            return 'Name cannot be empty';
                          }
                          return null;
                        },
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
                          } else if (!_isPasswordStrong(sanitizedValue)) {
                            return 'Password must be at least 8 characters long';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
                SizedBox(
                  width: screenWidth / 2.5,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Perform sign-up action after all validations pass
                        String username = _sanitizeInput(_usernameController.text)!;
                        String name = _sanitizeInput(_nameController.text)!;
                        String email = _sanitizeInput(_emailController.text)!;
                        String password = _sanitizeInput(_passwordController.text)!;

                        // Proceed with sign-up logic (e.g., API call)
                        print('Sign-up details: Username: $username, Name: $name, Email: $email');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CyberpunkColors.hollywoodCerise,
                      elevation: 8, // Shadow effect
                    ),
                    child: const Text(
                      "Sign Up",
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
                      MaterialPageRoute(
                        builder: (context) => const SignIn(),
                      ),
                    );
                  },
                  child: const Text(
                    'Already have an account? Sign-in',
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
