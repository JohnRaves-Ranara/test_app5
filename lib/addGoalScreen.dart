import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'Current_User.dart';
import 'theme/app_colors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class addGoalScreen extends StatefulWidget {
  final Current_User loggedInUser;
  const addGoalScreen({required this.loggedInUser});

  @override
  State<addGoalScreen> createState() => _addGoalScreenState();
}

class _addGoalScreenState extends State<addGoalScreen> {
  TextEditingController goalNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  PlatformFile? pickedImage;
  String? imageDownloadURL;

  Future<void> selectImage() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    setState(() {
      pickedImage = result.files.first;
    });
  }

  Future<String> uploadImage() async {
    final path =
        'goal-image-banners/${widget.loggedInUser.userID}-${widget.loggedInUser.email}/${goalNameController.text.trim()}/${pickedImage!.name}';
    final file = File(pickedImage!.path!);
    final storageRef = FirebaseStorage.instance.ref().child(path);
    await storageRef.putFile(file);
    imageDownloadURL = await storageRef.getDownloadURL();
    return imageDownloadURL!;
  }


  //validation popup 
  showValidationDialog(BuildContext context){
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Invalid"),
            content: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Please fill out all the necessary information.",
                    style:
                        TextStyle(fontFamily: 'LexendDeca-Regular', fontSize: 14),
                  ),
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
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
                                  "OK",
                                  style: TextStyle(
                                      fontFamily: 'LexendDeca-Regular', fontSize: 12),
                                ),
                                onPressed: () => { 
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



  @override
  Widget build(BuildContext context) {
    String goalName;
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        reverse: true,
        child: Column(
          children: [
            SizedBox(height: 10),
            (pickedImage!=null)
            ?
            Container(
              clipBehavior: Clip.hardEdge,
              child: Image.file(File(pickedImage!.path!)),
              height: 125,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(25)),
              )
            :
            Container(
              height: 125,
              decoration: BoxDecoration(
                  image:
                      DecorationImage(image: AssetImage('assets/upload.png')),),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Container(
                height: 32,
                width: MediaQuery.of(context).size.width / 4,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)),
                        backgroundColor: Color(0xFFD13C3C)),
                    child: Text(
                      "Add Icon",
                      style: TextStyle(
                          fontFamily: 'LexendDeca-Regular', fontSize: 12),
                    ),
                    onPressed: () => {
                      selectImage()
                    }),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                style:
                    TextStyle(fontFamily: 'LexendDeca-Regular', fontSize: 16),
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)),
                    hintText: "Goal Name"),
                controller: goalNameController,
              ),
            ),
            SizedBox(height: 20),
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
                    hintText: "Description"),
                controller: descriptionController,
              ),
            ),
            SizedBox(height: 20),
            Container(
              height: 55,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors().red,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Create Goal",
                        style: TextStyle(
                            fontFamily: 'LexendDeca-Bold', fontSize: 20)),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 20,
                    )
                  ],
                ),
                onPressed: () => {
                
                  if (goalNameController.text.isNotEmpty && descriptionController.text.isNotEmpty && pickedImage!=null)
                    {
                      createGoal(goal_name: goalNameController.text.trim(), description: descriptionController.text.trim()),
                      Navigator.pop(context)
                    }
                  else{
                    showValidationDialog(context)
                  }
                },
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Future createGoal({
    required String goal_name, required String description
  }) async {
    final docGoal = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.loggedInUser.userID)
        .collection('goals')
        .doc();

    String goal_banner_URL = await uploadImage();
    final json = {
      'goal_name': goal_name,
      'goal_id': docGoal.id,
      'goal_description': description,
      'goal_banner_URL' : goal_banner_URL
    };

    await docGoal.set(json);
  }
}
