import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'items/post.dart';
import 'items/item.dart';
import 'items/profile.dart';
import 'package:app/1-home/items/post.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../singleton.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class PhotoMain extends StatefulWidget {
  final Function() onTap;
  const PhotoMain(this.onTap);

  @override
  _PhotoMainState createState() => _PhotoMainState();
}

class _PhotoMainState extends State<PhotoMain> {
  
  // ジャンル選択btn
  bool btnAll = true;
  bool btnMen = false;
  bool btnLadies = false;
  bool btnStreet = false;
  bool btnClassic = false;
  bool btnMode = false;
  bool btnFeminin = false;
  bool btnGrunge = false;
  bool btnAnnui = false;
  bool btnRock = false;
  bool btnCrieitive = false;

  @override
  void initState() {
    super.initState();
    like();
  }
  Future<void> like() async {
    UserData.instance.documentLikeList.clear();
    await FirebaseFirestore.instance.collection('users').doc(UserData.instance.user).get()
    .then((doc) {
      UserData.instance.documentLikeList = doc["user_likes"];
      if (mounted) {setState(() {});}
    });
  }


  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onGenerateRoute: (settings) {
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (context) {
            return  Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "作品撮り",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        icon: Icon(
                          Icons.add_box_outlined,
                          color: Colors.black87,
                        ),
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            // MaterialPageRoute(builder: (context) => OtherMainPost(widget.onTap)),
                            MaterialPageRoute(builder: (context) => Post()),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                backgroundColor: Colors.white,
                centerTitle: false,
                elevation: 0.0,
              ),
              body: DefaultTabController(
                length: 11,
                child: NestedScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  headerSliverBuilder: (context,isScolled){
                    return [
                      SliverPersistentHeader(
                        delegate: MyDelegate(
                          TabBar(
                            tabs: [
                              Tab(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text("全選択"),
                                ),
                              ),
                              Tab(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text("メンズ"),
                                ),
                              ),
                              Tab(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text("レディース"),
                                ),
                              ),
                              Tab(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text("ストリート"),
                                ),
                              ),
                              Tab(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text("クラシック"),
                                ),
                              ),
                              Tab(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text("モード"),
                                ),
                              ),
                              Tab(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text("フェミニン"),
                                ),
                              ),
                              Tab(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text("グランジ"),
                                ),
                              ),
                              Tab(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text("アンニュイ"),
                                ),
                              ),
                              Tab(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text("ロック"),
                                ),
                              ),
                              Tab(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text("クリエイティブ"),
                                ),
                              ),
                            ],
                            isScrollable: true,
                            indicatorColor: Color(0xFFFF8D89),
                            unselectedLabelColor: Colors.grey,
                            labelColor: Colors.black,
                          )
                        ),
                        floating: true,
                        pinned: true,
                      )
                    ];
                  },
                  body: TabBarView(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 12, right: 12, left: 12),
                        child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                            .collection('posts')
                            .orderBy("post_count", descending: true)
                            .snapshots(),
                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasData) {
                              return StaggeredGridView.countBuilder(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 12,
                                itemCount: snapshot.data!.docs.length,
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
                                                Radius.circular(10),
                                              )
                                            ),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(10.0),
                                              child: snapshot.data!.docs[index]["post_image_500"] == null ? Image.network("") : Image.network(
                                                snapshot.data!.docs[index]["post_image_500"],
                                              ),
                                            ),
                                          ),
                                          onTap: () async {
                                            if (snapshot.data!.docs[index]["post_image_500"].isNotEmpty) {
                                              await Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => Item("${snapshot.data!.docs[index].id}",)),
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
                                              child: Text(
                                                "${snapshot.data!.docs[index]["post_instagram"]}",
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
                                              if (snapshot.data!.docs[index]["post_uid"].isNotEmpty) {
                                                await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => ProfileMain("${snapshot.data!.docs[index]["post_uid"]}")),
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
                                                isLiked: UserData.instance.documentLikeList.contains("${snapshot.data!.docs[index].id}") ? true : false,
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
                                                    UserData.instance.documentLikeList.remove("${snapshot.data!.docs[index].id}");
                                                    if (mounted) {setState(() {});}
                                                    await FirebaseFunctions.instanceFor(app: Firebase.app(), region: 'us-central1').httpsCallable('likePhoto_false')
                                                    .call(
                                                      <String, String>{
                                                      'userUid': UserData.instance.user,
                                                      'postUid': snapshot.data!.docs[index]['post_uid'],
                                                      'postId': snapshot.data!.docs[index].id}
                                                    );
                                                  } else {
                                                    result = true;
                                                    UserData.instance.documentLikeList.add("${snapshot.data!.docs[index].id}");
                                                    if (mounted) {setState(() {});}
                                                    await FirebaseFunctions.instanceFor(app: Firebase.app(), region: 'us-central1').httpsCallable('likePhoto_true')
                                                    .call(
                                                      <String, String>{
                                                      'userUid': UserData.instance.user,
                                                      'postUid': snapshot.data!.docs[index]['post_uid'],
                                                      'postId': snapshot.data!.docs[index].id}
                                                    );
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
                              );
                            } else {
                              return Container();
                            }
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 12, right: 12, left: 12),
                        child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                            .collection('posts')
                            .where('post_tags', arrayContains: 'メンズ')
                            .orderBy("post_count", descending: true)
                            .snapshots(),
                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasData) {
                              return StaggeredGridView.countBuilder(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 12,
                                itemCount: snapshot.data!.docs.length,
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
                                                Radius.circular(10),
                                              )
                                            ),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(10.0),
                                              child: snapshot.data!.docs[index]["post_image_500"] == null ? Image.network("") : Image.network(
                                                snapshot.data!.docs[index]["post_image_500"],
                                              ),
                                            ),
                                          ),
                                          onTap: () async {
                                            if (snapshot.data!.docs[index]["post_image_500"].isNotEmpty) {
                                              await Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => Item("${snapshot.data!.docs[index].id}",)),
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
                                              child: Text(
                                                "${snapshot.data!.docs[index]["post_instagram"]}",
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
                                              if (snapshot.data!.docs[index]["post_uid"].isNotEmpty) {
                                                await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => ProfileMain("${snapshot.data!.docs[index]["post_uid"]}")),
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
                                                isLiked: UserData.instance.documentLikeList.contains("${snapshot.data!.docs[index].id}") ? true : false,
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
                                                    UserData.instance.documentLikeList.remove("${snapshot.data!.docs[index].id}");
                                                    if (mounted) {setState(() {});}
                                                    await FirebaseFunctions.instanceFor(app: Firebase.app(), region: 'us-central1').httpsCallable('likePhoto_false')
                                                    .call(
                                                      <String, String>{
                                                      'userUid': UserData.instance.user,
                                                      'postUid': snapshot.data!.docs[index]['post_uid'],
                                                      'postId': snapshot.data!.docs[index].id}
                                                    );
                                                  } else {
                                                    result = true;
                                                    UserData.instance.documentLikeList.add("${snapshot.data!.docs[index].id}");
                                                    if (mounted) {setState(() {});}
                                                    await FirebaseFunctions.instanceFor(app: Firebase.app(), region: 'us-central1').httpsCallable('likePhoto_true')
                                                    .call(
                                                      <String, String>{
                                                      'userUid': UserData.instance.user,
                                                      'postUid': snapshot.data!.docs[index]['post_uid'],
                                                      'postId': snapshot.data!.docs[index].id}
                                                    );
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
                              );
                            } else {
                              return Container();
                            }
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 12, right: 12, left: 12),
                        child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                            .collection('posts')
                            .where('post_tags', arrayContains: 'レディース')
                            .orderBy("post_count", descending: true)
                            .snapshots(),
                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasData) {
                              return StaggeredGridView.countBuilder(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 12,
                                itemCount: snapshot.data!.docs.length,
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
                                                Radius.circular(10),
                                              )
                                            ),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(10.0),
                                              child: snapshot.data!.docs[index]["post_image_500"] == null ? Image.network("") : Image.network(
                                                snapshot.data!.docs[index]["post_image_500"],
                                              ),
                                            ),
                                          ),
                                          onTap: () async {
                                            if (snapshot.data!.docs[index]["post_image_500"].isNotEmpty) {
                                              await Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => Item("${snapshot.data!.docs[index].id}",)),
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
                                              child: Text(
                                                "${snapshot.data!.docs[index]["post_instagram"]}",
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
                                              if (snapshot.data!.docs[index]["post_uid"].isNotEmpty) {
                                                await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => ProfileMain("${snapshot.data!.docs[index]["post_uid"]}")),
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
                                                isLiked: UserData.instance.documentLikeList.contains("${snapshot.data!.docs[index].id}") ? true : false,
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
                                                    UserData.instance.documentLikeList.remove("${snapshot.data!.docs[index].id}");
                                                    if (mounted) {setState(() {});}
                                                    await FirebaseFunctions.instanceFor(app: Firebase.app(), region: 'us-central1').httpsCallable('likePhoto_false')
                                                    .call(
                                                      <String, String>{
                                                      'userUid': UserData.instance.user,
                                                      'postUid': snapshot.data!.docs[index]['post_uid'],
                                                      'postId': snapshot.data!.docs[index].id}
                                                    );
                                                  } else {
                                                    result = true;
                                                    UserData.instance.documentLikeList.add("${snapshot.data!.docs[index].id}");
                                                    if (mounted) {setState(() {});}
                                                    await FirebaseFunctions.instanceFor(app: Firebase.app(), region: 'us-central1').httpsCallable('likePhoto_true')
                                                    .call(
                                                      <String, String>{
                                                      'userUid': UserData.instance.user,
                                                      'postUid': snapshot.data!.docs[index]['post_uid'],
                                                      'postId': snapshot.data!.docs[index].id}
                                                    );
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
                              );
                            } else {
                              return Container();
                            }
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 12, right: 12, left: 12),
                        child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                            .collection('posts')
                            .where('post_tags', arrayContains: 'ストリート')
                            .orderBy("post_count", descending: true)
                            .snapshots(),
                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasData) {
                              return StaggeredGridView.countBuilder(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 12,
                                itemCount: snapshot.data!.docs.length,
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
                                                Radius.circular(10),
                                              )
                                            ),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(10.0),
                                              child: snapshot.data!.docs[index]["post_image_500"] == null ? Image.network("") : Image.network(
                                                snapshot.data!.docs[index]["post_image_500"],
                                              ),
                                            ),
                                          ),
                                          onTap: () async {
                                            if (snapshot.data!.docs[index]["post_image_500"].isNotEmpty) {
                                              await Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => Item("${snapshot.data!.docs[index].id}",)),
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
                                              child: Text(
                                                "${snapshot.data!.docs[index]["post_instagram"]}",
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
                                              if (snapshot.data!.docs[index]["post_uid"].isNotEmpty) {
                                                await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => ProfileMain("${snapshot.data!.docs[index]["post_uid"]}")),
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
                                                isLiked: UserData.instance.documentLikeList.contains("${snapshot.data!.docs[index].id}") ? true : false,
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
                                                    UserData.instance.documentLikeList.remove("${snapshot.data!.docs[index].id}");
                                                    if (mounted) {setState(() {});}
                                                    await FirebaseFunctions.instanceFor(app: Firebase.app(), region: 'us-central1').httpsCallable('likePhoto_false')
                                                    .call(
                                                      <String, String>{
                                                      'userUid': UserData.instance.user,
                                                      'postUid': snapshot.data!.docs[index]['post_uid'],
                                                      'postId': snapshot.data!.docs[index].id}
                                                    );
                                                  } else {
                                                    result = true;
                                                    UserData.instance.documentLikeList.add("${snapshot.data!.docs[index].id}");
                                                    if (mounted) {setState(() {});}
                                                    await FirebaseFunctions.instanceFor(app: Firebase.app(), region: 'us-central1').httpsCallable('likePhoto_true')
                                                    .call(
                                                      <String, String>{
                                                      'userUid': UserData.instance.user,
                                                      'postUid': snapshot.data!.docs[index]['post_uid'],
                                                      'postId': snapshot.data!.docs[index].id}
                                                    );
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
                              );
                            } else {
                              return Container();
                            }
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 12, right: 12, left: 12),
                        child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                            .collection('posts')
                            .where('post_tags', arrayContains: 'クラシック')
                            .orderBy("post_count", descending: true)
                            .snapshots(),
                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasData) {
                              return StaggeredGridView.countBuilder(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 12,
                                itemCount: snapshot.data!.docs.length,
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
                                                Radius.circular(10),
                                              )
                                            ),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(10.0),
                                              child: snapshot.data!.docs[index]["post_image_500"] == null ? Image.network("") : Image.network(
                                                snapshot.data!.docs[index]["post_image_500"],
                                              ),
                                            ),
                                          ),
                                          onTap: () async {
                                            if (snapshot.data!.docs[index]["post_image_500"].isNotEmpty) {
                                              await Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => Item("${snapshot.data!.docs[index].id}",)),
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
                                              child: Text(
                                                "${snapshot.data!.docs[index]["post_instagram"]}",
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
                                              if (snapshot.data!.docs[index]["post_uid"].isNotEmpty) {
                                                await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => ProfileMain("${snapshot.data!.docs[index]["post_uid"]}")),
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
                                                isLiked: UserData.instance.documentLikeList.contains("${snapshot.data!.docs[index].id}") ? true : false,
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
                                                    UserData.instance.documentLikeList.remove("${snapshot.data!.docs[index].id}");
                                                    if (mounted) {setState(() {});}
                                                    await FirebaseFunctions.instanceFor(app: Firebase.app(), region: 'us-central1').httpsCallable('likePhoto_false')
                                                    .call(
                                                      <String, String>{
                                                      'userUid': UserData.instance.user,
                                                      'postUid': snapshot.data!.docs[index]['post_uid'],
                                                      'postId': snapshot.data!.docs[index].id}
                                                    );
                                                  } else {
                                                    result = true;
                                                    UserData.instance.documentLikeList.add("${snapshot.data!.docs[index].id}");
                                                    if (mounted) {setState(() {});}
                                                    await FirebaseFunctions.instanceFor(app: Firebase.app(), region: 'us-central1').httpsCallable('likePhoto_true')
                                                    .call(
                                                      <String, String>{
                                                      'userUid': UserData.instance.user,
                                                      'postUid': snapshot.data!.docs[index]['post_uid'],
                                                      'postId': snapshot.data!.docs[index].id}
                                                    );
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
                              );
                            } else {
                              return Container();
                            }
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 12, right: 12, left: 12),
                        child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                            .collection('posts')
                            .where('post_tags', arrayContains: 'モード')
                            .orderBy("post_count", descending: true)
                            .snapshots(),
                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasData) {
                              return StaggeredGridView.countBuilder(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 12,
                                itemCount: snapshot.data!.docs.length,
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
                                                Radius.circular(10),
                                              )
                                            ),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(10.0),
                                              child: snapshot.data!.docs[index]["post_image_500"] == null ? Image.network("") : Image.network(
                                                snapshot.data!.docs[index]["post_image_500"],
                                              ),
                                            ),
                                          ),
                                          onTap: () async {
                                            if (snapshot.data!.docs[index]["post_image_500"].isNotEmpty) {
                                              await Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => Item("${snapshot.data!.docs[index].id}",)),
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
                                              child: Text(
                                                "${snapshot.data!.docs[index]["post_instagram"]}",
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
                                              if (snapshot.data!.docs[index]["post_uid"].isNotEmpty) {
                                                await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => ProfileMain("${snapshot.data!.docs[index]["post_uid"]}")),
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
                                                isLiked: UserData.instance.documentLikeList.contains("${snapshot.data!.docs[index].id}") ? true : false,
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
                                                    UserData.instance.documentLikeList.remove("${snapshot.data!.docs[index].id}");
                                                    if (mounted) {setState(() {});}
                                                    await FirebaseFunctions.instanceFor(app: Firebase.app(), region: 'us-central1').httpsCallable('likePhoto_false')
                                                    .call(
                                                      <String, String>{
                                                      'userUid': UserData.instance.user,
                                                      'postUid': snapshot.data!.docs[index]['post_uid'],
                                                      'postId': snapshot.data!.docs[index].id}
                                                    );
                                                  } else {
                                                    result = true;
                                                    UserData.instance.documentLikeList.add("${snapshot.data!.docs[index].id}");
                                                    if (mounted) {setState(() {});}
                                                    await FirebaseFunctions.instanceFor(app: Firebase.app(), region: 'us-central1').httpsCallable('likePhoto_true')
                                                    .call(
                                                      <String, String>{
                                                      'userUid': UserData.instance.user,
                                                      'postUid': snapshot.data!.docs[index]['post_uid'],
                                                      'postId': snapshot.data!.docs[index].id}
                                                    );
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
                              );
                            } else {
                              return Container();
                            }
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 12, right: 12, left: 12),
                        child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                            .collection('posts')
                            .where('post_tags', arrayContains: 'フェミニン')
                            .orderBy("post_count", descending: true)
                            .snapshots(),
                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasData) {
                              return StaggeredGridView.countBuilder(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 12,
                                itemCount: snapshot.data!.docs.length,
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
                                                Radius.circular(10),
                                              )
                                            ),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(10.0),
                                              child: snapshot.data!.docs[index]["post_image_500"] == null ? Image.network("") : Image.network(
                                                snapshot.data!.docs[index]["post_image_500"],
                                              ),
                                            ),
                                          ),
                                          onTap: () async {
                                            if (snapshot.data!.docs[index]["post_image_500"].isNotEmpty) {
                                              await Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => Item("${snapshot.data!.docs[index].id}",)),
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
                                              child: Text(
                                                "${snapshot.data!.docs[index]["post_instagram"]}",
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
                                              if (snapshot.data!.docs[index]["post_uid"].isNotEmpty) {
                                                await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => ProfileMain("${snapshot.data!.docs[index]["post_uid"]}")),
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
                                                isLiked: UserData.instance.documentLikeList.contains("${snapshot.data!.docs[index].id}") ? true : false,
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
                                                    UserData.instance.documentLikeList.remove("${snapshot.data!.docs[index].id}");
                                                    if (mounted) {setState(() {});}
                                                    await FirebaseFunctions.instanceFor(app: Firebase.app(), region: 'us-central1').httpsCallable('likePhoto_false')
                                                    .call(
                                                      <String, String>{
                                                      'userUid': UserData.instance.user,
                                                      'postUid': snapshot.data!.docs[index]['post_uid'],
                                                      'postId': snapshot.data!.docs[index].id}
                                                    );
                                                  } else {
                                                    result = true;
                                                    UserData.instance.documentLikeList.add("${snapshot.data!.docs[index].id}");
                                                    if (mounted) {setState(() {});}
                                                    await FirebaseFunctions.instanceFor(app: Firebase.app(), region: 'us-central1').httpsCallable('likePhoto_true')
                                                    .call(
                                                      <String, String>{
                                                      'userUid': UserData.instance.user,
                                                      'postUid': snapshot.data!.docs[index]['post_uid'],
                                                      'postId': snapshot.data!.docs[index].id}
                                                    );
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
                              );
                            } else {
                              return Container();
                            }
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 12, right: 12, left: 12),
                        child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                            .collection('posts')
                            .where('post_tags', arrayContains: 'グランジ')
                            .orderBy("post_count", descending: true)
                            .snapshots(),
                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasData) {
                              return StaggeredGridView.countBuilder(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 12,
                                itemCount: snapshot.data!.docs.length,
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
                                                Radius.circular(10),
                                              )
                                            ),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(10.0),
                                              child: snapshot.data!.docs[index]["post_image_500"] == null ? Image.network("") : Image.network(
                                                snapshot.data!.docs[index]["post_image_500"],
                                              ),
                                            ),
                                          ),
                                          onTap: () async {
                                            if (snapshot.data!.docs[index]["post_image_500"].isNotEmpty) {
                                              await Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => Item("${snapshot.data!.docs[index].id}",)),
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
                                              child: Text(
                                                "${snapshot.data!.docs[index]["post_instagram"]}",
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
                                              if (snapshot.data!.docs[index]["post_uid"].isNotEmpty) {
                                                await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => ProfileMain("${snapshot.data!.docs[index]["post_uid"]}")),
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
                                                isLiked: UserData.instance.documentLikeList.contains("${snapshot.data!.docs[index].id}") ? true : false,
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
                                                    UserData.instance.documentLikeList.remove("${snapshot.data!.docs[index].id}");
                                                    if (mounted) {setState(() {});}
                                                    await FirebaseFunctions.instanceFor(app: Firebase.app(), region: 'us-central1').httpsCallable('likePhoto_false')
                                                    .call(
                                                      <String, String>{
                                                      'userUid': UserData.instance.user,
                                                      'postUid': snapshot.data!.docs[index]['post_uid'],
                                                      'postId': snapshot.data!.docs[index].id}
                                                    );
                                                  } else {
                                                    result = true;
                                                    UserData.instance.documentLikeList.add("${snapshot.data!.docs[index].id}");
                                                    if (mounted) {setState(() {});}
                                                    await FirebaseFunctions.instanceFor(app: Firebase.app(), region: 'us-central1').httpsCallable('likePhoto_true')
                                                    .call(
                                                      <String, String>{
                                                      'userUid': UserData.instance.user,
                                                      'postUid': snapshot.data!.docs[index]['post_uid'],
                                                      'postId': snapshot.data!.docs[index].id}
                                                    );
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
                              );
                            } else {
                              return Container();
                            }
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 12, right: 12, left: 12),
                        child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                            .collection('posts')
                            .where('post_tags', arrayContains: 'アンニュイ')
                            .orderBy("post_count", descending: true)
                            .snapshots(),
                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasData) {
                              return StaggeredGridView.countBuilder(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 12,
                                itemCount: snapshot.data!.docs.length,
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
                                                Radius.circular(10),
                                              )
                                            ),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(10.0),
                                              child: snapshot.data!.docs[index]["post_image_500"] == null ? Image.network("") : Image.network(
                                                snapshot.data!.docs[index]["post_image_500"],
                                              ),
                                            ),
                                          ),
                                          onTap: () async {
                                            if (snapshot.data!.docs[index]["post_image_500"].isNotEmpty) {
                                              await Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => Item("${snapshot.data!.docs[index].id}",)),
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
                                              child: Text(
                                                "${snapshot.data!.docs[index]["post_instagram"]}",
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
                                              if (snapshot.data!.docs[index]["post_uid"].isNotEmpty) {
                                                await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => ProfileMain("${snapshot.data!.docs[index]["post_uid"]}")),
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
                                                isLiked: UserData.instance.documentLikeList.contains("${snapshot.data!.docs[index].id}") ? true : false,
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
                                                    UserData.instance.documentLikeList.remove("${snapshot.data!.docs[index].id}");
                                                    if (mounted) {setState(() {});}
                                                    await FirebaseFunctions.instanceFor(app: Firebase.app(), region: 'us-central1').httpsCallable('likePhoto_false')
                                                    .call(
                                                      <String, String>{
                                                      'userUid': UserData.instance.user,
                                                      'postUid': snapshot.data!.docs[index]['post_uid'],
                                                      'postId': snapshot.data!.docs[index].id}
                                                    );
                                                  } else {
                                                    result = true;
                                                    UserData.instance.documentLikeList.add("${snapshot.data!.docs[index].id}");
                                                    if (mounted) {setState(() {});}
                                                    await FirebaseFunctions.instanceFor(app: Firebase.app(), region: 'us-central1').httpsCallable('likePhoto_true')
                                                    .call(
                                                      <String, String>{
                                                      'userUid': UserData.instance.user,
                                                      'postUid': snapshot.data!.docs[index]['post_uid'],
                                                      'postId': snapshot.data!.docs[index].id}
                                                    );
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
                              );
                            } else {
                              return Container();
                            }
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 12, right: 12, left: 12),
                        child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                            .collection('posts')
                            .where('post_tags', arrayContains: 'ロック')
                            .orderBy("post_count", descending: true)
                            .snapshots(),
                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasData) {
                              return StaggeredGridView.countBuilder(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 12,
                                itemCount: snapshot.data!.docs.length,
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
                                                Radius.circular(10),
                                              )
                                            ),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(10.0),
                                              child: snapshot.data!.docs[index]["post_image_500"] == null ? Image.network("") : Image.network(
                                                snapshot.data!.docs[index]["post_image_500"],
                                              ),
                                            ),
                                          ),
                                          onTap: () async {
                                            if (snapshot.data!.docs[index]["post_image_500"].isNotEmpty) {
                                              await Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => Item("${snapshot.data!.docs[index].id}",)),
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
                                              child: Text(
                                                "${snapshot.data!.docs[index]["post_instagram"]}",
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
                                              if (snapshot.data!.docs[index]["post_uid"].isNotEmpty) {
                                                await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => ProfileMain("${snapshot.data!.docs[index]["post_uid"]}")),
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
                                                isLiked: UserData.instance.documentLikeList.contains("${snapshot.data!.docs[index].id}") ? true : false,
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
                                                    UserData.instance.documentLikeList.remove("${snapshot.data!.docs[index].id}");
                                                    if (mounted) {setState(() {});}
                                                    await FirebaseFunctions.instanceFor(app: Firebase.app(), region: 'us-central1').httpsCallable('likePhoto_false')
                                                    .call(
                                                      <String, String>{
                                                      'userUid': UserData.instance.user,
                                                      'postUid': snapshot.data!.docs[index]['post_uid'],
                                                      'postId': snapshot.data!.docs[index].id}
                                                    );
                                                  } else {
                                                    result = true;
                                                    UserData.instance.documentLikeList.add("${snapshot.data!.docs[index].id}");
                                                    if (mounted) {setState(() {});}
                                                    await FirebaseFunctions.instanceFor(app: Firebase.app(), region: 'us-central1').httpsCallable('likePhoto_true')
                                                    .call(
                                                      <String, String>{
                                                      'userUid': UserData.instance.user,
                                                      'postUid': snapshot.data!.docs[index]['post_uid'],
                                                      'postId': snapshot.data!.docs[index].id}
                                                    );
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
                              );
                            } else {
                              return Container();
                            }
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 12, right: 12, left: 12),
                        child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                            .collection('posts')
                            .where('post_tags', arrayContains: 'クリエイティブ')
                            .orderBy("post_count", descending: true)
                            .snapshots(),
                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasData) {
                              return StaggeredGridView.countBuilder(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 12,
                                itemCount: snapshot.data!.docs.length,
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
                                                Radius.circular(10),
                                              )
                                            ),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(10.0),
                                              child: snapshot.data!.docs[index]["post_image_500"] == null ? Image.network("") : Image.network(
                                                snapshot.data!.docs[index]["post_image_500"],
                                              ),
                                            ),
                                          ),
                                          onTap: () async {
                                            if (snapshot.data!.docs[index]["post_image_500"].isNotEmpty) {
                                              await Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => Item("${snapshot.data!.docs[index].id}",)),
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
                                              child: Text(
                                                "${snapshot.data!.docs[index]["post_instagram"]}",
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
                                              if (snapshot.data!.docs[index]["post_uid"].isNotEmpty) {
                                                await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => ProfileMain("${snapshot.data!.docs[index]["post_uid"]}")),
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
                                                isLiked: UserData.instance.documentLikeList.contains("${snapshot.data!.docs[index].id}") ? true : false,
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
                                                    UserData.instance.documentLikeList.remove("${snapshot.data!.docs[index].id}");
                                                    if (mounted) {setState(() {});}
                                                    await FirebaseFunctions.instanceFor(app: Firebase.app(), region: 'us-central1').httpsCallable('likePhoto_false')
                                                    .call(
                                                      <String, String>{
                                                      'userUid': UserData.instance.user,
                                                      'postUid': snapshot.data!.docs[index]['post_uid'],
                                                      'postId': snapshot.data!.docs[index].id}
                                                    );
                                                  } else {
                                                    result = true;
                                                    UserData.instance.documentLikeList.add("${snapshot.data!.docs[index].id}");
                                                    if (mounted) {setState(() {});}
                                                    await FirebaseFunctions.instanceFor(app: Firebase.app(), region: 'us-central1').httpsCallable('likePhoto_true')
                                                    .call(
                                                      <String, String>{
                                                      'userUid': UserData.instance.user,
                                                      'postUid': snapshot.data!.docs[index]['post_uid'],
                                                      'postId': snapshot.data!.docs[index].id}
                                                    );
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
                              );
                            } else {
                              return Container();
                            }
                          },
                        ),
                      ),
                    ]
                  ),
                ),
              ),
            );
          }
        );
      },
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Navigator(
  //     key: navigatorKey,
  //     onGenerateRoute: (settings) {
  //       return MaterialPageRoute<void>(
  //         settings: settings,
  //         builder: (context) {
  //           return Scaffold(
  //             appBar: AppBar(
  //               automaticallyImplyLeading: false,
  //               title: Stack(
  //                 alignment: Alignment.center,
  //                 children: <Widget>[
  //                   Align(
  //                     alignment: Alignment.center,
  //                     child: Text(
  //                       "ホーム",
  //                       textAlign: TextAlign.center,
  //                       style: TextStyle(
  //                         color: Colors.black87,
  //                         fontWeight: FontWeight.bold,
  //                         fontSize: 14,
  //                       ),
  //                     ),
  //                   ),
  //                   Align(
  //                     alignment: Alignment.centerRight,
  //                     child: IconButton(
  //                       icon: Icon(
  //                         Icons.add_box_outlined,
  //                         color: Colors.black87,
  //                       ),
  //                       onPressed: () async {
  //                         await Navigator.push(
  //                           context,
  //                           // MaterialPageRoute(builder: (context) => OtherMainPost(widget.onTap)),
  //                           MaterialPageRoute(builder: (context) => Post()),
  //                         );
  //                       },
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //               backgroundColor: Colors.white,
  //               centerTitle: false,
  //               elevation: 0.0,
  //             ),
  //             body: Column(
  //               children: <Widget>[
  //                 Container(
  //                   height: 35.0,
  //                   child: ListView(
  //                     scrollDirection: Axis.horizontal,
  //                     children: [
  //                       GestureDetector(
  //                         child: Container(
  //                           height: 10,
  //                           width: 70,
  //                           margin: EdgeInsets.only(left: 5, bottom: 5,),
  //                           decoration: BoxDecoration(
  //                             borderRadius: BorderRadius.circular(20),
  //                             border: Border.all(
  //                               color: btnAll ? Color(0xFFFF8D89) : Colors.black45,
  //                               width: 1,
  //                             ),
  //                           ),
  //                           child: Center(
  //                             child: Text(
  //                               "全選択",
  //                               textAlign: TextAlign.center,
  //                               style: TextStyle(
  //                                 color: btnAll ? Color(0xFFFF8D89) : Colors.black45,
  //                                 fontWeight: FontWeight.bold,
  //                                 fontSize: 12,
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                         onTap: () {
  //                           HapticFeedback.heavyImpact();
  //                           btnAll = true;
  //                           btnMen = false;
  //                           btnLadies = false;
  //                           btnStreet = false;
  //                           btnClassic = false;
  //                           btnMode = false;
  //                           btnFeminin = false;
  //                           btnGrunge = false;
  //                           btnAnnui = false;
  //                           btnRock = false;
  //                           btnCrieitive = false;
  //                           UserData.instance.choiceList = "all";
  //                           snapshot.data!.docs = UserData.instance.listAll;
  //                           if (mounted) {setState(() {});}
  //                         },
  //                       ),
  //                       GestureDetector(
  //                         child: Container(
  //                           height: 10,
  //                           width: 70,
  //                           margin: EdgeInsets.only(left: 5, bottom: 5,),
  //                           decoration: BoxDecoration(
  //                             borderRadius: BorderRadius.circular(20),
  //                             border: Border.all(
  //                               color: btnMen ? Color(0xFFFF8D89) : Colors.black45,
  //                               width: 1,
  //                             ),
  //                           ),
  //                           child: Center(
  //                             child: Text(
  //                               "メンズ",
  //                               textAlign: TextAlign.center,
  //                               style: TextStyle(
  //                                 color: btnMen ? Color(0xFFFF8D89) : Colors.black45,
  //                                 fontWeight: FontWeight.bold,
  //                                 fontSize: 12,
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                         onTap: () {
  //                           HapticFeedback.heavyImpact();
  //                           btnAll = false;
  //                           btnMen = true;
  //                           btnLadies = false;
  //                           btnStreet = false;
  //                           btnClassic = false;
  //                           btnMode = false;
  //                           btnFeminin = false;
  //                           btnGrunge = false;
  //                           btnAnnui = false;
  //                           btnRock = false;
  //                           btnCrieitive = false;
  //                           UserData.instance.choiceList = "men";
  //                           snapshot.data!.docs = UserData.instance.listMen;
  //                           if (mounted) {setState(() {});}
  //                         },
  //                       ),
  //                       GestureDetector(
  //                         child: Container(
  //                           height: 10,
  //                           width: 80,
  //                           margin: EdgeInsets.only(left: 5, bottom: 5,),
  //                           decoration: BoxDecoration(
  //                             borderRadius: BorderRadius.circular(20),
  //                             border: Border.all(
  //                               color: btnLadies ? Color(0xFFFF8D89) : Colors.black45,
  //                               width: 1,
  //                             ),
  //                           ),
  //                           child: Center(
  //                             child: Text(
  //                               "レディース",
  //                               textAlign: TextAlign.center,
  //                               style: TextStyle(
  //                                 color: btnLadies ? Color(0xFFFF8D89) : Colors.black45,
  //                                 fontWeight: FontWeight.bold,
  //                                 fontSize: 12,
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                         onTap: () {
  //                           HapticFeedback.heavyImpact();
  //                           btnAll = false;
  //                           btnMen = false;
  //                           btnLadies = true;
  //                           btnStreet = false;
  //                           btnClassic = false;
  //                           btnMode = false;
  //                           btnFeminin = false;
  //                           btnGrunge = false;
  //                           btnAnnui = false;
  //                           btnRock = false;
  //                           btnCrieitive = false;
  //                           UserData.instance.choiceList = "ladies";
  //                           snapshot.data!.docs = UserData.instance.listLadies;
  //                           if (mounted) {setState(() {});}
  //                         },
  //                       ),
  //                       GestureDetector(
  //                         child: Container(
  //                           height: 10,
  //                           width: 80,
  //                           margin: EdgeInsets.only(left: 5, bottom: 5,),
  //                           decoration: BoxDecoration(
  //                             borderRadius: BorderRadius.circular(20),
  //                             border: Border.all(
  //                               color: btnStreet ? Color(0xFFFF8D89) : Colors.black45,
  //                               width: 1,
  //                             ),
  //                           ),
  //                           child: Center(
  //                             child: Text(
  //                               "ストリート",
  //                               textAlign: TextAlign.center,
  //                               style: TextStyle(
  //                                 color: btnStreet ? Color(0xFFFF8D89) : Colors.black45,
  //                                 fontWeight: FontWeight.bold,
  //                                 fontSize: 12,
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                         onTap: () {
  //                           HapticFeedback.heavyImpact();
  //                           btnAll = false;
  //                           btnMen = false;
  //                           btnLadies = false;
  //                           btnStreet = true;
  //                           btnClassic = false;
  //                           btnMode = false;
  //                           btnFeminin = false;
  //                           btnGrunge = false;
  //                           btnAnnui = false;
  //                           btnRock = false;
  //                           btnCrieitive = false;
  //                           UserData.instance.choiceList = "street";
  //                           snapshot.data!.docs = UserData.instance.listStreet;
  //                           if (mounted) {setState(() {});}
  //                         },
  //                       ),
  //                       GestureDetector(
  //                         child: Container(
  //                           height: 10,
  //                           width: 80,
  //                           margin: EdgeInsets.only(left: 5, bottom: 5,),
  //                           decoration: BoxDecoration(
  //                             borderRadius: BorderRadius.circular(20),
  //                             border: Border.all(
  //                               color: btnClassic ? Color(0xFFFF8D89) : Colors.black45,
  //                               width: 1,
  //                             ),
  //                           ),
  //                           child: Center(
  //                             child: Text(
  //                               "クラシック",
  //                               textAlign: TextAlign.center,
  //                               style: TextStyle(
  //                                 color: btnClassic ? Color(0xFFFF8D89) : Colors.black45,
  //                                 fontWeight: FontWeight.bold,
  //                                 fontSize: 12,
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                         onTap: () {
  //                           HapticFeedback.heavyImpact();
  //                           btnAll = false;
  //                           btnMen = false;
  //                           btnLadies = false;
  //                           btnStreet = false;
  //                           btnClassic = true;
  //                           btnMode = false;
  //                           btnFeminin = false;
  //                           btnGrunge = false;
  //                           btnAnnui = false;
  //                           btnRock = false;
  //                           btnCrieitive = false;
  //                           UserData.instance.choiceList = "classic";
  //                           snapshot.data!.docs = UserData.instance.listClassic;
  //                           if (mounted) {setState(() {});}
  //                         },
  //                       ),
  //                       GestureDetector(
  //                         child: Container(
  //                           height: 10,
  //                           width: 70,
  //                           margin: EdgeInsets.only(left: 5, bottom: 5,),
  //                           decoration: BoxDecoration(
  //                             borderRadius: BorderRadius.circular(20),
  //                             border: Border.all(
  //                               color: btnMode ? Color(0xFFFF8D89) : Colors.black45,
  //                               width: 1,
  //                             ),
  //                           ),
  //                           child: Center(
  //                             child: Text(
  //                               "モード",
  //                               textAlign: TextAlign.center,
  //                               style: TextStyle(
  //                                 color: btnMode ? Color(0xFFFF8D89) : Colors.black45,
  //                                 fontWeight: FontWeight.bold,
  //                                 fontSize: 12,
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                         onTap: () {
  //                           HapticFeedback.heavyImpact();
  //                           btnAll = false;
  //                           btnMen = false;
  //                           btnLadies = false;
  //                           btnStreet = false;
  //                           btnClassic = false;
  //                           btnMode = true;
  //                           btnFeminin = false;
  //                           btnGrunge = false;
  //                           btnAnnui = false;
  //                           btnRock = false;
  //                           btnCrieitive = false;
  //                           UserData.instance.choiceList = "mode";
  //                           snapshot.data!.docs = UserData.instance.listMode;
  //                           if (mounted) {setState(() {});}
  //                         },
  //                       ),
  //                       GestureDetector(
  //                         child: Container(
  //                           height: 10,
  //                           width: 80,
  //                           margin: EdgeInsets.only(left: 5, bottom: 5,),
  //                           decoration: BoxDecoration(
  //                             borderRadius: BorderRadius.circular(20),
  //                             border: Border.all(
  //                               color: btnFeminin ? Color(0xFFFF8D89) : Colors.black45,
  //                               width: 1,
  //                             ),
  //                           ),
  //                           child: Center(
  //                             child: Text(
  //                               "フェミニン",
  //                               textAlign: TextAlign.center,
  //                               style: TextStyle(
  //                                 color: btnFeminin ? Color(0xFFFF8D89) : Colors.black45,
  //                                 fontWeight: FontWeight.bold,
  //                                 fontSize: 12,
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                         onTap: () {
  //                           HapticFeedback.heavyImpact();
  //                           btnAll = false;
  //                           btnMen = false;
  //                           btnLadies = false;
  //                           btnStreet = false;
  //                           btnClassic = false;
  //                           btnMode = false;
  //                           btnFeminin = true;
  //                           btnGrunge = false;
  //                           btnAnnui = false;
  //                           btnRock = false;
  //                           btnCrieitive = false;
  //                           UserData.instance.choiceList = "feminin";
  //                           snapshot.data!.docs = UserData.instance.listFeminin;
  //                           if (mounted) {setState(() {});}
  //                         },
  //                       ),
  //                       GestureDetector(
  //                         child: Container(
  //                           height: 10,
  //                           width: 80,
  //                           margin: EdgeInsets.only(left: 5, bottom: 5,),
  //                           decoration: BoxDecoration(
  //                             borderRadius: BorderRadius.circular(20),
  //                             border: Border.all(
  //                               color: btnGrunge ? Color(0xFFFF8D89) : Colors.black45,
  //                               width: 1,
  //                             ),
  //                           ),
  //                           child: Center(
  //                             child: Text(
  //                               "グランジ",
  //                               textAlign: TextAlign.center,
  //                               style: TextStyle(
  //                                 color: btnGrunge ? Color(0xFFFF8D89) : Colors.black45,
  //                                 fontWeight: FontWeight.bold,
  //                                 fontSize: 12,
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                         onTap: () {
  //                           HapticFeedback.heavyImpact();
  //                           btnAll = false;
  //                           btnMen = false;
  //                           btnLadies = false;
  //                           btnStreet = false;
  //                           btnClassic = false;
  //                           btnMode = false;
  //                           btnFeminin = false;
  //                           btnGrunge = true;
  //                           btnAnnui = false;
  //                           btnRock = false;
  //                           btnCrieitive = false;
  //                           UserData.instance.choiceList = "grunge";
  //                           snapshot.data!.docs = UserData.instance.listGrunge;
  //                           if (mounted) {setState(() {});}
  //                         },
  //                       ),
  //                       GestureDetector(
  //                         child: Container(
  //                           height: 10,
  //                           width: 80,
  //                           margin: EdgeInsets.only(left: 5, bottom: 5,),
  //                           decoration: BoxDecoration(
  //                             borderRadius: BorderRadius.circular(20),
  //                             border: Border.all(
  //                               color: btnAnnui ? Color(0xFFFF8D89) : Colors.black45,
  //                               width: 1,
  //                             ),
  //                           ),
  //                           child: Center(
  //                             child: Text(
  //                               "アンニュイ",
  //                               textAlign: TextAlign.center,
  //                               style: TextStyle(
  //                                 color: btnAnnui ? Color(0xFFFF8D89) : Colors.black45,
  //                                 fontWeight: FontWeight.bold,
  //                                 fontSize: 12,
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                         onTap: () {
  //                           HapticFeedback.heavyImpact();
  //                           btnAll = false;
  //                           btnMen = false;
  //                           btnLadies = false;
  //                           btnStreet = false;
  //                           btnClassic = false;
  //                           btnMode = false;
  //                           btnFeminin = false;
  //                           btnGrunge = false;
  //                           btnAnnui = true;
  //                           btnRock = false;
  //                           btnCrieitive = false;
  //                           UserData.instance.choiceList = "annui";
  //                           snapshot.data!.docs = UserData.instance.listAnnui;
  //                           if (mounted) {setState(() {});}
  //                         },
  //                       ),
  //                       GestureDetector(
  //                         child: Container(
  //                           height: 10,
  //                           width: 70,
  //                           margin: EdgeInsets.only(left: 5, bottom: 5,),
  //                           decoration: BoxDecoration(
  //                             borderRadius: BorderRadius.circular(20),
  //                             border: Border.all(
  //                               color: btnRock ? Color(0xFFFF8D89) : Colors.black45,
  //                               width: 1,
  //                             ),
  //                           ),
  //                           child: Center(
  //                             child: Text(
  //                               "ロック",
  //                               textAlign: TextAlign.center,
  //                               style: TextStyle(
  //                                 color: btnRock ? Color(0xFFFF8D89) : Colors.black45,
  //                                 fontWeight: FontWeight.bold,
  //                                 fontSize: 12,
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                         onTap: () {
  //                           HapticFeedback.heavyImpact();
  //                           btnAll = false;
  //                           btnMen = false;
  //                           btnLadies = false;
  //                           btnStreet = false;
  //                           btnClassic = false;
  //                           btnMode = false;
  //                           btnFeminin = false;
  //                           btnGrunge = false;
  //                           btnAnnui = false;
  //                           btnRock = true;
  //                           btnCrieitive = false;
  //                           UserData.instance.choiceList = "rock";
  //                           snapshot.data!.docs = UserData.instance.listRock;
  //                           if (mounted) {setState(() {});}
  //                         },
  //                       ),
  //                       GestureDetector(
  //                         child: Container(
  //                           height: 10,
  //                           width: 100,
  //                           margin: EdgeInsets.only(left: 5, bottom: 5,),
  //                           decoration: BoxDecoration(
  //                             borderRadius: BorderRadius.circular(20),
  //                             border: Border.all(
  //                               color: btnCrieitive ? Color(0xFFFF8D89) : Colors.black45,
  //                               width: 1,
  //                             ),
  //                           ),
  //                           child: Center(
  //                             child: Text(
  //                               "クリエイティブ",
  //                               textAlign: TextAlign.center,
  //                               style: TextStyle(
  //                                 color: btnCrieitive ? Color(0xFFFF8D89) : Colors.black45,
  //                                 fontWeight: FontWeight.bold,
  //                                 fontSize: 12,
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                         onTap: () {
  //                           HapticFeedback.heavyImpact();
  //                           btnAll = false;
  //                           btnMen = false;
  //                           btnLadies = false;
  //                           btnStreet = false;
  //                           btnClassic = false;
  //                           btnMode = false;
  //                           btnFeminin = false;
  //                           btnGrunge = false;
  //                           btnAnnui = false;
  //                           btnRock = false;
  //                           btnCrieitive = true;
  //                           UserData.instance.choiceList = "crieitive";
  //                           snapshot.data!.docs = UserData.instance.listCrieitive;
  //                           if (mounted) {setState(() {});}
  //                         },
  //                       ),
  //                     ]
  //                   ),
  //                 ),

  //                 Expanded(
  //                   child: Container(
  //                     margin: EdgeInsets.only(top: 12, right: 12, left: 12),
  //                     child: StaggeredGridView.countBuilder(
  //                       crossAxisCount: 2,
  //                       crossAxisSpacing: 10,
  //                       mainAxisSpacing: 12,
  //                       itemCount: snapshot.data!.docs.length,
  //                       staggeredTileBuilder: (index) => StaggeredTile.fit(1),
  //                       itemBuilder: (context, index) {
  //                         return Container(
  //                           child: Stack(
  //                             alignment: Alignment.bottomLeft,
  //                             children: [
  //                               GestureDetector(
  //                                 child: Container(
  //                                   decoration: BoxDecoration(
  //                                     color: Colors.transparent,
  //                                     borderRadius: BorderRadius.all(
  //                                       Radius.circular(10),
  //                                     )
  //                                   ),
  //                                   child: ClipRRect(
  //                                     borderRadius: BorderRadius.circular(10.0),
  //                                     child: snapshot.data!.docs[index]["post_image_500"] == null ? Image.network("") : Image.network(
  //                                       snapshot.data!.docs[index]["post_image_500"],
  //                                     ),
  //                                   ),
  //                                 ),
  //                                 onTap: () async {
  //                                   if (snapshot.data!.docs[index]["post_image_500"].isNotEmpty) {
  //                                     await Navigator.push(
  //                                       context,
  //                                       MaterialPageRoute(builder: (context) => Item("${snapshot.data!.docs[index].id}",)),
  //                                     );
  //                                     like();
  //                                   }
  //                                 },
  //                               ),
  //                               Align(
  //                                 alignment: Alignment.bottomLeft,
  //                                 child: GestureDetector(
  //                                   child: Container(
  //                                     margin: EdgeInsets.only(left: 10, bottom: 9),
  //                                     width: 30.w,
  //                                     child: Text(
  //                                       "${snapshot.data!.docs[index]["post_instagram"]}",
  //                                       style: TextStyle(
  //                                         color: Colors.white,
  //                                         fontWeight: FontWeight.bold,
  //                                         fontSize: 11.sp,
  //                                       ),
  //                                       overflow: TextOverflow.ellipsis,
  //                                       maxLines: 1,
  //                                     ),
  //                                   ),
  //                                   onTap: () async {
  //                                     if (snapshot.data!.docs[index]["post_uid"].isNotEmpty) {
  //                                       await Navigator.push(
  //                                         context,
  //                                         MaterialPageRoute(builder: (context) => ProfileMain("${snapshot.data!.docs[index]["post_uid"]}")),
  //                                       );
  //                                       like();
  //                                     }
  //                                   },
  //                                 ),
  //                               ),
  //                               Align(
  //                                 alignment: Alignment.bottomRight,
  //                                 child: GestureDetector(
  //                                   child: Container(
  //                                     width: 40,
  //                                     height: 35,
  //                                     child: LikeButton(
  //                                       isLiked: UserData.instance.documentLikeList.contains("${snapshot.data!.docs[index].id}") ? true : false,
  //                                       circleColor: CircleColor(start: Color(0xFFF44336), end: Color(0xFFF44336)),
  //                                       likeBuilder: (bool isLiked) {
  //                                         return Icon(
  //                                           Icons.favorite,
  //                                           size: 30,
  //                                           color: isLiked ? Colors.red : Colors.white70,
  //                                         );
  //                                       },
  //                                       onTap: (result) async {
  //                                         HapticFeedback.heavyImpact();
  //                                         if (result) {
  //                                           result = false;
  //                                           UserData.instance.documentLikeList.remove("${snapshot.data!.docs[index].id}");
  //                                           if (mounted) {setState(() {});}
  //                                           await FirebaseFunctions.instanceFor(app: Firebase.app(), region: 'us-central1').httpsCallable('likePhoto_false')
  //                                           .call(
  //                                             <String, String>{
  //                                             'userUid': UserData.instance.user,
  //                                             'postUid': snapshot.data!.docs[index]['post_uid'],
  //                                             'postId': snapshot.data!.docs[index].id}
  //                                           );
  //                                         } else {
  //                                           result = true;
  //                                           UserData.instance.documentLikeList.add("${snapshot.data!.docs[index].id}");
  //                                           if (mounted) {setState(() {});}
  //                                           await FirebaseFunctions.instanceFor(app: Firebase.app(), region: 'us-central1').httpsCallable('likePhoto_true')
  //                                           .call(
  //                                             <String, String>{
  //                                             'userUid': UserData.instance.user,
  //                                             'postUid': snapshot.data!.docs[index]['post_uid'],
  //                                             'postId': snapshot.data!.docs[index].id}
  //                                           );
  //                                         }
  //                                       },
  //                                     ),
  //                                   ),
  //                                 ),
  //                               )
  //                             ],
  //                           ),
  //                         );
  //                       },
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           );
  //         }
  //       );
  //     }
  //   );
  // }
}

class MyDelegate extends SliverPersistentHeaderDelegate{

  MyDelegate(this.tabBar);
  final TabBar tabBar;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: tabBar,
    );
  }

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }

}