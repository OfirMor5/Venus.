import 'dart:io';

import 'package:flutter/material.dart';
import 'package:textfield_tags/textfield_tags.dart';

// ignore: must_be_immutable
class PostForm extends StatelessWidget {
  List<String> tags;
  final Function onCrop;
  File imageFile;
  File originalFile;
  TextEditingController descriptionController;
  TextEditingController locationController;
  bool loading = false;
  PostForm(
      {@required this.imageFile,
      @required this.descriptionController,
      @required this.loading,
      @required this.locationController,
      @required this.tags,
      this.onCrop}) {
    this.originalFile = this.imageFile;
  }

  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        loading
            ? LinearProgressIndicator()
            : Padding(padding: EdgeInsets.only(top: 0.0)),
        Stack(
          alignment: AlignmentDirectional.bottomEnd,
          children: [
            Image.file(imageFile),
            TextButton.icon(
                style:
                    TextButton.styleFrom(primary: Colors.white, elevation: 2.0),
                onPressed: onCrop, //_cropImage,
                icon: Icon(Icons.crop),
                label: Text('Crop'))
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
                width: 250.0,
                child: Padding(
                  padding: EdgeInsets.only(left: 5, right: 5),
                  child: TextField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                        hintText: "Write a caption...",
                        border: InputBorder.none),
                  ),
                ))
          ],
        ),
        Divider(
          height: 5,
        ),
        TextFieldTags(
            tagsStyler: TagsStyler(
                tagTextStyle:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                tagDecoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                tagCancelIcon:
                    Icon(Icons.cancel, size: 18.0, color: Colors.white),
                tagPadding: const EdgeInsets.all(6.0)),
            textFieldStyler: TextFieldStyler(),
            onTag: (tag) {
              tags.add(tag);
            },
            onDelete: (tag) {
              tags.remove(tag);
            }),
        Divider(
          height: 5,
        ),
        ListTile(
          leading: Icon(Icons.pin_drop),
          title: Container(
            width: 250.0,
            child: TextField(
              controller: locationController,
              decoration: InputDecoration(
                  hintText: "Where was this photo taken?",
                  border: InputBorder.none),
            ),
          ),
        )
      ],
    );
  }
}
