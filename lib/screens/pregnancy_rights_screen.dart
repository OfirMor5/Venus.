import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hera2/utils/junk_data.dart' as junk;

class PregnancyRightsScreen extends StatefulWidget {
  PregnancyRightsScreen({Key key}) : super(key: key);

  @override
  createState() => new _PregnancyRightsScreen();
}

class _PregnancyRightsScreen extends State<PregnancyRightsScreen> {
  Map<String, List<String>> hospitals = junk.getPregnancyRightsMap();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
              icon: FaIcon(FontAwesomeIcons.arrowLeft, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              }),
          title: const Text('Pregnancy rights'),
        ),
        body: ListView(
          children: [
            for (var entries in hospitals.entries)
              ExpandablePanel(
                theme: ExpandableThemeData(),
                header: Container(
                  child: Padding(
                    child: Text(entries.key,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600)),
                    padding: EdgeInsets.all(10),
                  ),
                ),
                collapsed: null,
                expanded: Padding(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (var val in entries.value)
                          Text(val,
                              softWrap: true, style: TextStyle(fontSize: 15))
                      ]),
                  padding: EdgeInsets.only(left: 10),
                ),
              )
          ],
        ));
  }
}
