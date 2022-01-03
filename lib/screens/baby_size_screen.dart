import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hera2/models/baby_details.dart';
import 'package:hera2/models/user_details.dart';
import 'package:hera2/utils/junk_data.dart' as junk;
import 'package:hera2/utils/utils.dart';

class BabySizeScreen extends StatefulWidget {
  BabySizeScreen({Key key}) : super(key: key);
  @override
  createState() => new _BabySizeScreen();
}

class _BabySizeScreen extends State<BabySizeScreen> {
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
        title: const Text('Your week'),
      ),
      body: FutureBuilder<UserDetails>(
        future: fetchUserDetails(),
        builder: (context, snapshot) {
          if (snapshot.hasError)
            return Center(child: CircularProgressIndicator());

          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          int week = getCurrentWeek(snapshot.data.dueDate);
          BabyDetails babyDetails = junk.getBabyDetails(week);
          return Padding(
              padding: EdgeInsets.all(10),
              child: ListView(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundImage:
                            AssetImage('assets/images/images_fetus/$week.jpg'),
                        radius: 60,
                      ),
                      CircleAvatar(
                        backgroundImage: AssetImage(
                            'assets/images/images_baby_size/$week.png'),
                        radius: 60,
                      ),
                      CircleAvatar(
                        radius: 60,
                        child: Text(
                          (week >= 0 && week <= 40)
                              ? '${babyDetails.weekLeft} \n weeks \n to go!'
                              : '',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    (week >= 0 && week <= 40)
                        ? '${babyDetails.title}'
                        : 'You are not in pragnant',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Text(
                    '${babyDetails.isLike}',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Text(
                    '${babyDetails.description}',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 17),
                  ),
                ],
              ));
        },
      ),
    );
  }
}
