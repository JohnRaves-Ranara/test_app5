import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'Current_User.dart';
import 'LT_goal.dart';
import 'theme/app_colors.dart';
import 'package:file_picker/file_picker.dart';

class addGoalScreen extends StatefulWidget {
  final Current_User loggedInUser;
  final LT_goal LT_goal_info;
  const addGoalScreen({required this.loggedInUser, required this.LT_goal_info});

  @override
  State<addGoalScreen> createState() => _addGoalScreenState();
}

class _addGoalScreenState extends State<addGoalScreen> {
  TextEditingController goalNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  PlatformFile? pickedImage;
  String? imageDownloadURL;

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
                        backgroundColor: AppColors().red,
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

  @override
  Widget build(BuildContext context) {
    String goalName;
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.black),
          ),
      body: SingleChildScrollView(
        reverse: true,
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height*0.1,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                style:
                    TextStyle(fontFamily: 'LexendDeca-Regular', fontSize: 12),
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
                maxLines: 20,
                style:
                    TextStyle(fontFamily: 'LexendDeca-Regular', fontSize: 12),
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
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.black87, width: 0.5),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Create Goal",
                        style: TextStyle(
                            fontFamily: 'LexendDeca-Bold', fontSize: 12, color: Colors.black87)),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.black87,
                    )
                  ],
                ),
                onPressed: () => {
                  if (goalNameController.text.isNotEmpty &&
                      descriptionController.text.isNotEmpty)
                    {
                      createGoal(
                          goal_name: goalNameController.text.trim(),
                          description: descriptionController.text.trim()),
                      Navigator.pop(context)
                    }
                  else
                    {showValidationDialog(context)}
                },
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Future createGoal(
      {required String goal_name, required String description}) async {
    final docGoal = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.loggedInUser.userID)
        .collection('longterm_goals')
        .doc(widget.LT_goal_info.LT_goal_ID)
        .collection('shortterm_goals')
        .doc();
    final json = {
      'ST_goal_name': goal_name,
      'ST_goal_ID': docGoal.id,
      'ST_goal_desc': description,
      'ST_goal_status': "Ongoing",
      'creationDate' : DateTime.now().toString(),
    };

    await docGoal.set(json);
  }
}
