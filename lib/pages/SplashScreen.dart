import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home_page.dart'; // Import your HomePage

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String username = '';
  String profileImageUrl = ''; // Default to empty string if no image

  @override
  void initState() {
    super.initState();
    _getStudentData(); // Fetch user data as soon as the screen starts
  }

  // Fetch student data from Firestore
  Future<void> _getStudentData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Fetch student data using the user UID from Firestore
        DocumentSnapshot snapshot = await FirebaseFirestore.instance
            .collection('students')
            .doc(user.uid) // Use UID to get student data
            .get();

        if (snapshot.exists) {
          // Access the snapshot data properly
          var data = snapshot.data() as Map<String, dynamic>?;

          setState(() {
            // Use null-aware operators to handle potential null fields
            username =
                data?['name'] ?? 'No Name Available'; // Default name if missing
            profileImageUrl =
                data?['profileImage'] ?? ''; // Fallback if no profileImage
          });
        } else {
          print("No data available for user.");
        }
      }

      // After a delay of 3 seconds, navigate to the HomePage
      Future.delayed(Duration(seconds: 3), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ), // Navigate to HomePage
        );
      });
    } catch (e) {
      print("Error fetching student data: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red, // Background color to match your design
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/luc_logo.png', // Your logo image
              height: 100,
            ),
            SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              backgroundImage: profileImageUrl.isEmpty
                  ? AssetImage('assets/profile.jpeg') // Default profile image
                  : NetworkImage(profileImageUrl),
            ),
            SizedBox(height: 20),
            Text(
              'Welcome, $username',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
