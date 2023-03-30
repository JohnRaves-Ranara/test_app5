import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:test_app5/tabs/ST_goal_screens/dashboard_screen.dart';
import '../../Current_User.dart';
import '../../LT_goal.dart';
import '../ST_goal_tab.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class main_screen extends StatefulWidget {
  final Current_User loggedInUser;

  main_screen({required this.loggedInUser});

  @override
  State<main_screen> createState() => _main_screenState();
}

class _main_screenState extends State<main_screen> {
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
      {required String goal_name, required String description, required String LT_goal_ID}) async {
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
            actionsPadding: EdgeInsets.all(15),
            actions: [
              Container(
                        height: 45,
                        width: MediaQuery.of(context).size.width / 3.5,
                        child: OutlinedButton(
                          
                            style: OutlinedButton.styleFrom(
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
                        child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              elevation: 5,
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
            title: Text("Delete Long-Term Goal?", style: TextStyle(fontFamily: 'LexendDeca-Bold', fontSize: 16),),
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
            insetPadding: EdgeInsets.symmetric(horizontal: 10),
            contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            title: Text("Update Long-Term Goal", style: TextStyle(fontFamily: 'LexendDeca-Bold', fontSize: 16),),
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
                        backgroundColor: Colors.blue,
                        elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Update Goal",
                              style: TextStyle(
                                  fontFamily: 'LexendDeca-Bold',
                                  fontSize: 14,
                                  color: Colors.white)),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 12,
                            color: Colors.white,
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
                if (snapshot.hasData) {
                  final goals = snapshot.data!;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GridView(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2),
                      physics: BouncingScrollPhysics(),
                      children: goals.map(buildLTGoals).toList(),
                    ),
                  );
                } else {
                  return Center(
                    child: Text("No data found."),
                  );
                }
              }),
        )
      ]),
    );
  }

  Widget buildLTGoals(LT_goal LT_goal_info) {
    return FocusedMenuHolder(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ST_goal_tab(
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
                  CachedNetworkImage(
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
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
                  Container(
                    width: 200,
                    // color: Colors.green[100],
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 17),
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
        .where("LT_goal_status", isEqualTo: "Ongoing")
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => LT_goal(
                LT_goal_ID: doc.data()['LT_goal_ID'],
                LT_goal_desc: doc.data()['LT_goal_desc'],
                LT_goal_name: doc.data()['LT_goal_name'],
                LT_goal_banner: doc.data()['LT_goal_banner'],
                LT_goal_status: doc.data()['LT_goal_status']
                ))
                
            .toList());
  }
}
