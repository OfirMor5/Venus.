import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hera2/screens/uploader.dart';
import 'screens/chatbot.dart';
import 'screens/home.dart';
import 'screens/profile_page.dart';
import 'screens/weight_screen.dart';
import 'utils/router.dart' as router;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(Hera());
}

class Hera extends StatelessWidget {
  final Color mainColor = const Color(0xffffc8c7);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hera',
      initialRoute: router.SignInRoute,
      onGenerateRoute: router.generateRoute,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          fontFamily: 'Rubik',
          primaryColor: mainColor,
          splashColor: mainColor.withAlpha(80),
          buttonColor: Colors.pink,
          primaryTextTheme: TextTheme(
              headline6:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          primaryIconTheme: IconThemeData(color: Colors.black)),
      //home: SignInScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _pageViewController = PageController();
  int _page = 0;
  List<Widget> _screens = [
    Home(),
    Chatbot(),
    Uploader(),
    WeightScreen(),
    ProfilePage()
  ];
  bool firebaseInitialized = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: PageView(
          controller: _pageViewController,
          children: _screens,
          onPageChanged: (index) {
            setState(() {
              _page = index;
            });
          },
        ),
        bottomNavigationBar: AnimatedContainer(
            duration: Duration(milliseconds: 500),
            child: BottomNavigationBar(
              showSelectedLabels: false,
              showUnselectedLabels: false,
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.white,
              items: _bottomNavigationItems(),
              currentIndex: _page,
              onTap: (index) {
                //if (index != 2)
                _pageViewController.animateToPage(index,
                    duration: Duration(milliseconds: 200),
                    curve: Curves.bounceOut);
                /* else {
                showModalBottomSheet(
                  backgroundColor: Colors.transparent,
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(10),
                              topRight: const Radius.circular(10))),
                      height: 200,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Text(
                              'Create a Post',
                              style: TextStyle(fontSize: 17),
                            ),
                            SizedBox(
                              height: 7,
                            ),
                            Divider(
                              thickness: 1.5,
                            ),
                            ListTile(
                              leading: FaIcon(FontAwesomeIcons.camera),
                              title: Text("Take a photo"),
                              onTap: () {
                                Navigator.pop(context);
                                Uploader(
                                  imageSource: ImageSource.camera,
                                );
                              },
                            ),
                            ListTile(
                              leading: FaIcon(FontAwesomeIcons.images),
                              title: Text("Choose from Gallery"),
                              onTap: () {
                                Navigator.pop(context);
                                return Uploader(
                                  imageSource: ImageSource.gallery,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }*/
              },
            )),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().then((_) {
      setState(() {
        firebaseInitialized = true;
      });
    });
  }

  @override
  void dispose() {
    _pageViewController.dispose();
    super.dispose();
  }

  List<BottomNavigationBarItem> _bottomNavigationItems() {
    return [
      BottomNavigationBarItem(
          icon: FaIcon(FontAwesomeIcons.home), label: 'Home'),
      BottomNavigationBarItem(
          icon: FaIcon(FontAwesomeIcons.robot), label: 'Chatbot'),
      BottomNavigationBarItem(
        icon: FaIcon(FontAwesomeIcons.plusCircle),
        label: 'Create',
      ),
      BottomNavigationBarItem(
        icon: FaIcon(FontAwesomeIcons.weight),
        label: 'Timeline',
      ),
      BottomNavigationBarItem(
          icon: FaIcon(FontAwesomeIcons.solidUser), label: 'Profile'),
    ];
  }
}
