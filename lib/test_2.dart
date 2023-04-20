import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'LT_goal.dart';
import 'dart:math';

class test_2 extends StatelessWidget {
  test_2({super.key});
  List<Color?> colors = [
    Colors.orange[400],
    Colors.purple[400],
    Colors.green[400]
  ];

  LT_goal goal = LT_goal(
    LT_goal_ID: '12121',
    LT_goal_banner: 'dasda',
    LT_goal_desc: 'bruh',
    LT_goal_name: 'I wanna be the very best',
    LT_goal_status: 'Ongoing'

  );
  

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 200,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  children: [
                    FocusedMenuHolder(
                      onPressed: () {},
                      animateMenuItems: false,
                      openWithTap: false,
                      menuItems: [
                        FocusedMenuItem(
                            title: Text("Update"),
                            onPressed: () {},
                            trailingIcon: Icon(Icons.update)),
                        FocusedMenuItem(
                            backgroundColor: Colors.red[600],
                            title: Text(
                              "Delete",
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {},
                            trailingIcon: Icon(
                              Icons.delete,
                              color: Colors.white,
                            )),
                      ],
                      child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.black87.withOpacity(0.2),
                                      width: 1),
                                  borderRadius: BorderRadius.circular(25),
                                  color: Colors.white),
                              child: Column(
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      goal.LT_goal_name.trim()[0].toUpperCase(),
                                      style: TextStyle(
                                          fontFamily: 'LexendDeca-Bold',
                                          fontSize: 32),
                                    ),
                                    height: 90,
                                    decoration: BoxDecoration(
                                      color: colors[
                                          Random().nextInt(colors.length)],
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(23),
                                          topRight: Radius.circular(23)),
                                    ),
                                  ),
                                  Container(
                                    width: 200,
                                    // color: Colors.green[100],
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 10),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          goal.LT_goal_name,
                                          style: TextStyle(
                                              fontSize: 10,
                                              fontFamily: 'LexendDeca-Bold'),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          'goal.LT_goal_desc',
                                          style: TextStyle(
                                              fontSize: 8,
                                              fontFamily: 'LexendDeca-Regular'),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.justify,
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ))),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget buildLT_Goals_noBanner(LT_goal LT_goal_info) {
  List<Color?> colors = [
    Colors.orange[400],
    Colors.purple[400],
    Colors.green[400]
  ];
  return FocusedMenuHolder(
    onPressed: () {},
    animateMenuItems: false,
    openWithTap: false,
    menuItems: [
      FocusedMenuItem(
          title: Text("Update"),
          onPressed: () {},
          trailingIcon: Icon(Icons.update)),
      FocusedMenuItem(
          backgroundColor: Colors.red[600],
          title: Text(
            "Delete",
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {},
          trailingIcon: Icon(
            Icons.delete,
            color: Colors.white,
          )),
    ],
    child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
            decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.black87.withOpacity(0.2), width: 1),
                borderRadius: BorderRadius.circular(25),
                color: Colors.white),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    'A',
                    style:
                        TextStyle(fontFamily: 'LexendDeca-Bold', fontSize: 32),
                  ),
                  height: 90,
                  decoration: BoxDecoration(
                    color: colors[Random().nextInt(colors.length)],
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(23),
                        topRight: Radius.circular(23)),
                  ),
                ),
                Container(
                  width: 200,
                  // color: Colors.green[100],
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Achieve aesthetic physique',
                        style: TextStyle(
                            fontSize: 10, fontFamily: 'LexendDeca-Bold'),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Bruh',
                        style: TextStyle(
                            fontSize: 8, fontFamily: 'LexendDeca-Regular'),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.justify,
                      )
                    ],
                  ),
                )
              ],
            ))),
  );
}
