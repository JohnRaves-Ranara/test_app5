import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:test_app5/Current_User.dart';
import 'package:google_fonts/google_fonts.dart';

class pet_screen extends StatefulWidget {
  final Current_User loggedInUser;

  pet_screen({required this.loggedInUser});

  @override
  State<pet_screen> createState() => _pet_screenState();
}

class _pet_screenState extends State<pet_screen> {

  void feedPet(int pokemon_level, int pokemon_exp, int pokemon_food) async {
    DocumentReference doc = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.loggedInUser.userID)
        .collection('pokemon')
        .doc(widget.loggedInUser.userID);

    if (pokemon_level != 10) {
      if (pokemon_food >=10) {
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
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  int pokemon_level =
                      snapshot.data!.docs[index]['pokemon_level'];
                  int pokemon_exp = snapshot.data!.docs[index]['pokemon_exp'];
                  int pokemon_food = snapshot.data!.docs[index]['pokemon_food'];

                  String pokemon_name = widget.loggedInUser.pet_name;

                  return Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 40,
                            width: 40,
                            child: Image.asset('assets/apple_pixel.png'),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "${pokemon_food}",
                            style: TextStyle(
                                fontFamily: 'LexendDeca-Bold', fontSize: 20),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Text(
                        "${widget.loggedInUser.username}'s pet",
                        style: TextStyle(
                            fontFamily: 'LexendDeca-Bold', fontSize: 22),
                      ),
                      SizedBox(height: 20,),
                      (pokemon_level > 0 && pokemon_level < 4)
                          ? //1,2,3
                          Center(
                              child: Container(
                                // color: Colors.blue[100],
                                height: MediaQuery.of(context).size.height * 0.3,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      // color: Colors.orange[100],
                                      height: MediaQuery.of(context).size.height * 0.18,
                                      child: Image.asset(
                                          'assets/${pokemon_name}lvl1.gif',
                                          fit: BoxFit.contain),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : (pokemon_level > 3 && pokemon_level < 7)
                              ? //4,5,6
                              Center(
                                  child: Container(
                                    // color: Colors.orange[100],
                                    height: MediaQuery.of(context).size.height *
                                        0.28,
                                    child: Image.asset(
                                        'assets/${pokemon_name}lvl2.gif',
                                        fit: BoxFit.contain),
                                  ),
                                )
                              : (pokemon_level > 6 && pokemon_level < 10)  ? //7,8,9
                                  Center(
                                      child: Container(
                                        // color: Colors.orange[100],
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.28,
                                    
                                        child: Image.asset(
                                          'assets/${pokemon_name}lvl3.gif',
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    )
                                  : Center(                  //10
                                      child: Container(
                                        // color: Colors.orange[100],
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.28,
                                   
                                        child: Image.asset(
                                            'assets/${pokemon_name}lvl4.gif',
                                            fit: BoxFit.contain,
                                            ),
                                      ),
                                    ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        (pokemon_level != 10)
                            ? 'Level ${pokemon_level}'
                            : 'Level MAX',
                        style: TextStyle(
                            fontFamily: 'LexendDeca-Bold', fontSize: 20),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                          child: LinearProgressIndicator(
                            color: Colors.green[400],
                            backgroundColor: Colors.grey[300],
                            value: (pokemon_level!=10) ? pokemon_exp / 100 : 0,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25))),
                          onPressed: () async {
                            feedPet(pokemon_level, pokemon_exp, pokemon_food);
                          },
                          child: Text(
                            "Feed",
                            style: TextStyle(
                                fontFamily: 'LexendDeca-Bold', fontSize: 22),
                          ),
                        ),
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
