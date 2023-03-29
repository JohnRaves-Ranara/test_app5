import 'package:flutter/material.dart';

class test extends StatelessWidget {
  const test({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              height: 150,
              width: 170,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.black87, width: 0.5)),
              child: Column(
                children: [
                  Container(
                    height: 90,
                    width: 170,
                    decoration: BoxDecoration(
                      color: Colors.orange[100],
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                            image: NetworkImage(
                              
                                'https://firebasestorage.googleapis.com/v0/b/test-22c27.appspot.com/o/3HG6HYxcCORBnVt6TMgYXcUUIYB2-john%40gmail.com%2FTo%20Travel%20the%20world%2FIMG_20230210_233838.jpg?alt=media&token=22bd634c-4768-4ae0-a2f5-c13019ef1dfb'))),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Details", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),),
                        SizedBox(height: 5,),
                        Text("Details details detailsdetailsdetailsdetailsdetailsdetailsdetailsdetailsdetailsdetailsdetailsdetailsdetailsdetailsdetailsdetailsdetails", style: TextStyle(fontSize: 8), maxLines: 2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.justify,)
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
