import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:like_button/like_button.dart';
import 'package:url_launcher/url_launcher.dart';
import 'item.dart';
import '../../../singleton.dart';
import 'package:sizer/sizer.dart';

class ProfileMain extends StatefulWidget {
  final String name;
  ProfileMain(this.name);

  @override
  _ProfileMainState createState() => _ProfileMainState();
}

class _ProfileMainState extends State<ProfileMain> {

  List userList = [];
  List documentList = [];

  @override
  void initState() {
    super.initState();
    start();
  }

  Future <void> start() async {
    await FirebaseFirestore.instance.collection('users').doc(widget.name).get()
    .then((doc) {
      userList.add(doc);
      if (mounted) {setState(() {});}
    });

    await FirebaseFirestore.instance.collection('posts')
    .where('post_uid', isEqualTo: widget.name).orderBy("post_time", descending: true).get()
    .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        documentList.add(doc);
        if (mounted) {setState(() {});}
      });
    });

    like();
  }
  Future <void> like() async {
    await FirebaseFirestore.instance.collection('users')
    .doc(UserData.instance.user).get()
    .then((doc) {
      UserData.instance.documentLikeList = doc["user_likes"];
      if (mounted) {setState(() {});}
    });
  }
  _launchInApp() async {
    var url = 'https://www.instagram.com/${userList[0]["user_instagram"]}';
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
                    color: Colors.white,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: TextButton(
                child: userList.length > 0 ? Text(
                  userList[0]["user_instagram"],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15
                  ),
                ) : Text(""),
                onPressed: () {
                  _launchInApp();
                },
              ),
            ),
          ],
        ),
        backgroundColor: Color(0xFFFF8D89),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 140,
                    color: Color(0xFFFF8D89),
                  ),
                  Stack(
                    children: [
                      Container(
                        width: 80.w,
                        height: 140,
                        margin: EdgeInsets.only(top: 80, right: 10.w, left: 10.w),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 20.0,
                              spreadRadius: 1.0,
                              offset: Offset(0, 0)
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 80.w,
                        height: 140,
                        color: Colors.white,
                        margin: EdgeInsets.only(top: 80, right: 10.w, left: 10.w),
                      ),
                      Container(
                        height: 110,
                        width: 30.w,
                        margin: EdgeInsets.only(top: 20, right: 35.w, left: 35.w),
                        child: userList.length > 0 ? CircleAvatar(
                          radius: 100,
                          backgroundColor: Colors.white,
                          backgroundImage: NetworkImage(userList[0]["user_image_500"]),
                        ) : null,
                        padding: EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                          color: Color(0xFFFFFFFF),
                          shape: BoxShape.circle,
                        )
                      ),
                      Container(
                        width: 50.w,
                        margin: EdgeInsets.only(top: 150, right: 25.w, left: 25.w),
                        child: userList.length > 0 ? Text(
                          userList[0]["user_name"] != "" ? userList[0]["user_name"] : "unnamed",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            fontSize: 20,
                          ),
                        ) : Text(""),
                      ),
                      Container(
                        width: 50.w,
                        margin: EdgeInsets.only(top: 180, right: 25.w, left: 25.w),
                        child: userList.length > 0 ? Text(
                          userList[0]["user_text"],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black26,
                            fontSize: 12,
                          ),
                        ) : Text(""),
                      ),
                    ]
                  ),
                ],
              ),
              Container(
                height: 50,
              ),
              Container(
                margin: EdgeInsets.only(right: 4.w, left: 4.w),
                child: GridView.count( 
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  childAspectRatio: 7.0 / 7.0,
                  children: documentList.map((document) {
                    return Card(
                      clipBehavior: Clip.antiAlias,
                      child: Stack(
                        children: <Widget>[
                          GestureDetector(
                            child: AspectRatio(
                            aspectRatio: 11.0 / 11.0,
                              child: Image.network(
                                document["post_image_500"],
                                fit: BoxFit.cover,
                              ),
                            ),
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Item(document.id)),
                              );
                              like();
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
                                like();
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
                                      UserData.instance.documentLikeList.remove("${document.id}");
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
                                      UserData.instance.documentLikeList.add("${document.id}");
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
              ),
              Container(
                height: 200,
              ),
            ],
          ),
        ),
      ),
    );
  }
}