import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'Current_User.dart';
import 'theme/app_colors.dart';

class addGoalScreen extends StatefulWidget {
  final Current_User loggedInUser;
  const addGoalScreen({required this.loggedInUser});

  @override
  State<addGoalScreen> createState() => _addGoalScreenState();
}

class _addGoalScreenState extends State<addGoalScreen> {
  @override
  Widget build(BuildContext context) {
    TextEditingController goalNameController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    String goalName;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          reverse: true,
          child: Column(
            children: [
              SizedBox(height: 20),
              Container(
                height: 100,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                            'assets/upload_jpeg.jpg'))),
              ),
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width/3,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)), backgroundColor: Color(0xFFD13C3C)),
                  child: Text("Add Icon", style: TextStyle(fontFamily: 'LexendDeca-Regular', fontSize: 16),),
                  onPressed: ()=>{}
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  style: TextStyle(fontFamily: 'LexendDeca-Regular', fontSize: 16),
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)), hintText: "Goal Name"),
                  controller: goalNameController,
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  maxLines: 15,
                  style: TextStyle(fontFamily: 'LexendDeca-Regular', fontSize: 16),
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)), hintText: "Description"),
                  controller: descriptionController,
                ),
              ),
              SizedBox(height: 20),
              Container(
                height: 55,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors().red, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Create Goal", style: TextStyle(fontFamily: 'LexendDeca-Bold', fontSize: 20)),
                      Icon(Icons.arrow_forward_ios, size: 20,)
        
                    ],
                  ),
                onPressed: ()=>{
                  goalName = goalNameController.text,
              if (goalName != "")
                {
                  createGoal(goal_name: goalName),
                  goalNameController.clear(),
                  Navigator.pop(context)
                }
                },
                ),
              ),
            ],
          ),
        ),
        // floatingActionButton: Container(
        //   height: 55,
        //   width: 120,
        //   child: FloatingActionButton(
        //     shape: RoundedRectangleBorder(
        //         side: BorderSide.none, borderRadius: BorderRadius.circular(12)),
        //     onPressed: () => {
        //       goalName = goalNameController.text,
        //       if (goalName != "")
        //         {
        //           createGoal(goal_name: goalName),
        //           goalNameController.clear(),
        //           Navigator.pop(context)
        //         }
        //     },
        //     backgroundColor: AppColors().red,
        //     child: Text(
        //       "Confirm",
        //       style: TextStyle(fontSize: 16),
        //     ),
        //   ),
        // ),
      )  
    );
  }

  Future createGoal({required String goal_name}) async {
    final docGoal = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.loggedInUser.userID)
        .collection('goals')
        .doc();

    final json = {'goal_name': goal_name, 'goal_id': docGoal.id};

    await docGoal.set(json);
  }
}
