import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hera2/models/user_details.dart';

Future<UserDetails> fetchUserDetails() async {
  var query = await FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser.uid)
      .get();
  return UserDetails.fromMap(query.data());
}

int getCurrentWeek(DateTime dueDate) {
  DateTime today = DateTime.now();
  var difference = dueDate.difference(today).inDays;
  return (difference.toDouble() ~/ 7).toInt();
}

String getStringedNumber(int number) {
  String addition = "th";
  switch (number) {
    case 1:
      addition = "st";
      break;
    case 2:
      addition = "nd";
      break;
    case 3:
      addition = "rd";
      break;
  }
  return "$number$addition";
}

int getTrimesterByWeek(int week) {
  if (week >= 1 && week <= 12) {
    return 1;
  } else if (week >= 13 && week <= 26) {
    return 2;
  } else {
    return 3;
  }
}

int getTrimesterByDueDate(DateTime dueDate) {
  int week = getCurrentWeek(dueDate);
  return getTrimesterByWeek(week);
}

String greeting() {
  var hour = DateTime.now().hour;
  if (hour < 12) {
    return 'Morning';
  }
  if (hour < 17) {
    return 'Afternoon';
  }
  return 'Evening';
}

FaIcon greetingIcon() {
  var hour = DateTime.now().hour;
  if (hour < 12) {
    return FaIcon(
      FontAwesomeIcons.solidSun,
      color: Colors.yellow,
    );
  }
  if (hour < 17) {
    return FaIcon(
      FontAwesomeIcons.cloudSun,
      color: Colors.orange,
    );
  }
  return FaIcon(
    FontAwesomeIcons.solidMoon,
    color: Colors.blueGrey,
  );
}
