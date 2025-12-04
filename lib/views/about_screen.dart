import 'package:flutter/material.dart';
import 'package:sandwich_shop/views/app_styles.dart';
import 'package:sandwich_shop/views/app_shell.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShell(
      title: const Text('About Us', style: heading1),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Welcome to Sandwich Shop!', style: heading2),
            SizedBox(height: 20),
            Text(
              'We are a family-owned business dedicated to serving the best sandwiches in town. ',
              style: normalText,
            ),
          ],
        ),
      ),
    );
  }
}
