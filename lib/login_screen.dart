import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:test_app5/tabs/LT_goal_screens/main_screen.dart';
import 'package:test_app5/tabs/LT_goal_tab.dart';
// import 'package:test_app5/tabs/ST_goal_screens/dashboard_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_app5/signup_screen.dart';
import 'Current_User.dart';
import 'theme/app_colors.dart';
// import 'tabs/LT_goal_screens/main_screen.dart';

class login_screen extends StatefulWidget {
  const login_screen({super.key});

  @override
  State<login_screen> createState() => _login_screenState();
}

class _login_screenState extends State<login_screen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String? username;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  Future logIn() async {
    final FirebaseAuth auth = FirebaseAuth.instance;

    await auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim());

    final uid = auth.currentUser!.uid;
    final Current_User loggedInUser = await getUserInfo(uid);
    emailController.clear();
    passwordController.clear();
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                LT_goal_tab(loggedInUser: loggedInUser)));
  }

  Future getUserInfo(String id) async {
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection('users').doc(id).get();

    if (snapshot.exists) {
      final data = snapshot.data()! as Map<String, dynamic>;
      String username = data['username'];
      String email = data['email'];
      String password = data['password'];
      return Current_User(
          userID: id, username: username, email: email, password: password);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                  alignment: Alignment.center,
                  child: Text(
                    "VisioLife",
                    style:
                        TextStyle(fontSize: 48, fontFamily: 'LexendDeca-Bold'),
                  )),
              SizedBox(
                height: 55,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  style: TextStyle(fontFamily: 'LexendDeca-Regular'),
                  controller: emailController,
                  decoration: InputDecoration(
                    labelStyle: TextStyle(color: Colors.grey[800]),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors().red)),
                      labelText: "E-mail"),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  style: TextStyle(fontFamily: 'LexendDeca-Regular'),
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelStyle: TextStyle(color: Colors.grey[800]),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors().red)),
                      labelText: "Password"),
                      
                ),
              ),
              SizedBox(height: 50),
              Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 60,
                  ),
                  width: MediaQuery.of(context).size.width,
                  height: 40,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          backgroundColor: AppColors().red),
                      onPressed: logIn,
                      child: Text(
                        "LOGIN",
                        style: TextStyle(
                            fontFamily: 'LexendDeca-SemiBold', fontSize: 16),
                      ))),
              SizedBox(
                height: 20,
              ),
              RichText(
                  text: TextSpan(children: [
                TextSpan(
                    text: 'Don\'t have an account? ',
                    style: TextStyle(
                        color: Colors.black, fontFamily: 'LexendDeca-Regular')),
                TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => signup_screen())),
                    text: 'Sign Up here!',
                    style: TextStyle(
                        fontFamily: 'LexendDeca-Regular',
                        decoration: TextDecoration.underline,
                        color: AppColors().red))
              ]))
            ]),
          ),
        ),
      ),
    );
  }
}
