import 'package:flutter/material.dart';
import 'package:focused_menu/modals.dart';
import 'Current_User.dart';
import 'Goal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_image_screen.dart';
import 'theme/app_colors.dart';
import 'package:focused_menu/focused_menu.dart';

class documentation_screen extends StatefulWidget {
  final Goal goal;
  final Current_User loggedInUser;
  const documentation_screen({required this.goal, required this.loggedInUser});

  @override
  State<documentation_screen> createState() => _documentation_screenState();
}

class _documentation_screenState extends State<documentation_screen> {
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
                    Container(
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width,
                          maxHeight: 200),
                      decoration: BoxDecoration(
                          image:
                              DecorationImage(image: NetworkImage(imageURL))),
                    ),
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

  Future deleteImage(String imageID)async{
    await FirebaseFirestore.instance
      .collection('users')
      .doc(widget.loggedInUser.userID)
      .collection('goals')
      .doc(widget.goal.goal_id)
      .collection('images')
      .doc(imageID)
      .delete();
  }

  Future updateImageDescription(String imageID, String description) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.loggedInUser.userID)
        .collection('goals')
        .doc(widget.goal.goal_id)
        .collection('images')
        .doc(imageID)
        .update({'image_Description': description});
  }
  //DELETE DESCRIPTION POPUP
  showDeleteImageDialog(BuildContext context, imageID) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Delete Image?", style: TextStyle(fontFamily: 'LexendDeca-Regular'),),
            content: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Are you sure you want to delete this image?",
                    style:
                        TextStyle(fontFamily: 'LexendDeca-Regular', fontSize: 14),
                  ),
                  SizedBox(height: 20,),
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
                                      fontFamily: 'LexendDeca-Regular', fontSize: 12),
                                ),
                                onPressed: () => {
                                      Navigator.pop(context)
                                    }),
                          ),
                          SizedBox(width: 20,),
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
                                onPressed: () => {
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
  //UPDATE DESCRIPTION POPUP
  showUpdateDescriptionDialog(BuildContext context, imageID) {
    TextEditingController descriptionController = TextEditingController();

    return showDialog(
        context: context,
        builder: ((context) {
          return AlertDialog(
            title: Text("Edit Description", style: TextStyle(fontFamily: 'LexendDeca-Regular'),),
            content: SingleChildScrollView(
              reverse: true,
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextField(
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
                    width: MediaQuery.of(context).size.width,
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
                                  fontFamily: 'LexendDeca-SemiBold', fontSize: 15)),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 15,
                          )
                        ],
                      ),
                      onPressed: () => {
                        updateImageDescription(
                            imageID, descriptionController.text.trim()),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Container(
        height: 75,
        width: 75,
        child: FloatingActionButton(
          backgroundColor: AppColors().red,
          child: Icon(Icons.add),
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => add_image_screen(
                      goal: widget.goal, loggedInUser: widget.loggedInUser))),
        ),
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  "${widget.goal.goal_name}",
                  maxLines: 2,
                  style: TextStyle(
                      fontSize: 30,
                      fontFamily: 'Montserrat-Bold',
                      overflow: TextOverflow.ellipsis),
                )),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.goal.goal_description!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 16, fontFamily: 'LexendDeca-ExtraLight'),
                )),
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(widget.loggedInUser.userID)
                  .collection("goals")
                  .doc(widget.goal.goal_id)
                  .collection("images")
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return (const Center(child: Text("No image/s uploaded.")));
                } else {
                  return GridView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: snapshot.data!.docs.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2),
                      itemBuilder: (context, index) {
                        String imageURL =
                            snapshot.data!.docs[index]['imageDownloadURL'];
                        String imageID = snapshot.data!.docs[index]['imageID'];
                        String imageDescription =
                            snapshot.data!.docs[index]['image_Description'];
                        return FocusedMenuHolder(
                          openWithTap: false,
                          onPressed: () => {},
                          menuItems: [
                            FocusedMenuItem(
                              title: Text('Edit Description', style: TextStyle(fontFamily: 'LexendDeca-Regular'),),
                              trailingIcon: Icon(Icons.update),
                              onPressed: () => {
                                showUpdateDescriptionDialog(context, imageID)
                              },
                            ),
                            FocusedMenuItem(
                              title: Text('Delete', style: TextStyle(color: Colors.white, fontFamily: 'LexendDeca-Regular'),),
                              backgroundColor: AppColors().red,
                              trailingIcon: Icon(Icons.delete),
                              onPressed: () => {
                                showDeleteImageDialog(context, imageID)
                              },
                            ),
                            
                          ],
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                                borderRadius: BorderRadius.circular(10),
                                onTap: () => {
                                      openImage(
                                          context, imageURL, imageDescription)
                                    },
                                child: Container(
                                  height: 100,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                          image: NetworkImage(imageURL),
                                          fit: BoxFit.cover)),
                                )),
                          ),
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
