import 'package:app/Views/main_page.dart';
import 'package:app/Views/sign-in-up/sign_up.dart';
import 'package:app/components/secrue_fields.dart';
import 'package:app/components/text_input_field.dart';
import 'package:app/utils/colors.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
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

  // login function
  Future<void> login(String email, String password) async {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MainPage()));
    
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
              end: Alignment.bottomCenter),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Text(
                "Sign In",
                style: TextStyle(
                    color: CyberpunkColors.fluorescentCyan,
                    fontSize: 35,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
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
                  } else if (!_isPasswordStrong(sanitizedValue)) {
                    return 'Password must be at least 8 characters long';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                width: screenWidth / 2.5,
                child: ElevatedButton(
                  onPressed: (){
                    if(_formKey.currentState!.validate()){
                        String email = _sanitizeInput(_emailController.text)!;
                        String password = _sanitizeInput(_passwordController.text)!;
                        login(email, password);
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
              const SizedBox(
                height: 5,
              ),
              TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignUp()));
                  },
                  child: const Text(
                    'Want to create an account? Sign-up',
                    style: TextStyle(
                        color: CyberpunkColors.fluorescentCyan,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ))
            ]),
          ),
        ),
      ),
    );
  }
}
