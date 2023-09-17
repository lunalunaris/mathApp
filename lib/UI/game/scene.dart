import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:math/UI/game/desk.dart';

class Scene extends StatefulWidget {
  late String container;
  late AssetImage btn1;
  @override
  State<Scene> createState() => _Scene();

  Scene({Key? key,}) : super(key: key);
}

class _Scene extends State<Scene> {
  late User user;
  int sceneKey = 0;
  int innerSceneKey = 0;

  @override
  void initState() {
    super.initState();
      user = FirebaseAuth.instance.currentUser!;

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      // DeviceOrientation.landscapeLeft,
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
              GestureDetector(
                  onTap: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Desk()));
                  },
                  child:  Container(

                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage("assets/page1.png"))),
                  ));
  }

}
