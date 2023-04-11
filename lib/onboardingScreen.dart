import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:test_app5/main.dart';
import 'package:test_app5/theme/app_colors.dart';
import 'test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class onBoardingScreen extends StatefulWidget {
  const onBoardingScreen({super.key});

  @override
  State<onBoardingScreen> createState() => _onBoardingScreenState();
}

class _onBoardingScreenState extends State<onBoardingScreen> {
  final controller = PageController();
  bool isLastPage = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        padding: EdgeInsets.only(bottom: 80),
        child: PageView(
          onPageChanged: (index){
            setState(() {
              isLastPage = index ==2;
            });
          },
          controller: controller,
          children: [
            BuildOnboarding(
                assetImage: 'assets/1080_1.png',
                title: "Personal Life Goals",
                desc: "Keep track of your Long-Term and Short-Term Goals"),
            BuildOnboarding(
                assetImage: 'assets/1080_2.png',
                title: "Goal Documentation",
                desc: "Keep track of your progress through documentations"),
            BuildOnboarding(
                assetImage: 'assets/1080.png',
                title: "Gamify your journey",
                desc:
                    "Evolve your Pet Companion! Earn Pet Food through Goal Completions!"),
          ],
        ),
      ),
      bottomSheet: isLastPage?
      TextButton(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0)
          ),
          backgroundColor: AppColors().red,
          minimumSize: Size.fromHeight(80)
        ),
        child: Text("Get Started", style: TextStyle(fontFamily: 'LexendDeca-Bold', fontSize: 20, color: Colors.white),),
        onPressed: ()async{
          final prefs = await SharedPreferences.getInstance();
          prefs.setBool('showMainPage', true);
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> MainPage()), (route) => false);
        },
      ):
      
      Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        height: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () => controller.previousPage(
                  curve: Curves.easeInOut,
                  duration: Duration(milliseconds: 200)),
              child: Text(
                "Back",
                style:
                    TextStyle(fontFamily: 'LexendDeca-Regular', fontSize: 16),
              ),
            ),
            Center(
              child: SmoothPageIndicator(
                controller: controller,
                count: 3,
                onDotClicked: (index)=> controller.jumpToPage(index),
              ),
            ),
            TextButton(
              onPressed: () => controller.nextPage(
                  curve: Curves.easeInOut,
                  duration: Duration(milliseconds: 200)),
              child: Text(
                "Next",
                style:
                    TextStyle(fontFamily: 'LexendDeca-Regular', fontSize: 16),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
