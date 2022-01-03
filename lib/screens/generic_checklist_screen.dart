import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hera2/enums/checklist_context_type.dart';
import 'package:hera2/utils/junk_data.dart' as junk;
import 'package:hera2/utils/utils.dart';

class GenericChecklistScreen extends StatefulWidget {
  final ChecklistContextType contextType;
  GenericChecklistScreen({Key key, @required this.contextType})
      : super(key: key);

  @override
  createState() => new _GenericChecklistScreen();
}

class _GenericChecklistScreen extends State<GenericChecklistScreen> {
  bool _loaded = false;
  List<String> _markedItems;
  List<String> _items;
  String _arrayName;
  String _title;
  @override
  void initState() {
    super.initState();
    switch (widget.contextType) {
      case ChecklistContextType.maternity_bag:
        _arrayName = 'markedMaternityBagItems';
        _items = junk.getMaternityBagItems();
        _title = 'Maternity bag';
        break;
      case ChecklistContextType.baby_bag:
        _arrayName = 'markedBabyBagItems';
        _items = junk.getBabyBagItems();
        _title = 'Baby Bag';
        break;
      case ChecklistContextType.shoping_list_for_baby:
        _arrayName = 'markedShoppingListItemsForBaby';
        _items = junk.getShopingListItemsForBaby();
        _title = 'Shopping list for baby';
        break;
      case ChecklistContextType.tests_list_by_week:
        _arrayName = 'markedTestsListByWeek';
        fetchUserDetails().then((details) {
          int week = getCurrentWeek(details.dueDate);
          _items = junk.getTestsByWeek(week);
          _fetchMarkedItems();
        });

        _title = 'Tests list by week';
        break;
    }
    if (_items != null) _fetchMarkedItems();
  }

  @override
  void dispose() {
    super.dispose();
    FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .update({_arrayName: _markedItems});
  }

  _fetchMarkedItems() {
    FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get()
        .then((snapshot) {
      _markedItems = [];

      if (snapshot.data().containsKey(_arrayName)) {
        List<dynamic> result = snapshot.data()[_arrayName];
        result.forEach((element) {
          _markedItems.add(element);
        });
      }
      setState(() {
        _loaded = true;
      });
    });
  }

  _updateLists(String item) {
    (_markedItems.contains(item))
        ? _markedItems.remove(item)
        : _markedItems.add(item);
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
          title: Text(_title),
        ),
        body: !_loaded
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      setState(() {
                        _updateLists(_items[index]);
                      });
                    },
                    title: Text(
                      '${_items[index]}',
                      style: (_markedItems.contains(_items[index]))
                          ? TextStyle(
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey,
                              fontSize: 20)
                          : TextStyle(fontSize: 20),
                    ),
                  );
                },
              ));
  }
}
