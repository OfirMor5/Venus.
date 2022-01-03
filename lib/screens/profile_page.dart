import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hera2/enums/post_type.dart';
import 'package:hera2/models/post.dart';
import 'package:hera2/models/user_details.dart';
import 'package:hera2/screens/sign_in_screen.dart';
import 'package:hera2/utils/auth.dart';
import 'package:hera2/utils/router.dart' as router;
import 'package:hera2/widgets/image_tile.dart';
import 'package:hera2/widgets/pdf_viewer_button.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key key}) : super(key: key);
  @override
  createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin<ProfilePage> {
  User user = FirebaseAuth.instance.currentUser;
  int postCount = 0;
  PostType postType = PostType.image;
  UserDetails userDetails;

  changeView(PostType type) {
    setState(() {
      postType = type;
    });
  }

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get()
        .then((value) {
      userDetails = UserDetails.fromMap(value.data());
      setState(() {});
    });
  }

  /* Future<UserDetails> _fetchUserDetails() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get();
       return UserDetails.fromMap(snapshot.data());
  }*/

  @override
  Widget build(BuildContext context) {
    super.build(context); // reloads state when opened again

    Container buildUserPosts() {
      Future<List<Post>> getPosts() async {
        List<Post> posts = [];
        try {
          var snap = await FirebaseFirestore.instance
              .collection('posts')
              .where('ownerId', isEqualTo: user.uid)
              .get();
          posts = snap.docs
              .map((e) => Post.fromMap(e.data()))
              .where((element) => element.postType == postType)
              .toList();
          posts.sort((a, b) => b.timestamp.compareTo(a.timestamp));
          setState(() {
            postCount = snap.docs.length;
          });
        } catch (err) {}

        return posts;
      }

      return Container(
          child: FutureBuilder<List<Post>>(
        future: getPosts(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Container(
                alignment: FractionalOffset.center,
                padding: const EdgeInsets.only(top: 10.0),
                child: CircularProgressIndicator());
          else {
            if (postType == PostType.image)
              // build the grid
              return GridView.count(
                  crossAxisCount: 3,
                  childAspectRatio: 1.0,
                  mainAxisSpacing: 1.5,
                  crossAxisSpacing: 1.5,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: snapshot.data.map((Post imagePost) {
                    return GridTile(child: ImageTile(imagePost));
                  }).toList());
            return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: snapshot.data.map((Post post) {
                  return PdfViewerButton(pdfPost: post);
                }).toList());
          }
        },
      ));
    }

    Row buildImageViewButtonBar() {
      Color isActiveButtonColor(PostType type) {
        if (postType == type) {
          return Colors.pink.shade200;
        } else {
          return Colors.black26;
        }
      }

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          IconButton(
            icon: FaIcon(FontAwesomeIcons.images,
                color: isActiveButtonColor(PostType.image)),
            onPressed: () {
              changeView(PostType.image);
            },
          ),
          IconButton(
            icon: FaIcon(FontAwesomeIcons.file,
                color: isActiveButtonColor(PostType.document)),
            onPressed: () {
              changeView(PostType.document);
            },
          ),
        ],
      );
    }

    if (user == null) return Container();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          user.displayName,
        ),
        actions: [
          PopupMenuButton<int>(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            padding: const EdgeInsets.all(4),
            icon: FaIcon(
              FontAwesomeIcons.ellipsisV,
              color: Colors.white,
              size: 20,
            ),
            onSelected: (item) => onMuneItemSelected(context, item),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text("Update your due date"),
                value: 0,
              ),
              PopupMenuDivider(
                height: 0,
              ),
              PopupMenuItem(
                child: Text("Sign out"),
                value: 1,
              ),
            ],
          ),
        ],
      ),
      body: ListView(children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 50.0,
                    backgroundColor: Colors.grey,
                    backgroundImage: NetworkImage(user.photoURL),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Member since:",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 17),
                              ),
                              Text(
                                "${user.metadata.creationTime.toString().split(" ")[0]}",
                                style: TextStyle(fontSize: 17),
                              )
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Number of posts:",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 17),
                              ),
                              Text(
                                "$postCount",
                                style: TextStyle(fontSize: 17),
                              )
                            ],
                          ),
                          userDetails != null
                              ? Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Due date:",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17),
                                    ),
                                    Text(
                                      userDetails.dueDate
                                          .toLocal()
                                          .toString()
                                          .split(' ')[0],
                                      style: TextStyle(fontSize: 17),
                                    )
                                  ],
                                )
                              : Container(),
                        ],
                      ))
                ],
              )
            ],
          ),
        ),
        Divider(),
        buildImageViewButtonBar(),
        Divider(
          thickness: 1.5,
          height: 0.0,
        ),
        buildUserPosts()
      ]),
    );
  }

  @override
  bool get wantKeepAlive => true;

  onMuneItemSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        Navigator.of(context).pushNamed(router.DueDateRoute, arguments: true);
        break;
      case 1:
        Authentication.signOut(context: context).then((value) => {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) {
                return SignInScreen();
              }), ModalRoute.withName(router.SignInRoute))
            });

        break;
    }
  }
}
