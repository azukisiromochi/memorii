import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:like_button/like_button.dart';
import 'profile.dart';
import '../../../singleton.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class Item extends StatefulWidget {
  final String name;
  Item(this.name);

  @override
  _ItemState createState() => _ItemState();
}

class _ItemState extends State<Item> {
  
  List documentList = [];
  List likeDocumentId = [];
  List itemList = [];

  @override
  void initState() {
    super.initState();
    start();
  }

  Future<void> start() async {
    await FirebaseFirestore.instance.collection('posts').doc(widget.name).get()
    .then((doc) {
      itemList.add(doc);
      if (mounted) {setState(() {});}
      FirebaseFirestore.instance.collection('posts')
      .where('post_tags', arrayContainsAny: doc["post_tags"])
      .orderBy("post_count").limit(50).get()
      .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          documentList.add(doc);
          documentList.shuffle();
          if (mounted) {setState(() {});}
        });
      });
    });
    like();
  }
  Future<void> like() async {
    await FirebaseFirestore.instance.collection('users').doc(UserData.instance.user).get()
    .then((doc) {
      UserData.instance.documentLikeList = doc["user_likes"];
      if (mounted) {setState(() {});}
    });
  }
  _launchInApp() async {
    var url = 'https://www.instagram.com/${itemList[0]["post_instagram"]}';
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: true,
        forceWebView: true,
      );
    }
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
              child: ButtonTheme(
                padding: EdgeInsets.symmetric(vertical: 8),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                minWidth: 0,
                height: 0,
                child: TextButton(
                  child: itemList.length > 0 ? Text(
                    itemList[0]["post_instagram"],
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 15
                    ),
                  ) :  Text(""),
                  onPressed: () {
                    _launchInApp();
                  },
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  child: Icon(
                    Icons.more_horiz,
                    color: Colors.black87,
                  ),
                  onTap: () async {
                    await showCupertinoModalPopup(
                      context: context,
                      builder: (BuildContext context) {
                        return CupertinoActionSheet(
                          actions: [
                            Container(
                              color: Colors.black87,
                              child: CupertinoActionSheetAction(
                                child: Text(
                                  '報告',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onPressed: () async {
                                  HapticFeedback.heavyImpact();
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                            Container(
                              color: Colors.black87,
                              child: CupertinoActionSheetAction(
                                child: Text(
                                  'ブロック',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                                onPressed: () async {
                                  HapticFeedback.heavyImpact();
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          ],
                          cancelButton: CupertinoButton(
                            color: Colors.black87,
                            child: Text(
                              'キャンセル',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            }
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Stack(
                alignment: Alignment.bottomLeft,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10))
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10)
                      ),
                      child: itemList.length > 0 ? Image.network(
                        itemList[0]["post_image_1080"],
                        fit: BoxFit.fitWidth,
                      ) : null,
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: GestureDetector(
                      child: Container(
                        margin: EdgeInsets.only(bottom: 25, left: 25,),
                        width: 60.w,
                        child: itemList.length > 0 ? Text(
                          itemList[0]["post_instagram"],
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 11.sp,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ) : null,
                      ),
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ProfileMain(itemList[0]["post_uid"])),
                        );
                        documentList.clear();
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
                        margin: EdgeInsets.only(bottom: 15, right: 15,),
                        child: itemList.length > 0 ? LikeButton(
                          isLiked: UserData.instance.documentLikeList.contains(itemList[0].id) ? true : false,
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
                              UserData.instance.documentLikeList.remove(itemList[0].id);
                              if (mounted) {setState(() {});}
                              await FirebaseFunctions.instanceFor(app: Firebase.app(), region: 'us-central1').httpsCallable('likePhoto_false')
                              .call(
                                <String, String>{
                                'userUid': UserData.instance.user,
                                'postUid': itemList[0]['post_uid'],
                                'postId': itemList[0].id,
                              });
                            } else {
                              result = true;
                              UserData.instance.documentLikeList.add(itemList[0].id);
                              if (mounted) {setState(() {});}
                              await FirebaseFunctions.instanceFor(app: Firebase.app(), region: 'us-central1').httpsCallable('likePhoto_true')
                              .call(
                                <String, String>{
                                'userUid': UserData.instance.user,
                                'postUid': itemList[0]['post_uid'],
                                'postId': itemList[0].id,
                              });
                            }
                          },
                        ) : null,
                      ),
                    ),
                  )
                ],
              ),
              Container(
                margin: EdgeInsets.all(12),
                child: StaggeredGridView.countBuilder(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 12,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: documentList.length,
                  staggeredTileBuilder: (index) => StaggeredTile.fit(1),
                  itemBuilder: (context, index) {
                    return Container(
                      child: Stack(
                      alignment: Alignment.bottomLeft,
                        children: [
                          GestureDetector(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10))
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10)
                                ),
                                child: documentList.length > 0 ? Image.network(
                                  documentList[index]["post_image_500"],
                                  fit: BoxFit.cover,
                                ) : null,
                              ),
                            ),
                            onTap: () async {
                              if (documentList[index]["post_image_500"].isNotEmpty) {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => Item("${documentList[index].id}",)),
                                );
                                like();
                              }
                            },
                          ),
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: GestureDetector(
                              child: Container(
                                margin: EdgeInsets.only(left: 10, bottom: 9),
                                width: 30.w,
                                child: documentList.length > 0 ? Text(
                                  "${documentList[index]["post_instagram"]}",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11.sp,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ) : Text(""),
                              ),
                              onTap: () async {
                                if (documentList[index]["post_uid"].isNotEmpty) {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => ProfileMain("${documentList[index]["post_uid"]}")),
                                  );
                                  like();
                                }
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
                                  isLiked: UserData.instance.documentLikeList.contains("${documentList[index].id}") ? true : false,
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
                                      UserData.instance.documentLikeList.remove(documentList[index].id);
                                      if (mounted) {setState(() {});}
                                      await FirebaseFunctions.instanceFor(app: Firebase.app(), region: 'us-central1').httpsCallable('likePhoto_false')
                                      .call(
                                        <String, String>{
                                        'userUid': UserData.instance.user,
                                        'postUid': documentList[index]['post_uid'],
                                        'postId': documentList[index].id,
                                      });
                                    } else {
                                      result = true;
                                      UserData.instance.documentLikeList.add(documentList[index].id);
                                      if (mounted) {setState(() {});}
                                      await FirebaseFunctions.instanceFor(app: Firebase.app(), region: 'us-central1').httpsCallable('likePhoto_true')
                                      .call(
                                        <String, String>{
                                        'userUid': UserData.instance.user,
                                        'postUid': documentList[index]['post_uid'],
                                        'postId': documentList[index].id,
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
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}