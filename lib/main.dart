import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:test_app5/add_note_screen.dart';
// import 'package:test_app5/choosePet_screen.dart';
import 'package:test_app5/login_screen.dart';
import 'package:test_app5/tabs/LT_goal_tab.dart';

import 'Current_User.dart';
// import 'package:test_app5/test.dart';
// import 'tabs/LT_goal_screens/main_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  Future<Current_User> getUserInfo(String id) async {
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection('users').doc(id).get();
    String? username;
    String? email;
    String? password;
    String? pet_name;
    if (snapshot.exists) {
      final data = snapshot.data()! as Map<String, dynamic>;
      username = data['username'];
      email = data['email'];
      password = data['password'];
      pet_name = data['pokemon_name']!;
    }
    return Current_User(
        userID: id,
        username: username!,
        email: email!,
        password: password!,
        pet_name: pet_name!);
  }

  const MainPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // User is authenticated, get user info and pass it to LT_goal_tab
                return FutureBuilder<Current_User>(
                  future: getUserInfo(snapshot.data!.uid),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return LT_goal_tab(loggedInUser: snapshot.data!);
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                );
              } else {
                // User is not authenticated, show login screen
                return login_screen();
              }
            }));
  }
}
