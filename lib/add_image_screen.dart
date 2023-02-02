import 'package:flutter/material.dart';
import 'Current_User.dart';
import 'Goal.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'theme/app_colors.dart';

class add_image_screen extends StatefulWidget {
  final Goal goal;
  final Current_User loggedInUser;
  const add_image_screen({required this.goal, required this.loggedInUser});

  @override
  State<add_image_screen> createState() => _add_image_screenState();
}

class _add_image_screenState extends State<add_image_screen> {
  PlatformFile? pickedImage;
  String? imageDownloadURL;

  Future uploadImage() async {
    final path = '${widget.loggedInUser.userID}-${widget.loggedInUser.email}/${widget.goal.goal_name}/${pickedImage!.name}';
    final file = File(pickedImage!.path!);

    final storageRef = FirebaseStorage.instance.ref().child(path);
    await storageRef.putFile(file);
    imageDownloadURL = await storageRef.getDownloadURL();
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    print("Firestore upload start");
    await firebaseFirestore
        .collection('users')
        .doc(widget.loggedInUser.userID)
        .collection("goals")
        .doc(widget.goal.goal_id)
        .collection("images")
        .add({'imageDownloadURL': imageDownloadURL});
    print("Firestore upload finish");
    Navigator.pop(context);
  }

  Future selectImage() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    setState(() {
      pickedImage = result.files.first;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Add Image")),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (pickedImage != null)
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                child: Image.file(File(pickedImage!.path!)),
                height: 500,
                width: 500,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          Center(
            child: Container(
              height: 50,
              width: 150,
              child: ElevatedButton(
                  child: Center(child: Text("Select Image")),
                  onPressed: () => {
                        selectImage(),
                      }),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Center(
            child: Container(
              height: 50,
              width: 150,
              child: ElevatedButton(
                  child: Center(child: Text("Confirm")),
                  onPressed: () => {
                        uploadImage(),
                      }),
            ),
          ),
        ],
      ),
    );
  }
}
