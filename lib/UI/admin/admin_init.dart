import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:math/UI/admin/section_choice_admin.dart';

import '../../generated/l10n.dart';

class AdminInit extends StatefulWidget {
  AdminInit({
    Key? key,
  }) : super(key: key);

  @override
  State<AdminInit> createState() => _AdminInitState();
}

class _AdminInitState extends State<AdminInit> {
  late User? user;

  FirebaseFirestore db = FirebaseFirestore.instance;
  final sectionController = TextEditingController();
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
  var languageList = {"English": "en", "Polish": "pl"};
  var languageListPl = {"Angielski": "en", "Polski": "pl"};
  var typeListPl = {
    "rozdział": "0",
    "temat": "1",
    "teoria": "2",
    "nauka": "3",
    "quiz": "4",
    "quiz rozdziału": "5"
  };
  var typeList = {
    "section": "0",
    "topic": "1",
    "theory": "2",
    "practice": "3",
    "quiz": "4",
    "section quiz": "5"
  };
  String typeDropdown = "";
  String classDropdown = "";
  String langDropdown = "";
  bool connected = true;
  late Locale locale;
  bool flag = false;
  TextEditingController controller = TextEditingController();
  int levelIndex = 99;
  int langIndex = 99;
  int typeIndex = 99;

  next(BuildContext context) {
    if (typeIndex == 0) {
      showSectionDialog(context);
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SectionChoice(
                  level: levelList.values.elementAt(langIndex),
                  lang: languageList.values.elementAt(langIndex),
                  type: typeList.values.elementAt(typeIndex))));
    }
  }

  Future<void> addSection() async {
    try {
      db.collection("Section").add({
        "lang": languageList.values.elementAt(langIndex),
        "name": sectionController.text,
        "level": levelList.values.elementAt(levelIndex)
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.of(context).sectionSubmittedSuccessfully)));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.of(context).submissionFailed)));
    }

    sectionController.text = "";
  }

  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser;
    initConnect();
    initTables();
    super.initState();
  }

  initConnect() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none ||
        connectivityResult == ConnectivityResult.bluetooth) {
      connected = false;
    }
  }

  initTables() async {}

  @override
  void didChangeDependencies() {
    locale = Localizations.localeOf(context);
    if (locale.languageCode.toString() == "pl") {
      typeList = typeListPl;
      levelList = levelListPl;
      languageList = languageListPl;
    }
    setState(() {});
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(S.of(context).dataImport),
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
          )),
          child: Container(
              padding: const EdgeInsets.all(5),
              margin: const EdgeInsets.all(30),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.white.withOpacity(0.8),
              ),
              child: buildPicker())),
    );
  }

  Column buildPicker() {
    return Column(
      children: [
        Container(
            margin: const EdgeInsets.all(20),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(S.of(context).chooseLevel),
                ),
                Wrap(
                  alignment: WrapAlignment.spaceEvenly,
                  children: [
                    for (var i = 0; i < levelList.keys.length; i++)
                      ChoiceChip(
                          label: Text(levelList.keys.elementAt(i)),
                          selected: levelIndex == i,
                          selectedColor: Colors.teal,
                          backgroundColor: Colors.pink,
                          labelStyle: const TextStyle(color: Colors.white),
                          onSelected: (bool value) {
                            setState(() {
                              levelIndex = i;
                            });
                          }),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(S.of(context).chooseLanguage),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    for (var i = 0; i < languageList.keys.length; i++)
                      ChoiceChip(
                          label: Text(languageList.keys.elementAt(i)),
                          selected: langIndex == i,
                          selectedColor: Colors.teal,
                          backgroundColor: Colors.pink,
                          labelStyle: const TextStyle(color: Colors.white),
                          onSelected: (bool value) {
                            setState(() {
                              langIndex = i;
                            });
                          })
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(S.of(context).chooseDataType),
                ),
                Wrap(
                  alignment: WrapAlignment.spaceEvenly,
                  children: [
                    for (var i = 0; i < typeList.keys.length; i++)
                      ChoiceChip(
                          label: Text(typeList.keys.elementAt(i)),
                          selected: typeIndex == i,
                          selectedColor: Colors.teal,
                          backgroundColor: Colors.pink,
                          labelStyle: const TextStyle(color: Colors.white),
                          onSelected: (bool value) {
                            setState(() {
                              typeIndex = i;
                            });
                          })
                  ],
                )
              ],
            )),
        ElevatedButton(
            style: ButtonStyle(
                backgroundColor: connected == true
                    ? MaterialStateProperty.all(Colors.pink)
                    : MaterialStateProperty.all(Colors.blueGrey)),
            onPressed: () {
              if (!connected) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(S.of(context).noInternetConnection)));
              } else {
                if (levelIndex != 99 && langIndex != 99 && typeIndex != 99) {
                  next(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(S.of(context).chooseFromAllCategories)));
                }
              }
            },
            child: Text(S.of(context).next))
      ],
    );
  }

  showSectionDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(
                  20.0,
                ),
              ),
            ),
            contentPadding: const EdgeInsets.only(
              top: 10.0,
            ),
            content: SizedBox(
              height: 140,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      obscureText: false,
                      enableSuggestions: false,
                      autocorrect: false,
                      controller: sectionController,
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          hintText: S.of(context).sectionName),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        if (connected) {
                          addSection();
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(S.of(context).sectionSubmitted)));
                        }
                      },
                      child: Text(S.of(context).submit))
                ],
              ),
            ),
          );
        });
  }
}
