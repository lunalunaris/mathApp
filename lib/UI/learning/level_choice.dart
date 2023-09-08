import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:math/UI/learning/learning.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../Database/sqliteHandler.dart';
import '../../generated/l10n.dart';

class LevelChoice extends StatefulWidget {
  const LevelChoice({
    Key? key,
  }) : super(key: key);

  @override
  State<LevelChoice> createState() => _LevelChoiceState();
}

class _LevelChoiceState extends State<LevelChoice> {
  late User? user;
  late Locale locale;
  bool connected=true;
  FirebaseFirestore db = FirebaseFirestore.instance;
  var levelList = {
    "Primary school 1-3": "0",
    "Primary school 4-6": "1",
    "Primary school  7-8": "2",
    "High school basic level": "3",
    "High school advanced level": "4"
  };
  var levelListPl = {
    "Szkoła podstawowa 1-3": "0",
    "Szkoła podstawowa 4-6": "1",
    "Szkoła podstawowa 7-8": "2",
    "Szkoła średnia poziom podstawowy": "3",
    "Skoła średnia poziom rozszerzony": "4"
  };
  SqliteHandler sql=SqliteHandler();

  selectLevel(String level) {
    addtoDb(levelList[level]!);
    if(connected) {
      addLevel(levelList[level]!);
    }
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const Learning()));
  }

  Future<void> addLevel(String level) async {
    db.collection("UserLevel").doc(user?.uid).set({"level": level});
  }
  addtoDb(String level)async{
    await sql.insertLevel(level);
  }

  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser;
    initConnect();
    super.initState();
  }

  initConnect() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none ||
        connectivityResult == ConnectivityResult.bluetooth) {
      connected = false;
    }
  }
  @override
  void didChangeDependencies() {
    locale = Localizations.localeOf(context);
    if (locale.languageCode.toString()=="pl") {
      levelList = levelListPl;
    }
    setState(() {});
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title:  Text(S.of(context).chooseLevel),
      ),
      body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.pink.shade500.withOpacity(0.8),
              Colors.teal.shade100.withOpacity(0.8),
            ],
            )
          ),
          child: Container(
              padding: const EdgeInsets.all(5),
              margin: const EdgeInsets.all(30),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.white.withOpacity(0.8),
              ),
              child: ListView(
                children: [
                  Container(padding: const EdgeInsets.all(10),alignment: Alignment.center,
                      child: Text(S.of(context).chooseClass, style:
                      TextStyle(fontSize: 20,
                          fontWeight: FontWeight.bold,color: Colors.teal.withOpacity(0.7)),)),
                  const Divider(height: 0,indent: 40, endIndent: 40,color: Colors.teal,),
              for (var i in  levelList.keys)
                  Column(
      children: [
                    ListTile(
      leading: const Icon(Icons.sailing_rounded),
      title: TextButton(
          onPressed: () {selectLevel(i);},
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                  Colors.white.withOpacity(0.1)),
              overlayColor: MaterialStateProperty.all(
                  Colors.pinkAccent.withOpacity(0.3)),
              shape: MaterialStateProperty.all<
                  RoundedRectangleBorder>(
                  const RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.all(Radius.circular(5)),
                  ))),
          child: Text(
            i,
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black54),
            textAlign: TextAlign.center,
          )),

    ),
    const Divider(height: 0),
    ])
     ] )
    )
    ),
    );
  }
}
//     Center(
// child: Column(
// mainAxisAlignment: MainAxisAlignment.center,
// children: [
// const Text(
// "Choose your class",
// style: TextStyle(
// fontSize: 30,
// fontWeight: FontWeight.bold,
// color: Colors.pink),
// ),
// const SizedBox(
// height: 30,
// ),
// Table(
// children: [
// for (var item in)
// TableRow(children: [
// ElevatedButton(
// onPressed: () {
// selectLevel(item);
// },
// style: ButtonStyle(
// padding:
// MaterialStateProperty.all<EdgeInsets>(
// const EdgeInsets.all(15)),
// backgroundColor:
// MaterialStateProperty.all(Colors.teal),
// shape: MaterialStateProperty.all<
//     RoundedRectangleBorder>(
// const RoundedRectangleBorder(
// borderRadius: BorderRadius.zero,
// ))),
// child: Text(
// item,
// softWrap: true,
// textAlign: TextAlign.center,
// style: const TextStyle(
// fontSize: 25,
// fontWeight: FontWeight.bold),
// ))
// ]),
// ],
// )
