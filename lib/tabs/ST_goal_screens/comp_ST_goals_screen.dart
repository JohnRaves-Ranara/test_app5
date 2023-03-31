import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:focused_menu/modals.dart';
import 'package:test_app5/Current_User.dart';
import 'package:test_app5/add_STGoal_Screen.dart';
import 'package:test_app5/login_screen.dart';
import 'package:test_app5/tabs/LT_goal_screens/LT_goals_screen.dart';
import 'package:test_app5/tabs/LT_goal_tab.dart';
import '../../ST_goal.dart';
import '../../comp_documentation_screen.dart';
import '../../documentation_screen.dart';
import '../../theme/app_colors.dart';
import 'package:focused_menu/focused_menu.dart';
import '../../LT_goal.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'dart:math';

class comp_dashboard_screen extends StatefulWidget {
  final Current_User loggedInUser;
  final LT_goal LT_goal_info;
  const comp_dashboard_screen(
      {required this.loggedInUser, required this.LT_goal_info});

  @override
  State<comp_dashboard_screen> createState() => _comp_dashboard_screenState();
}

class _comp_dashboard_screenState extends State<comp_dashboard_screen> {
  TextEditingController goalNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  int? finishedCount;
  Map<int, dynamic> quotes = {
    1: {
      'quote': 'Believe you can and you\'re halfway there.',
      'by': 'Theodore Roosevelt'
    },
    2: {
      'quote': 'It does not matter how slowly you go as long as you dont stop',
      'by': 'Confucius'
    },
    3: {
      'quote': 'Never let anyone tell you what is possible.',
      'by': 'Shane Parrish'
    },
    4: {
      'quote':
          'Success is not about never falling, but about rising every time you fall.',
      'by': 'Michelle Corasanti'
    },
    5: {
      'quote': 'It always seems impossible until it\'s done',
      'by': 'Nelson Mandela'
    }
  };

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

  updateLT_goal_status() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.loggedInUser.userID)
        .collection('longterm_goals')
        .doc(widget.LT_goal_info.LT_goal_ID)
        .update({'LT_goal_status': "Finished"});
  }

  //DELETE POPUP
  showDeleteGoalDialog(BuildContext context, goalID) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            actionsPadding: EdgeInsets.all(15),
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
            insetPadding: EdgeInsets.symmetric(horizontal: 10),
            contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
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
                          backgroundColor: Colors.blue,
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Update Goal",
                              style: TextStyle(
                                  fontFamily: 'LexendDeca-Bold',
                                  fontSize: 14,
                                  color: Colors.white)),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 12,
                            color: Colors.white,
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

  Future<Map<String, int>> calculateRewards() async {
    print("NISULOD SYA SA CALCULATE");
    DateTime? startDate;
    DateTime endDate = DateTime.now();
    int? imageCount;
    DocumentReference docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.loggedInUser.userID);

    DocumentSnapshot docSnap = await docRef
        .collection('longterm_goals')
        .doc(widget.LT_goal_info.LT_goal_ID)
        .get();

    if (docSnap.exists) {
      final data = docSnap.data()! as Map<String, dynamic>;
      setState(() {
        //get startdate and imagecount
        startDate = DateTime.parse(data['startDate']);
        imageCount = data['image_count'];
      });
      //update enddate to current datetime
      await docRef
          .collection('longterm_goals')
          .doc(widget.LT_goal_info.LT_goal_ID)
          .update({'endDate': endDate.toString()});
    }
    print("START DATE: ${startDate}");
    print("END DATE: ${endDate}");

    //rewards calculation
    Duration startEndDifference = endDate.difference(startDate!);
    int differenceDays = startEndDifference.inDays;
    print("DIFFERENCE IN DAYS: ${differenceDays}");
    int rewardBaseMultiplier = 5;
    int result = rewardBaseMultiplier * (differenceDays + imageCount!);

    Map<String, int> rewards = {
      "goal_duration": differenceDays,
      "total_documentations": imageCount!,
      "base_reward_multiplier": rewardBaseMultiplier,
      "reward": result
    };

    //add pokemon food
    DocumentSnapshot pokemonSnap = await docRef
        .collection('pokemon')
        .doc(widget.loggedInUser.userID)
        .get();
    if (pokemonSnap.exists) {
      final pokemonData = pokemonSnap.data()! as Map<String, dynamic>;
      final pokemonFood = pokemonData['pokemon_food'];
      await docRef
          .collection('pokemon')
          .doc(widget.loggedInUser.userID)
          .update({'pokemon_food': pokemonFood + result});
    }
    print('NAHUMAN ANG CALCULAET');
    return rewards;
  }

  showFinishLT_GoalConfirmDialog(BuildContext contexts, goalID) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            actionsPadding: EdgeInsets.all(15),
            insetPadding: EdgeInsets.symmetric(horizontal:20),
            titlePadding: EdgeInsets.only(left: 20, right: 20, top: 40),
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
                    onPressed: () async {
                      Navigator.pop(context);
                      //for testing
                      // Map<String, int> k = {
                      //   'goal_duration': 90,
                      //   'total_documentations': 90,
                      //   'reward': 180
                      // };
                      //comment this out for testing
                      Map<String, int> rewards = await calculateRewards();
                      await updateLT_goal_status();
                      //comment this out for testing
                      congratsAndRewardsDialog(contexts, rewards);
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
                    textAlign: TextAlign.justify,
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

  showMarkAsFinishedNotAllowedDialog(){
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            actionsPadding: EdgeInsets.all(15),
            insetPadding: EdgeInsets.symmetric(horizontal: 20),
            title: Text(
              "Error",
              style: TextStyle(fontFamily: 'LexendDeca-Bold', fontSize: 16),
            ),
            actions: [
              Container(
                height: 45,
                width: MediaQuery.of(context).size.width / 3.5,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 5,
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25))),
                    child: Text(
                      "OK",
                      style: TextStyle(
                          fontFamily: 'LexendDeca-Regular', fontSize: 12),
                    ),
                    onPressed: ()
                        {
                          Navigator.pop(context);
                        }),
              ),
            ],
            content: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Short-Term Goals without documentation cannot be marked as Finished.",
                    textAlign: TextAlign.start,
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
  markAsFinished(ST_goal ST_goal_info) async {
    //doc reference to ST goal collection
    CollectionReference ST_goal_collection = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.loggedInUser.userID)
        .collection('longterm_goals')
        .doc(widget.LT_goal_info.LT_goal_ID)
        .collection('shortterm_goals');

    //get number of images in ST goal
    CollectionReference imageColRef =
        ST_goal_collection.doc(ST_goal_info.ST_goal_ID).collection('images');
    QuerySnapshot imageSnapshot = await imageColRef.get();
    int ST_goal_image_count = imageSnapshot.docs.length;

    if (ST_goal_image_count < 1) {
      showMarkAsFinishedNotAllowedDialog();
    } else {
      //update the ST goal's status to finished
      await ST_goal_collection.doc(ST_goal_info.ST_goal_ID)
          .update({'ST_goal_status': 'Finished'});
      QuerySnapshot docSnapshot = await ST_goal_collection.get();
      Query<Object?> checkStatusFinished =
          ST_goal_collection.where('ST_goal_status', isEqualTo: 'Finished');
      //gets all docs of finished ST goals
      QuerySnapshot checkFinishedSnapshot = await checkStatusFinished.get();

      //number of all ST goals
      int countDocs = docSnapshot.docs.length;
      setState(() {
        //number of finished ST goals
        finishedCount = checkFinishedSnapshot.docs.length;
      });
      print("COUNT OF DOCS: ${countDocs}");
      print("COUNT OF FINISHED ST GOALS: ${finishedCount}");

      //if all ST goals are finished, show finish confirm dialog
      if (countDocs == finishedCount) {
        showFinishLT_GoalConfirmDialog(context, ST_goal_info.ST_goal_ID);
      }
    }
    //get all ST goals
  }

  congratsAndRewardsDialog(BuildContext context, Map<String, int> reward) {
    int random = Random().nextInt(quotes.length + 1);
    random = random.clamp(1, 6);

    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            actionsPadding: EdgeInsets.all(15),
            insetPadding: EdgeInsets.symmetric(horizontal: 10),
            content: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    "CONGRATULATIONS!",
                    style:
                        TextStyle(fontFamily: 'LexendDeca-Bold', fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    "You have completed the Long-Term Goal:",
                    style: TextStyle(
                        fontFamily: 'LexendDeca-Regular', fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "${widget.LT_goal_info.LT_goal_name}",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style:
                        TextStyle(fontFamily: 'LexendDeca-Bold', fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Text(
                    quotes[random]['quote'],
                    style: TextStyle(
                        fontFamily: 'LexendDeca-Regular', fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "- ${quotes[random]['by']}",
                    style: TextStyle(
                        fontFamily: 'LexendDeca-Regular', fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        // color: Colors.blue[100],
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Total duration (in days):",
                              style: TextStyle(
                                  fontFamily: 'LexendDeca-Regular',
                                  fontSize: 14),
                              textAlign: TextAlign.start,
                            ),
                            Text(
                              "Total documentations:",
                              style: TextStyle(
                                  fontFamily: 'LexendDeca-Regular',
                                  fontSize: 14),
                              textAlign: TextAlign.start,
                            ),
                            Text(
                              "Base Reward Multiplier:",
                              style: TextStyle(
                                  fontFamily: 'LexendDeca-Regular',
                                  fontSize: 14),
                              textAlign: TextAlign.start,
                            ),
                            Row(
                              children: [
                                Container(
                                    height: 30,
                                    width: 30,
                                    child:
                                        Image.asset('assets/apple_pixel.png')),
                                Text(
                                  "Earned:",
                                  style: TextStyle(
                                      fontFamily: 'LexendDeca-Regular',
                                      fontSize: 14),
                                  textAlign: TextAlign.start,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        // color: Colors.orange[100],
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "${reward['goal_duration']}",
                              style: TextStyle(
                                  fontFamily: 'LexendDeca-Regular',
                                  fontSize: 14),
                              textAlign: TextAlign.start,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "${reward['total_documentations']}",
                              style: TextStyle(
                                  fontFamily: 'LexendDeca-Regular',
                                  fontSize: 14),
                              textAlign: TextAlign.start,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "x${reward['base_reward_multiplier']}",
                              style: TextStyle(
                                  fontFamily: 'LexendDeca-Regular',
                                  fontSize: 14),
                              textAlign: TextAlign.start,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "${reward['reward']}",
                              style: TextStyle(
                                  fontFamily: 'LexendDeca-Regular',
                                  fontSize: 14),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
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
                          "OK",
                          style: TextStyle(
                              fontFamily: 'LexendDeca-Regular', fontSize: 12),
                        ),
                        onPressed: () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LT_goal_tab(
                                      loggedInUser: widget.loggedInUser
                                      )));
                        }),
                  ),
                ],
              ),
            ),
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
                    onPressed: null,
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
              if(snapshot.connectionState == ConnectionState.waiting){
                return Center(child: CircularProgressIndicator(),);
              }
              else if(!snapshot.hasData || snapshot.data!.isEmpty){
                return Center(child: Text("No Short-Term Goals yet."),);
              }
              else {
                final goals = snapshot.data!;
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final ST_goal goal = goals[index];
                    return Column(children: [buildGoals(goal)]);
                  },
                  physics: BouncingScrollPhysics(),
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
                builder: (context) => comp_documentation_screen(
                      goal: goal,
                      loggedInUser: widget.loggedInUser,
                      LT_goal_info: widget.LT_goal_info,
                    ))),
      },
      menuItems: [],
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
        .orderBy("creationDate", descending: false)
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
