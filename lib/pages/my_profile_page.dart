import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../theme.dart'; // Your AppColors

class ProfilePage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get the current signed-in user's UID
  String get userId => _auth.currentUser?.uid ?? '';

  // Fetch user data from Firestore
  Future<Map<String, dynamic>> _getUserProfileData() async {
    try {
      // Check if user is logged in
      if (userId.isEmpty) {
        throw 'User is not logged in';
      }

      // Print the userId for debugging purposes
      print('Fetching data for user: $userId');

      // Fetch user data from Firestore using the userId
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('students')
          .doc(userId) // Fetch data using current user's UID
          .get();

      // Check if the document exists
      if (!userDoc.exists) {
        print('User document does not exist in Firestore!');
        throw 'User data not found in Firestore';
      }

      // Print the fetched document for debugging purposes
      print('Fetched data: ${userDoc.data()}');

      return userDoc.data() as Map<String, dynamic>;
    } catch (error) {
      print(
        'Error fetching profile data: $error',
      ); // Print the error for debugging
      throw 'Error fetching profile data: $error';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.darkRed,
        title: Center(
          child: Text("My Profile", style: TextStyle(color: Colors.white)),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.report, color: Colors.white),
            onPressed: () {
              // Handle report action here
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FutureBuilder<Map<String, dynamic>>(
          future: _getUserProfileData(),
          builder: (context, snapshot) {
            // Handle the loading state
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            // Handle errors
            if (snapshot.hasError) {
              return Center(
                child: Text("Error loading profile: ${snapshot.error}"),
              );
            }

            // Handle no data found
            if (!snapshot.hasData) {
              return Center(child: Text("No profile data found"));
            }

            Map<String, dynamic> userData = snapshot.data!;

            // Check if the user has a profile image; use a default if not
            String profileImage =
                userData['profileImage'] ?? 'assets/bydef.jpeg'; // Local asset

            return ListView(
              children: <Widget>[
                // Profile Header Container
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.darkRed,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage(profileImage),
                      ),
                      SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userData['name'] ?? 'None',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          // Display studentId instead of Roll no
                          Text(
                            'Student ID: ${userData['studentId'] ?? 'None'}',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                // Profile Information Grid (2 fields per row)
                GridView.count(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 20.0,
                  mainAxisSpacing: 20.0,
                  childAspectRatio: 2,
                  children: [
                    ProfileInfo(
                      title: "Registration Number",
                      value: userData['registrationNumber'] ?? 'None',
                    ),
                    ProfileInfo(
                      title: "Academic Year",
                      value: userData['academicYear'] ?? 'None',
                    ),
                    ProfileInfo(
                      title: "Admission Class",
                      value: userData['class'] ?? 'None',
                    ),
                    ProfileInfo(
                      title: "Admission Number",
                      value: userData['admissionNumber'] ?? 'None',
                    ),
                    ProfileInfo(
                      title: "Date of Admission",
                      value: userData['dateOfAdmission'] ?? 'None',
                    ),
                    ProfileInfo(
                      title: "Date of Birth",
                      value: userData['dateOfBirth'] ?? 'None',
                    ),
                  ],
                ),
                // Profile Information Column (1 field per row)
                ProfileInfo(title: "Email", value: userData['email'] ?? 'None'),
                ProfileInfo(
                  title: "Father Name",
                  value: userData['fatherName'] ?? 'None',
                ),
                ProfileInfo(
                  title: "Mother Name",
                  value: userData['motherName'] ?? 'None',
                ),
                ProfileInfo(
                  title: "Phone Number",
                  value: userData['phone'] ?? 'None',
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class ProfileInfo extends StatelessWidget {
  final String title;
  final String value;

  ProfileInfo({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 5),
                Text(value, style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
          Icon(Icons.lock, color: Colors.grey, size: 14),
        ],
      ),
    );
  }
}
