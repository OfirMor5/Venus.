class CardItem {
  String assetImage;
  int leadingIconDataCodePoint;
  String routeName;
  String title;
  String subtitle;
  dynamic args;

  CardItem.fromMap(Map<String, dynamic> map)
      : assetImage = map["assetImage"],
        leadingIconDataCodePoint = map["leadingIconDataCodePoint"].toInt(),
        routeName = map["routeName"],
        title = map["title"],
        subtitle = map["subtitle"],
        args = map.containsKey('args') ? map['args'] : null;
}
