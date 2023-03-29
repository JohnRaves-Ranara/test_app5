import 'package:animated_segmented_tab_control/animated_segmented_tab_control.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:test_app5/Current_User.dart';
import 'package:test_app5/tabs/ST_goal_screens/dashboard_screen.dart';
import 'package:test_app5/tabs/ST_goal_screens/LT_note_screen.dart';
import '../LT_goal.dart';

class ST_goal_tab extends StatefulWidget {
  final Current_User loggedInUser;
  final LT_goal LT_goal_info;
  ST_goal_tab({required this.loggedInUser, required this.LT_goal_info});

  @override
  State<ST_goal_tab> createState() => _ST_goal_tabState();
}

class _ST_goal_tabState extends State<ST_goal_tab> {
  int? groupvalue = 0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 100,
          actions: [
            Container(width: 90,),
            Flexible(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: Align(
                    alignment: Alignment.center,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        widget.LT_goal_info.LT_goal_name,
                        style: TextStyle(
                            fontFamily: 'LexendDeca-Bold',
                            fontSize: 20,
                            color: Colors.black),
                        overflow: TextOverflow.ellipsis,
                      ),
                    )),
              ),
            ),
            SizedBox(
              width: 30,
            )
          ],
          // centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        body: Column(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: CupertinoSlidingSegmentedControl(
                  backgroundColor: Colors.grey.withOpacity(0.1),
                  groupValue: groupvalue,
                  children: {
                    0: text_Tab("Short-Term Goals"),
                    1: text_Tab("Notes")
                  },
                  onValueChanged: (groupvalue) {
                    setState(() {
                      this.groupvalue = groupvalue;
                    });
                  },
                ),
              ),
            ),
            (groupvalue == 0)
                ? dashboard_screen(
                    loggedInUser: widget.loggedInUser,
                    LT_goal_info: widget.LT_goal_info)
                : LT_notes_screen(
                    loggedInUser: widget.loggedInUser,
                    LT_goal_info: widget.LT_goal_info,
                  )
          ],
        ),
      ),
    );
  }

  Widget text_Tab(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Container(
        width: 150,
        child: Center(
          child: Text(
            text,
            style: TextStyle(fontFamily: 'LexendDeca-Regular', fontSize: 13),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
