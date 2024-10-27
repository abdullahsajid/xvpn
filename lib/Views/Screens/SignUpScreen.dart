import 'package:flutter/material.dart';
import 'package:xvpn/Views/Screens/LoginScreen.dart';
import 'package:xvpn/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xvpn/Views/Screens/HomeView.dart';

class SignUpScreen extends StatefulWidget{
  const SignUpScreen({super.key});

  @override
  _SignUp createState() => _SignUp();
}

class _SignUp extends State<SignUpScreen>{
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _reTypePasswordController = TextEditingController();
  bool _createObscurePassword = true;
  bool _RetypeObscurePassword = true;

  void signUp() async {
    try {
      final email = _emailController.text;
      final password = _passwordController.text;
      final reTypePassword = _reTypePasswordController.text;

      if(password != reTypePassword) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Passwords do not match'))
        );
        return;
      }

      if (_formKey.currentState!.validate()) {
        final res = await _authService.SignUp(email, password);

        if (res.status == 201 && res.data != null) {
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
                  SnackBar(content: Text('Error saving Signup data: $e'))
              );
            }
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Signup failed: Invalid response'))
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Signup error: $e'))
        );
      }
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
              key: _formKey,
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
                              'Sign Up!',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Sign up with one of Following Options',
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
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'Create Password*',
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
                                  validator: (value) {
                                    if(value == null || value!.isEmpty){
                                      return ('Please Enter Password');
                                    }
                                    return null;
                                  },
                                  obscureText: _createObscurePassword,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    hintText: 'Create your Password',
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
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _createObscurePassword ? Icons.visibility_off : Icons.visibility,
                                        color: Colors.white70,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _createObscurePassword = !_createObscurePassword;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'Retype Password*',
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
                                  controller: _reTypePasswordController,
                                  validator: (value) {
                                    if(value == null || value!.isEmpty){
                                      return ('Please Enter Password');
                                    }
                                    return null;
                                  },
                                  obscureText: _RetypeObscurePassword,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    hintText: 'Retype your Password',
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
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _RetypeObscurePassword ? Icons.visibility_off : Icons.visibility,
                                        color: Colors.white70,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _RetypeObscurePassword = !_RetypeObscurePassword;
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
                            signUp();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Sign Up',
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
                        'Already Have an Account? ',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const LoginScreen())
                          );
                        },
                        child: const Text(
                          'Sign In',
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
          )
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
        onPressed: () {},
        child: Image.asset(
          imagePath,
          height: 24,
        ),
      ),
    );
  }
}
