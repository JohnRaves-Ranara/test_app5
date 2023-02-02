import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:test_app5/Current_User.dart';
import 'package:test_app5/addGoalScreen.dart';
import 'Goal.dart';
import 'documentation_screen.dart';
import 'theme/app_colors.dart';

class dashboard_screen extends StatefulWidget {
  final Current_User loggedInUser;
  const dashboard_screen({required this.loggedInUser});

  @override
  State<dashboard_screen> createState() => _dashboard_screenState();
}

class _dashboard_screenState extends State<dashboard_screen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Container(
            height: 140,
            child: Center(
              child: ListTile(
                title: Text(
                  "Hello ${widget.loggedInUser.username}.",
                  style: TextStyle(fontSize: 36, fontFamily: 'LexendDeca-Bold'),
                  textAlign: TextAlign.center,
                ),
                subtitle: InkWell(
                  child: Text(
                    "What's on your mind?",
                    style: TextStyle(
                        fontSize: 18, fontFamily: 'LexendDeca-Regular'),
                    textAlign: TextAlign.center,
                  ),
                  onTap: () => {
                    print(
                        "when clicked user will be navigated to text input screen for journal adding"),
                  },
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 30,
            ),
            width: MediaQuery.of(context).size.width,
            height: 55,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors().red,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15))),
              onPressed: () => {
                Navigator.push(context, MaterialPageRoute(builder: (context) => addGoalScreen(loggedInUser: widget.loggedInUser,)))
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Create Goal",
                      style: TextStyle(
                          fontSize: 20, fontFamily: 'LexendDeca-Bold'),
                    ),
                    Icon(Icons.add, size: 30,)
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: StreamBuilder<List<Goal>>(
                stream: readGoals(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text("${snapshot.error}"));
                  } else if (snapshot.hasData) {
                    final goals = snapshot.data!;
                    return ListView(
                      children: goals.map(buildGoals).toList(),
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                }),
          )
        ],
      )),
    );
  }

  Widget buildGoals(Goal goal) {
    return InkWell(
      child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
            child: Container(
                height: 120,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(
                            'https://www.shape.com/thmb/xcMppPKHI0J7PuGKeIVDke2tTCA=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/squat-GettyImages-1004449544-2000-f72d11a72ed84c1885ccbeed1ccaa3c1.jpg'),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.6), BlendMode.darken)),
                    borderRadius: BorderRadius.circular(25)),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                        width: 250,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(goal.goal_name,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontFamily: 'LexendDeca-Bold')),
                              SizedBox(height: 10),
                              Text(
                                  "No excuses! Achieve the body of a Greek God! Lets fucking goooooooooooooooooooooooooooooooooooooo!",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontFamily: 'LexendDeca-ExtraLight'))
                            ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 18),
                        child: Container(
                          child: Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20)
                        ),
                      ),
                    ])),
          ),
      onTap: () => {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => documentation_screen(
                    goal: goal, loggedInUser: widget.loggedInUser))),
      },
    );
  }

  Stream<List<Goal>> readGoals() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(widget.loggedInUser.userID)
        .collection('goals')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Goal.fromJson(doc.data())).toList());
  }
}
