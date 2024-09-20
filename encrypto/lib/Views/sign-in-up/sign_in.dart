import 'package:app/Views/main_page.dart';
import 'package:app/Views/sign-in-up/sign_up.dart';
import 'package:app/components/secrue_fields.dart';
import 'package:app/components/text_input_field.dart';
import 'package:app/utils/colors.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // login function
  Future<void> login() async{
    if(_emailController.text.isEmpty && _passwordController.text.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Email and password are required!',style: TextStyle(color: Colors.white),),backgroundColor: Colors.red,));
    }else{
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MainPage()));
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
              end: Alignment.bottomCenter),
        ),
        child: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
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
            ),
            const SizedBox(height: 10),
            SecureField(
              publicKeyController: _passwordController,
              labelText: 'Password',
              prefixIcon: Icons.lock,
              isPassword: true,
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: screenWidth / 2.5,
              child: ElevatedButton(
                onPressed: login,
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
            const SizedBox(height: 5,),
              TextButton(onPressed: (){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const SignUp()));
              }, child:const  Text('Want to create an account? Sign-up',style: TextStyle(color: CyberpunkColors.fluorescentCyan,fontSize: 16,fontWeight: FontWeight.bold),))

          ]),
        ),
      ),
    );
  }
}
