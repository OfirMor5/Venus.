import 'package:flutter/foundation.dart';

class WeightRecord {
  double weight;
  DateTime timestamp;

  WeightRecord({@required double weight, @required DateTime timestamp}) {
    this.weight = weight;
    this.timestamp = timestamp;
  }
  toMap() {
    return <String, dynamic>{
      "weight": this.weight,
      "timestamp": this.timestamp
    };
  }

  WeightRecord.fromMap(Map<String, dynamic> map)
      : weight = map["weight"].toDouble(),
        timestamp = DateTime.fromMillisecondsSinceEpoch(
            map['timestamp'].seconds * 1000);
}
