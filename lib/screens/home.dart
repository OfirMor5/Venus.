import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hera2/models/card_item.dart';
import 'package:hera2/models/user_details.dart';
import 'package:hera2/utils/utils.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  createState() => new _Home();
}

class _Home extends State<Home> {
  AnimationController controller;
  bool _loaded = false;
  List<CardItem> _cards;
  User user = FirebaseAuth.instance.currentUser;
  UserDetails userDetails;
  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Venus")),
      body: _loaded
          ? RefreshIndicator(
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  Card(
                    child: InkWell(
                      highlightColor:
                          Theme.of(context).primaryColor.withAlpha(20),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          'baby_size',
                        );
                      },
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              leading: greetingIcon(),
                              title: Text(
                                  "Good ${greeting().toLowerCase()} ${user.displayName}"),
                              subtitle: FutureBuilder<UserDetails>(
                                future: fetchUserDetails(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) print(snapshot.error);
                                  if (snapshot.hasData) {
                                    int week =
                                        getCurrentWeek(snapshot.data.dueDate);
                                    int trimester = getTrimesterByWeek(week);
                                    return Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                              'you are in the ${getStringedNumber(week)} weeks pregnant.'),
                                          SizedBox(
                                            height: 2,
                                          ),
                                          Text(
                                            "${getStringedNumber(trimester)} trimester.",
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          LinearProgressIndicator(
                                            backgroundColor: Theme.of(context)
                                                .primaryColor
                                                .withAlpha(80),
                                            value: week / 40,
                                            semanticsLabel: "Dfsdfs",
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Colors.pink.shade200),
                                          )
                                        ]);
                                  } else
                                    return Container();
                                },
                              ),
                            ),
                            /*FutureBuilder<int>(
                                future: getUserCurrentWeek(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) print(snapshot.error);
                                  return snapshot.hasData
                                      ? LinearProgressIndicator(
                                          backgroundColor: Theme.of(context)
                                              .primaryColor
                                              .withAlpha(80),
                                          value: snapshot.data / 40,
                                          semanticsLabel: "Dfsdfs",
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.pink.shade200),
                                        )
                                      : Container();
                                },
                              )*/
                          ]),
                    ),
                  ),
                  for (var card in _cards)
                    Card(
                      child: InkWell(
                        highlightColor:
                            Theme.of(context).primaryColor.withAlpha(20),
                        onTap: () {
                          Navigator.pushNamed(context, card.routeName,
                              arguments: card.args);
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Image.network(
                              card.assetImage,
                            ),
                            ListTile(
                              leading: Icon(IconData(
                                  card.leadingIconDataCodePoint,
                                  fontFamily: 'MaterialIcons')),
                              title: Text(card.title),
                              subtitle: Text(card.subtitle),
                            ),
                          ],
                        ),
                      ),
                    )
                ],
              ),
              onRefresh: _refreshData)
          : Center(child: CircularProgressIndicator()),
    );
  }

  _fetchCardItems() async {
    var query = await FirebaseFirestore.instance.collection("cards").get();
    _cards = query.docs.map((doc) => CardItem.fromMap(doc.data())).toList();
    _loaded = true;
  }

  Future _refreshData() async {
    _loaded = false;
    await _fetchCardItems();

    setState(() {});
  }
}
