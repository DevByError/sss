// lib/util/image_util.dart

import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<void> uploadProfileImage(BuildContext context) async {
  // Pick the image from the gallery
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);

  if (pickedFile != null) {
    // Create a File object from the picked image
    File imageFile = File(pickedFile.path);

    try {
      // Get the current user's UID
      String userId = FirebaseAuth.instance.currentUser!.uid;

      // Create a reference to Firebase Storage
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference storageRef = storage.ref().child('profile_images/$userId.jpg');

      // Upload the image to Firebase Storage
      UploadTask uploadTask = storageRef.putFile(imageFile);

      // Wait for the upload to complete
      TaskSnapshot snapshot = await uploadTask.whenComplete(() {});

      // Get the download URL of the uploaded image
      String imageUrl = await snapshot.ref.getDownloadURL();

      // Save the image URL in Firestore
      await FirebaseFirestore.instance
          .collection('students')
          .doc(userId)
          .update({'profileImage': imageUrl});

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Profile image updated successfully")),
      );
    } catch (e) {
      print("Error uploading image: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error uploading image")));
    }
  } else {
    print("No image selected");
  }
}
