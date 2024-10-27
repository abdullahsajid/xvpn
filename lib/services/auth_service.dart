import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/services.dart';

class User{
  final int status;
  final String? data;

  User({required this.status,required this.data});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      status: json['status'] as int,
      data: json['data'] != null ? json['data'] as String : null,
    );
  }

  @override
  String toString() {
    return 'User(status: $status, data: $data)';
  }
}

class ApiResponse {
  final int status;
  // final UserData? data;
  final String? error;
  final String? data;

  ApiResponse({
    required this.status,
    this.data,
    this.error,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      status: json['status'] as int,
      data: json['data'] != null ? json['data']['token'] : null,
      error: json['error'] as String?,
    );
  }

  @override
  String toString() {
    return 'ApiResponse(status: $status, data: $data)';
  }
}


class AuthService{
  final String baseUrl = 'https://c16d-182-188-55-52.ngrok-free.app';
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<User> loginUser(String email,String password) async{
      final response = await http.post(
          Uri.parse('$baseUrl/login'),
          headers: {'Content-Type':'application/json'},
          body:jsonEncode({'email':email,'password':password})
      );
      print(response.body);
      Map<String,dynamic> data = jsonDecode(response.body);
      return User.fromJson(data);
  }

  Future<ApiResponse> SignUp(String email,String password) async{
    final response = await http.post(
      Uri.parse('$baseUrl/sign-up'),
      headers: {'Content-Type':'application/json'},
      body:jsonEncode({'email':email,'password':password})
    );
    print(response.body);
    Map<String,dynamic> data = jsonDecode(response.body);
    return ApiResponse.fromJson(data);
  }

  // Future<void> signWithGoggle() async{
  //   try{
  //       final googleUser = await GoogleSignIn().signIn();
  //       final googleAuth = await googleUser?.authentication;
  //       print("test ${googleUser?.email}");
  //       // final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
  //       // final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount!.authentication;
  //       // final Map<String, String> userData = {
  //       //   'email': googleSignInAccount.email,
  //       //   'displayName': googleSignInAccount.displayName ?? '',
  //       //   'id': googleSignInAccount.id,
  //       //   'photoUrl': googleSignInAccount.photoUrl ?? '',
  //       //   'idToken': googleSignInAuthentication.idToken ?? '', // JWT token
  //       //   'accessToken': googleSignInAuthentication.accessToken ?? '',
  //       // };
  //       //
  //       // print('Signed in successfully');
  //       // print('User data: $userData');
  //
  //   }catch(e){
  //     print('Error ${e.toString()}');
  //   }
  // }

  // Future<int>  logoutUser() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.remove('xvpn');
  //
  //   final response = await http.get(
  //     Uri.parse('$baseUrl/logout'),
  //     headers: {'Content-Type':'application/json'},
  //   );
  //   print(response.body);
  //   Map<String,dynamic> data = jsonDecode(response.body);
  //   return data['status'];
  //   final status = data['status'];
  //   if(status == 200){
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     await prefs.remove('xvpn');
  //   }
  // }
  Future<void> signWithGoogle() async {
    try {
      await _googleSignIn.signOut();

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        print('Sign in aborted by user');
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      print('Success! User email: ${googleUser.email}');
      print('Access Token: ${googleAuth.accessToken}');
      print('ID Token: ${googleAuth.idToken}');

    } on PlatformException catch (e) {
      print('Platform Exception: ${e.code} - ${e.message}');
      switch (e.code) {
        case 'sign_in_failed':
          print('Sign in failed. Please check your Google Cloud Console configuration.');
          break;
        case 'network_error':
          print('Network error occurred. Please check your internet connection.');
          break;
        default:
          print('Unknown error occurred: ${e.message}');
      }
    } catch (e) {
      print('Unexpected error: $e');
    }
  }
}
