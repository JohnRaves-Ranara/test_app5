import 'package:flutter/material.dart';
import 'Current_User.dart';
import 'Goal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_image_screen.dart';
import 'theme/app_colors.dart';

class documentation_screen extends StatefulWidget {
  final Goal goal;
  final Current_User loggedInUser;
  const documentation_screen({required this.goal, required this.loggedInUser});

  @override
  State<documentation_screen> createState() => _documentation_screenState();
}

class _documentation_screenState extends State<documentation_screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Container(
        height: 75,
        width: 75,
        child: FloatingActionButton(
          backgroundColor: AppColors().red,
          child: Icon(Icons.add),
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => add_image_screen(
                      goal: widget.goal, loggedInUser: widget.loggedInUser))),
        ),
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: 
      Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  "${widget.goal.goal_name}",
                  maxLines: 2,
                  style: TextStyle(fontSize: 30, fontFamily: 'Montserrat-Bold', overflow: TextOverflow.ellipsis),
                )),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Documentation of your goal",
                  style: TextStyle(fontSize: 16, fontFamily: 'Montserrat-Thin'),
                )),
          ),
              
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(widget.loggedInUser.userID)
                  .collection("goals")
                  .doc("${widget.goal.goal_id}")
                  .collection("images")
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return (const Center(child: Text("No image/s uploaded.")));
                } else {
                  return GridView.builder(
                      itemCount: snapshot.data!.docs.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2),
                      itemBuilder: (context, index) {
                        String url = snapshot.data!.docs[index]['imageDownloadURL'];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                              onTap: () => {
                                print("show image screen " + url),
                              },
                              child:
                                  Image.network(url, height: 100, fit: BoxFit.cover)),
                        );
                      });
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
