import 'package:flutter/foundation.dart';

class BabyName {
  final String name;
  final String gender;
  final String country;

  BabyName(
      {@required this.name, @required this.gender, @required this.country});

  factory BabyName.fromJson(Map<String, dynamic> json) {
    return BabyName(
        name: json['name'] as String,
        gender: json['gender'] as String,
        country: json['country'] as String);
  }
}
