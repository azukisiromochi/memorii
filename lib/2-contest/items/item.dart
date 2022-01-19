import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../1-home/items/profile.dart';
import '../../singleton.dart';
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

  String postImage = "";
  String postUid = "";
  String postId = "";
  String postInstagram = "";
  List postTags = [];

  @override
  void initState() {
    super.initState();
    start();
  }

  Future <void> start() async {
    print(widget.name);
    await FirebaseFirestore.instance.collection('contests')
    .doc(widget.name)
    .get()
    .then((doc) {
      if (mounted) {setState(() {
        postImage = doc["post_image_1080"];
        postUid = doc["post_uid"];
        postId = doc.id;
        postInstagram = doc["post_instagram"];
        postTags = doc["post_tags"];
      });}
      FirebaseFirestore.instance.collection('contests')
      .get()
      .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          documentList.add(doc);
          documentList.shuffle();
          if (mounted) {setState(() {});}
        });
      });
    });
  }

  _launchInApp() async {
    var url = 'https://www.instagram.com/$postInstagram';
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
                  child: Text(
                    postInstagram,
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 15
                    ),
                  ),
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
                    await showModalBottomSheet<void>(
                      context: context,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                      ), 
                      builder: (context) {
                        return StatefulBuilder(
                          builder: (BuildContext context, StateSetter setState) {
                            return BottomSheet(
                              onClosing: () {},
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                  BorderRadius.vertical(top: Radius.circular(20)),
                              ),
                              builder: (context) {
                                return Container(
                                  height:240,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(top: 20, bottom: 0,),
                                        child: Text(
                                          "レポート",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(top: 20,),
                                            width: 29.w,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(color: Colors.black12),
                                              borderRadius: BorderRadius.circular(5),
                                            ),
                                            child: TextButton(
                                              child: Text(
                                                "報告",
                                                style: TextStyle(
                                                  color: Color(0xffED7470),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 8.sp,
                                                ),
                                              ),
                                              style: TextButton.styleFrom(
                                                primary: Colors.white,
                                              ),
                                              onPressed: () {
                                                FirebaseFirestore.instance.collection("users")
                                                  .doc(UserData.instance.user).update({'user_report':FieldValue.arrayUnion([postId,])});
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(top: 20,),
                                            width: 29.w,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(color: Colors.black12),
                                              borderRadius: BorderRadius.circular(5),
                                            ),
                                            child: TextButton(
                                              child: Text(
                                                "ブロック",
                                                style: TextStyle(
                                                  color: Color(0xffED7470),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 8.sp,
                                                ),
                                              ),
                                              style: TextButton.styleFrom(
                                                primary: Colors.white,
                                              ),
                                              onPressed: () {
                                                FirebaseFirestore.instance.collection("users")
                                                  .doc(UserData.instance.user)
                                                  .update({
                                                    'user_block':
                                                      FieldValue.arrayUnion([
                                                        postId,
                                                        ])
                                                  });
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(top: 10,),
                                            width: 29.w,
                                            height: 50,
                                          ),
                                        ],
                                      ),                   
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    );
                    if (mounted) {setState(() {});}
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
                      child: postImage.isEmpty ? null : Image.network(
                        postImage,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: GestureDetector(
                      child: Container(
                        margin: EdgeInsets.only(bottom: 25, left: 25,),
                        width: 60.w,
                        child: Text(
                          postInstagram,
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
                          MaterialPageRoute(builder: (context) => ProfileMain(postUid)),
                        );
                        documentList.clear();
                        start();
                      },
                    ),
                  ),
                  // Align(
                  //   alignment: Alignment.bottomRight,
                  //   child: GestureDetector(
                  //     child: Container(
                  //       width: 40,
                  //       height: 35,
                  //       margin: EdgeInsets.only(bottom: 15, right: 15,),
                  //       child: LikeButton(
                  //         isLiked: likeDocumentId.contains(postId) ? true : false,
                  //         circleColor: CircleColor(start: Color(0xFFF44336), end: Color(0xFFF44336)),
                  //         likeBuilder: (bool isLiked) {
                  //           return Icon(
                  //             Icons.favorite,
                  //             size: 30,
                  //             color: isLiked ? Colors.red : Colors.white70,
                  //           );
                  //         },
                  //         onTap: (result) async {
                  //           if (result) {
                  //             await FirebaseFirestore.instance.collection("posts")
                  //             .doc(postId).update({"post_count": FieldValue.increment(-1),});
                  //             await FirebaseFirestore.instance.collection("users")
                  //             .doc(UserData.instance.user).update({'user_likes':FieldValue.arrayRemove([postId,])});
                  //             likeDocumentId.remove(postId);
                  //             if (mounted) {setState(() {});}
                  //           } else {
                  //             await FirebaseFirestore.instance.collection("posts")
                  //             .doc(postId).update({"post_count": FieldValue.increment(1),});
                  //             await FirebaseFirestore.instance.collection("users")
                  //             .doc(UserData.instance.user).update({'user_likes':FieldValue.arrayUnion([postId,])});
                  //             likeDocumentId.add(postId);
                  //             if (mounted) {setState(() {});}
                  //           }
                  //           return !result;
                  //         },
                  //       ),
                  //     ),
                    // ),
                  // ),
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
                                child: Image.network(
                                  "${documentList[index]["post_image_500"]}",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            onTap: () async {
                              if (documentList[index]["post_image_500"].isNotEmpty) {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => Item("${documentList[index].id}",)),
                                );
                              }
                            },
                          ),
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: GestureDetector(
                              child: Container(
                                margin: EdgeInsets.only(left: 10, bottom: 9),
                                width: 30.w,
                                child: Text(
                                  "${documentList[index]["post_instagram"]}",
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
                                if (documentList[index]["post_uid"].isNotEmpty) {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => ProfileMain("${documentList[index]["post_uid"]}")),
                                  );
                                }
                              },
                            ),
                          ),
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