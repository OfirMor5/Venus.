import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PdfPagePreview extends StatefulWidget {
  final String imgPath;
  PdfPagePreview({@required this.imgPath});
  _PdfPagePreviewState createState() => new _PdfPagePreviewState();
}

class _PdfPagePreviewState extends State<PdfPagePreview> {
  bool imgReady = false;
  ImageProvider provider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadPreview(needsRepaint: true);
  }

  @override
  void didUpdateWidget(PdfPagePreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imgPath != widget.imgPath) {
      _loadPreview(needsRepaint: true);
    }
  }

  void _loadPreview({@required bool needsRepaint}) {
    if (needsRepaint) {
      imgReady = false;
      provider = FileImage(File(widget.imgPath), scale: 0.5);
      final resolver = provider.resolve(createLocalImageConfiguration(context));
      resolver.addListener(ImageStreamListener((imgInfo, alreadyPainted) {
        imgReady = true;
        if (!alreadyPainted) setState(() {});
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: imgReady
          ? new Image(
              image: provider,
            )
          : new CircularProgressIndicator(
              strokeWidth: 2.0,
              value: null,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
            ),
    );
  }
}
