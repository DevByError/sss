import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/reset_password.dart';

class OTPPage extends StatefulWidget {
  @override
  _OTPPageState createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  final TextEditingController otpController1 = TextEditingController();
  final TextEditingController otpController2 = TextEditingController();
  final TextEditingController otpController3 = TextEditingController();
  final TextEditingController otpController4 = TextEditingController();

  String verificationId = ''; // Store the verification ID

  Future<void> _sendOtp(String phoneNumber) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber, // Provide phone number here
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Automatically sign in if the OTP is verified
        await FirebaseAuth.instance.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        // Handle error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Verification failed: ${e.message}')),
        );
      },
      codeSent: (String verificationId, int? resendToken) {
        this.verificationId = verificationId;
        // OTP sent, you can notify user to enter OTP
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Handle auto retrieval timeout if needed
        this.verificationId = verificationId;
      },
    );
  }

  Future<void> _verifyOtp(BuildContext context) async {
    String otp =
        otpController1.text +
        otpController2.text +
        otpController3.text +
        otpController4.text;

    // Use the verification ID from codeSent to create a PhoneAuthCredential
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: otp,
    );

    try {
      // Sign in using the credential
      await FirebaseAuth.instance.signInWithCredential(credential);

      // If OTP is correct, navigate to the ResetPasswordPage
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ResetPasswordPage()),
      );
    } catch (e) {
      // OTP verification failed, show error
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Invalid OTP')));
    }
  }

  Widget _buildOtpBox(TextEditingController controller, FocusNode focusNode) {
    return Container(
      width: 50,
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.red),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        autofocus: true,
        keyboardType: TextInputType.number,
        maxLength: 1,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 24),
        focusNode: focusNode,
        decoration: InputDecoration(counterText: '', border: InputBorder.none),
        onChanged: (value) {
          if (value.isNotEmpty) {
            FocusScope.of(context).nextFocus();
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    FocusNode focusNode1 = FocusNode();
    FocusNode focusNode2 = FocusNode();
    FocusNode focusNode3 = FocusNode();
    FocusNode focusNode4 = FocusNode();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Verify OTP', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Your OTP is on the way!',
                style: TextStyle(fontSize: 24, color: Colors.red),
              ),
              SizedBox(height: 20),
              Text(
                'We\'ve sent a one-time password (OTP) to your phone.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildOtpBox(otpController1, focusNode1),
                  _buildOtpBox(otpController2, focusNode2),
                  _buildOtpBox(otpController3, focusNode3),
                  _buildOtpBox(otpController4, focusNode4),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _verifyOtp(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text('Next', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
