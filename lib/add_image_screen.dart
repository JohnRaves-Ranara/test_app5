import 'package:flutter/material.dart';
import 'Current_User.dart';
import 'Goal.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'theme/app_colors.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class add_image_screen extends StatefulWidget {
  final Goal goal;
  final Current_User loggedInUser;
  const add_image_screen({required this.goal, required this.loggedInUser});

  @override
  State<add_image_screen> createState() => _add_image_screenState();
}

class _add_image_screenState extends State<add_image_screen> {
  PlatformFile? pickedImage;
  File? compressedImage;
  String? imageDownloadURL;
  TextEditingController imageDescriptionController = TextEditingController();
  String compressedImagePath = "/storage/emulated/0/Download";

  Future<void> compressImage() async{
    if(pickedImage==null) return null;

    final compressedFile = await FlutterImageCompress.compressAndGetFile(pickedImage!.path!, "${compressedImagePath}/${pickedImage!.name}");

    if(compressedFile != null){
      setState(()=>{
        compressedImage = compressedFile,
        
      });
    }
  }




  Future upload() async {
    final path =
        '${widget.loggedInUser.userID}-${widget.loggedInUser.email}/${widget.goal.goal_name}/${pickedImage!.name}';
    final file = File(pickedImage!.path!);

    final storageRef = FirebaseStorage.instance.ref().child(path);
    compressImage();
    await storageRef.putFile(file);
    imageDownloadURL = await storageRef.getDownloadURL();
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    print("Firestore upload start");
    DocumentReference docImage = firebaseFirestore
        .collection('users')
        .doc(widget.loggedInUser.userID)
        .collection("goals")
        .doc(widget.goal.goal_id)
        .collection("images")
        .doc();

    final json = {
      'imageID' : docImage.id,
      'imageDownloadURL': imageDownloadURL,
      'image_Description': imageDescriptionController.text.trim()
    };
    docImage.set(json);
    print("Firestore upload finish");
    Navigator.pop(context);
  }

  Future<void> selectImage() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    setState(() {
      pickedImage = result.files.first;
    });
  }

  //validation popup 
  showValidationDialog(BuildContext context){
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Invalid"),
            content: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Please select an image.",
                    style:
                        TextStyle(fontFamily: 'LexendDeca-Regular', fontSize: 14),
                  ),
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
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
                                  "OK",
                                  style: TextStyle(
                                      fontFamily: 'LexendDeca-Regular', fontSize: 12),
                                ),
                                onPressed: () => { 
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
        backgroundColor: AppColors().red,
        title: Align(
          child: Text(
            "Add Image",
            style: TextStyle(fontFamily: 'LexendDeca-Regular'),
          ),
          alignment: Alignment.center,
        ),
        actions: [
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: AppColors().red,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50))),
              onPressed: () => {
                if(pickedImage==null){
                  showValidationDialog(context)
                }
                else{
                  upload()
                }
                },
              child: Text(
                "Done",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: 'LexendDeca-Regular'),
              ))
        ],
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            (pickedImage != null)
                ? Container(
                    clipBehavior: Clip.hardEdge,
                    constraints: BoxConstraints(maxHeight: 180, maxWidth: 200),
                    child: Image.file(
                      File(pickedImage!.path!),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  )
                : Container(
                    height: 200,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/upload.png')),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 40,
              width: MediaQuery.of(context).size.width / 3,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors().red,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25))),
                  child: Text(
                    "Select Image",
                    style: TextStyle(
                        fontFamily: 'LexendDeca-Regular', fontSize: 12),
                  ),
                  onPressed: () => {
                        selectImage(),
                      }),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                maxLines: 15,
                style:
                    TextStyle(fontFamily: 'LexendDeca-Regular', fontSize: 16),
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)),
                    hintText: "Image Description..."),
                controller: imageDescriptionController,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
