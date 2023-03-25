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

  void feedPet(int pokemon_level, int pokemon_exp, int pokemon_food) async{
    DocumentReference doc = 
          FirebaseFirestore.instance
                .collection('users')
                .doc(widget.loggedInUser.userID)
                .collection('pokemon')
                .doc(widget.loggedInUser.userID);

            if (pokemon_food > 0) {
              await doc.update(
                  {'pokemon_food': pokemon_food - 10});
              if (pokemon_exp < 90) {
                await doc.update({
                  'pokemon_exp': pokemon_exp + 10,
                });
              } else {
                await doc.update({
                  'pokemon_exp': 0,
                  'pokemon_level': pokemon_level + 1
                });
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
                      child: Text('No data found.'),
                    );
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      int pokemon_level =
                          snapshot.data!.docs[index]['pokemon_level'];
                      int pokemon_exp =
                          snapshot.data!.docs[index]['pokemon_exp'];
                      int pokemon_food =
                          snapshot.data!.docs[index]['pokemon_food'];
                      // int max_level = 10;

                      return Column(
                        children: [
                          SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 30,
                                width: 30,
                                child: Image.asset('assets/apple.png'),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "${pokemon_food}",
                                style: TextStyle(
                                    fontFamily: 'LexendDeca-Bold',
                                    fontSize: 20),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Text(
                            "${widget.loggedInUser.username}'s pet",
                            style: TextStyle(
                                fontFamily: 'LexendDeca-Bold', fontSize: 22),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          (pokemon_level>0 && pokemon_level<5) ? //1,2,3,4,5
                          Center(
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.3,
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: Image.asset('assets/charmander.gif', fit: BoxFit.contain),
                            ),
                          )
                          : (pokemon_level>4 && pokemon_level<10) ? //6, 7, 8, 9, 10
                          Center(
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.3,
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: Image.asset('assets/charmeleon.gif', fit: BoxFit.contain),
                            ),
                          ) : (pokemon_level>9 && pokemon_level <15) ? //11,12,13,14,15
                          Center(
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.3,
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: Image.asset('assets/charizard_bb.gif', fit: BoxFit.contain,),
                            ),
                          ) :
                          Center(
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.4,
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: Image.asset('assets/charmelat.jpg'),
                            ),
                          ),
              
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Level ${pokemon_level}',
                            style: TextStyle(
                                fontFamily: 'LexendDeca-Bold', fontSize: 20),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25)),
                              child: LinearProgressIndicator(
                                color: Colors.green[400],
                                backgroundColor: Colors.grey[300],
                                value: pokemon_exp / 100,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
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
                                    fontFamily: 'LexendDeca-Bold',
                                    fontSize: 22),
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
