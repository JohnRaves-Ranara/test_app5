import 'package:flutter/material.dart';
import 'package:test_app5/Current_User.dart';

class user_profile_screen extends StatefulWidget {
  final Current_User loggedInUser;

  user_profile_screen({required this.loggedInUser});

  @override
  State<user_profile_screen> createState() => _user_profile_screenState();
}

class _user_profile_screenState extends State<user_profile_screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Username: ${widget.loggedInUser.username}"),
          Text("Email: ${widget.loggedInUser.email}"),
        ],
      ),
    );
  }
}
