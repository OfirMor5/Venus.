import 'dart:collection';

//import "package:collection/collection.dart";
import 'dart:convert';
import 'dart:math';

import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hera2/models/baby_name.dart';
import 'package:http/http.dart' as http;
import 'package:lite_rolling_switch/lite_rolling_switch.dart';

Future<List<BabyName>> fetchBabyNames(http.Client client) async {
  final response = await client.get(Uri.parse(
      'https://raw.githubusercontent.com/railsmechanic/firstnames-to-gender/master/names.json'));

  // Use the compute function to run parsePhotos in a separate isolate.
  return compute(parseBabyNames, response.body);
}

// A function that converts a response body into a List<Photo>.
List<BabyName> parseBabyNames(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<BabyName>((json) => BabyName.fromJson(json)).toList();
}

class BabyNamesScreen extends StatefulWidget {
  BabyNamesScreen({Key key}) : super(key: key);

  @override
  createState() => new _BabyNamesScreen();
}

class _BabyNamesScreen extends State<BabyNamesScreen> {
  bool _loaded = false;
  Future<SplayTreeMap<String, List<String>>> _listFuture;
  Future<SplayTreeMap<String, List<String>>> _babyNamesByGenderMap(
      bool isMale) async {
    var list = await fetchBabyNames(http.Client());
    var data = new SplayTreeMap<String, List<String>>();
    var byGender = list.where((element) =>
        element.country == 'us' &&
        element.gender == (isMale ? 'male' : 'female'));
    byGender.forEach((e) => {
          if (data[e.name[0]] == null) data[e.name[0]] = [],
          data[e.name[0]].add(e.name)
        });
    return data;
  }

  @override
  void initState() {
    super.initState();

    // initial load
    _loaded = false;
    _listFuture = _babyNamesByGenderMap(true);
  }

  void refreshList(bool isMale) {
    // reload
    setState(() {
      _listFuture = _babyNamesByGenderMap(isMale);
    });
  }

  @override
  Widget build(BuildContext context) {
    _loaded = false;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
            icon: FaIcon(FontAwesomeIcons.arrowLeft, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            }),
        actions: [
          IconButton(
            icon: const FaIcon(
              FontAwesomeIcons.dice,
              color: Colors.white,
            ),
            tooltip: 'Pick for me',
            onPressed: () async {
              var list = await _listFuture;
              final randomLetter = new Random();
              final randomName = new Random();
              int chosenPlace = randomLetter.nextInt(list.length);
              var listOfLetter = list.entries.elementAt(chosenPlace).value;
              var chosenName =
                  listOfLetter[randomName.nextInt(listOfLetter.length)];
              return showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('The chosen name is...'),
                  content: Text(chosenName),
                  actions: <Widget>[
                    TextButton(
                      style: ButtonStyle(
                        overlayColor: MaterialStateProperty.all(
                            Theme.of(context).primaryColor.withAlpha(40)),
                      ),
                      onPressed: () => Navigator.pop(context, 'Close'),
                      child: Text(
                        'Close',
                        style: TextStyle(
                          color: Colors.pink.shade200,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
        title: const Text('Baby Names Dictionary'),
      ),
      floatingActionButton: LiteRollingSwitch(
        //initial value
        value: true,
        textOn: 'Male',
        textOff: 'Female',
        colorOn: const Color(0xff5f9cf3), //74b4fc
        colorOff: const Color(0xfffd968b),
        iconOn: FontAwesomeIcons.mars,
        iconOff: FontAwesomeIcons.venus,
        textSize: 16.0,
        onChanged: (bool state) {
          if (_loaded) {
            print('Current State of SWITCH IS: $state');
            refreshList(state);
          }
          //Use it to manage the different states
        },
      ),
      body: FutureBuilder<SplayTreeMap<String, List<String>>>(
        future: _listFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          _loaded = snapshot.hasData;
          return snapshot.hasData
              ? ListView(
                  children: [
                    for (var entry in snapshot.data.entries)
                      ExpandablePanel(
                        theme: ExpandableThemeData(),
                        header: Container(
                          child: Padding(
                            child: Text(entry.key.toString().toUpperCase(),
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w600)),
                            padding: EdgeInsets.all(10),
                          ),
                        ),
                        collapsed: null,
                        expanded: Padding(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                for (var value in entry.value)
                                  Text(value,
                                      softWrap: true,
                                      style: TextStyle(fontSize: 17))
                              ]),
                          padding: EdgeInsets.only(left: 10),
                        ),
                      )
                  ],
                )
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
