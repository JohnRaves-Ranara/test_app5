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
  TextEditingController imageDescriptionController = TextEditingController();

  Future upload() async {
    final path =
        '${widget.loggedInUser.userID}-${widget.loggedInUser.email}/${widget.goal.goal_name}/${pickedImage!.name}';
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
        .add({'imageDownloadURL': imageDownloadURL, 'image_Description': imageDescriptionController.text.trim()});
    print("Firestore upload finish");
    Navigator.pop(context);
  }

  Future<void> selectImage() async {
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
        title: Align(
          child: Text(
            "Add Image",
            style: TextStyle(fontFamily: 'LexendDeca-Regular'),
          ),
          alignment: Alignment.center,
        ),
        actions: [
          ElevatedButton(
              style: ElevatedButton.styleFrom(elevation: 0),
              onPressed: () => {upload()},
              child: Text(
                "Done",
                style: TextStyle(
                    
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: 'LexendDeca-Regular'),
              ))
        ],
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Column(
          children: [
            SizedBox(height: 20,),
            (pickedImage != null)
                ? Container(
                  clipBehavior: Clip.hardEdge,
                  constraints: BoxConstraints(maxHeight: 180, maxWidth: 180),
                    child: Image.file(
                      File(pickedImage!.path!),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  )
                : Container(
                    height: 200,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/upload.png')),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
            SizedBox(height: 20,),
            Container(
              height: 40,
              width: MediaQuery.of(context).size.width / 3,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors().red,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25))),
                  child: Text(
                    "Select Image",
                    style: TextStyle(
                        fontFamily: 'LexendDeca-Regular', fontSize: 12),
                  ),
                  onPressed: () => {
                        selectImage(),
                      }),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                maxLines: 15,
                style:
                    TextStyle(fontFamily: 'LexendDeca-Regular', fontSize: 16),
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)),
                    hintText: "Image Description..."),
                controller: imageDescriptionController,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
