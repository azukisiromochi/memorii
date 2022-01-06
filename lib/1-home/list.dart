import 'package:chewie/chewie.dart';
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

  get controller => null;

  @override
  void initState() {
    super.initState();
    like();
  }
  Future<void> like() async {
    await FirebaseFirestore.instance.collection('users').doc(UserData.instance.user).get()
    .then((doc) {
      UserData.instance.documentLikeList.clear();
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
                            // MaterialPageRoute(builder: (context) => Post()),
                            // MaterialPageRoute(builder: (context) => Gallery())
                            MaterialPageRoute(builder: (context) => Post(widget.onTap)),
                            // MaterialPageRoute(builder: (context) => Html()),
                          );
                          like();
                        },
                      ),
                    ),
                  ],
                ),
                backgroundColor: Colors.white,
                centerTitle: false,
                elevation: 0.0,
              ),
              // SF/ファンタジー
              // ロボット/メカ
              // アクション/バトル
              // コメディ/ギャグ
              // 恋愛/ラブコメ
              // 日常/ほのぼの
              // スポーツ/競技
              // ホラー/サスペンス/推理
              // 歴史/戦記
              // 戦争/ミリタリー
              // ドラマ/青春
              // キッズ/ファミリー
              // ショート
              // 2.5次元舞台
              // ライブ/ラジオ/etc.
              body: DefaultTabController(
                length: 6,
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
                                  child: Text("最新"),
                                ),
                              ),
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
                                  child: Text("サロンスタイル"),
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
                          ),
                        ),
                        floating: true,
                        pinned: true,
                      ),
                    ];
                  },
                  body: TabBarView(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 12, right: 12, left: 12),
                        child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                            .collection('posts')
                            .orderBy("post_time", descending: true)
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
                                                MaterialPageRoute(builder: (context) => Item(snapshot.data!.docs[index].id, snapshot.data!.docs[index]['post_video'])),
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
                                                snapshot.data!.docs[index]["post_instagram"],
                                                // snapshot.data!.docs[index]["post_name"],
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
                                                  MaterialPageRoute(builder: (context) => ProfileMain(snapshot.data!.docs[index]["post_uid"],)),
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
                                                isLiked: UserData.instance.documentLikeList.contains(snapshot.data!.docs[index].id) ? true : false,
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
                                                    UserData.instance.documentLikeList.remove(snapshot.data!.docs[index].id);
                                                    if (mounted) {setState(() {});}
                                                    await FirebaseFirestore.instance.collection('users').doc(UserData.instance.user)
                                                      .update({'user_likes': FieldValue.arrayRemove([snapshot.data!.docs[index].id])});
                                                    await FirebaseFirestore.instance.collection('users').doc(snapshot.data!.docs[index]["post_uid"])
                                                      .update({'user_like_count': FieldValue.increment(-1)});
                                                    await FirebaseFirestore.instance.collection('posts').doc(snapshot.data!.docs[index].id)
                                                      .update({'post_count': FieldValue.increment(-1)});
                                                    await FirebaseFirestore.instance.collection('posts').doc(snapshot.data!.docs[index].id)
                                                      .update({'post_liker': FieldValue.arrayRemove([snapshot.data!.docs[index]["post_uid"]])});
                                                  } else {
                                                    result = true;
                                                    UserData.instance.documentLikeList.add(snapshot.data!.docs[index].id);
                                                    if (mounted) {setState(() {});}
                                                    await FirebaseFirestore.instance.collection('users').doc(UserData.instance.user)
                                                      .update({'user_likes': FieldValue.arrayUnion([snapshot.data!.docs[index].id])});
                                                    await FirebaseFirestore.instance.collection('users').doc(snapshot.data!.docs[index]["post_uid"])
                                                      .update({'user_like_count': FieldValue.increment(1)});
                                                    await FirebaseFirestore.instance.collection('posts').doc(snapshot.data!.docs[index].id)
                                                      .update({'post_count': FieldValue.increment(1)});
                                                    await FirebaseFirestore.instance.collection('posts').doc(snapshot.data!.docs[index].id)
                                                      .update({'post_liker': FieldValue.arrayUnion([snapshot.data!.docs[index]["post_uid"]])});
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
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 12, right: 12, left: 12),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 12, right: 12, left: 12),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 12, right: 12, left: 12),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 12, right: 12, left: 12),
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
