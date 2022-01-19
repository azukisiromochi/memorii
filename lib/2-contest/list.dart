import 'package:app/2-contest/items/post.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'items/item.dart';
import '../1-home/items/profile.dart';

final navigatorsKey = GlobalKey<NavigatorState>();

class ContestMain extends StatefulWidget {
  final Function() onTap;
  const ContestMain(this.onTap);

  @override
  _ContestMainState createState() => _ContestMainState();
}

class _ContestMainState extends State<ContestMain> {

  // リスト
  List contestList = [];

  // ジャンル選択btn
  bool btnAll = true;
  bool btnMen = false;
  bool btnLadies = false;

  // ジャンルdoc
  List listAll = [];
  List listMen = [];
  List listLadies = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorsKey,
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
                        "コンテスト",
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
                            MaterialPageRoute(builder: (context) => Post(widget.onTap)),
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
                length: 4,
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
                            .collection('contests')
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
                                                MaterialPageRoute(builder: (context) => Item(snapshot.data!.docs[index].id)),
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
                                                  MaterialPageRoute(builder: (context) => ProfileMain(snapshot.data!.docs[index]["post_uid"])),
                                                );
                                              }
                                            },
                                          ),
                                        ),
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
                            .collection('contests')
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
                                                MaterialPageRoute(builder: (context) => Item(snapshot.data!.docs[index].id)),
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
                                                snapshot.data!.docs[index]["post_instagram"],
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
                                                  MaterialPageRoute(builder: (context) => ProfileMain(snapshot.data!.docs[index]["post_uid"])),
                                                );
                                              }
                                            },
                                          ),
                                        ),
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
                            .collection('contests')
                            .where('post_tags', arrayContainsAny: ['ストリート','クラシック','モード','フェミニン','グランジ','アンニュイ','ロック',])
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
                                                MaterialPageRoute(builder: (context) => Item(snapshot.data!.docs[index].id)),
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
                                                  MaterialPageRoute(builder: (context) => ProfileMain(snapshot.data!.docs[index]["post_uid"])),
                                                );
                                              }
                                            },
                                          ),
                                        ),
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
                            .collection('contests')
                            .where('post_tags', arrayContains: 'クリエイティブ')
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
                                                MaterialPageRoute(builder: (context) => Item(snapshot.data!.docs[index].id)),
                                              );
                                            }
                                          },
                                        ),
                                        // Align(
                                        //   alignment: Alignment.bottomLeft,
                                        //   child: GestureDetector(
                                        //     child: Container(
                                        //       margin: EdgeInsets.only(left: 10, bottom: 9),
                                        //       width: 30.w,
                                        //       child: Text(
                                        //         snapshot.data!.docs[index]["post_instagram"],
                                        //         // snapshot.data!.docs[index]["post_name"],
                                        //         style: TextStyle(
                                        //           color: Colors.white,
                                        //           fontWeight: FontWeight.bold,
                                        //           fontSize: 11.sp,
                                        //         ),
                                        //         overflow: TextOverflow.ellipsis,
                                        //         maxLines: 1,
                                        //       ),
                                        //     ),
                                        //     onTap: () async {
                                        //       if (snapshot.data!.docs[index]["post_uid"].isNotEmpty) {
                                        //         await Navigator.push(
                                        //           context,
                                        //           MaterialPageRoute(builder: (context) => ProfileMain(snapshot.data!.docs[index]["post_uid"])),
                                        //         );
                                        //       }
                                        //     },
                                        //   ),
                                        // ),
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
      }
    );
  }
}
