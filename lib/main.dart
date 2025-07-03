import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/pages/forgot_password_page.dart';
import 'package:flutter_application_1/pages/signup_page.dart';
import 'pages/signin_page.dart'; // SignInPage import
import 'pages/home_page.dart'; // HomePage import
import 'pages/splashScreen.dart'; // SplashScreen import

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Required to use Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Auth',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.red,
        scaffoldBackgroundColor: Colors.white,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      home:
          _getInitialPage(), // Set initial page to SignInPage or HomePage based on auth status
      routes: {
        '/signup': (context) => SignUpPage(),
        '/forgot-password': (context) => ForgotPasswordPage(),
        '/signin': (context) => SignInPage(), // Add SignInPage route
      },
    );
  }

  // This method checks if the user is logged in and directs them accordingly
  Widget _getInitialPage() {
    // Check if the user is already signed in
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // If the user is logged in, navigate to SplashScreen
      return SplashScreen();
    } else {
      // If the user is not logged in, show the SignInPage
      return SignInPage();
    }
  }
}
