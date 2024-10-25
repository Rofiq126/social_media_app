//This page usage is for determined to show login or register page

import 'package:flutter/material.dart';
import 'package:social_media_app/features/auth/presentation/page/login_page.dart';
import 'package:social_media_app/features/auth/presentation/page/register_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  //initial will show login page
  bool showLoginPage = true;

  //toggle between pages
  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (showLoginPage) {
      case true:
        return LoginPage(
          onTap: () => togglePages(),
        );
      default:
        return RegisterPage(
          onTap: () => togglePages(),
        );
    }
  }
}
