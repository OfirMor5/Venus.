import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hera2/utils/router.dart' as router;

class InitialMeasurementsScreen extends StatefulWidget {
  InitialMeasurementsScreen({Key key}) : super(key: key);

  @override
  createState() => new _InitialMeasurementsScreen();
}

class _InitialMeasurementsScreen extends State<InitialMeasurementsScreen> {
  int minHeight = 63, minWeight = 5, maxHeight = 180, maxWeight = 120;
  double totalWeight;
  int height;
  FixedExtentScrollController kgsController;
  FixedExtentScrollController gramsController =
      FixedExtentScrollController(initialItem: 0);
  FixedExtentScrollController heightController;

  @override
  void initState() {
    super.initState();

    setState(() {
      totalWeight =
          ((maxWeight - minWeight) / 2).floor() + minWeight.toDouble();
      kgsController = FixedExtentScrollController(
          initialItem: totalWeight.toInt() - minWeight);
      height = ((maxHeight - minHeight) / 2).floor() + minHeight;
      heightController =
          FixedExtentScrollController(initialItem: height - minHeight);
    });
  }

  void _weightPickerHandler() {
    setState(
      () => totalWeight = (kgsController.selectedItem + minWeight).toDouble() +
          (gramsController.selectedItem / 10),
    );
  }

  void _heightPickerHandler() {
    setState(() => height = heightController.selectedItem + minHeight);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Measurments before conception'),
      ),
      body: Container(
        padding: EdgeInsets.all(5),
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Text(
              "What was your weight before the conception(kg)?",
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(
                  child: Center(
                    child: CupertinoPicker(
                      itemExtent: 50,
                      scrollController: kgsController,
                      onSelectedItemChanged: (int index) =>
                          _weightPickerHandler(),
                      children: List<Widget>.generate(maxWeight - minWeight,
                          (int index) {
                        return Center(
                          child: Text(
                            (index++ + minWeight).toString(),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
                Text(
                  ".",
                  style: TextStyle(fontSize: 40),
                ),
                Expanded(
                  child: Center(
                    child: CupertinoPicker(
                      itemExtent: 50,
                      scrollController: gramsController,
                      onSelectedItemChanged: (int index) =>
                          _weightPickerHandler(),
                      children: List<Widget>.generate(10, (int index) {
                        return Center(
                          child: Text(
                            (index++).toString(),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 50,
            ),
            Text(
              "What was your height before the conception(cm)?",
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 40,
            ),
            CupertinoPicker(
              itemExtent: 50,
              scrollController: heightController,
              onSelectedItemChanged: (int index) => _heightPickerHandler(),
              children:
                  List<Widget>.generate(maxHeight - minHeight, (int index) {
                return Center(
                  child: Text(
                    "${index++ + minHeight}",
                  ),
                );
              }),
            ),
            SizedBox(
              height: 40,
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: OutlinedButton(
                  style: ButtonStyle(
                      overlayColor:
                          MaterialStateProperty.all(const Color(0xfffd968b)),
                      backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).primaryColor)),
                  onPressed: _updateInitialMeasurements,
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
          ],
        ),
      ),
    );
  }

  _updateInitialMeasurements() async {
    User user = FirebaseAuth.instance.currentUser;
    final ref = FirebaseFirestore.instance.collection('users');
    await ref
        .doc(user.uid)
        .update({"initialWeight": totalWeight, "initialHeight": height});
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).pushReplacementNamed(router.HomePageRoute);
    }
  }
}
