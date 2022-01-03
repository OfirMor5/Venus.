class UserDetails {
  DateTime dueDate;
  double initialWeight;
  int initialHeight;

  UserDetails({DateTime dueDate, double initialWeight, int initialHeight}) {
    this.dueDate = dueDate;
    this.initialWeight = initialWeight;
    this.initialHeight = initialHeight;
  }

  toMap() {
    return <String, dynamic>{
      'dueDate': dueDate,
      'initialWeight': initialWeight,
      'initialHeight': initialHeight
    };
  }

  UserDetails.fromMap(Map<String, dynamic> map)
      : dueDate =
            DateTime.fromMillisecondsSinceEpoch(map['dueDate'].seconds * 1000),
        initialHeight = map['initialHeight'].toInt(),
        initialWeight = map['initialWeight'].toDouble();
}
