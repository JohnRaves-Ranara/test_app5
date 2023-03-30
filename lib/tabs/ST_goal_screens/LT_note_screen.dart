import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:test_app5/Current_User.dart';
import 'package:test_app5/add_note_screen.dart';

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
  //DELETE POPUP
  showDeleteNoteDialog(BuildContext context, LT_note_id) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Delete Note?",
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
                        backgroundColor: Colors.red[600],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25))),
                    child: Text(
                      "Delete",
                      style: TextStyle(
                          fontFamily: 'LexendDeca-Regular', fontSize: 12),
                    ),
                    onPressed: () async
                        {
                          await FirebaseFirestore.instance
                          .collection('users')
                          .doc(widget.loggedInUser.userID)
                          .collection('longterm_goals')
                          .doc(widget.LT_goal_info.LT_goal_ID)
                          .collection('LT_notes')
                          .doc(LT_note_id)
                          .delete();
                          Navigator.pop(context);
                          
                          }),
              ),
            ],
            content: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Are you sure you want to delete this note?",
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
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
                    onPressed: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => add_note_screen(
                                  note_text_text: "",
                                  note_title_text: "",
                                  isUpdate: false,
                                  loggedInUser: widget.loggedInUser,
                                  LT_goal_info: widget.LT_goal_info)))
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
              stream: readLTnotes(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final notes = snapshot.data!;
                  return GridView(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2),
                      children: notes.map(buildLT_notes).toList());
                } else {
                  return Center(
                    child: Text("No data found"),
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Widget buildLT_notes(LT_note LT_note_info) {
    return FocusedMenuHolder(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => add_note_screen(
                      LT_note_ID: LT_note_info.LT_note_ID,
                      loggedInUser: widget.loggedInUser,
                      LT_goal_info: widget.LT_goal_info,
                      isUpdate: true,
                      note_text_text: LT_note_info.LT_note_text,
                      note_title_text: LT_note_info.LT_note_title,
                    )));
      },
      openWithTap: false,
      menuItems: [
        FocusedMenuItem(
            backgroundColor: Colors.red[600],
            title: Text(
              "Delete",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              showDeleteNoteDialog(context, LT_note_info.LT_note_ID);
            },
            trailingIcon: Icon(
              Icons.delete,
              color: Colors.white,
            )),
      ],
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.2,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black87, width: 0.2),
              borderRadius: BorderRadius.circular(25),
              color: Colors.yellow[100]),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10,),
                Text(
                  LT_note_info.LT_note_title,
                  style: TextStyle(
                    fontFamily: 'LexendDeca-Bold',
                    fontSize: 12,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 10,),
                Text(
                  LT_note_info.LT_note_text,
                  style: TextStyle(
                    fontFamily: 'LexendDeca-Regular',
                    fontSize: 10,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 6,
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 10,),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Stream<List<LT_note>> readLTnotes() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(widget.loggedInUser.userID)
        .collection('longterm_goals')
        .doc(widget.LT_goal_info.LT_goal_ID)
        .collection('LT_notes')
        .orderBy("configDate", descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => LT_note(
                LT_note_ID: doc.data()['LT_note_id'],
                LT_note_text: doc.data()['LT_note_text'],
                LT_note_title: doc.data()['LT_note_title']))
            .toList());
  }
}
