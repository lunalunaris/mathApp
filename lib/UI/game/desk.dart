import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:math/UI/game/eights.dart';

class Desk extends StatefulWidget {
  late String container;
  late AssetImage btn1;
  @override
  State<Desk> createState() => _Desk();

  Desk({Key? key,}) : super(key: key);
}

class _Desk extends State<Desk> {
  late User user;
  int sceneKey = 0;
  int innerSceneKey = 0;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser!;

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  dispose() {
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.landscapeRight,
    //   DeviceOrientation.landscapeLeft,
    //   DeviceOrientation.portraitUp,
    //   DeviceOrientation.portraitDown,
    // ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return
                 Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage("assets/page22.png"))),
                   child: Row(
                     children: [
                       GestureDetector(
                           onTap: (){
                             Navigator.push(
                                 context,
                                 MaterialPageRoute(
                                     builder: (context) =>
                                         Eights()));
                           },
                           child:  Container(
                             width: 200,
                             height: 150,
                             padding: const EdgeInsets.all(8),
                             margin: const EdgeInsets.only(left: 100,top: 30),
                             alignment: Alignment.center,
                             decoration: const BoxDecoration(
                                 borderRadius:
                                 BorderRadius.all(Radius.circular(10)),
                                 image: DecorationImage(
                                     fit: BoxFit.cover,
                                     image: AssetImage("assets/bottles.png"))),
                           )),
                     ],
                   ),

    );
  }

}
