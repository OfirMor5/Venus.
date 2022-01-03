import 'package:flutter/foundation.dart';

class BabyDetails {
  String isLike;
  String title;
  int weekLeft;
  String description;

  BabyDetails(
      {@required String description,
      @required int week,
      @required String isLike}) {
    this.description = description;
    this.title = "You are in the ${week}th Weeks Pregnant";
    this.weekLeft = 40 - week;
    this.isLike = isLike;
  }
}
