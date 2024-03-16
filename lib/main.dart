import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app5/add_note_screen.dart';
// import 'package:test_app5/choosePet_screen.dart';
import 'package:test_app5/login_screen.dart';
import 'package:test_app5/onboardingScreen.dart';
import 'package:test_app5/tabs/LT_goal_tab.dart';
import 'package:test_app5/test.dart';
import 'package:test_app5/test_2.dart';

import 'Current_User.dart';
// import 'package:test_app5/test.dart';
// import 'tabs/LT_goal_screens/main_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final prefs = await SharedPreferences.getInstance();
  final showMainPage = prefs.getBool('showMainPage') ?? false;
  runApp(MyApp(showMainPage: showMainPage));
}
final navigatorKey = GlobalKey<NavigatorState>();
class MyApp extends StatelessWidget {
  final bool? showMainPage;
  const MyApp({
    Key? key,
    this.showMainPage
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: showMainPage! ? MainPage() : onBoardingScreen(),
      // home: test_2(),
    );
  }
}



class MainPage extends StatelessWidget {
  Current_User? curr_User;
  MainPage({this.curr_User});
  
  //retrieves the current user's information
  Future<Current_User> getUserInfo(String id) async {
    DocumentReference doc_snapshot =
        FirebaseFirestore.instance.collection('users').doc(id);
    DocumentSnapshot user_snapshot = await doc_snapshot.get();
    DocumentSnapshot pokemon_snapshot =
        await doc_snapshot.collection('pokemon').doc(id).get();
    String? username;
    String? email;
    String? password;
    String? pet_name;

    if (user_snapshot.exists) {
      final user_data = user_snapshot.data()! as Map<String, dynamic>;
      username = user_data['username'];
      email = user_data['email'];
      password = user_data['password'];
      pet_name = user_data['pokemon_name']!;

      print("${email} ${password}");
    }
    return Current_User(
        userID: id,
        username: username!,
        email: email!,
        password: password!,
        pet_name: pet_name!,);
  }

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
                      return LT_goal_tab(
                        loggedInUser: snapshot.data!,
                        current_user: curr_User,
                      );
                    } else {
                      return Center(child: Container(height: 90, child: Image.asset('assets/loading.gif'),));
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
