import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;
import '../../Model/User.dart';
import '../settings/settings.dart';

class Learning extends StatefulWidget {
  late User user;
  late String level;

  Learning({Key? key, required this.user}) : super(key: key);

  @override
  State<Learning> createState() => _Learning();
}

class _Learning extends State<Learning> {
  late User user;
  late String level;

  @override
  void initState() {
    user = widget.user;
    level = "test";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text("Learning"),
      ),
      body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(level,
            style: TextStyle(
                fontSize: 30, fontWeight: FontWeight.bold, color: Colors.pink))
      ])),
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
              label: "Setup",
            ),
          ],
          onTap: (option) {
            developer.log(option.toString());
            switch (option) {
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
          selectedItemColor: Colors.pink),
    );
  }
}
