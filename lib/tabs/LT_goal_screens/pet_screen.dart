import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:test_app5/Current_User.dart';

class pet_screen extends StatefulWidget {
  final Current_User loggedInUser;
  final Current_User? curr_User;

  pet_screen({required this.loggedInUser, this.curr_User});

  @override
  State<pet_screen> createState() => _pet_screenState();
}

class _pet_screenState extends State<pet_screen> {
  @override
  void initState() {
    super.initState();
    // getPokemonName();
  }

  void feedPet(int pokemon_level, int pokemon_exp, int pokemon_food) async {
    DocumentReference doc = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.loggedInUser.userID)
        .collection('pokemon')
        .doc(widget.loggedInUser.userID);

    if (pokemon_level != 4) {
      if (pokemon_food >= 10) {
        await doc.update({'pokemon_food': pokemon_food - 10});
        if (pokemon_exp < 90) {
          await doc.update({
            'pokemon_exp': pokemon_exp + 10,
          });
        } else {
          await doc
              .update({'pokemon_exp': 0, 'pokemon_level': pokemon_level + 1});
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Column(
      children: [
        Expanded(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(widget.loggedInUser.userID)
                .collection('pokemon')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: Container(height: 90, child: Image.asset('assets/loading.gif'),));
              }
              return ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  int pokemon_level =
                      snapshot.data!.docs[index]['pokemon_level'];
                  int pokemon_exp = snapshot.data!.docs[index]['pokemon_exp'];
                  int pokemon_food = snapshot.data!.docs[index]['pokemon_food'];
                  return Column(
                    children: [
                      // SizedBox(
                      //   height: 20,
                      // ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     Container(
                      //       height: 40,
                      //       width: 40,
                      //       child: Image.asset('assets/apple_pixel.png'),
                      //     ),
                      //     SizedBox(
                      //       width: 10,
                      //     ),
                      //     Text(
                      //       "${pokemon_food}",
                      //       style: TextStyle(
                      //           fontFamily: 'LexendDeca-Bold', fontSize: 20),
                      //     ),
                      //   ],
                      // ),
                      SizedBox(
                        height: 50,
                      ),
                      Text(
                        "${widget.loggedInUser.username}'s pet",
                        style: TextStyle(
                            fontFamily: 'LexendDeca-Bold', fontSize: 34, color: Colors.grey[350]),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      (pokemon_level==1)
                          ? //1,2,3
                          Container(
                              // color: Colors.blue[100],
                              height: MediaQuery.of(context).size.height * 0.3,
                              width: double.infinity,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    // color: Colors.orange[100],
                                    height: MediaQuery.of(context).size.height *
                                        0.2,
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                    child: Image.asset(
                                        'assets/${widget.curr_User!.pet_name}lvl1.gif',
                                        fit: BoxFit.contain),
                                  ),
                                ],
                              ),
                            )
                          : (pokemon_level==2)
                              ? //4,5,6
                              Container(
                                  // color: Colors.blue[100],
                                  height:
                                      MediaQuery.of(context).size.height * 0.3,
                                  width: double.infinity,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        // color: Colors.orange[100],
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.3,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.75,
                                        child: Image.asset(
                                            'assets/${widget.curr_User!.pet_name}lvl2.gif',
                                            fit: BoxFit.contain),
                                      ),
                                    ],
                                  ),
                                )
                              : (pokemon_level==3)
                                  ? //7,8,9
                                  Container(
                                      // color: Colors.blue[100],
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.3,
                                      width: double.infinity,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            // color: Colors.orange[100],
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.3,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.75,
                                            child: Image.asset(
                                                'assets/${widget.curr_User!.pet_name}lvl3.gif',
                                                fit: BoxFit.contain),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Container(
                                      // color: Colors.blue[100],
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.3,
                                      width: double.infinity,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            // color: Colors.orange[100],
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.3,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.75,
                                            child: Image.asset(
                                                'assets/${widget.curr_User!.pet_name}lvl4.gif',
                                                fit: BoxFit.contain),
                                          ),
                                        ],
                                      ),
                                    ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.8),
                        // color: Colors.orange[100],
                        child: Column(
                          children: [
                            Container(
                              height: 30,
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25)),
                                child: LinearProgressIndicator(
                                  color: Colors.blue[700],
                                  backgroundColor: Colors.grey[300],
                                  value: (pokemon_level != 10)
                                      ? pokemon_exp / 100
                                      : 0,
                                ),
                              ),
                            ),
                            SizedBox(height:5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  (pokemon_level !=4)
                                      ? 'Lvl. ${pokemon_level}'
                                      : 'Lvl. MAX',
                                  style: TextStyle(
                                      fontFamily: 'LexendDeca-Regular',
                                      fontSize: 14),
                                ),
                                Text(
                                  "${pokemon_exp}/100",
                                  style: TextStyle(
                                      fontFamily: 'LexendDeca-Regular',
                                      fontSize: 14),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 55,),
                      Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width * 0.75,
                        child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                                backgroundColor: Colors.white,
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            onPressed: () async {
                              feedPet(pokemon_level, pokemon_exp, pokemon_food);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Feed",
                                  style: TextStyle(
                                      fontFamily: 'LexendDeca-Bold',
                                      fontSize: 14,
                                      color: Colors.black),
                                ),
                                Container(
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 20,
                                        width: 30,
                                        child: Image.asset(
                                            'assets/apple_pixel.png'),
                                      ),
                                      Text(
                                        "x10",
                                        style: TextStyle(
                                            fontFamily: 'LexendDeca-Bold',
                                            fontSize: 14,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            )),
                      )
                    ],
                  );
                },
              );
            },
          ),
        ),
      ],
    ));
  }
}
