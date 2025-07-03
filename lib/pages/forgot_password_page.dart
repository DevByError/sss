import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/pages/otp.dart';
import '../theme.dart'; // Import your theme file

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController emailController = TextEditingController();
  bool otpSent = false; // To track if OTP has been sent

  // Updated _sendOtp method with OTP message and email format validation
  Future<void> _sendOtp(BuildContext context) async {
    String email = emailController.text.trim();

    // Email format validation
    if (!RegExp(
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
    ).hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid email address')),
      );
      return;
    }

    try {
      // Firebase Auth - Send password reset email
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      print('OTP Sent');
      setState(() {
        otpSent = true; // Show the container after OTP is sent
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('OTP has been sent to your email.')),
      );
    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase exceptions
      String errorMessage = '';

      if (e.code == 'invalid-email') {
        errorMessage = 'The email address is badly formatted.';
      } else if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
      } else {
        errorMessage = 'An unknown error occurred.';
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage)));
      print("Error code: ${e.code}"); // Debug: Log error code
      print("Error message: ${e.message}"); // Debug: Log error message
    } catch (e) {
      // Catch any other errors
      print('Error sending OTP: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.highRed,
        title: Text('Reset Password', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Reset Your Password',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.highRed,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Enter your email address below, and we\'ll send you a one-time password (OTP) to reset your password.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 40),
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(color: AppColors.darkRed),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: Icon(Icons.email, color: AppColors.highRed),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _sendOtp(context), // Call updated method
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.highRed,
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                    ),
                    child: Text(
                      'Send OTP',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
          otpSent
              ? Center(
                  // Center the container on the screen
                  child: Container(
                    padding: EdgeInsets.all(
                      30,
                    ), // Increased padding for a larger container
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(
                        20,
                      ), // Rounded corners
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    width:
                        MediaQuery.of(context).size.width *
                        0.85, // Increased width
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Your OTP is on the way!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 30, // Large font size for the first line
                            fontWeight: FontWeight.bold,
                            color: AppColors.highRed,
                          ),
                        ),
                        SizedBox(height: 20),

                        Text(
                          'We’ve sent a one-time password (OTP) to your email.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey[800],
                          ),
                        ),
                        SizedBox(height: 20),

                        Text(
                          'Please check your inbox to proceed.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 20),

                        ElevatedButton(
                          onPressed: () {
                            // Navigate to OTPPage when Verify Now is pressed
                            setState(() {
                              otpSent =
                                  false; // Hide the container when "Verify Now" is pressed
                            });
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OTPPage(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.highRed,
                            minimumSize: Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 5,
                          ),
                          child: Text(
                            'Verify Now',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
