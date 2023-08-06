import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:math/UI/learning/learning.dart';
import 'dart:developer' as developer;
import '../../Model/User.dart';
import '../settings/settings.dart';

class Theory extends StatefulWidget {
  late User user;
  late String level;
  @override
  State<Theory> createState() => _Theory();

  Theory({Key? key, required this.user})
      : super(key: key);

}

class _Theory extends State<Theory> {
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
    //switch this for photos from db
    var list = ["https://64.media.tumblr.com/8ebfaf7d9b0f82b1536796d0e0bf525d/cbcc0cd57983521e-a9/s540x810/8d19a8310eae32bedf86c5d2cff8aa3295b61b1e.pnj",
      "https://64.media.tumblr.com/1c8a683577b5d33ba638645b60d56c76/fc419cb40728c877-0b/s640x960/bb0236f0461906dc61447227766a837c054c58eb.pnj",
      "https://64.media.tumblr.com/4f7ad6796da4281f2c908d6572992cc4/6e83c5459b64ae53-84/s540x810/7e7774f16f7ee1ab1c0d03e676e353c70b1bc869.pnj"];
    final PageController controller = PageController();
    return Scaffold(
      appBar: AppBar(
        title:  Text(topic),
      ),
      body:
     PageView(
      /// [PageView.scrollDirection] defaults to [Axis.horizontal].
      /// Use [Axis.vertical] to scroll vertically.
      controller: controller,
      children:  <Widget>[
        for(var i in list)
          Center(
            child: Image.network(i),
          ),

      ],
    )
    );
  }

}
