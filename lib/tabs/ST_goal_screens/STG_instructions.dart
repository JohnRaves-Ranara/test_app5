import 'package:flutter/material.dart';
import 'comp_ST_goals_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class STG_instructions extends StatelessWidget {
  STG_instructions({super.key});

  var controller = PageController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Container(
            // color: Colors.orange[100],
            height: MediaQuery.of(context).size.height,
            child: PageView(
              controller: controller,
              children: [
                Container(
                    child: Image.asset('assets/STG_instruction_0-min.jpg',
                        fit: BoxFit.contain)),
                Container(
                    child: Image.asset('assets/STG_instruction_1-min.jpg',
                        fit: BoxFit.contain)),
                Container(
                    child: Image.asset('assets/STG_instruction_2-min.jpg',
                        fit: BoxFit.contain)),
                Container(
                    child: Image.asset('assets/STG_instruction_3-min.jpg',
                        fit: BoxFit.contain)),
              ],
            ),
          ),
        ),
        bottomSheet: Container(
          // color: Colors.orange[100],
          height: 50,
          child: Center(
              child: SmoothPageIndicator(
            controller: controller,
            count: 4,
          )),
        ),
      ),
    );
  }
}
