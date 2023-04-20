import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:test_app5/tabs/ST_goal_screens/ST_goals_screen.dart';
import '../../Current_User.dart';
import '../../LT_goal.dart';
import '../ST_goal_tab.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../comp_ST_goal_tab.dart';

class completed_LT_goals extends StatefulWidget {
  final Current_User loggedInUser;

  completed_LT_goals({required this.loggedInUser});

  @override
  State<completed_LT_goals> createState() => _completed_LT_goalsState();
}

class _completed_LT_goalsState extends State<completed_LT_goals> {
  TextEditingController goalNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  File? pickedImage;
  String? imageDownloadURL;

  Future selectImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() => this.pickedImage = imageTemp);
    } on PlatformException catch (e) {
      print("Failed to pick image: ${e} ");
    }
  }

  Future<String> uploadImage() async {
    final path =
        'goal-image-banners/${widget.loggedInUser.userID}-${widget.loggedInUser.email}/goal_name diri/${pickedImage!}';
    final file = File(pickedImage!.path);
    final storageRef = FirebaseStorage.instance.ref().child(path);
    await storageRef.putFile(file);
    imageDownloadURL = await storageRef.getDownloadURL();
    return imageDownloadURL!;
  }

  Future deleteGoal({required String LT_goal_ID}) async {
    final docGoal = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.loggedInUser.userID)
        .collection('longterm_goals')
        .doc(LT_goal_ID);

    await docGoal.delete();
  }

  Future updateGoal(
      {required String goal_name,
      required String description,
      required String LT_goal_ID}) async {
    print("update!");
    final docGoal = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.loggedInUser.userID)
        .collection('longterm_goals')
        .doc(LT_goal_ID);

    await docGoal
        .update({'LT_goal_name': goal_name, 'LT_goal_desc': description});
  }

  //DELETE POPUP
  showDeleteGoalDialog(BuildContext context, goalID) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            actions: [
              Container(
                height: 45,
                width: MediaQuery.of(context).size.width / 3.5,
                child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
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
                child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        side: BorderSide(width: 0.5, color: Colors.white),
                        backgroundColor: Colors.red[600],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25))),
                    child: Text(
                      "Delete",
                      style: TextStyle(
                          fontFamily: 'LexendDeca-Regular',
                          fontSize: 12,
                          color: Colors.white),
                    ),
                    onPressed: () => {
                          deleteGoal(LT_goal_ID: goalID),
                          Navigator.pop(context)
                        }),
              ),
            ],
            title: Text(
              "Delete Long-Term Goal?",
              style: TextStyle(fontFamily: 'LexendDeca-Bold', fontSize: 16),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Are you sure you want to delete this Long-Term Goal?",
                    style: TextStyle(
                        fontFamily: 'LexendDeca-Regular', fontSize: 14),
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

  //UPDATE POPUP
  showUpdateGoalDialog(BuildContext context, String goalID) {
    return showDialog(
        context: context,
        builder: ((context) {
          return AlertDialog(
            title: Text(
              "Update Long-Term Goal",
              style: TextStyle(fontFamily: 'LexendDeca-Bold', fontSize: 16),
            ),
            content: SingleChildScrollView(
              reverse: true,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextField(
                      style: TextStyle(
                          fontFamily: 'LexendDeca-Regular', fontSize: 12),
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
                      maxLines: 10,
                      style: TextStyle(
                          fontFamily: 'LexendDeca-Regular', fontSize: 12),
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
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          side: BorderSide(width: 0.5, color: Colors.black87),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Update Goal",
                              style: TextStyle(
                                  fontFamily: 'LexendDeca-Regular',
                                  fontSize: 12,
                                  color: Colors.black87)),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 12,
                            color: Colors.black87,
                          )
                        ],
                      ),
                      onPressed: () => {
                        updateGoal(
                            LT_goal_ID: goalID,
                            goal_name: goalNameController.text.trim(),
                            description: descriptionController.text.trim()),
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

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(children: [
        SizedBox(
          height: 25,
        ),
        Expanded(
          child: StreamBuilder(
              stream: readLTgoals(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Container(
                      height: 90,
                      child: Image.asset('assets/loading.gif'),
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text("No Completed Long-Term Goals yet.",
                        style: TextStyle(
                            fontFamily: 'LexendDeca-Regular', fontSize: 12)),
                  );
                } else {
                  final goals = snapshot.data!;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2),
                      physics: BouncingScrollPhysics(),
                      itemCount: goals.length,
                      itemBuilder: (context, index) {
                        if (goals[index].LT_goal_banner[0]=='h') {
                            print("IMAGE:" + goals[index].LT_goal_banner);
                            return buildLTGoals(goals[index]);
                          } else {
                            print("COLOR:" + goals[index].LT_goal_banner);
                            return buildLT_Goals_noBanner(goals[index]);
                          }
                      }
                    ),
                  );
                }
              }),
        )
      ]),
    );
  }

  Widget buildLT_Goals_noBanner(LT_goal LT_goal_info) {
    return FocusedMenuHolder(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => comp_ST_goal_tab(
                    loggedInUser: widget.loggedInUser,
                    LT_goal_info: LT_goal_info)));
      },
      animateMenuItems: false,
      openWithTap: false,
      menuItems: [
        FocusedMenuItem(
            title: Text("Update"),
            onPressed: () {
              goalNameController.text = LT_goal_info.LT_goal_name;
              descriptionController.text = LT_goal_info.LT_goal_desc;
              showUpdateGoalDialog(context, LT_goal_info.LT_goal_ID);
            },
            trailingIcon: Icon(Icons.update)),
        FocusedMenuItem(
            backgroundColor: Colors.red[600],
            title: Text(
              "Delete",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              showDeleteGoalDialog(context, LT_goal_info.LT_goal_ID);
            },
            trailingIcon: Icon(
              Icons.delete,
              color: Colors.white,
            )),
      ],
      child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.black87.withOpacity(0.2), width: 1),
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.white),
              child: Column(
                children: [
                  Stack(
                    children: [Container(
                      alignment: Alignment.center,
                      child: Text(
                        LT_goal_info.LT_goal_name.trim()[0].toUpperCase(),
                        style: TextStyle(
                            fontFamily: 'LexendDeca-Bold', fontSize: 32,),
                      ),
                      height: 90,
                      decoration: BoxDecoration(
                        color: _getColorFromString(LT_goal_info.LT_goal_banner),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(23),
                            topRight: Radius.circular(23)),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.green.withOpacity(0.5)),
                            child: Icon(
                              Icons.check,
                              color: Colors.white.withOpacity(0.8),
                              size: 15,
                            ),
                          ),
                        ),
                      )
                    ]
                  ),
                  Container(
                    width: 200,
                    // color: Colors.green[100],
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          LT_goal_info.LT_goal_name,
                          style: TextStyle(
                              fontSize: 10, fontFamily: 'LexendDeca-Bold'),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          LT_goal_info.LT_goal_desc,
                          style: TextStyle(
                              fontSize: 8, fontFamily: 'LexendDeca-Regular'),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.justify,
                        )
                      ],
                    ),
                  )
                ],
              ))),
    );
  }

  Widget buildLTGoals(LT_goal LT_goal_info) {
    return FocusedMenuHolder(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => comp_ST_goal_tab(
                    loggedInUser: widget.loggedInUser,
                    LT_goal_info: LT_goal_info)));
      },
      animateMenuItems: false,
      openWithTap: false,
      menuItems: [
        FocusedMenuItem(
            backgroundColor: Colors.red[600],
            title: Text(
              "Delete",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              showDeleteGoalDialog(context, LT_goal_info.LT_goal_ID);
            },
            trailingIcon: Icon(
              Icons.delete,
              color: Colors.white,
            )),
      ],
      child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.black87.withOpacity(0.2), width: 1),
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.white),
              child: Column(
                children: [
                  Stack(
                    children: [
                      CachedNetworkImage(
                        placeholder: (context, url) => Center(
                            child: Container(
                          height: 90,
                          child: Image.asset('assets/loading.gif'),
                        )),
                        imageUrl: LT_goal_info.LT_goal_banner,
                        imageBuilder: ((context, imageProvider) => Container(
                              clipBehavior: Clip.hardEdge,
                              height: 90,
                              decoration: BoxDecoration(
                                  color: Colors.orange[100],
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(23),
                                      topRight: Radius.circular(23)),
                                  image: DecorationImage(
                                      colorFilter: ColorFilter.mode(
                                          Colors.black.withOpacity(0.4),
                                          BlendMode.darken),
                                      fit: BoxFit.cover,
                                      image: imageProvider)),
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.green.withOpacity(0.5)),
                            child: Icon(
                              Icons.check,
                              color: Colors.white.withOpacity(0.8),
                              size: 15,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Container(
                    width: 200,
                    // color: Colors.green[100],
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          LT_goal_info.LT_goal_name,
                          style: TextStyle(
                              fontSize: 10, fontFamily: 'LexendDeca-Bold'),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          LT_goal_info.LT_goal_desc,
                          style: TextStyle(
                              fontSize: 8, fontFamily: 'LexendDeca-Regular'),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.justify,
                        )
                      ],
                    ),
                  )
                ],
              ))),
    );
  }

  Stream<List<LT_goal>> readLTgoals() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(widget.loggedInUser.userID)
        .collection('longterm_goals')
        .where("LT_goal_status", isEqualTo: "Finished")
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => LT_goal(
                LT_goal_ID: doc.data()['LT_goal_ID'],
                LT_goal_desc: doc.data()['LT_goal_desc'],
                LT_goal_name: doc.data()['LT_goal_name'],
                LT_goal_banner: doc.data()['LT_goal_banner'],
                LT_goal_status: doc.data()['LT_goal_status']))
            .toList());
  }

    Color _getColorFromString(String colorString) {
    switch (colorString) {
      case "orange":
        return Color(0xfffaa424);
      case "purple":
        return Color(0xffab47bc);
      case "blue":
        return Color(0xff2292ef);
      default:
        return Colors.white;
    }
  }
}
