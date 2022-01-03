import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hera2/models/user_details.dart';
import 'package:hera2/utils/router.dart' as router;

class DueDateScreen extends StatefulWidget {
  final bool isPoppable;
  DueDateScreen({Key key, @required this.isPoppable}) : super(key: key);

  @override
  createState() => new _DueDateScreen();
}

class _DueDateScreen extends State<DueDateScreen> {
  DateTime _chosenDateTime;
  DateTime _min, _initial;
  @override
  void initState() {
    super.initState();
    DateTime now = new DateTime.now();
    _min = new DateTime(now.year, now.month, now.day + 30);
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get()
        .then((value) {
      if (value.data().containsKey('dueDate')) {
        _initial = UserDetails.fromMap(value.data()).dueDate;
      } else {
        _initial = _min;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    AppBar appBar = widget.isPoppable
        ? AppBar(
            leading: IconButton(
                icon: FaIcon(FontAwesomeIcons.arrowLeft, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                }),
            elevation: 0,
          )
        : null;
    return Scaffold(
      appBar: appBar,
      body: Column(
        children: [
          Container(
            child: Center(
              child: Column(
                children: [
                  SizedBox(
                    height: (appBar != null)
                        ? 100 - appBar.preferredSize.height
                        : 100,
                  ),
                  Text(
                    "Mommy,", //\nWhen will we see each other?",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  Text(
                    "When will we see each other?",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  SizedBox(
                    height: 100,
                  ),
                  Divider(
                    color: Color(0xfffd968b),
                    height: 0,
                    thickness: 10,
                  )
                ],
              ),
            ),
            color: Theme.of(context).primaryColor,
          ),
          _initial != null
              ? Container(
                  height: 350,
                  child: CupertinoDatePicker(
                      minimumDate: _min,
                      maximumDate: _min.add(const Duration(days: 250)),
                      initialDateTime: _initial,
                      mode: CupertinoDatePickerMode.date,
                      onDateTimeChanged: (val) {
                        setState(() {
                          _chosenDateTime = val;
                        });
                      }),
                )
              : Container(),
          Container(
            child: Align(
                alignment: Alignment.bottomCenter,
                child: OutlinedButton(
                  style: ButtonStyle(
                      overlayColor:
                          MaterialStateProperty.all(const Color(0xfffd968b)),
                      backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).primaryColor)),
                  onPressed: () {
                    _updateDueDate().then((value) => postDueDate(context));
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        'ooh wee',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                )),
          )
        ],
      ),
    );
  }

  Future<void> postDueDate(BuildContext context) async {
    var userRecord = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get();
    String nextRoute = router.InitialMeasurementsRoute;
    if (widget.isPoppable) {
      Navigator.pop(context);
    } else {
      if (userRecord.data().containsKey("initialWeight")) {
        nextRoute = router.HomePageRoute;
      }
      Navigator.of(context).pushNamed(nextRoute);
    }
  }

  Future<void> _updateDueDate() async {
    User user = FirebaseAuth.instance.currentUser;
    final ref = FirebaseFirestore.instance.collection('users');
    await ref.doc(user.uid).update({"dueDate": _chosenDateTime});
  }
}
