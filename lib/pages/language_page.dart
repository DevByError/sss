import 'package:flutter/material.dart';
import '../theme.dart';

class LanguagePage extends StatelessWidget {
  const LanguagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.highRed,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/lincoln_logo.png',
              width: 120,
            ), // Add your logo in assets
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(24),
              margin: EdgeInsets.symmetric(horizontal: 32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  Text(
                    "Choose Your Language",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkRed,
                    ),
                  ),
                  SizedBox(height: 20),
                  Wrap(
                    spacing: 16,
                    children: [
                      _buildLangButton(context, "🇺🇸 English", '/'),
                      _buildLangButton(context, "🇲🇾 Bahasa Melayu", '/'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLangButton(BuildContext context, String label, String route) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushNamed(context, route);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.darkRed,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: StadiumBorder(),
      ),
      child: Text(label, style: TextStyle(color: Colors.white)),
    );
  }
}
