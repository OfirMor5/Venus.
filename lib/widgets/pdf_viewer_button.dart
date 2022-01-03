import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hera2/models/post.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewerButton extends StatelessWidget {
  final Post pdfPost;

  PdfViewerButton({@required this.pdfPost});

  showPdf(BuildContext context) {
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
              title: Text(pdfPost.description,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              actions: [
                IconButton(
                    icon: const FaIcon(
                      FontAwesomeIcons.trashAlt,
                      color: Colors.red,
                    ),
                    tooltip: 'delete document',
                    onPressed: () {
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text(
                              'Are you sure you want to delete this document?'),
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
              // backgroundColor: Colors.white,
            ),
            body: ListView(
              children: [SfPdfViewer.network(pdfPost.mediaUrl)],
            )),
      );
    }));
  }

  Widget build(BuildContext context) {
    return OutlinedButton(
      style: ButtonStyle(
          overlayColor: MaterialStateProperty.all(Colors.pink.shade800),
          backgroundColor:
              MaterialStateProperty.all(Colors.pink.shade200.withAlpha(80))),
      onPressed: () => {showPdf(context)},
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FaIcon(FontAwesomeIcons.filePdf, color: Colors.white),
                SizedBox(
                  width: 10,
                ),
                Text(
                  pdfPost.description,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            )),
      ),
    );
  }

  void deletePost() {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(pdfPost.postId)
        .delete()
        .then((value) => FirebaseStorage.instance.refFromURL(pdfPost.mediaUrl).delete());
  }
}
