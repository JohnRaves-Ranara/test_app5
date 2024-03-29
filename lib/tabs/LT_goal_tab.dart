import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_app5/Current_User.dart';
import 'package:test_app5/add_LTgoal_screen.dart';
import 'package:test_app5/tabs/LT_goal_screens/completed_LT_goals.dart';
import '../theme/app_colors.dart';
import 'LT_goal_screens/LT_goals_screen.dart';
import 'LT_goal_screens/pet_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LT_goal_tab extends StatefulWidget {
  final Current_User loggedInUser;
  final Current_User? current_user;
  LT_goal_tab({required this.loggedInUser, this.current_user});

  @override
  State<LT_goal_tab> createState() => _LT_goal_tabState();
}

class _LT_goal_tabState extends State<LT_goal_tab> {
  int? groupvalue = 1;
  TextEditingController LT_goal_name_controller = TextEditingController();
  TextEditingController LT_goal_desc_controller = TextEditingController();

  addLTGoal() async {
    final DocumentReference doc = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.loggedInUser.userID)
        .collection('longterm_goals')
        .doc();

    print("start add");
    await doc.set({
      'LT_goal_ID': doc.id,
      'LT_goal_name': LT_goal_name_controller.text.trim(),
      'LT_goal_desc': LT_goal_desc_controller.text.trim()
    });

    print("finish add");
  }

  Stream getPokemonFood() {
    // var snapshot = await FirebaseFirestore.instance
    //     .collection('users')
    //     .doc(widget.loggedInUser.userID)
    //     .collection('pokemon')
    //     .doc(widget.loggedInUser.userID)
    //     .get();
    // int? food;
    // if (snapshot.exists) {
    //   print("GA EXIST ANG SNAPSHOT");
    //   food = snapshot.get('pokemon_food');
    // }
    // return food!;
    final DocumentReference docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.loggedInUser.userID)
        .collection('pokemon')
        .doc(widget.loggedInUser.userID);

    final Stream<DocumentSnapshot> docStream = docRef.snapshots();
    return docStream;
  }

  showAddLTGoalDialiog(BuildContext context) {
    return showDialog(
        context: context,
        builder: ((context) {
          return AlertDialog(
            actions: [
              Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(25)),
                height: 20,
                width: 100,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                        fontFamily: 'LexendDeca-Regular', fontSize: 14),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                ),
              ),
              Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(25)),
                height: 20,
                width: 100,
                child: ElevatedButton(
                  onPressed: () {
                    addLTGoal();
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Add Long-Term Goal",
                    style: TextStyle(
                        fontFamily: 'LexendDeca-Regular', fontSize: 14),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                ),
              ),
            ],
            title: Text(
              'Add Long-Term Goal',
              style: TextStyle(fontFamily: 'LexendDeca-Bold', fontSize: 22),
            ),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextField(
                      style: TextStyle(
                          fontFamily: 'LexendDeca-Regular', fontSize: 14),
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15)),
                          hintText: "Long-Term Goal Name"),
                      controller: LT_goal_name_controller,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextField(
                      maxLines: 15,
                      style: TextStyle(
                          fontFamily: 'LexendDeca-Regular', fontSize: 14),
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15)),
                          hintText: "Description"),
                      controller: LT_goal_desc_controller,
                    ),
                  ),
                ],
              ),
            ),
          );
        }));
  }

  Future<bool?> showExitWarning(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        actionsPadding: EdgeInsets.all(15),
        title: Text(
          "Confirm Exit?",
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
                onPressed: () => Navigator.of(context).pop(false)),
          ),
          Container(
            height: 45,
            width: MediaQuery.of(context).size.width / 3.5,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  elevation: 5,
                  backgroundColor: AppColors().red,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25))),
              child: Text(
                "Confirm",
                style:
                    TextStyle(fontFamily: 'LexendDeca-Regular', fontSize: 12),
              ),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          )
        ],
        content: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                "Are you sure you want to exit?",
                style:
                    TextStyle(fontFamily: 'LexendDeca-Regular', fontSize: 14),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          final shouldExit = await showExitWarning(context);
          return shouldExit ?? false;
        },
        child: Scaffold(
          drawer: Drawer(
            child: ListView(
              children: [
                ListTile(
                  title: Text(
                    "Sign Out",
                    style: TextStyle(
                        fontFamily: 'LexendDeca-Regular', fontSize: 13),
                  ),
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                  },
                )
              ],
            ),
          ),
          appBar: AppBar(
            
            leading: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Center(
                child: Builder(
                  builder: (BuildContext context) {
                    return Container(
                      // color: Colors.orange[100],
                      child: IconButton(
                        iconSize: 300,
                        icon: Row(
                          children: [
                            Text('VisioLife',
                                overflow: TextOverflow.fade,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'LexendDeca-Bold',
                                    fontSize: 16)),
                            SizedBox(width: 10,),
                            Icon(Icons.info, size: 20,),
                          ],
                        ),
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                        tooltip: "Open Drawer",
                      ),
                    );
                  },
                ),
              ),
            ),
            leadingWidth: MediaQuery.of(context).size.width*0.45,
            toolbarHeight: 80,
            actions: [
              (groupvalue == 1)
                  ? Container(
                    margin: EdgeInsets.only(right: 20),
                    // color: Colors.orange[100],
                    width: MediaQuery.of(context).size.width * 0.35,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          elevation: 5,
                          side:
                              BorderSide(width: 0.5, color: Colors.black87),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15))),
                      onPressed: () => {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => add_LTGoal_screen(
                                    loggedInUser: widget.loggedInUser)))
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "ADD GOAL",
                            style: TextStyle(
                                fontSize: 10,
                                fontFamily: 'LexendDeca-Regular',
                                color: Colors.black87),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Icons.add,
                            size: 15,
                            color: Colors.black87,
                          ),
                        ],
                      ),
                    ),
                  )
                  : (groupvalue == 0)
                      ? Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: StreamBuilder(
                            stream: getPokemonFood(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData ||
                                  snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                return Center(child: Container(height: 90, child: Image.asset('assets/loading.gif'),));
                              } else {
                                final pokemon_food =
                                    snapshot.data['pokemon_food'];

                                return Row(
                                  children: [
                                    Tooltip(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                                      triggerMode: TooltipTriggerMode.tap,
                                      message:
                                          'Earn berries by completing Long-Term Goals!',
                                      showDuration: Duration(seconds: 5),
                                      child: Icon(
                                        Icons.help,
                                        size: 20,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      height: 20,
                                      width: 30,
                                      child:
                                          Image.asset('assets/apple_pixel.png'),
                                    ),
                                    Text(
                                      pokemon_food.toString(),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontFamily: 'LexendDeca-Bold',
                                          fontSize: 14,
                                          color: Colors.black),
                                    ),
                                  ],
                                );
                              }
                            },
                          ),
                        )
                      : SizedBox()
            ],
            // centerTitle: true,
            // backgroundColor: Colors.red,
            iconTheme: IconThemeData(color: Colors.black),
          ),
          body: Column(
            children: [
              Center(
                child: CupertinoSlidingSegmentedControl(
                  backgroundColor: Colors.grey.withOpacity(0.075),
                  groupValue: groupvalue,
                  children: {
                    0: text_Tab("Pet"),
                    1: text_Tab("Long-Term Goals"),
                    2: text_Tab("Completed")
                  },
                  onValueChanged: (groupvalue) {
                    setState(() {
                      this.groupvalue = groupvalue;
                    });
                  },
                ),
              ),
              (groupvalue == 0)
                  ? pet_screen(
                      loggedInUser: widget.loggedInUser,
                      curr_User: widget.loggedInUser,
                    )
                  : (groupvalue == 1)
                      ? main_screen(
                          loggedInUser: widget.loggedInUser,
                        )
                      : (completed_LT_goals(loggedInUser: widget.loggedInUser))
            ],
          ),
        ),
      ),
    );
  }

  Widget text_Tab(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 1, vertical: 10),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontFamily: 'LexendDeca-Regular',
            fontSize: 11,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
