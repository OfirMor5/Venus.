import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hera2/enums/post_type.dart';
import 'package:hera2/forms/file_form.dart';
import 'package:hera2/forms/post_form.dart';
import 'package:hera2/models/post.dart';
import 'package:hera2/utils/location.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'dart:async';
import 'dart:io';
import 'package:geocoder/geocoder.dart';

class Uploader extends StatefulWidget {
  _Uploader createState() => _Uploader();
}

class _Uploader extends State<Uploader> {
  PostType fileType;
  File file;
  File originalFile;
  List<String> tags;
  Address address;
  User currentUser = FirebaseAuth.instance.currentUser;

  Map<String, double> currentLocation = Map();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  final imagePicker = ImagePicker();

  bool uploading = false;

  @override
  initState() {
    tags = [];
    //variables with location assigned as 0.0
    currentLocation['latitude'] = 0.0;
    currentLocation['longitude'] = 0.0;
    initPlatformState(); //method to call location
    super.initState();
  }

  //method to get Location and save into variables
  initPlatformState() async {
    Address first = await getUserLocation();
    if (this.mounted) {
      setState(() {
        address = first;
      });
    }
  }

  Widget build(BuildContext context) {
    if (file == null) {
      return IconButton(
          icon: Icon(Icons.file_upload),
          onPressed: () => {_selectAction(context)});
    }
    bool isImage = fileType == PostType.image;
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: FaIcon(FontAwesomeIcons.arrowLeft, color: Colors.white),
              onPressed: clearImage),
          title: Text('Upload ' + (isImage ? 'post' : 'file')),
        ),
        resizeToAvoidBottomInset: false,
        body: ListView(
          children: <Widget>[
            isImage
                ? new PostForm(
                    imageFile: file,
                    descriptionController: descriptionController,
                    locationController: locationController,
                    loading: uploading,
                    tags: tags,
                    onCrop: () {
                      _cropImage();
                    },
                  )
                : new FileForm(
                    file: file,
                    descriptionController: descriptionController,
                    loading: uploading,
                  ),
            Divider(), //scroll view where we will show location to users
            (!isImage || address == null)
                ? Container()
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.only(right: 5.0, left: 5.0),
                    child: Row(
                      children: <Widget>[
                        buildLocationButton(address.featureName),
                        buildLocationButton(address.subLocality),
                        buildLocationButton(address.locality),
                        buildLocationButton(address.subAdminArea),
                        buildLocationButton(address.adminArea),
                        buildLocationButton(address.countryName),
                      ],
                    ),
                  ),
            (!isImage || address == null) ? Container() : Divider(),
            uploading
                ? Container()
                : OutlinedButton(
                    style: ButtonStyle(
                        overlayColor:
                            MaterialStateProperty.all(Colors.pink.shade800),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.pink.shade200)),
                    onPressed: () => postImage(),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          'Post',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
          ],
        ));
  }

  //method to build buttons with location.
  buildLocationButton(String locationName) {
    if (locationName != null ?? locationName.isNotEmpty) {
      return InkWell(
        onTap: () {
          locationController.text = locationName;
        },
        child: Center(
          child: Container(
            //width: 100.0,
            height: 30.0,
            padding: EdgeInsets.only(left: 8.0, right: 8.0),
            margin: EdgeInsets.only(right: 3.0, left: 3.0),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Center(
              child: Text(
                locationName,
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  _selectAction(BuildContext parentContext) async {
    return showDialog<Null>(
      context: parentContext,
      barrierDismissible: false, // user must tap button!

      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Create a Post'),
          children: <Widget>[
            SimpleDialogOption(
                child: const Text('Take a photo'),
                onPressed: () async {
                  Navigator.pop(context);
                  PickedFile imageFile = await imagePicker.getImage(
                      source: ImageSource.camera,
                      maxWidth: 1920,
                      maxHeight: 1200,
                      imageQuality: 80);
                  setState(() {
                    if (imageFile != null) {
                      fileType = PostType.image;
                      file = File(imageFile.path);
                    } else {
                      print('No image selected.');
                    }
                  });
                }),
            SimpleDialogOption(
                child: const Text('Choose from Gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  PickedFile imageFile = await imagePicker.getImage(
                      source: ImageSource.gallery,
                      maxWidth: 1920,
                      maxHeight: 1200,
                      imageQuality: 80);
                  setState(() {
                    if (imageFile != null) {
                      fileType = PostType.image;
                      file = File(imageFile.path);
                    } else {
                      print('No image selected.');
                    }
                  });
                }),
            SimpleDialogOption(
                child: const Text('Upload file (pdf)'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  FilePickerResult result = await FilePicker.platform.pickFiles(
                      type: FileType.custom, allowedExtensions: ['pdf']);
                  setState(() {
                    if (result != null) {
                      fileType = PostType.document;
                      file = File(result.files.single.path);
                    } else {
                      print('No file selected.');
                    }
                  });
                }),
            SimpleDialogOption(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  void clearImage() {
    setState(() {
      file = null;
    });
  }

  void postImage() {
    setState(() {
      uploading = true;
    });
    uploadFile(file, fileType).then((String data) {
      postToFireStore(
          mediaUrl: data,
          description: descriptionController.text,
          location: locationController.text,
          tags: tags,
          postType: fileType);
    }).then((_) {
      setState(() {
        file = null;
        uploading = false;
        descriptionController.clear();
        locationController.clear();
      });
    });
  }

  Future<void> _cropImage() async {
    if (originalFile == null) {
      originalFile = file;
    }
    File cropped = await ImageCropper.cropImage(
        sourcePath: originalFile.path,
        aspectRatioPresets: [CropAspectRatioPreset.square],
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));
    setState(() {
      file = cropped ?? file;
    });
  }
}

Future<String> uploadFile(var file, PostType fileType) async {
  var uuid = Uuid().v1();
  String filename = fileType == PostType.image
      ? "images/post_$uuid.jpg"
      : "documents/file_$uuid.pdf";
  Reference ref = FirebaseStorage.instance.ref().child(filename);
  UploadTask uploadTask = ref.putFile(file);

  String downloadUrl = await (await uploadTask).ref.getDownloadURL();
  return downloadUrl;
}

void postToFireStore(
    {String mediaUrl,
    String location,
    String description,
    PostType postType,
    List<String> tags}) async {
  var reference = FirebaseFirestore.instance.collection('posts');
  Post post = new Post(
      mediaUrl: mediaUrl,
      publisher: FirebaseAuth.instance.currentUser.uid,
      timestamp: DateTime.now(),
      description: description,
      location: location,
      postType: postType,
      tags: tags);
  reference.add(post.toMap()).then((DocumentReference doc) {
    String docId = doc.id;
    reference.doc(docId).update({"postId": docId});
  });
}
