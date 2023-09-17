import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Eights extends StatefulWidget {
  late String container;
  late AssetImage btn1;

  @override
  State<Eights> createState() => _Eights();

  Eights({
    Key? key,
  }) : super(key: key);
}

class _Eights extends State<Eights> {
  late User user;

  int counter=0;
  int tubState1=0;
  int tubState2=0;
  int tubState3=0;
  int tubState4=0;
  int tubState5=0;
  int tubCounter1=0;
  int tubCounter2=0;
  int tubCounter3=0;
  int tubCounter4=0;
  int tubCounter5=0;
  bool completed=false;
  AssetImage tub1=AssetImage("assets/0.png");
  AssetImage tub2=AssetImage("assets/0.png");
  AssetImage tub3=AssetImage("assets/0.png");
  AssetImage tub4=AssetImage("assets/0.png");
  AssetImage tub5=AssetImage("assets/0.png");
  AssetImage dialog=const AssetImage("assets/dialogue1.png");
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
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover, image: AssetImage("assets/page3.png"))),
      child: Column(
        children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
            width: 500,
            height: 100,
              margin: const EdgeInsets.only( top: 10),
            alignment: Alignment.topLeft,
            decoration:  BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fitWidth,
                    image: dialog)),
      ),    GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  width: 60,
                  height: 50,
                  padding: const EdgeInsets.all(5),
                  margin: const EdgeInsets.only(left: 60, top: 10),
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.fitHeight,
                          image: AssetImage("assets/quit.png"))),
                )),
          ],
        ),
          Row(
            children: [
              GestureDetector(
                  onTap: () {
                    if(tubState1!=3){
                      tubState1+=1;
                    }
                    else{
                      tubState1=0;
                    }

                    switch (tubState1){
                      case 0:
                        tub1= AssetImage("assets/0.png");
                        if (counter!=0){
                          counter-=tubCounter1;
                          tubCounter1=0;
                          print(counter);
                        }
                        break;
                      case 1:
                        tub1= AssetImage("assets/8.png");
                        counter-=tubCounter1;
                        counter+=8;
                        tubCounter1=8;
                        print(counter);
                        break;
                      case 2:
                        tub1=AssetImage("assets/88.png");
                        counter-=tubCounter1;
                        counter+=88;
                        tubCounter1=88;
                        print(counter);
                        break;
                      case 3:
                        tub1=AssetImage("assets/888.png");
                        counter-=tubCounter1;
                        counter+=888;
                        tubCounter1=888;
                        print(counter);
                        break;
                    }
                    setState(() {

                    });
                  },
                  child: Container(
                    width: 60,
                    height: 200,
                    padding: const EdgeInsets.all(5),
                    margin: const EdgeInsets.only(left: 60, top: 50),
                    alignment: Alignment.center,
                    decoration:  BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.fitHeight,
                            image: tub1)),
                  )),
              GestureDetector(
                  onTap: () {  if(tubState2!=3){
                    tubState2+=1;
                  }
                  else{
                    tubState2=0;
                  }

                  switch (tubState2){
                    case 0:
                      tub2= AssetImage("assets/0.png");
                      if (counter!=0){
                        counter-=tubCounter2;
                        tubCounter2=0;
                        print(counter);
                      }
                      break;
                    case 1:
                      tub2= AssetImage("assets/8.png");
                      counter-=tubCounter2;
                      counter+=8;
                      tubCounter2=8;
                      print(counter);
                      break;
                    case 2:
                      tub2=AssetImage("assets/88.png");
                      counter-=tubCounter2;
                      counter+=88;
                      tubCounter2=88;
                      print(counter);
                      break;
                    case 3:
                      tub2=AssetImage("assets/888.png");
                      counter-=tubCounter2;
                      counter+=888;
                      tubCounter2=888;
                      print(counter);
                      break;
                  }
                  setState(() {

                  });},
                  child: Container(
                    width: 60,
                    height: 200,
                    padding: const EdgeInsets.all(5),
                    margin: const EdgeInsets.only(left: 20, top: 50),
                    alignment: Alignment.center,
                    decoration:  BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.fitHeight,
                            image: tub2)),
                  )),
              GestureDetector(
                  onTap: () {  if(tubState3!=3){
                    tubState3+=1;
                  }
                  else{
                    tubState3=0;
                  }

                  switch (tubState3){
                    case 0:
                      tub3= AssetImage("assets/0.png");
                      if (counter!=0){
                        counter-=tubCounter3;
                        tubCounter3=0;
                        print(counter);
                      }
                      break;
                    case 1:
                      tub3= AssetImage("assets/8.png");
                      counter-=tubCounter3;
                      counter+=8;
                      tubCounter3=8;
                      print(counter);
                      break;
                    case 2:
                      tub3=AssetImage("assets/88.png");
                      counter-=tubCounter3;
                      counter+=88;
                      tubCounter3=88;
                      print(counter);
                      break;
                    case 3:
                      tub3=AssetImage("assets/888.png");
                      counter-=tubCounter3;
                      counter+=888;
                      tubCounter3=888;
                      print(counter);
                      break;
                  }
                  setState(() {

                  });},
                  child: Container(
                    width: 60,
                    height: 200,
                    padding: const EdgeInsets.all(5),
                    margin: const EdgeInsets.only(left:20, top: 50),
                    alignment: Alignment.center,
                    decoration:  BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.fitHeight,
                            image: tub3)),
                  )),
              GestureDetector(
                  onTap: () {  if(tubState4!=3){
                    tubState4+=1;
                  }
                  else{
                    tubState4=0;
                  }

                  switch (tubState4){
                    case 0:
                      tub4= AssetImage("assets/0.png");
                      if (counter!=0){
                        counter-=tubCounter4;
                        tubCounter4=0;
                        print(counter);
                      }
                      break;
                    case 1:
                      tub4= AssetImage("assets/8.png");
                      counter-=tubCounter4;
                      counter+=8;
                      tubCounter4=8;
                      print(counter);
                      break;
                    case 2:
                      tub4=AssetImage("assets/88.png");
                      counter-=tubCounter4;
                      counter+=88;
                      tubCounter4=88;
                      print(counter);
                      break;
                    case 3:
                      tub4=AssetImage("assets/888.png");
                      counter-=tubCounter4;
                      counter+=888;
                      tubCounter4=888;
                      print(counter);
                      break;
                  }
                  setState(() {

                  });},
                  child: Container(
                    width: 60,
                    height: 200,
                    padding: const EdgeInsets.all(5),
                    margin: const EdgeInsets.only(left: 20, top: 50),
                    alignment: Alignment.center,
                    decoration:  BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.fitHeight,
                            image:tub4)),
                  )),
              GestureDetector(
                  onTap: () {  if(tubState5!=3){
                    tubState5+=1;
                  }
                  else{
                    tubState5=0;
                  }

                  switch (tubState5){
                    case 0:
                      tub5= AssetImage("assets/0.png");
                      if (counter!=0){
                        counter-=tubCounter5;
                        tubCounter5=0;
                        print(counter);
                      }
                      break;
                    case 1:
                      tub5= AssetImage("assets/8.png");
                      counter-=tubCounter5;
                      counter+=8;
                      tubCounter5=8;
                      print(counter);
                      break;
                    case 2:
                      tub5=AssetImage("assets/88.png");
                      counter-=tubCounter5;
                      counter+=88;
                      tubCounter5=88;
                      print(counter);
                      break;
                    case 3:
                      tub5=AssetImage("assets/888.png");
                      counter-=tubCounter5;
                      counter+=888;
                      tubCounter5=888;
                      print(counter);
                      break;
                  }
                  setState(() {

                  });},
                  child: Container(
                    width: 60,
                    height: 200,
                    padding: const EdgeInsets.all(5),
                    margin: const EdgeInsets.only(left: 20, top: 50),
                    alignment: Alignment.center,
                    decoration:  BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.fitHeight,
                            image: tub5)),

                  )),
              GestureDetector(
                  onTap: () {

                      if (counter == 1000) {
                        dialog = AssetImage("assets/correct.png");
                        completed=true;
                      }
                      else {
                        print("here");
                        dialog = AssetImage("assets/wrong.png");
                      }
                      setState(() {

                      });

                  },
                  child: Container(
                    width: 150,
                    height: 50,
                    padding: const EdgeInsets.all(5),
                    margin: const EdgeInsets.only(left: 60, top: 50),
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.fitHeight,
                            image: AssetImage("assets/check.png"))),
                  )),
            ],
          ),
        ],
      ),
    );
  }

}
