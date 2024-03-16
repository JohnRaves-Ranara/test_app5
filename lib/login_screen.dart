import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:test_app5/tabs/LT_goal_screens/main_screen.dart';
import 'package:test_app5/tabs/LT_goal_tab.dart';
// import 'package:test_app5/tabs/ST_goal_screens/dashboard_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_app5/signup_screen.dart';
import 'Current_User.dart';
import 'main.dart';
import 'theme/app_colors.dart';
// import 'tabs/LT_goal_screens/main_screen.dart';

class login_screen extends StatefulWidget {
  const login_screen({super.key});

  @override
  State<login_screen> createState() => _login_screenState();
}

class _login_screenState extends State<login_screen> {
  bool isLoggingIn = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  Future logIn() async {
    setState(() {
      isLoggingIn = true;
    });
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      await auth.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());

      final uid = auth.currentUser!.uid;
      final Current_User loggedInUser = await getUserInfo(uid);
      emailController.clear();
      passwordController.clear();
      // Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) =>
      //             LT_goal_tab(
      //               loggedInUser: loggedInUser
      //               )));
    } on FirebaseAuthException catch (e) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return AlertDialog(
              actionsPadding: EdgeInsets.all(15),
              insetPadding: EdgeInsets.symmetric(horizontal: 10),
              actions: [
                Container(
                  height: 45,
                  width: MediaQuery.of(context).size.width / 3.5,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 5,
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25))),
                      child: Text(
                        "OK",
                        style: TextStyle(
                            fontFamily: 'LexendDeca-BOLD', fontSize: 14),
                      ),
                      onPressed: () => {Navigator.pop(context)}),
                ),
              ],
              title: Text(
                "ERROR",
                style: TextStyle(fontFamily: 'LexendDeca-Bold', fontSize: 16),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      e.message.toString(),
                      style: TextStyle(
                          fontFamily: 'LexendDeca-Regular', fontSize: 16),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            );
          });
    } finally {
      setState(() {
        isLoggingIn = false;
      });
    }
  }

  Future getUserInfo(String id) async {
    DocumentReference doc_snapshot =
        FirebaseFirestore.instance.collection('users').doc(id);
    DocumentSnapshot user_snapshot = await doc_snapshot.get();
    DocumentSnapshot pokemon_snapshot =
        await doc_snapshot.collection('pokemon').doc(id).get();
    String? username;
    String? email;
    String? password;
    String? pet_name;
    int? pokemon_food;

    if (user_snapshot.exists) {
      final user_data = user_snapshot.data()! as Map<String, dynamic>;
      username = user_data['username'];
      email = user_data['email'];
      password = user_data['password'];
      pet_name = user_data['pokemon_name']!;
    }

    if (pokemon_snapshot.exists) {
      final pokemon_data = pokemon_snapshot.data()! as Map<String, dynamic>;
      pokemon_food = pokemon_data['pokemon_food'];
    }
    return Current_User(
        userID: id,
        username: username!,
        email: email!,
        password: password!,
        pet_name: pet_name!);
  }

  var obscureText = true;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        alignment: Alignment.center,
                        child: Text(
                          "VisioLife",
                          style: TextStyle(
                              fontSize: 48, fontFamily: 'LexendDeca-Bold'),
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                        alignment: Alignment.center,
                        child: Text(
                          "From vision to reality.",
                          style: TextStyle(
                              fontSize: 14, fontFamily: 'LexendDeca-Regular'),
                        )),
                    SizedBox(
                      height: 55,
                    ),
                    TextField(
                      style: TextStyle(fontFamily: 'LexendDeca-Regular'),
                      controller: emailController,
                      decoration: InputDecoration(
                          labelStyle: TextStyle(color: Colors.grey[800],fontFamily: 'LexendDeca-Regular'),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColors().red)),
                          labelText: "E-mail"),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      style: TextStyle(fontFamily: 'LexendDeca-Regular'),
                      obscureText: obscureText,
                      controller: passwordController,
                      decoration: InputDecoration(
                          suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  obscureText = !obscureText;
                                });
                              },
                              child: obscureText
                                  ? Icon(
                                      Icons.visibility_off,
                                      color: Colors.grey,
                                      size: 25,
                                    )
                                  : Icon(
                                      Icons.visibility,
                                      color: Colors.grey,
                                      size: 25,
                                    )),
                          labelStyle: TextStyle(color: Colors.grey[800],fontFamily: 'LexendDeca-Regular'),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColors().red)),
                          labelText: "Password"),
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
                            onPressed: isLoggingIn ? null : logIn,
                            child: Text(
                              "LOGIN",
                              style: TextStyle(
                                  fontFamily: 'LexendDeca-SemiBold',
                                  fontSize: 16,
                                  color: Colors.white
                                  ),
                            ))),
                    SizedBox(
                      height: 20,
                    ),
                    RichText(
                        text: TextSpan(children: [
                      TextSpan(
                          text: 'Don\'t have an account? ',
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'LexendDeca-Regular')),
                      TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              passwordController.clear();
                              emailController.clear();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => signup_screen()));
                            },
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
      ),
    );
  }
}
