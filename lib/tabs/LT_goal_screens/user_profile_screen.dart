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
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Text("Logged in User: ${widget.loggedInUser.username}"),)
        ],
      ),
    );
  }
}