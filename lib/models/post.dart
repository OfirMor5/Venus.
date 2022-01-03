import 'package:flutter/foundation.dart';
import 'package:hera2/enums/post_type.dart';

class Post {
  String postId;
  String mediaUrl;
  String ownerId;
  DateTime timestamp;
  String location;
  String description;
  List<String> tags;
  PostType postType;

  Post(
      {@required String mediaUrl,
      @required String publisher,
      @required DateTime timestamp,
      @required String description,
      @required List<String> tags,
      String location = "",
      PostType postType = PostType.image}) {
    this.mediaUrl = mediaUrl;
    this.ownerId = publisher;
    this.timestamp = timestamp;
    this.location = location;
    this.description = description;
    this.tags = tags;
    this.postType = postType;
  }

  toMap() {
    return <String, dynamic>{
      'mediaUrl': mediaUrl,
      'ownerId': ownerId,
      'timestamp': timestamp,
      'location': location,
      'description': description,
      'tags': tags,
      'postType': postType.index
    };
  }

  Post.fromMap(Map<String, dynamic> map)
      : postId = map['postId'],
        mediaUrl = map['mediaUrl'],
        ownerId = map['ownerId'],
        timestamp = DateTime.fromMillisecondsSinceEpoch(
            map['timestamp'].seconds * 1000),
        location = map['location'],
        description = map['description'],
        tags = map.containsKey('tags') ? List.from(map['tags']) : [],
        postType = map.containsKey('postType')
            ? PostType.values[map['postType'].toInt()]
            : PostType.image;
}
