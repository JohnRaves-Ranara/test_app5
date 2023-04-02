import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_app5/main.dart';
import 'Current_User.dart';
import 'LT_goal.dart';
import 'ST_goal.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'theme/app_colors.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class add_image_screen extends StatefulWidget {
  final ST_goal goal;
  final LT_goal LT_goal_info;
  final Current_User loggedInUser;
  const add_image_screen(
      {required this.goal,
      required this.loggedInUser,
      required this.LT_goal_info});

  @override
  State<add_image_screen> createState() => _add_image_screenState();
}

class _add_image_screenState extends State<add_image_screen> {
  File? pickedImage;
  File? compressedImage;
  String? imageDownloadURL;
  bool isUploading = false;
  TextEditingController imageDescriptionController = TextEditingController();
  String compressedImagePath = "/storage/emulated/0/Download";

  @override
  void dispose() {
    imageDescriptionController.dispose();
    super.dispose();
  }

  Future<Uint8List> compressImage(File file) async {
    print("Original image file size: ${await file.length()}");
    Uint8List imageBytes = await file.readAsBytes();
    final Uint8List compressedFile =
        await FlutterImageCompress.compressWithList(imageBytes, quality: 20);
    print("Compressed image file size: ${compressedFile.length}");
    return compressedFile;
  }

  addImageCount() async {
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
        .update({'image_count': imageCount! + 1});
  }

  Future upload(BuildContext context) async {
    setState(() {
      isUploading = true;
    });
    final path =
        '${widget.loggedInUser.userID}-${widget.loggedInUser.email}/${widget.goal.ST_goal_name}-${widget.goal.ST_goal_ID}/${basename(pickedImage!.path)}';
    final file = File(pickedImage!.path);
    final storageRef = FirebaseStorage.instance.ref().child(path);

    //compress image
    final compressedImageFile = await compressImage(file);

    //upload image
    await storageRef.putData(compressedImageFile);
    // print("Image Quality 100: ${await file.length()}");
    // await storageRef.putFile(file);
    String imageDownloadURL = await storageRef.getDownloadURL();

    final DocumentReference doc = FirebaseFirestore.instance
        .collection("users")
        .doc(widget.loggedInUser.userID)
        .collection("longterm_goals")
        .doc(widget.LT_goal_info.LT_goal_ID)
        .collection("shortterm_goals")
        .doc(widget.goal.ST_goal_ID)
        .collection("images")
        .doc();

    final json = {
      'image_ID': doc.id,
      'image_URL': imageDownloadURL,
      'image_desc': imageDescriptionController.text.trim(),
      'creationDate': DateTime.now().toString()
    };

    doc.set(json);
    await addImageCount();
    setState(() {
      isUploading = false;
    });
    Navigator.pop(context);
  }

  Future<void> selectImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      final imageTemp = File(image.path);
      setState(() => this.pickedImage = imageTemp);
    } on PlatformException catch (e) {
      print("Failed to pick image: ${e} ");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        toolbarHeight: 70,
        title: Text(
          "Add Image",
          style: TextStyle(
              fontFamily: 'LexendDeca-Bold', fontSize: 18, color: Colors.black),
        ),
        actions: [
          (pickedImage!=null)?
          Container(
            padding: EdgeInsets.symmetric(horizontal: 7),
            child: IconButton(
                splashColor: Colors.grey,
                onPressed: isUploading ? null : () {upload(context);},
                icon: Icon(
                  Icons.check,
                  size: 30,
                )),
          )
          :
          Container(
            padding: EdgeInsets.symmetric(horizontal: 7),
            child: IconButton(
                splashColor: Colors.grey,
                onPressed: null,
                icon: Icon(
                  Icons.check,
                  size: 30,
                )),
          )
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
                      File(pickedImage!.path),
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
              child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.black87, width: 0.5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25))),
                  child: Text(
                    "Select Image",
                    style: TextStyle(
                        fontFamily: 'LexendDeca-Regular',
                        fontSize: 12,
                        color: Colors.black),
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
                maxLines: 16,
                style:
                    TextStyle(fontFamily: 'LexendDeca-Regular', fontSize: 14),
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
