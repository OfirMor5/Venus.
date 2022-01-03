import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hera2/models/weight_record.dart';
import 'package:hera2/utils/utils.dart';

class WeightScreen extends StatefulWidget {
  const WeightScreen({Key key}) : super(key: key);

  @override
  createState() => new _WeightScreen();
}

class _WeightScreen extends State<WeightScreen>
    with AutomaticKeepAliveClientMixin<WeightScreen> {
  TextEditingController _newWeightController;
  int segmentedControlGroupValue = 0;
  @override
  void initState() {
    super.initState();
    _newWeightController = new TextEditingController(text: "");
  }

  LineChartData sampleData1(List<WeightRecord> records) {
    records = records.reversed.toList();

    var maxY = records.map<double>((e) => e.weight).reduce(max);
    return LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(tooltipBgColor: Colors.white),
        touchCallback: (LineTouchResponse touchResponse) {},
        handleBuiltInTouches: true,
      ),
      gridData: FlGridData(
        show: false,
      ),
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
            showTitles: true,
            reservedSize: 5,
            getTextStyles: (value) => const TextStyle(
                  color: Color(0xff72719b),
                  fontWeight: FontWeight.bold,
                  fontSize: 9,
                ),
            margin: 10,
            getTitles: (value) {
              if (value.toInt() <= records.length - 1) {
                var dt = records[value.toInt()].timestamp.toString().split(" ");
                String dateToShow = dt[0] + "\n" + dt[1].split(".")[0];
                return dateToShow;
              }
              return '';
            }),
        leftTitles: SideTitles(
          interval: 5,
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
            fontSize: 10,
          ),
          getTitles: (value) {
            return value.toString() + "kg";
          },
          margin: 8,
          reservedSize: 40,
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(
            color: Colors.grey,
            width: 4,
          ),
          left: BorderSide(
            color: Colors.transparent,
          ),
          right: BorderSide(
            color: Colors.transparent,
          ),
          top: BorderSide(
            color: Colors.transparent,
          ),
        ),
      ),
      minX: 0,
      maxX: records.length.toDouble(),
      maxY: maxY + 5,
      minY: 0,
      lineBarsData: linesBarData1(records),
    );
  }

  List<LineChartBarData> linesBarData1(List<WeightRecord> records) {
    List<FlSpot> list = records
        .asMap()
        .entries
        .map((entry) => FlSpot(entry.key.toDouble(), entry.value.weight))
        .toList();
    final lineChartBarData1 = LineChartBarData(
      spots: list,
      isCurved: true,
      colors: [
        const Color(0xfffd968b),
      ],
      barWidth: 8,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: true,
      ),
      belowBarData: BarAreaData(show: true, colors: [
        Theme.of(context).primaryColor.withAlpha(20),
        Theme.of(context).primaryColor.withAlpha(100)
      ]),
    );
    return [lineChartBarData1];
  }

  _streamUserWeights() {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('weightsRecords')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  _getWeightGainRange(int week, double bmi) {
    int trimester = getTrimesterByWeek(week);
    if (trimester == 1) return null;
    if (bmi < 18.5) return [0.45 * week, 0.6 * week];
    if (bmi >= 18.5 && bmi < 25) return [0.35 * week, 0.45 * week];
    if (bmi >= 25 && bmi < 30) return [0.23 * week, 0.3 * week];
    return [0.18 * week, 0.27 * week];
  }

  Future<List<double>> _getNormalWeightRange() async {
    var userDetails = await fetchUserDetails();
    int week = getCurrentWeek(userDetails.dueDate);
    double bmi = userDetails.initialWeight / pow(userDetails.initialHeight, 2);
    var range = _getWeightGainRange(week, bmi);
    if (range == null) {
      return [userDetails.initialWeight, userDetails.initialWeight];
    }
    return [
      userDetails.initialWeight + range[0],
      userDetails.initialWeight + range[1]
    ];
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // reloads state when opened again

    AppBar appBar = AppBar(
      title: Text("Weight History"),
      actions: [
        IconButton(
            icon: FaIcon(FontAwesomeIcons.plus),
            color: Colors.white,
            splashColor: const Color(0xfffd968b),
            highlightColor: Theme.of(context).primaryColor.withAlpha(20),
            onPressed: _showNewWeightInsertBottomModal)
      ],
    );

    return Scaffold(
      appBar: appBar,
      backgroundColor: Colors.white,
      body: StreamBuilder<QuerySnapshot>(
        stream: _streamUserWeights(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
            return Center(
              child: Text("an error occured"),
            );
          }
          if (snapshot.hasData && snapshot.data.docs.length > 0) {
            List<WeightRecord> weightsRecords = snapshot.data.docs
                .map((e) => WeightRecord.fromMap(e.data()))
                .toList();
            return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CupertinoSlidingSegmentedControl(
                      groupValue: segmentedControlGroupValue,
                      children: {0: Text("Chart"), 1: Text("List")},
                      onValueChanged: (i) {
                        setState(() {
                          segmentedControlGroupValue = i;
                        });
                      }),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Your weight (kg)",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    weightsRecords.first.weight.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50),
                  ),
                  FutureBuilder<List<double>>(
                    future: _getNormalWeightRange(),
                    builder: (context, weightRangeSnapshot) {
                      if (weightRangeSnapshot.hasError) {
                        print(weightRangeSnapshot.error);
                        return Center(
                          child: Text("an error occured"),
                        );
                      }
                      if (weightRangeSnapshot.hasData) {
                        if (weightRangeSnapshot.data[0] ==
                            weightRangeSnapshot.data[1]) {
                          return Container();
                        }
                        return Column(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("Recommended weight"),
                              Tooltip(
                                message:
                                    'Source: American college of obstreticians and gynecologists.',
                                child: IconButton(
                                  icon: FaIcon(
                                    FontAwesomeIcons.infoCircle,
                                    size: 15,
                                  ),
                                  onPressed: () {
                                    /* your code */
                                  },
                                  padding: EdgeInsets.all(4),
                                ),
                              ),
                            ],
                          ),
                          Text(
                              "${weightRangeSnapshot.data[0]}-${weightRangeSnapshot.data[1]}")
                        ]);
                      }
                      return Container();
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  segmentedControlGroupValue == 0
                      ? _buildChart(weightsRecords)
                      : Expanded(
                          child: new ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: weightsRecords.length,
                            itemBuilder: (BuildContext ctxt, int index) {
                              return new Column(
                                children: [
                                  ListTile(
                                    title: Text(weightsRecords[index]
                                        .weight
                                        .toString()),
                                    subtitle: Text(weightsRecords[index]
                                        .timestamp
                                        .toString()),
                                  ),
                                  Divider(
                                    height: 2,
                                    thickness: 1.5,
                                  )
                                ],
                              );
                            },
                          ),
                        ),
                ]);
          }
          return _buildEmptyView();
        },
      ),
    );
  }

  @override
  void dispose() {
    _newWeightController.clear();
    super.dispose();
  }

  _showNewWeightInsertBottomModal() {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          _newWeightController.clear();
          return Container(
            height: 300,
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Container(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 20),
                  Text(
                    'New Weight Record',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  Divider(
                    thickness: 1.5,
                  ),
                  Text(
                    'Date',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 5),
                  Text(
                    DateTime.now().toString(),
                    style: TextStyle(fontSize: 17),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Weight',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 5),
                  TextField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: const EdgeInsets.only(
                              left: 5, right: 5, top: 3, bottom: 3),
                          hintText: 'Enter your weight here'),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      //autofocus: true,
                      controller: _newWeightController),
                  SizedBox(height: 10),
                  ValueListenableBuilder<TextEditingValue>(
                      valueListenable: _newWeightController,
                      builder: (context, value, child) {
                        return value.text.isNotEmpty
                            ? OutlinedButton(
                                style: ButtonStyle(
                                    overlayColor: MaterialStateProperty.all(
                                        const Color(0xfffd968b)),
                                    backgroundColor: MaterialStateProperty.all(
                                        Theme.of(context).primaryColor)),
                                onPressed: () {
                                  _insertNewWeight();
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 10, 0, 10),
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
                              )
                            : Container();
                      }),
                ],
              ),
            ),
          );
        });
  }

  Future<void> _insertNewWeight() async {
    // Timer(Duration(seconds: 5), () => print('done'));
    User user = FirebaseAuth.instance.currentUser;
    final reference = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('weightsRecords');
    WeightRecord record = new WeightRecord(
        weight: double.parse(_newWeightController.text),
        timestamp: DateTime.now());
    reference.add(record.toMap()).then((res) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Successfully inserted"),
      ));
      Navigator.of(context).pop();
    }, onError: (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("an error occured"),
      ));
    });
  }

  Widget _buildEmptyView() {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(left: 30, right: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FaIcon(
              FontAwesomeIcons.weightHanging,
              size: 100,
              color: Colors.grey,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "You haven't entered any weight record yet.",
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 5,
            ),
            Text("Tap on the + sign to enter your first!"),
          ],
        ),
      ),
    );
  }

  _buildChart(List<WeightRecord> weightsRecords) {
    return Container(
      height: 400,
      child: Padding(
        padding: const EdgeInsets.only(right: 16.0, left: 6.0),
        child: LineChart(
          sampleData1(weightsRecords),
          swapAnimationDuration: const Duration(milliseconds: 250),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
