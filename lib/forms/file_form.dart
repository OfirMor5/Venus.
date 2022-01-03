import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hera2/widgets/pdf_file_preview.dart';
import 'package:path/path.dart';
import 'package:pdf_previewer/pdf_previewer.dart';

// ignore: must_be_immutable
class FileForm extends StatelessWidget {
  File file;
  TextEditingController descriptionController;
  bool loading = false;
  Future<dynamic> previewPathFuture;

  FileForm(
      {@required this.file,
      @required this.descriptionController,
      @required this.loading}) {
    previewPathFuture = PdfPreviewer.getPagePreview(filePath: file.path);
  }

  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        loading
            ? LinearProgressIndicator()
            : Padding(padding: EdgeInsets.only(top: 0.0)),
        FutureBuilder(
          future: previewPathFuture,
          builder: (context, snapshot) {
            if (snapshot.hasError) print("fsdgsg" + snapshot.error);
            return new Container(
              child: Stack(
                alignment: AlignmentDirectional.bottomStart,
                children: [
                  new Center(
                    child: snapshot.hasData
                        ? PdfPagePreview(
                            imgPath: snapshot.data,
                          )
                        : Center(child: CircularProgressIndicator()),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        FaIcon(FontAwesomeIcons.filePdf, color: Colors.white),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          basename(file.path),
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    color: Colors.black,
                  )
                ],
              ),
              decoration: new BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      spreadRadius: 1.0,
                      color: Color(0xffebebeb),
                      blurRadius: 3.0),
                ],
                border: Border.all(
                  width: 1.0,
                  color: Color(0xffebebeb),
                ),
                shape: BoxShape.rectangle,
              ),
            );
          },
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
        )
      ],
    );
  }
}
