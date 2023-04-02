import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test_app5/showPetConfirmed_screen.dart';
import 'Current_User.dart';
import 'tabs/LT_goal_tab.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class choosePet_Screen extends StatefulWidget {
  Current_User loggedInUser;
  choosePet_Screen({required this.loggedInUser});

  @override
  State<choosePet_Screen> createState() => _choosePet_ScreenState();
}

class _choosePet_ScreenState extends State<choosePet_Screen> {
  int? chosenValue;
  String? pokemon_name;
  showConfirmPet(BuildContext context) async {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Confirm Pet?",
              style: TextStyle(fontFamily: 'LexendDeca-Bold', fontSize: 16),
            ),
            actions: [
              Container(
                height: 45,
                width: MediaQuery.of(context).size.width / 3.5,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 5,
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25))),
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'LexendDeca-Regular',
                          fontSize: 12),
                    ),
                    onPressed: () => {Navigator.pop(context)}),
              ),
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
                      "Confirm",
                      style: TextStyle(
                          fontFamily: 'LexendDeca-Regular',
                          fontSize: 12,
                          color: Colors.white),
                    ),
                    onPressed: () async {
                      showDialog(
                        barrierDismissible: false,
                          context: context,
                          builder: (context) => Center(
                                child: CircularProgressIndicator(),
                              ));
                      if (chosenValue == 1) {
                        setState(() {
                          pokemon_name = "torchic";
                        });
                      } else if (chosenValue == 2) {
                        setState(() {
                          pokemon_name = "gengar";
                        });
                      } else if (chosenValue == 3) {
                        setState(() {
                          pokemon_name = "squirtle";
                        });
                      } else if (chosenValue == 4) {
                        setState(() {
                          pokemon_name = "abra";
                        });
                      } else if (chosenValue == 5) {
                        setState(() {
                          pokemon_name = "charmeleon";
                        });
                      } else {
                        setState(() {
                          pokemon_name = "rookidee";
                        });
                      }
                      print(pokemon_name);
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(widget.loggedInUser.userID)
                          .update({"pokemon_name": pokemon_name});
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => showPetConfirmed_screen(
                                  loggedInUser: widget.loggedInUser,
                                  pokemon_name: pokemon_name!)),
                          (route) => false);
                    }),
              ),
            ],
            content: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Are you sure you want to choose this pet?",
                    style: TextStyle(
                        fontFamily: 'LexendDeca-Regular',
                        fontSize: 14,
                        color: Colors.black),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.15,
          ),
          Text(
            "Select a Pokeball",
            style: TextStyle(fontFamily: 'LexendDeca-Bold', fontSize: 22),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.5,
            child: Column(
              children: [
                Expanded(
                  child: GridView.count(
                    padding: EdgeInsets.all(20),
                    crossAxisCount: 3,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            chosenValue = 1;
                            print(chosenValue);
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(
                                  color: (chosenValue == 1)
                                      ? Colors.blue
                                      : Colors.transparent,
                                  width: 2)),
                          height: 50,
                          width: 100,
                          child: Image.asset('assets/pokeball_new_final.gif'),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            chosenValue = 2;
                            print(chosenValue);
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(
                                  color: (chosenValue == 2)
                                      ? Colors.blue
                                      : Colors.transparent,
                                  width: 2)),
                          height: 50,
                          width: 100,
                          child: Image.asset('assets/pokeball_new_final.gif'),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            chosenValue = 3;
                            print(chosenValue);
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(
                                  color: (chosenValue == 3)
                                      ? Colors.blue
                                      : Colors.transparent,
                                  width: 2)),
                          height: 50,
                          width: 100,
                          child: Image.asset('assets/pokeball_new_final.gif'),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            chosenValue = 4;
                            print(chosenValue);
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(
                                  color: (chosenValue == 4)
                                      ? Colors.blue
                                      : Colors.transparent,
                                  width: 2)),
                          height: 50,
                          width: 100,
                          child: Image.asset('assets/pokeball_new_final.gif'),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            chosenValue = 5;
                            print(chosenValue);
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(
                                  color: (chosenValue == 5)
                                      ? Colors.blue
                                      : Colors.transparent,
                                  width: 2)),
                          height: 50,
                          width: 100,
                          child: Image.asset('assets/pokeball_new_final.gif'),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            chosenValue = 6;
                            print(chosenValue);
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(
                                  color: (chosenValue == 6)
                                      ? Colors.blue
                                      : Colors.transparent,
                                  width: 2)),
                          height: 50,
                          width: 100,
                          child: Image.asset('assets/pokeball_new_final.gif'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 50,
            width: 145,
            child: OutlinedButton(
              onPressed: () async {
                showConfirmPet(context);
              },
              child: Text(
                "Confirm",
                style: TextStyle(
                    fontFamily: 'LexendDeca-Bold',
                    fontSize: 20,
                    color: Colors.black87),
              ),
              style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                  backgroundColor: Colors.white,
                  elevation: 5),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
          )
        ],
      ),
    );
  }
}
