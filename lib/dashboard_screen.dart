import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:focused_menu/modals.dart';
import 'package:test_app5/Current_User.dart';
import 'package:test_app5/addGoalScreen.dart';
import 'package:test_app5/login_screen.dart';
import 'Goal.dart';
import 'documentation_screen.dart';
import 'theme/app_colors.dart';
import 'package:focused_menu/focused_menu.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class dashboard_screen extends StatefulWidget {
  final Current_User loggedInUser;
  const dashboard_screen({required this.loggedInUser});

  @override
  State<dashboard_screen> createState() => _dashboard_screenState();
}

class _dashboard_screenState extends State<dashboard_screen> {
  Future deleteGoal({required String goalID}) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.loggedInUser.userID)
        .collection('goals')
        .doc(goalID)
        .delete();
  }

  Future updateGoal(
      {String? goal_name, String? description, required String goalID}) async {
    print("update!");
    final docGoal = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.loggedInUser.userID)
        .collection('goals')
        .doc(goalID);

    if (description != null && goal_name == null) {
      await docGoal.update({'goal_description': description});
    } else if (goal_name != null && description == null) {
      await docGoal.update({'goal_name': goal_name});
    } else {
      await docGoal
          .update({'goal_name': goal_name, 'goal_description': description});
    }
  }

  //DELETE POPUP
  showDeleteGoalDialog(BuildContext context, goalID) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Delete Goal?"),
            content: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Are you sure you want to delete this goal?",
                    style:
                        TextStyle(fontFamily: 'LexendDeca-Regular', fontSize: 14),
                  ),
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
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
                                      fontFamily: 'LexendDeca-Regular', fontSize: 12),
                                ),
                                onPressed: () => {
                                      Navigator.pop(context)
                                    }),
                          ),
                          SizedBox(width: 20,),
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
                                  "Delete",
                                  style: TextStyle(
                                      fontFamily: 'LexendDeca-Regular', fontSize: 12),
                                ),
                                onPressed: () => {
                                      deleteGoal(goalID: goalID),
                                      Navigator.pop(context)
                                    }),
                          ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  //UPDATE POPUP
  showUpdateGoalDialog(BuildContext context, String goalID) {
    TextEditingController goalNameController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();

    return showDialog(
        context: context,
        builder: ((context) {
          return AlertDialog(
            title: Text("Update Goal"),
            content: SingleChildScrollView(
              reverse: true,
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
                          hintText: "Goal Name"),
                      controller: goalNameController,
                    ),
                  ),
                  SizedBox(height: 10),
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
                      controller: descriptionController,
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 45,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors().red,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Update Goal",
                              style: TextStyle(
                                  fontFamily: 'LexendDeca-Bold', fontSize: 15)),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 10,
                          )
                        ],
                      ),
                      onPressed: () => {
                        if (goalNameController.text.isNotEmpty &&
                            descriptionController.text.isEmpty)
                          {
                            print("1"),
                            updateGoal(
                                goalID: goalID,
                                goal_name: goalNameController.text.trim())
                          }
                        else if (goalNameController.text.isEmpty &&
                            descriptionController.text.isNotEmpty)
                          {
                            print("2"),
                            updateGoal(
                                goalID: goalID,
                                description: descriptionController.text.trim())
                          }
                        else if (goalNameController.text.isNotEmpty &&
                            descriptionController.text.isNotEmpty)
                          {
                            print("3"),
                            updateGoal(
                                goalID: goalID,
                                goal_name: goalNameController.text.trim(),
                                description: descriptionController.text.trim())
                          },
                        Navigator.pop(context)
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        }));
  }

  //DELETE POPUP
  Future<bool?> showLogoutDialog(BuildContext context) async{
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Logout"),
            content: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Are you sure you want to logout?",
                    style:
                        TextStyle(fontFamily: 'LexendDeca-Regular', fontSize: 14),
                  ),
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
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
                                      fontFamily: 'LexendDeca-Regular', fontSize: 12),
                                ),
                                onPressed: () => {
                                      Navigator.pop(context, false)
                                    }),
                          ),
                          SizedBox(width: 20,),
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
                                  "Logout",
                                  style: TextStyle(
                                      fontFamily: 'LexendDeca-Regular', fontSize: 12),
                                ),
                                onPressed: () => {
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>login_screen()))
                                    }),
                          ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  //WIDGET BUILD
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        final shouldPop = await showLogoutDialog(context);
        return shouldPop ?? false;
      },
      child: SafeArea(
        child: Scaffold(
          drawer: Drawer(
            child: ListView(
              children: [
                ListTile(
                  title: Text("Logout", style: TextStyle(fontSize: 16, fontFamily: 'LexendDeca-Regular'),),
                  onTap: (){showLogoutDialog(context);},
                )
              ],
            ),
          ),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.black),
          ),
            body: Column(
          children: [
            Container(
              height: 120,
              child: Center(
                child: ListTile(
                  title: Text(
                    "Hello ${widget.loggedInUser.username}.",
                    style: TextStyle(fontSize: 36, fontFamily: 'LexendDeca-Bold'),
                    textAlign: TextAlign.center,
                  ),
                  subtitle: InkWell(
                    child: Text(
                      "Feeling productive? Add a goal!",
                      style: TextStyle(
                          fontSize: 18, fontFamily: 'LexendDeca-Regular'),
                      textAlign: TextAlign.center,
                    ),
                    onTap: () => {
                      print(
                          "when clicked user will be navigated to text input screen for journal adding"),
                    },
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 30,
              ),
              width: MediaQuery.of(context).size.width,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors().red,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15))),
                onPressed: () => {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => addGoalScreen(
                                loggedInUser: widget.loggedInUser,
                              )))
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Create Goal",
                        style: TextStyle(
                            fontSize: 20, fontFamily: 'LexendDeca-Bold'),
                      ),
                      Icon(
                        Icons.add,
                        size: 30,
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20,),
            Expanded(
              child: StreamBuilder<List<Goal>>(
                stream: readGoals(),
                builder: (context,snapshot){
                  if(snapshot.hasData){
                    final goals = snapshot.data!;
                    return ListView(
                      physics: BouncingScrollPhysics(),
                      children: goals.map(buildGoals).toList(),
                    );
                  }else{
                    return Center(child: Text("No data found."),);
                  }
                },
              )
            )
          ],
        )),
      ),
    );
  }

  Widget buildGoals(Goal goal) {
    return FocusedMenuHolder(
      openWithTap: false,
      onPressed: () => {},
      menuItems: [
        FocusedMenuItem(
            title: Text("Update"),
            onPressed: () {
              showUpdateGoalDialog(context, goal.goal_id!);
            },
            trailingIcon: Icon(Icons.update)),
        FocusedMenuItem(
            backgroundColor: AppColors().red,
            title: Text("Delete", style: TextStyle(color: Colors.white),),
            onPressed: () {
              showDeleteGoalDialog(context, goal.goal_id);
            },
            trailingIcon: Icon(Icons.delete, color: Colors.white,))
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
        child: Container(
            height: 120,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage('${goal.goal_banner_URL}'),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.6), BlendMode.darken)),
                borderRadius: BorderRadius.circular(25)),
            child: InkWell(
              borderRadius: BorderRadius.circular(25),
              onTap: () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => documentation_screen(
                            goal: goal, loggedInUser: widget.loggedInUser))),
              },
              splashColor: Colors.black.withOpacity(0.2),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                      width: 250,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(goal.goal_name,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontFamily: 'LexendDeca-Bold')),
                            Padding(
                              //diri usually mag overflow ang pixel
                              padding: const EdgeInsets.only(top: 5),
                              child: Text('${goal.goal_description}',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 8,
                                      fontFamily: 'LexendDeca-ExtraLight')),
                            )
                          ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 18),
                      child: Container(
                          child: Icon(Icons.arrow_forward_ios,
                              color: Colors.white, size: 20)),
                    ),
                  ]),
            )),
      ),
    );
  }

  Stream<List<Goal>> readGoals() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(widget.loggedInUser.userID)
        .collection('goals')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Goal.fromJson(doc.data())).toList());
  }
}
