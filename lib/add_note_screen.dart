import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Current_User.dart';
import 'LT_goal.dart';
import 'ST_goal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';

class add_note_screen extends StatefulWidget {
  final Current_User loggedInUser;
  final LT_goal LT_goal_info;
  final bool isUpdate;
  final String note_title_text;
  final String note_text_text;
  final String? LT_note_ID;
  add_note_screen({this.LT_note_ID,required this.loggedInUser, required this.LT_goal_info, required this.isUpdate, required this.note_text_text, required this.note_title_text});

  @override
  State<add_note_screen> createState() => _add_note_screenState();
}

class _add_note_screenState extends State<add_note_screen> {
  TextEditingController note_title = TextEditingController();
  TextEditingController note_text = TextEditingController();

  @override
  void initState(){
    super.initState();
    print(widget.isUpdate);
    note_title = TextEditingController(text: widget.note_title_text);
    note_text = TextEditingController(text: widget.note_text_text);
  }

   @override
  void dispose() {
    note_text.dispose();
    note_text.dispose();

    super.dispose();
  }

  updateNote() async {
    print(note_text.text);
    print(note_title.text);
    DocumentReference noteDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.loggedInUser.userID)
        .collection('longterm_goals')
        .doc(widget.LT_goal_info.LT_goal_ID)
        .collection('LT_notes')
        .doc(widget.LT_note_ID);

    await noteDoc.update({
      'LT_note_title': note_title.text.trim(),
      'LT_note_text': note_text.text.trim(),
    });
  }

  addNote() async {
    DocumentReference noteDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.loggedInUser.userID)
        .collection('longterm_goals')
        .doc(widget.LT_goal_info.LT_goal_ID)
        .collection('LT_notes')
        .doc();

    await noteDoc.set({
      'LT_note_id': noteDoc.id,
      'LT_note_title': note_title.text.trim(),
      'LT_note_text': note_text.text.trim(),
      'configDate' : DateTime.now().toString()
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 80,
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        floatingActionButton: Container(
          height: 75,
          width: 75,
          child: FloatingActionButton(
            onPressed: () {
              if(widget.isUpdate==false){
                addNote();
                Navigator.pop(context);
              }else{
                updateNote();
                Navigator.pop(context);
              }
            },
            child: Icon(Icons.save),
            backgroundColor: Colors.blue[400],
          ),
        ),
        body: SingleChildScrollView(
          reverse: true,
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  style:
                      TextStyle(fontFamily: 'LexendDeca-Regular', fontSize: 14),
                  maxLines: 1,
                  controller: note_title,
                  decoration: InputDecoration(
                      border: InputBorder.none, hintText: "Note Title"),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  style:
                      TextStyle(fontFamily: 'LexendDeca-Regular', fontSize: 14),
                  maxLines: null,
                  controller: note_text,
                  decoration: InputDecoration(
                      border: InputBorder.none, hintText: "Note content"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
