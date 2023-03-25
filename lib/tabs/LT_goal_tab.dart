import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_app5/Current_User.dart';
import 'package:test_app5/add_LTgoal_screen.dart';
import 'LT_goal_screens/main_screen.dart';
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
        appBar: AppBar(
          leading: Align(
              alignment: Alignment.centerRight,
              child: Text(
                "Dashboard",
                style: TextStyle(
                    fontFamily: 'LexendDeca-Bold',
                    fontSize: 20,
                    color: Colors.black),
              )),
          leadingWidth: 200,
          toolbarHeight: 100,
          actions: [
            (groupvalue == 1)
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 15),
                    child: Container(
                      // color: Colors.orange[100],
                      width: MediaQuery.of(context).size.width * 0.3,
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
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add,
                                size: 30,
                                color: Colors.black87,
                              ),
                              Text(
                                "ADD GOAL",
                                style: TextStyle(
                                    fontSize: 10,
                                    fontFamily: 'LexendDeca-Regular',
                                    color: Colors.black87),
                                textAlign: TextAlign.center,
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
              child: CupertinoSegmentedControl(
                // padding: EdgeInsets.symmetric(horizontal: 30),
                borderColor: Colors.black,
                selectedColor: Colors.blue[700],
                groupValue: groupvalue,
                children: {
                  0: text_Tab("Pet"),
                  1: text_Tab("Long-Term Goals"),
                  2: text_Tab("Profile")
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
                  )
                : (groupvalue == 1)
                    ? main_screen(
                        loggedInUser: widget.loggedInUser,
                      )
                    : user_profile_screen(
                        loggedInUser: widget.loggedInUser,
                      )
          ],
        ),
      ),
    );
  }

  Widget text_Tab(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Container(
        width: 150,
        child: Center(
          child: Text(
            text,
            style: TextStyle(fontFamily: 'LexendDeca-Regular', fontSize: 14,),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
