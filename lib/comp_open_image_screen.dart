import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'Current_User.dart';
import 'ST_goal.dart';
import 'LT_goal.dart';

class comp_open_image_screen extends StatefulWidget {
  String imageURL;
  String image_desc;
  String image_ID;
  Current_User loggedInUser;
  ST_goal ST_goal_info;
  LT_goal LT_goal_info;

  comp_open_image_screen(
      {required this.image_ID,
      required this.image_desc,
      required this.imageURL,
      required this.loggedInUser,
      required this.ST_goal_info,
      required this.LT_goal_info});

  @override
  State<comp_open_image_screen> createState() => _comp_open_image_screenState();
}

class _comp_open_image_screenState extends State<comp_open_image_screen> {
  late String imageDescDynamic;
  TextEditingController descriptionController = TextEditingController();

  Future<void> getImageDescription() async {
    DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.loggedInUser.userID)
        .collection('longterm_goals')
        .doc(widget.LT_goal_info.LT_goal_ID)
        .collection('shortterm_goals')
        .doc(widget.ST_goal_info.ST_goal_ID)
        .collection('images')
        .doc(widget.image_ID)
        .get();

    if (docSnapshot.exists) {
      final data = docSnapshot.data()! as Map<String, dynamic>;
      setState(() {
        imageDescDynamic = data['image_desc'];
      });
    }
  }

  //UPDATE DESCRIPTION POPUP
  showUpdateDescriptionDialog(BuildContext context, imageID) {
    return showDialog(
        context: context,
        builder: ((context) {
          return AlertDialog(
            insetPadding: EdgeInsets.symmetric(horizontal: 10),
            title: Text(
              "Edit Image Description",
              style: TextStyle(fontFamily: 'LexendDeca-Regular'),
            ),
            contentPadding: EdgeInsets.all(15),
            content: SingleChildScrollView(
              reverse: true,
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: TextField(
                      textAlign: TextAlign.justify,
                      maxLines: 15,
                      style: TextStyle(
                          fontFamily: 'LexendDeca-Regular', fontSize: 14),
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15)),
                          hintText: "Description"),
                      controller: descriptionController,
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    height: 45,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Confirm edit",
                              style: TextStyle(
                                  fontFamily: 'LexendDeca-SemiBold',
                                  fontSize: 15)),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 15,
                          )
                        ],
                      ),
                      onPressed: () => {
                        updateImageDescription(
                            imageID, descriptionController.text.trim()),
                        getImageDescription(),
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

  Future updateImageDescription(String imageID, String description) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.loggedInUser.userID)
        .collection('longterm_goals')
        .doc(widget.LT_goal_info.LT_goal_ID)
        .collection('shortterm_goals')
        .doc(widget.ST_goal_info.ST_goal_ID)
        .collection('images')
        .doc(imageID)
        .update({'image_desc': description});
  }

  @override
  void initState() {
    super.initState();
    imageDescDynamic = widget.image_desc;

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(Icons.edit_note_rounded),
              onPressed: null,
            )
          ],
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          toolbarHeight: 70,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5,),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              // color: Colors.orange[100],
              child: InteractiveViewer(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl: widget.imageURL,
                        placeholder: (context, url) =>
                            Center(child: const CircularProgressIndicator()),
                      ),
                    ),
                  ),
            ),
            SizedBox(height: 25,),
            Flexible(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  // color: Colors.blue[100],
                  child: Text(imageDescDynamic, textAlign: TextAlign.justify, style: TextStyle(fontFamily: 'LexendDeca-Regular', fontSize: 14),)
                  ),
              ),
            ),
            SizedBox(height: 25,),
          ],
        ),
      ),
    );
  }
}
