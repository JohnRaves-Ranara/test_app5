import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_app5/Current_User.dart';
import 'package:test_app5/add_LTgoal_screen.dart';
import 'package:test_app5/tabs/LT_goal_screens/completed_LT_goals.dart';
import 'LT_goal_screens/LT_goals_screen.dart';
import 'LT_goal_screens/pet_screen.dart';
import 'LT_goal_screens/user_profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LT_goal_tab extends StatefulWidget {
  final Current_User loggedInUser;
  LT_goal_tab({required this.loggedInUser});

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

  bruh() async {
    DocumentReference bruh = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.loggedInUser.userID)
        .collection("longterm_goals")
        .doc("kqk5xoo1pJAuLBCcU2lo");
    DocumentSnapshot bruhSnap = await bruh.get();

    final DocumentReference target = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.loggedInUser.userID)
        .collection("finished_longterm_goals")
        .doc("kqk5xoo1pJAuLBCcU2lo");

    await target.set(bruhSnap.data());
    await bruh.delete();
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: Drawer(
                child: ListView(
                  children: [
                    ListTile(
                      title: Text("Profile", style: TextStyle(fontFamily: 'LexendDeca-Regular', fontSize: 18),),
                      onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=> user_profile_screen(loggedInUser: widget.loggedInUser))),
                    ),
                    ListTile(
                      title: Text("Sign Out", style: TextStyle(fontFamily: 'LexendDeca-Regular', fontSize: 18),),
                      onTap: ()async{ await FirebaseAuth.instance.signOut();},
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
                  return IconButton(
                    iconSize: 300,
                    icon: Text('VisioLife',
                        overflow: TextOverflow.fade,
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'LexendDeca-Bold',
                            fontSize: 19)),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                    tooltip:
                        MaterialLocalizations.of(context).openAppDrawerTooltip,
                  );
                },
              ),
            ),
          ),
          leadingWidth: 200,
          toolbarHeight: 100,
          actions: [
            (groupvalue == 1)
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 25.0, horizontal: 22),
                    child: Container(
                      // color: Colors.orange[100],
                      width: MediaQuery.of(context).size.width * 0.35,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            side: BorderSide(width: 0.5, color: Colors.black87),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15))),
                        onPressed: () => {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => add_LTGoal_screen(
                                      loggedInUser: widget.loggedInUser)))
                          // bruh()
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8),
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
                      ),
                    ),
                  )
                : SizedBox()
          ],
          // centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        body: Column(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: CupertinoSlidingSegmentedControl(
                  backgroundColor: Colors.grey.withOpacity(0.075),
                  groupValue: groupvalue,
                  children: {
                    0: text_Tab("Pet"),
                    1: text_Tab("Long-Term Goals"),
                    2: text_Tab("Completed Goals")
                  },
                  onValueChanged: (groupvalue) {
                    setState(() {
                      this.groupvalue = groupvalue;
                    });
                  },
                ),
              ),
            ),
            (groupvalue == 0)
                ? pet_screen(
                    loggedInUser: widget.loggedInUser,
                  )
                : (groupvalue == 1)
                    ? main_screen(
                        loggedInUser: widget.loggedInUser,
                      )
                    : (completed_LT_goals(loggedInUser: widget.loggedInUser))
          ],
        ),
      ),
    );
  }

  Widget text_Tab(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 10),
      width: 150,
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontFamily: 'LexendDeca-Regular',
            fontSize: 13,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
