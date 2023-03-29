import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:test_app5/Current_User.dart';

import '../../LT_goal.dart';
import '../../LT_note.dart';

class LT_notes_screen extends StatefulWidget {
  final Current_User loggedInUser;
  final LT_goal LT_goal_info;

  LT_notes_screen({required this.loggedInUser, required this.LT_goal_info});

  @override
  State<LT_notes_screen> createState() => _LT_notes_screenState();
}

class _LT_notes_screenState extends State<LT_notes_screen> {
  TextEditingController LT_note_title = TextEditingController();
  TextEditingController LT_note_text = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 25,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 10),
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: MediaQuery.of(context).size.height * 0.12,
                  // color: Colors.orange[100],
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
                      Text(
                        widget.LT_goal_info.LT_goal_desc,
                        style: TextStyle(
                          fontFamily: 'LexendDeca-ExtraLight',
                          fontSize: 8,
                        ),
                        maxLines: 7,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.justify,
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
                    onPressed: () => {},
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
                          Text(
                            "ADD NOTE",
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
            child: StreamBuilder(
              stream: readNotes(),
              builder: (context, snapshot) {
                final notes = snapshot.data!;
                if (snapshot.hasData) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GridView(
                        physics: BouncingScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                        children: notes.map(buildLT_notes).toList()),
                  );
                }
                  return const Center(
                    child: Text("No data found."),
                  );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget buildLT_notes(LT_note LT_note_info) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: InkWell(
        onTap: () => {},
        child: Container(
          height: 200,
          width: MediaQuery.of(context).size.width * 0.2,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Colors.purple[100]),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LT_note_info.LT_note_text,
                  style: TextStyle(
                    fontFamily: 'LexendDeca-Regular',
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 7,
                  textAlign: TextAlign.start,
                ),
                // SizedBox(
                //   height: 5,
                // ),
                // Text(
                //   LT_goal_info.LT_goal_desc,
                //   style:
                //       TextStyle(fontFamily: 'LexendDeca-Regular', fontSize: 12),
                //   overflow: TextOverflow.ellipsis,
                //   maxLines: 2,
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Stream<List<LT_note>> readNotes() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(widget.loggedInUser.userID)
        .collection('longterm_goals')
        .doc(widget.LT_goal_info.LT_goal_ID)
        .collection('LT_notes')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => LT_note.fromJson(doc.data())).toList());
  }
}
