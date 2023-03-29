import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:test_app5/Current_User.dart';
import 'package:path/path.dart';

class add_LTGoal_screen extends StatefulWidget {
  final Current_User loggedInUser;

  add_LTGoal_screen({required this.loggedInUser});

  @override
  State<add_LTGoal_screen> createState() => _add_LTGoal_screenState();
}

class _add_LTGoal_screenState extends State<add_LTGoal_screen> {
  TextEditingController goalNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  File? pickedImage;

  Future createGoal(
      {required String goal_name, required String description}) async {
    final DocumentReference docGoal = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.loggedInUser.userID)
        .collection('longterm_goals')
        .doc();

    String goal_banner_URL = await uploadImage(docGoal.id);
    final json = {
    'LT_goal_ID': docGoal.id,
    'LT_goal_name' : goal_name,
    'LT_goal_desc' : description,
    'LT_goal_banner' : goal_banner_URL,
    'LT_goal_status' : 'Ongoing'
    };

    await docGoal.set(json);
  }

  //validation popup
  showValidationDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            actions: [
              Container(
                height: 45,
                width: MediaQuery.of(context).size.width / 3.5,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 5,
                        backgroundColor: Colors.blue[700],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25))),
                    child: Text(
                      "OK",
                      style: TextStyle(
                          fontFamily: 'LexendDeca-Regular', fontSize: 12),
                    ),
                    onPressed: () => {Navigator.pop(context)}),
              ),
            ],
            title: Text("Invalid"),
            content: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Please fill out all the necessary information.",
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
  Future<String> uploadImage(String goal_id) async{
    final path =
        'LT_goal-image-banners/${widget.loggedInUser.userID}-${widget.loggedInUser.email}/${goalNameController.text.trim()}-${goal_id}/${basename(pickedImage!.path)}';
    final file = File(pickedImage!.path);
    final storageRef = FirebaseStorage.instance.ref().child(path);
    await storageRef.putFile(file);
    String imageDownloadURL = await storageRef.getDownloadURL();
    return imageDownloadURL;
  }

  Future<void> selectImage() async{
    try{
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      final imageTemp = File(image.path);
      setState(()=> this.pickedImage = imageTemp);

    } on PlatformException catch(e){
      print("Failed to pick image: ${e} ");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        reverse: true,
        child: Column(
          children: [
            SizedBox(height: 40),
            (pickedImage!=null)
            ?
            Container(
              clipBehavior: Clip.hardEdge,
              child: Image.file(pickedImage!),
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
                child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.black87, width: 0.5),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)),
                        ),
                    child: Text(
                      "Add Icon",
                      style: TextStyle(
                          fontFamily: 'LexendDeca-Regular', fontSize: 12, color: Colors.black87),
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
                maxLength: 40,
                maxLengthEnforcement: MaxLengthEnforcement.truncateAfterCompositionEnds,
                style:
                    TextStyle(fontFamily: 'LexendDeca-Regular', fontSize: 12),
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)),
                    hintText: "Goal Name",
                    counterText: ""),
                controller: goalNameController,
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                maxLength: 245,
                maxLines: 15,
                style:
                    TextStyle(fontFamily: 'LexendDeca-Regular', fontSize: 12),
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)),
                    hintText: "Description",),
                controller: descriptionController,
              ),
            ),
            SizedBox(height: 20),
            Container(
              height: 55,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                    side: BorderSide(width: 0.5, color: Colors.black87.withOpacity(0.4)),
                    shape: RoundedRectangleBorder(
                        
                        borderRadius: BorderRadius.circular(15))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Create Long-Term Goal",
                        style: TextStyle(
                            fontFamily: 'LexendDeca-Bold', fontSize: 12 ,color: Colors.black87)),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.black87,
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

  
}