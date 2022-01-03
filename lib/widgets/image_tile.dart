import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hera2/enums/post_type.dart';
import 'package:hera2/models/post.dart';

class ImageTile extends StatelessWidget {
  final Post imagePost;

  ImageTile(this.imagePost);

  clickedImage(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute<bool>(builder: (BuildContext context) {
      return Center(
        child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                  icon: FaIcon(FontAwesomeIcons.arrowLeft, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              title: Text('Photo',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              actions: [
                IconButton(
                    icon: const FaIcon(
                      FontAwesomeIcons.trashAlt,
                      color: Colors.red,
                    ),
                    tooltip: 'delete post',
                    onPressed: () {
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text(
                              'Are you sure you want to delete this post?'),
                          actions: <Widget>[
                            TextButton(
                              style: ButtonStyle(
                                overlayColor: MaterialStateProperty.all(
                                    Theme.of(context)
                                        .primaryColor
                                        .withAlpha(40)),
                              ),
                              onPressed: () => Navigator.pop(context, 'Close'),
                              child: Text(
                                'Close',
                                style: TextStyle(
                                  color: Colors.pink.shade200,
                                ),
                              ),
                            ),
                            TextButton(
                              style: ButtonStyle(
                                overlayColor: MaterialStateProperty.all(
                                    Theme.of(context)
                                        .primaryColor
                                        .withAlpha(40)),
                              ),
                              onPressed: () {
                                deletePost();
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Delete',
                                style: TextStyle(
                                  color: Colors.pink.shade200,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    })
              ],
            ),
            body: ListView(
              children: [
                Image.network(imagePost.mediaUrl),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      imagePost.tags.isNotEmpty
                          ? Row(
                              children: [
                                FaIcon(FontAwesomeIcons.tags),
                                SizedBox(
                                  width: 10,
                                ),
                                for (String tag in imagePost.tags)
                                  Container(
                                    child: Text(
                                      tag,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    margin: EdgeInsets.only(right: 4),
                                    padding: EdgeInsets.all(4),
                                    color: Theme.of(context).primaryColor,
                                  )
                              ],
                            )
                          : SizedBox(),
                      SizedBox(
                        height: 10,
                      ),
                      imagePost.location.isNotEmpty
                          ? Row(
                              children: [
                                FaIcon(FontAwesomeIcons.mapMarkerAlt),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(imagePost.location)
                              ],
                            )
                          : SizedBox(),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        imagePost.description,
                        style: TextStyle(
                            fontSize: 20, fontStyle: FontStyle.italic),
                      )
                    ],
                  ),
                ),
              ],
            )),
      );
    }));
  }

  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => clickedImage(context),
        child: imagePost.postType == PostType.image
            ? Image.network(imagePost.mediaUrl, fit: BoxFit.cover)
            : CircularProgressIndicator());
  }

  void deletePost() {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(imagePost.postId)
        .delete()
        .then((value) =>
            FirebaseStorage.instance.refFromURL(imagePost.mediaUrl).delete());
  }
}
