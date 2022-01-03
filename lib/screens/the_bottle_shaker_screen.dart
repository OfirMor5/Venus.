import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shake/shake.dart';

class TheBottleShakerScreen extends StatefulWidget {
  const TheBottleShakerScreen({Key key}) : super(key: key);
  @override
  createState() => new _TheBottleShakerScreen();
}

class _TheBottleShakerScreen extends State<TheBottleShakerScreen> {
  ShakeDetector detector;
  Color color = Colors.red;
  String localFilePath;

  @override
  void initState() {
    super.initState();

    detector = ShakeDetector.autoStart(onPhoneShake: () {
      setState(() {
        color = Colors.green;
      });
      Timer(Duration(seconds: 1), () {
        setState(() {
          color = Colors.red;
        });
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    detector.stopListening();
  }

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
        title: const Text("The bottle Shaker"),
      ),
      body: Center(
        child: Container(
          color: color,
        ),
      ),
    );
  }

  String formatTime(int milliseconds) {
    var secs = milliseconds ~/ 1000;
    var hours = (secs ~/ 3600).toString().padLeft(2, '0');
    var minutes = ((secs % 3600) ~/ 60).toString().padLeft(2, '0');
    var seconds = (secs % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$seconds";
  }
}
