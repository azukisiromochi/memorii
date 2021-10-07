import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:like_button/like_button.dart';
import '../../1-home/items/item.dart';
import '../../1-home/items/profile.dart';
import '../../singleton.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/rendering.dart';

class Like extends StatefulWidget {

  @override
  _LikeState createState() => _LikeState();
}

class _LikeState extends State<Like> {
  
  List followPhotos = [];
  List likePhotos = [];
  List likeDocumentId = [];
  bool screenNumber = true;

  @override
  void initState() {
    super.initState();
    start();
  }

  Future<void> start() async {
    followPhotos.clear();
    likePhotos.clear();
    if (mounted) {setState(() {});}

    await FirebaseFirestore.instance.collection('users')
    .doc(UserData.instance.user).get()
    .then((doc) {
      likeDocumentId = doc["user_likes"];
      if (doc["user_likes"].isNotEmpty) {
        for (var fruit in doc["user_likes"]) {
          FirebaseFirestore.instance.collection('posts').doc(fruit).get()
          .then((doc) {
            likePhotos.add(doc);
            UserData.instance.likePhotos = likePhotos;
            if (mounted) {setState(() {});}
          });
        }
      } else {
        UserData.instance.likePhotos = [];
      }
      if (mounted) {setState(() {});}
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  child: Icon(
                    Icons.clear_outlined,
                    color: Colors.black87,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                "favorite",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 7.0 / 7.0,
              children: UserData.instance.likePhotos.map((document) {
                return Card(
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    children: <Widget>[
                      GestureDetector(
                        // child: ClipRRect(
                        //   borderRadius: BorderRadius.circular(8.0),
                          child: AspectRatio(
                            aspectRatio: 11.0 / 11.0,
                          // child: Container(
                          //   decoration: BoxDecoration(
                          //     borderRadius: BorderRadius.circular(10.0),
                          //   ),
                            child: Image.network(
                              document["post_image_500"],
                              fit: BoxFit.cover,
                            ),
                          ),
                        // ),
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Item(document.id)),
                          );
                          start();
                        },
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: GestureDetector(
                          child: Container(
                            margin: EdgeInsets.only(left: 10, bottom: 9),
                            width: 30.w,
                            child: Text(
                              document["post_instagram"],
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 11.sp,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ProfileMain(document["post_uid"])),
                            );
                            start();
                          },
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: GestureDetector(
                          child: Container(
                            width: 40,
                            height: 35,
                            child: LikeButton(
                              isLiked: UserData.instance.documentLikeList.contains(document.id) ? true : false,
                              circleColor: CircleColor(start: Color(0xFFF44336), end: Color(0xFFF44336)),
                              likeBuilder: (bool isLiked) {
                                return Icon(
                                  Icons.favorite,
                                  size: 30,
                                  color: isLiked ? Colors.red : Colors.white70,
                                );
                              },
                              onTap: (result) async {
                                HapticFeedback.heavyImpact();
                                if (result) {
                                  result = false;
                                  UserData.instance.documentLikeList.remove(document.id);
                                  if (mounted) {setState(() {});}
                                  await FirebaseFunctions.instanceFor(app: Firebase.app(), region: 'us-central1').httpsCallable('likePhoto_false')
                                  .call(
                                    <String, String>{
                                    'userUid': UserData.instance.user,
                                    'postUid': document['post_uid'],
                                    'postId': document.id,
                                  });
                                } else {
                                  result = true;
                                  UserData.instance.documentLikeList.add(document.id);
                                  if (mounted) {setState(() {});}
                                  await FirebaseFunctions.instanceFor(app: Firebase.app(), region: 'us-central1').httpsCallable('likePhoto_true')
                                  .call(
                                    <String, String>{
                                    'userUid': UserData.instance.user,
                                    'postUid': document['post_uid'],
                                    'postId': document.id,
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }
}
