import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
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
                    padding: const EdgeInsets.symmetric(horizontal: 10),
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

    // );
  }

  Widget buildLTGoals(LT_goal LT_goal_info) {
    return InkWell(
        onTap: () => {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ST_goal_tab(
                          loggedInUser: widget.loggedInUser,
                          LT_goal_info: LT_goal_info)))
            },
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.black87.withOpacity(0.4), width: 1.5),
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.transparent),
                child: Container(
                  // color: Colors.orange[100],
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        LT_goal_info.LT_goal_name,
                        style: TextStyle(
                          fontFamily: 'LexendDeca-Bold',
                          fontSize: 10,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        LT_goal_info.LT_goal_desc,
                        style: TextStyle(
                            fontFamily: 'LexendDeca-Regular',
                            fontSize: 8),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      )
                    ],
                  ),
                ))),
          );
  }

  Stream<List<LT_goal>> readLTgoals() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(widget.loggedInUser.userID)
        .collection('longterm_goals')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => LT_goal(
                LT_goal_ID: doc.data()['LT_goal_ID'],
                LT_goal_desc: doc.data()['LT_goal_desc'],
                LT_goal_name: doc.data()['LT_goal_name'],
                LT_goal_banner: doc.data()['LT_goal_banner']))
            .toList());
  }
}
