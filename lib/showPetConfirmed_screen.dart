import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test_app5/main.dart';
import 'package:test_app5/tabs/LT_goal_tab.dart';
import 'Current_User.dart';

class showPetConfirmed_screen extends StatefulWidget {
  Current_User loggedInUser;
  String pokemon_name;
  showPetConfirmed_screen(
      {required this.loggedInUser, required this.pokemon_name});

  @override
  State<showPetConfirmed_screen> createState() =>
      _showPetConfirmed_screenState();
}

class _showPetConfirmed_screenState extends State<showPetConfirmed_screen> {

  Future logIn() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: widget.loggedInUser.email,
        password: widget.loggedInUser.password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "You have chosen",
                  style:
                      TextStyle(fontFamily: 'LexendDeca-Regular', fontSize: 22),
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  widget.pokemon_name,
                  style: TextStyle(fontFamily: 'LexendDeca-Bold', fontSize: 22),
                ),
              ],
            ),
            SizedBox(
              height: 40,
            ),
            Text(
              "His growth depends on your success.",
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'LexendDeca-Regular', fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              "Go make him big and strong!",
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'LexendDeca-Regular', fontSize: 18),
            ),
            SizedBox(
              height: 50,
            ),
            Container(
                // color: Colors.orange[100],
                height: MediaQuery.of(context).size.height * 0.2,
                width: MediaQuery.of(context).size.height * 0.2,
                child: Image.asset(
                  'assets/${widget.pokemon_name}lvl1.gif',
                  fit: BoxFit.contain,
                )),
            SizedBox(
              height: 50,
            ),
            Text(
              "Welcome to VisioLife",
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'LexendDeca-Bold', fontSize: 18),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Where your goals are brought to life.",
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'LexendDeca-Regular', fontSize: 18),
            ),
            SizedBox(
              height: 50,
            ),
            Container(
              height: 45,
              width: MediaQuery.of(context).size.width * 0.4,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 5,
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25))),
                  child: Text(
                    "Proceed",
                    style: TextStyle(
                        fontFamily: 'LexendDeca-Bold',
                        fontSize: 18,
                        color: Colors.white),
                  ),
                  onPressed: ()async{
                    await logIn();
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MainPage()));
                  }),
            ),
            SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}