import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:focused_menu/modals.dart';
import 'package:test_app5/Current_User.dart';
import 'package:test_app5/add_STGoal_Screen.dart';
import 'package:test_app5/login_screen.dart';
import 'package:test_app5/tabs/LT_goal_screens/main_screen.dart';
import 'package:test_app5/tabs/LT_goal_tab.dart';
import '../../ST_goal.dart';
import '../../documentation_screen.dart';
import '../../theme/app_colors.dart';
import 'package:focused_menu/focused_menu.dart';
import '../../LT_goal.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class dashboard_screen extends StatefulWidget {
  final Current_User loggedInUser;
  final LT_goal LT_goal_info;
  const dashboard_screen(
      {required this.loggedInUser, required this.LT_goal_info});

  @override
  State<dashboard_screen> createState() => _dashboard_screenState();
}

class _dashboard_screenState extends State<dashboard_screen> {
  TextEditingController goalNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  int? finishedCount;

  String status = "ongoing";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    readGoals();
  }

  static final customCacheManager = CacheManager(
    Config('customCacheKey',
        stalePeriod: const Duration(days: 15), maxNrOfCacheObjects: 100),
  );

  Future deleteGoal({required String goalID}) async {
    final docGoal = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.loggedInUser.userID)
        .collection('longterm_goals')
        .doc(widget.LT_goal_info.LT_goal_ID)
        .collection('shortterm_goals')
        .doc(goalID);

    await docGoal.delete();
  }

  Future updateGoal(
      {String? goal_name, String? description, required String goalID}) async {
    print("update!");
    final docGoal = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.loggedInUser.userID)
        .collection('longterm_goals')
        .doc(widget.LT_goal_info.LT_goal_ID)
        .collection('shortterm_goals')
        .doc(goalID);

    await docGoal
        .update({'ST_goal_name': goal_name, 'ST_goal_desc': description});
  }

  //DELETE POPUP
  showDeleteGoalDialog(BuildContext context, goalID) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Delete Short-Term Goal?",
              style: TextStyle(fontFamily: 'LexendDeca-Bold', fontSize: 16),
            ),
            actions: [
              Container(
                height: 45,
                width: MediaQuery.of(context).size.width / 3.5,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
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
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 5,
                        backgroundColor: AppColors().red,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25))),
                    child: Text(
                      "Delete",
                      style: TextStyle(
                          fontFamily: 'LexendDeca-Regular', fontSize: 12),
                    ),
                    onPressed: () =>
                        {deleteGoal(goalID: goalID), Navigator.pop(context)}),
              ),
            ],
            content: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Are you sure you want to delete this Short-Term Goal?",
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
            title: Text(
              "Update Short-Term Goal",
              style: TextStyle(fontFamily: 'LexendDeca-Bold', fontSize: 16),
            ),
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
                          side: BorderSide(width: 0.5, color: Colors.black87),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Update Goal",
                              style: TextStyle(
                                  fontFamily: 'LexendDeca-Regular',
                                  fontSize: 12,
                                  color: Colors.black87)),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 12,
                            color: Colors.black87,
                          )
                        ],
                      ),
                      onPressed: () => {
                        updateGoal(
                            goalID: goalID,
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

  // //DELETE POPUP
  // Future<bool?> showLogoutDialog(BuildContext context) async {
  //   return showDialog(
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //           title: Text("Logout"),
  //           content: SingleChildScrollView(
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 Text(
  //                   "Are you sure you want to logout?",
  //                   style: TextStyle(
  //                       fontFamily: 'LexendDeca-Regular', fontSize: 14),
  //                 ),
  //                 SizedBox(
  //                   height: 20,
  //                 ),
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                   children: [
  //                     Container(
  //                       height: 45,
  //                       width: MediaQuery.of(context).size.width / 3.5,
  //                       child: ElevatedButton(
  //                           style: ElevatedButton.styleFrom(
  //                               elevation: 5,
  //                               backgroundColor: Colors.white,
  //                               shape: RoundedRectangleBorder(
  //                                   borderRadius: BorderRadius.circular(25))),
  //                           child: Text(
  //                             "Cancel",
  //                             style: TextStyle(
  //                                 color: Colors.black,
  //                                 fontFamily: 'LexendDeca-Regular',
  //                                 fontSize: 12),
  //                           ),
  //                           onPressed: () => {Navigator.pop(context, false)}),
  //                     ),
  //                     SizedBox(
  //                       width: 20,
  //                     ),
  //                     Container(
  //                       height: 45,
  //                       width: MediaQuery.of(context).size.width / 3.5,
  //                       child: ElevatedButton(
  //                           style: ElevatedButton.styleFrom(
  //                               elevation: 5,
  //                               backgroundColor: AppColors().red,
  //                               shape: RoundedRectangleBorder(
  //                                   borderRadius: BorderRadius.circular(25))),
  //                           child: Text(
  //                             "Logout",
  //                             style: TextStyle(
  //                                 fontFamily: 'LexendDeca-Regular',
  //                                 fontSize: 12),
  //                           ),
  //                           onPressed: () => {
  //                                 Navigator.push(
  //                                     context,
  //                                     MaterialPageRoute(
  //                                         builder: (context) => login_screen()))
  //                               }),
  //                     ),
  //                   ],
  //                 )
  //               ],
  //             ),
  //           ),
  //         );
  //       });
  // }

  showFinishLT_GoalConfirmDialog(BuildContext context, goalID) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Confirm Long-Term Goal Completion?",
              style: TextStyle(fontFamily: 'LexendDeca-Bold', fontSize: 16),
            ),
            actions: [
              Container(
                height: 45,
                width: MediaQuery.of(context).size.width / 3.5,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
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
                    onPressed: () =>
                        {markAsOngoing(goalID), Navigator.pop(context)}),
              ),
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
                      "Confirm",
                      style: TextStyle(
                          fontFamily: 'LexendDeca-Regular', fontSize: 12),
                    ),
                    onPressed: () => {
                          Navigator.pop(context),
                          congratsAndRewardsDialog(context),
                        }),
              ),
            ],
            content: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Are you sure you want to complete this Long-Term Goal? Once completed, it will be added to the Finished Goals Tab in view-only mode.",
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

  markAsOngoing(String ST_goal_id) async {
    DocumentReference update_status = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.loggedInUser.userID)
        .collection('longterm_goals')
        .doc(widget.LT_goal_info.LT_goal_ID)
        .collection('shortterm_goals')
        .doc(ST_goal_id);

    update_status.update({'ST_goal_status': 'Ongoing'});
  }

  markAsFinished(ST_goal ST_goal_info) async {
    CollectionReference ST_goal_collection = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.loggedInUser.userID)
        .collection('longterm_goals')
        .doc(widget.LT_goal_info.LT_goal_ID)
        .collection('shortterm_goals');
    await ST_goal_collection.doc(ST_goal_info.ST_goal_ID)
        .update({'ST_goal_status': 'Finished'});

    QuerySnapshot docSnapshot = await ST_goal_collection.get();
    Query<Object?> checkStatusFinished =
        ST_goal_collection.where('ST_goal_status', isEqualTo: 'Finished');
    QuerySnapshot checkFinishedSnapshot = await checkStatusFinished.get();
    int countDocs = docSnapshot.docs.length;
    setState(() {
      finishedCount = checkFinishedSnapshot.docs.length;
    });
    print("COUNT OF DOCS: ${countDocs}");
    print("COUNT OF FINISHED ST GOALS: ${finishedCount}");
    if (countDocs == finishedCount) {
      showFinishLT_GoalConfirmDialog(context, ST_goal_info.ST_goal_ID);
    }
  }

  congratsAndRewardsDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Hooray!"),
            content: Text(
                "You have completed '${widget.LT_goal_info.LT_goal_name}'! Keep up the good work!"),
            actions: [
              Container(
                height: 45,
                width: MediaQuery.of(context).size.width / 3.5,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.black87, width: 0.5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25))),
                  onPressed: () async{
                    await FirebaseFirestore.instance.collection('users')
                    .doc(widget.loggedInUser.userID)
                    .collection('longterm_goals')
                    .doc(widget.LT_goal_info.LT_goal_ID)
                    .update({
                      'LT_goal_status' : 'Finished'
                    });
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LT_goal_tab(loggedInUser: widget.loggedInUser)));
                  },
                  child: Text("OK"),
                ),
              )
            ],
          );
        });
  }

  //WIDGET BUILD
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          SizedBox(
            height: 25,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 10),
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.LT_goal_info.LT_goal_name,
                          style: TextStyle(
                              fontFamily: 'LexendDeca-Bold', fontSize: 10)),
                      SizedBox(
                        height: 5,
                      ),
                      SingleChildScrollView(
                        child: Text(
                          widget.LT_goal_info.LT_goal_desc,
                          style: TextStyle(
                            fontFamily: 'LexendDeca-ExtraLight',
                            fontSize: 8,
                          ),
                          maxLines: 7,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.justify,
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.35,
                  height: MediaQuery.of(context).size.height * 0.12,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        side: BorderSide(width: 0.5, color: Colors.black87),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15))),
                    onPressed: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => addGoalScreen(
                                    loggedInUser: widget.loggedInUser,
                                    LT_goal_info: widget.LT_goal_info,
                                  )))
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add,
                            size: 30,
                            color: Colors.black87,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "ADD GOAL",
                            style: TextStyle(
                                fontSize: 10,
                                fontFamily: 'LexendDeca-Regular',
                                color: Colors.black87),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
              child: StreamBuilder<List<ST_goal>>(
            stream: readGoals(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final goals = snapshot.data!;
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final ST_goal goal = goals[index];
                    return Column(children: [buildGoals(goal)]);
                  },
                  physics: BouncingScrollPhysics(),
                );
              } else {
                return Center(
                  child: Text("No data found."),
                );
              }
            },
          ))
        ],
      ),
    );
  }

  Widget buildGoals(ST_goal goal) {
    return FocusedMenuHolder(
      animateMenuItems: false,
      openWithTap: false,
      onPressed: () => {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => documentation_screen(
                      goal: goal,
                      loggedInUser: widget.loggedInUser,
                      LT_goal_info: widget.LT_goal_info,
                    ))),
      },
      menuItems: [
        FocusedMenuItem(
            title: Text("Update"),
            onPressed: () {
              goalNameController.text = goal.ST_goal_name;
              descriptionController.text = goal.ST_goal_desc;
              showUpdateGoalDialog(context, goal.ST_goal_ID);
            },
            trailingIcon: Icon(Icons.update)),
        FocusedMenuItem(
            backgroundColor: AppColors().red,
            title: Text(
              "Delete",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              showDeleteGoalDialog(context, goal.ST_goal_ID);
            },
            trailingIcon: Icon(
              Icons.delete,
              color: Colors.white,
            )),
        FocusedMenuItem(
            backgroundColor: Colors.blue[700],
            title: Text(
              "Mark as Ongoing",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              markAsOngoing(goal.ST_goal_ID);
            },
            trailingIcon: Icon(Icons.circle_outlined)),
        FocusedMenuItem(
            backgroundColor: Colors.green[700],
            title: Text(
              "Mark as Finished",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              markAsFinished(goal);
            },
            trailingIcon: Icon(Icons.check)),
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Container(
            height: 120,
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                    color: Colors.black87.withOpacity(0.2), width: 1),
                borderRadius: BorderRadius.circular(25)),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                    width: 200,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(goal.ST_goal_name,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                  fontSize: 10, fontFamily: 'LexendDeca-Bold')),
                          Padding(
                            //diri usually mag overflow ang pixel
                            padding: const EdgeInsets.only(top: 5),
                            child: Text('${goal.ST_goal_desc}',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: TextStyle(
                                    fontSize: 8,
                                    fontFamily: 'LexendDeca-ExtraLight')),
                          )
                        ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: Container(
                      height: 30,
                      width: 100,
                      child: Center(
                          child: Text(
                        goal.ST_goal_status!,
                        style: TextStyle(
                            fontFamily: 'LexendDeca-Regular',
                            fontSize: 10,
                            color: Colors.white),
                      )),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: (goal.ST_goal_status == "Ongoing")
                              ? Colors.blue[700]
                              : Colors.green[700]),
                    ),
                  ),
                ])),
      ),
    );
  }

  Stream<List<ST_goal>> readGoals() {
    setState(() => isLoading = true);
    Stream<List<ST_goal>> stream = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.loggedInUser.userID)
        .collection('longterm_goals')
        .doc(widget.LT_goal_info.LT_goal_ID)
        .collection('shortterm_goals')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ST_goal(
                ST_goal_name: doc.data()['ST_goal_name'],
                ST_goal_ID: doc.data()['ST_goal_ID'],
                ST_goal_desc: doc.data()['ST_goal_desc'],
                ST_goal_status: doc.data()['ST_goal_status']))
            .toList());

    setState(() => isLoading = false);
    return stream;
  }
}
