import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/pages/signin_page.dart';
import 'my_profile_page.dart'; // Import ProfilePage
import '../theme.dart'; // Your AppColors

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0; // Track the selected tab index
  String? profileImage; // Variable to store profile image URL

  // Fetch the user's profile picture URL (if available)
  Future<void> _fetchProfilePicture() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && user.photoURL != null) {
      setState(() {
        profileImage = user.photoURL;
      });
    } else {
      setState(() {
        profileImage = 'assets/bydef.jpeg'; // Default photo if none exists
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchProfilePicture(); // Fetch profile picture when the page is loaded
  }

  // Handle navigation between pages based on the selected index
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // The body of the home page changes based on the selected tab
  Widget _getBody() {
    switch (_selectedIndex) {
      case 0:
        return Center(child: Text("Home Screen"));
      case 1:
        return Center(child: Text("Profile Screen"));
      case 2:
        return Center(child: Text("Settings Screen"));
      case 3:
        return Center(child: Text("Notifications Screen"));
      default:
        return Center(child: Text("Home Screen"));
    }
  }

  // Method to handle logout
  void _logOut(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Log Out",
          style: TextStyle(color: AppColors.highRed), // Apply theme color
        ),
        content: Text(
          "Are you sure you want to log out?",
          style: TextStyle(color: AppColors.darkRed), // Apply theme color
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              "No",
              style: TextStyle(color: AppColors.highRed), // Apply theme color
            ),
            onPressed: () {
              Navigator.of(
                context,
              ).pop(); // Close the dialog without logging out
            },
          ),
          TextButton(
            child: Text(
              "Yes",
              style: TextStyle(color: AppColors.highRed), // Apply theme color
            ),
            onPressed: () async {
              await FirebaseAuth.instance.signOut(); // Log out the user
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => SignInPage(),
                ), // Navigate to SignInPage
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: AppColors.darkRed, // Set app bar color from AppColors
        title: Center(
          child: Text("Home Page", style: TextStyle(color: Colors.white)),
        ),
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer(); // Open the drawer
          },
        ),
        actions: [
          // Profile photo or default photo in the AppBar
          IconButton(
            icon: CircleAvatar(
              radius: 20,
              backgroundImage: profileImage != null
                  ? NetworkImage(
                      profileImage!,
                    ) // Display the user's photo if available
                  : AssetImage('assets/bydef.jpeg')
                        as ImageProvider, // Default image if no photo URL
              backgroundColor: Colors.transparent,
            ),
            onPressed: () {
              // Navigate to Profile Page when profile icon is pressed
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: Text(
                "Menu",
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
              decoration: BoxDecoration(color: AppColors.darkRed),
            ),
            // These are buttons without functionality
            TextButton(
              onPressed: () {},
              child: Text(
                "Option 1",
                style: TextStyle(color: AppColors.highRed),
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                "Option 2",
                style: TextStyle(color: AppColors.highRed),
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                "Option 3",
                style: TextStyle(color: AppColors.highRed),
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                "Option 4",
                style: TextStyle(color: AppColors.highRed),
              ),
            ),
            // Add Log Out option
            ListTile(
              leading: Icon(Icons.exit_to_app, color: AppColors.highRed),
              title: Text(
                "Log Out",
                style: TextStyle(color: AppColors.highRed),
              ),
              onTap: () {
                _logOut(context); // Show the logout confirmation dialog
              },
            ),
          ],
        ),
      ),
      body: _getBody(), // Display content based on selected tab
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.darkRed, // Use the darkRed theme color
        unselectedItemColor: AppColors.lightRed, // Color for unselected items
        selectedItemColor: AppColors.highRed, // Use highRed for selected items
        currentIndex: _selectedIndex, // Keep track of selected index
        onTap: _onItemTapped, // Call method to update the index
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
        ],
      ),
    );
  }
}
