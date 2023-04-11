import 'package:flutter/material.dart';

class BuildOnboarding extends StatelessWidget {
  String assetImage;
  String title;
  String desc;

  BuildOnboarding({required this.assetImage, required this.title, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 70,),
            Container(
              // color: Colors.orange[100],
              width: MediaQuery.of(context).size.width*0.9,
              child: Image.asset(
                assetImage,
              ),
            ),
            SizedBox(height: 50,),
            Text(
              title,
              style: TextStyle(
                  fontFamily: 'LexendDeca-Bold', fontSize: 22),
            ),
            SizedBox(
              height: 25,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                desc,
                style: TextStyle(
                    fontFamily: 'LexendDeca-Regular', fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 50,
            )
          ],
        ),
      ),
    );
  }
}
