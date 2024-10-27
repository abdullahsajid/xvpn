import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:xvpn/Views/Screens/HomeView.dart';
import 'package:xvpn/Views/Screens/ResetPassword.dart';
import 'package:xvpn/Views/Screens/SignUpScreen.dart';
import 'package:xvpn/main.dart';
import 'package:xvpn/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget{
  const LoginScreen({super.key});

  @override
  _Login createState() => _Login();
}

class _Login extends State<LoginScreen>{
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  GoogleSignIn signin = GoogleSignIn();

  void signIn() async {
    try {
      final email = _emailController.text;
      final password = _passwordController.text;

      if (_formKey.currentState!.validate()) {
        final res = await _authService.loginUser(email, password);

        if (res.status == 200 && res.data != null) {
          try {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString('xvpn', res.data!);

            if (mounted) {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomeView())
              );
            }
          } catch (e) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error saving login data: $e'))
              );
            }
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Login failed: Invalid response'))
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Login error: $e'))
        );
      }
    }
  }

  Future<void> googleSignin() async{
    try{
      var user = await signin.signIn();
      var cred = user?.authentication;
      print(user);
      print(cred);
    }catch(e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
        body: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Color(0xFF181E31),
          ),
          child: SafeArea(
            child:Form(
              key:_formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      const SizedBox(height: 40),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Welcome Back!',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.start,
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Enjoy the fast vpn in world',
                                style: TextStyle(
                                  color: Color(0xFF2A324B),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Email*',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.start,
                              ),
                              const SizedBox(height: 8),
                              Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2A324B),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: TextFormField(
                                  controller: _emailController,
                                  validator: (value) {
                                      if(value == null || value!.isEmpty){
                                        return ("please enter validate email!");
                                      }
                                      return null;
                                  },
                                  style: const TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    hintText: 'Enter your Email',
                                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                                    errorStyle: const TextStyle(
                                      color: Colors.redAccent,
                                      fontSize: 12,
                                      height: 0.1,
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(100),
                                      borderSide: const BorderSide(color: Colors.redAccent, width: 1),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(100),
                                      borderSide: const BorderSide(color: Colors.redAccent, width: 1),
                                    ),  // Reduces overall field height
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'Password*',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2A324B),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: TextFormField(
                                  controller: _passwordController,
                                  obscureText: _obscurePassword,
                                  validator: (value) {
                                      if(value == null || value!.isEmpty){
                                        return ('Please Enter Password');
                                      }
                                      return null;
                                  },
                                  style: const TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    hintText: 'Enter your Password',
                                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                    errorStyle: const TextStyle(
                                      color: Colors.redAccent,
                                      fontSize: 12,
                                      height: 0.1,
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(100),
                                      borderSide: const BorderSide(color: Colors.redAccent, width: 1),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(100),
                                      borderSide: const BorderSide(color: Colors.redAccent, width: 1),
                                    ),// Reduces overall field height
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                        color: Colors.white70,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _obscurePassword = !_obscurePassword;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              //end
                            ],
                          ),
                        )
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: ShaderMask(
                            shaderCallback: (Rect bounds) {
                              return const LinearGradient(
                                colors: <Color>[
                                  Color(0xFF691CEF),
                                  Color(0xFF1B6BF2),
                                ],
                              ).createShader(bounds);
                            },
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const ResetPassword())
                                );
                              },
                              child: const Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding:const EdgeInsets.symmetric(horizontal: 15),
                        child: Container(
                          width: double.infinity,
                          height: 56,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [Color(0xFF691CEF), Color(0xFF1B6BF2)],
                            ),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              // signIn();
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => HomeView())
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Sign In',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xffffffff)
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: Text(
                          'Or continue with',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _socialLoginButton('assets/images/google.png'),
                          _socialLoginButton('assets/images/google.png'),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),

                  Center(
                    child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Dont have an account? ',
                        style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SignUpScreen())
                        );
                      },
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                        color: Color(0xFF691CEF),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ],
                ),
              ),

                ],
              ),
            ),
          ),
        ),
      );
  }
  Widget _socialLoginButton(String imagePath) {
    return Container(
      width: 150,
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xFF2A324B),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextButton(
        onPressed: () async {
          await googleSignin();
        },
        child: Image.asset(
          imagePath,
          height: 24,
        ),
      ),
    );
  }
}
