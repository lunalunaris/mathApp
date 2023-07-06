import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LevelChoice extends StatefulWidget{
  LevelChoice({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<LevelChoice> createState() => _LevelChoiceState();
}

class _LevelChoiceState extends State<LevelChoice>{
  @override
  void initState() {
    super.initState();
    }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
          ],
        ),
      ),
    );
  }
  }

