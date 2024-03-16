import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:test_app5/theme/app_colors.dart';
import 'Current_User.dart';
import 'ST_goal.dart';
import 'LT_goal.dart';

class open_image_screen extends StatefulWidget {
  String imageURL;
  String image_desc;
  String image_ID;
  Current_User loggedInUser;
  ST_goal ST_goal_info;
  LT_goal LT_goal_info;

  open_image_screen(
      {required this.image_ID,
      required this.image_desc,
      required this.imageURL,
      required this.loggedInUser,
      required this.ST_goal_info,
      required this.LT_goal_info});

  @override
  State<open_image_screen> createState() => _open_image_screenState();
}

class _open_image_screenState extends State<open_image_screen> {
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
                  SizedBox(height: 10),
                  Container(
                    height: 45,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors().red,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Confirm edit",
                              style: TextStyle(
                                color: Colors.white,
                                  fontFamily: 'LexendDeca-SemiBold',
                                  fontSize: 15)),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 15,
                            color: Colors.white,
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
  void dispose() {
    descriptionController.dispose();
    super.dispose();
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
              onPressed: () {
                descriptionController.text = imageDescDynamic;

                showUpdateDescriptionDialog(context, widget.image_ID);
              },
            )
          ],
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          toolbarHeight: 70,
        ),
        body: Container(
          // color: Colors.orange[100],
          child: Center(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: InteractiveViewer(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          imageUrl: widget.imageURL,
                          placeholder: (context, url) =>
                              Center(child: Container(height: 90, child: Image.asset('assets/loading.gif'),)),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      // color: Colors.blue[100],
                      child: Text(
                        imageDescDynamic,
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                            fontFamily: 'LexendDeca-Regular', fontSize: 14),
                      )),
                  SizedBox(
                    height: 25,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
