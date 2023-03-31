import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_app5/choosePet_screen.dart';
// import 'package:test_app5/tabs/LT_goal_tab.dart';
import 'Current_User.dart';
import 'theme/app_colors.dart';

import 'login_screen.dart';

class signup_screen extends StatefulWidget {
  const signup_screen({super.key});

  @override
  State<signup_screen> createState() => _signup_screenState();
}

class _signup_screenState extends State<signup_screen> {
  bool isSigningIn = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
  
 Future getUserInfo(String id) async {
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection('users').doc(id).get();

    if (snapshot.exists) {
      final data = snapshot.data()! as Map<String, dynamic>;
      String username = data['username'];
      String email = data['email'];
      String password = data['password'];
      String pet_name = data['pokemon_name'];

      return Current_User(
          userID: id, username: username, email: email, password: password, pet_name: pet_name);
    }
  }
  
  Future signUp() async {
    setState(() {
      isSigningIn = true;
    });
    try{
      final FirebaseAuth auth = FirebaseAuth.instance;
    await auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim());

    final uid = auth.currentUser!.uid;

    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'email': emailController.text.trim(),
      'password': passwordController.text.trim(),
      'username': usernameController.text.trim(),
      'userID': uid,
      'pokemon_name' : ""
    });

    await FirebaseFirestore.instance.collection('users')
    .doc(uid)
    .collection('pokemon')
    .doc(uid)
    .set({
      "userID" : uid,
      "pokemon_exp" : 0,
      "pokemon_food" : 0,
      "pokemon_level" : 1,
    });

    final Current_User loggedInUser = await getUserInfo(uid);

    emailController.clear();
    passwordController.clear();
    usernameController.clear();
    Navigator.push(context, MaterialPageRoute(builder: (context)=> choosePet_Screen(loggedInUser: loggedInUser)));
    } on FirebaseAuthException catch (e){
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
            title: Text("ERROR", style: TextStyle(fontFamily: 'LexendDeca-Bold', fontSize: 16),),
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
    }finally{
      setState(() {
      isSigningIn = false;
    });
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
                  child: Text(
                "Sign Up",
                style: TextStyle(fontSize: 48, fontFamily: 'LexendDeca-Bold'),
              )),
              SizedBox(
                height: 55,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  style: TextStyle(fontFamily: 'LexendDeca-Regular'),
                  controller: usernameController,
                  decoration: InputDecoration(
                    labelStyle: TextStyle(color: Colors.grey[800]),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors().red)), labelText: "Username"),
                ),
              ),
              SizedBox(
                height: 15,
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
                height: 15,
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
              SizedBox(
                height: 50,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 60),
                width: MediaQuery.of(context).size.width,
                height: 40,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                            backgroundColor: AppColors().red),
                    onPressed:isSigningIn ? null : signUp,
                    child: Text(
                      "SIGNUP",
                      style: TextStyle(
                          fontFamily: 'LexendDeca-SemiBold', fontSize: 16),
                    )),
              ),
              SizedBox(
                height: 20,
              ),
              RichText(
                  text: TextSpan(children: [
                TextSpan(
                    text: 'Already have an account? ',
                    style: TextStyle(
                        color: Colors.black, fontFamily: 'LexendDeca-Regular')),
                TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => Navigator.pop(context),
                    text: 'Login Here!',
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
