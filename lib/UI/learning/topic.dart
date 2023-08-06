import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:math/UI/learning/learning.dart';
import 'dart:developer' as developer;
import '../../Model/User.dart';
import '../settings/settings.dart';


class Topic extends StatefulWidget {
  late User user;
  late String level;
  @override
  State<Topic> createState() => _Topic();

  Topic({Key? key, required this.user})
      : super(key: key);


}

class _Topic extends State<Topic> {
  late User user;
  late String topic;

  @override
  void initState() {
    user = widget.user;
    topic = "test topic";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title:  Text(topic),
      ),
      body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
           Spacer(),
            ElevatedButton(onPressed:  (){Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Learning(user: user)));}, child: Text("Theory")),
            Spacer(),
            ElevatedButton(onPressed:  (){Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Learning(user: user)));}, child: Text("Practice")),
            Spacer(),
            ElevatedButton(onPressed:  (){Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Learning(user: user)));}, child: Text("Quiz"))
          ]

          )),
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.teal,

          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(

              icon: Icon(Icons.book),
              label: "Learn",
            ),
            BottomNavigationBarItem(
              backgroundColor: Colors.lime,
              icon: Icon(Icons.games),
              label: "Game",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label:"Setup",
            ),
          ],
          onTap: (option) {
            developer.log(option.toString());
            switch (option) {
              case 0:
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Learning(user: user)));
                break;
            // case 2:
            //   Navigator.of(context).pop();
            //   Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //           builder: (context) =>
            //               Game(user: user)));
            //   break;
              case 2:
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Settings(user: user)));
                break;
            }
          },

          selectedItemColor: Colors.pink),);
  }

}
