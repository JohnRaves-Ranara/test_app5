import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:focused_menu/modals.dart';
import 'package:test_app5/open_image_screen.dart';
import 'Current_User.dart';
import 'LT_goal.dart';
import 'ST_goal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_image_screen.dart';
import 'comp_open_image_screen.dart';
import 'theme/app_colors.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class comp_documentation_screen extends StatefulWidget {
  final ST_goal goal;
  final Current_User loggedInUser;
  final LT_goal LT_goal_info;
  const comp_documentation_screen(
      {required this.goal,
      required this.loggedInUser,
      required this.LT_goal_info});

  @override
  State<comp_documentation_screen> createState() => _comp_documentation_screenState();
}

class _comp_documentation_screenState extends State<comp_documentation_screen> {
  //OPEN IMAGE POPUP
  openImage(BuildContext context, String imageURL, String imageDescription) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CachedNetworkImage(
                        placeholder: (context, url) => Center(child: Container(height: 90, child: Image.asset('assets/loading.gif'),),
                            ),
                        imageUrl: imageURL,
                        imageBuilder: ((context, imageProvider) => Container(
                              constraints: BoxConstraints(
                                  maxWidth: MediaQuery.of(context).size.width,
                                  maxHeight: 200),
                              decoration: BoxDecoration(
                                  image: DecorationImage(image: imageProvider)),
                            ))),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: EdgeInsets.all(15),
                      alignment: Alignment.topLeft,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.blue[300]!.withOpacity(0.1)),
                      height: MediaQuery.of(context).size.height / 4,
                      width: MediaQuery.of(context).size.width,
                      child: SingleChildScrollView(
                          child: Text(
                        "${imageDescription}",
                        style: TextStyle(
                            fontFamily: 'LexendDeca-Regular', fontSize: 12),
                      )),
                    )
                  ]),
            ),
          );
        });
  }

  decreaseImageCount() async {
    int? imageCount;
    DocumentSnapshot docSnap = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.loggedInUser.userID)
        .collection('longterm_goals')
        .doc(widget.LT_goal_info.LT_goal_ID)
        .get();

    if (docSnap.exists) {
      final data = docSnap.data()! as Map<String, dynamic>;
      setState(() {
        imageCount = data['image_count'];
      });
    }

    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.loggedInUser.userID)
        .collection('longterm_goals')
        .doc(widget.LT_goal_info.LT_goal_ID)
        .update({'image_count': imageCount! - 1});
  }

  deleteImage(String imageID) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.loggedInUser.userID)
        .collection('longterm_goals')
        .doc(widget.LT_goal_info.LT_goal_ID)
        .collection('shortterm_goals')
        .doc(widget.goal.ST_goal_ID)
        .collection('images')
        .doc(imageID)
        .delete();
    decreaseImageCount();
  }

  //DELETE DESCRIPTION POPUP
  showDeleteImageDialog(BuildContext context, imageID) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Delete Image?",
              style: TextStyle(fontFamily: 'LexendDeca-Regular'),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Are you sure you want to delete this image?",
                    style: TextStyle(
                        fontFamily: 'LexendDeca-Regular', fontSize: 14),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
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
                      SizedBox(
                        width: 20,
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
                                  fontFamily: 'LexendDeca-Regular',
                                  fontSize: 12),
                            ),
                            onPressed: () => {
                                  print(imageID),
                                  deleteImage(imageID),
                                  Navigator.pop(context)
                                }),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        actions: [
          Container(
            width: 90,
          ),
          Flexible(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: Align(
                  alignment: Alignment.center,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      'Documentation',
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
          SizedBox(
            height: 15,
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
                      Text(widget.goal.ST_goal_name,
                          style: TextStyle(
                              fontFamily: 'LexendDeca-Bold', fontSize: 10)),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        widget.goal.ST_goal_desc,
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
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.12,
                )
                // Container(
                //   width: MediaQuery.of(context).size.width * 0.35,
                //   height: MediaQuery.of(context).size.height * 0.12,
                //   child: OutlinedButton(
                //     style: OutlinedButton.styleFrom(
                //         side: BorderSide(width: 0.5, color: Colors.black87),
                //         shape: RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(15))),
                //     onPressed: null,
                //     child: Padding(
                //       padding: const EdgeInsets.symmetric(horizontal: 10),
                //       child: Column(
                //         mainAxisAlignment: MainAxisAlignment.center,
                //         children: [
                //           Icon(
                //             Icons.add,
                //             size: 30,
                //             color: Colors.black87,
                //           ),
                //           SizedBox(
                //             height: 5,
                //           ),
                //           Text(
                //             "ADD IMAGE",
                //             style: TextStyle(
                //                 fontSize: 10,
                //                 fontFamily: 'LexendDeca-Regular',
                //                 color: Colors.black87),
                //             textAlign: TextAlign.center,
                //           ),
                //         ],
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(widget.loggedInUser.userID)
                  .collection("longterm_goals")
                  .doc(widget.LT_goal_info.LT_goal_ID)
                  .collection("shortterm_goals")
                  .doc(widget.goal.ST_goal_ID)
                  .collection("images")
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: Container(height: 90, child: Image.asset('assets/loading.gif'),));
                } else if (!snapshot.hasData || snapshot.data!.size == 0) {
                  return (const Center(child: Text("No image/s uploaded.")));
                } else {
                  return MasonryGridView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      physics: BouncingScrollPhysics(),
                      itemCount: snapshot.data!.docs.length,
                      gridDelegate:
                          SliverSimpleGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2),
                      itemBuilder: (context, index) {
                        String imageURL =
                            snapshot.data!.docs[index]['image_URL'];
                        String imageID = snapshot.data!.docs[index]['image_ID'];
                        String imageDescription =
                            snapshot.data!.docs[index]['image_desc'];
                        return FocusedMenuHolder(
                          openWithTap: false,
                          onPressed: () => {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => comp_open_image_screen(
                                        image_ID: imageID,
                                        image_desc: imageDescription,
                                        imageURL: imageURL,
                                        loggedInUser: widget.loggedInUser,
                                        ST_goal_info: widget.goal,
                                        LT_goal_info: widget.LT_goal_info)))
                          },
                          menuItems: [],
                          child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CachedNetworkImage(
                                  imageUrl: imageURL,
                                  placeholder: (context, url) => Center(child: Container(height: 90, child: Image.asset('assets/loading.gif'),)),
                                ),
                              )),
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
