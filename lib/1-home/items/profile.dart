import 'package:app/1-home/items/item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
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

  _launchInApp(doc) async {
    var url = 'https://www.instagram.com/$doc';
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: true,
        forceWebView: true,
      );
    }
  }
  launchTiktok(doc) async {
    var url = 'https://www.tiktok.com/@$doc';
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: true,
        forceWebView: true,
      );
    } else {
      throw 'このURLにはアクセスできません';
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
          ],
        ),
        backgroundColor: Color(0xFFFF8D89),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                  .collection('users')
                  .where('user_uid', isEqualTo: widget.name)
                  .snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return Container(
                      child: Stack(
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
                                margin: EdgeInsets.only(top: 80, right: 10.w, left: 10.w),
                                padding: EdgeInsets.only(bottom: 20,),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 20.0,
                                      spreadRadius: 1.0,
                                      offset: Offset(0, 0)
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(top: 60, right: 10.w, left: 10.w, bottom: 5,),
                                      child: snapshot.data!.docs.length > 0 ? Text(
                                        snapshot.data!.docs[0]["user_name"] != "" ?
                                        snapshot.data!.docs[0]["user_name"] : "unnamed",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                          fontSize: 20,
                                        ),
                                      ) : Text(""),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 0, right: 10.w, left: 10.w),
                                      child: snapshot.data!.docs.length > 0 ? Text(
                                        snapshot.data!.docs[0]["user_text"],
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black26,
                                          fontSize: 12,
                                        ),
                                      ) : Text(""),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      margin: EdgeInsets.only(top: 15, right: 20.w, left: 20.w),
                                      child: Row(
                                        children: [   
                                          Spacer(),                                              
                                          snapshot.data!.docs[0]['user_instagram'] == '' ? Container() :
                                          GestureDetector(
                                            child: Container(
                                              width: 28,
                                              height: 28,
                                              margin: EdgeInsets.only(right: 8, left: 8,),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(5),
                                                gradient: LinearGradient(
                                                  begin: Alignment.topRight,
                                                  end: Alignment.bottomLeft,
                                                  stops: [
                                                    0.1,
                                                    0.2,
                                                    0.3,
                                                    0.4,
                                                    0.5,
                                                    0.6,
                                                    0.7,
                                                    0.8,
                                                    0.9,
                                                    1.0,
                                                  ],
                                                  colors: [
                                                    Color(0xFF405DE6),
                                                    Color(0xFF5851DB),
                                                    Color(0xFF833AB4),
                                                    Color(0xFFC13584),
                                                    Color(0xFFE1306C),
                                                    Color(0xFFFD1D1D),
                                                    Color(0xFFF56040),
                                                    Color(0xFFF77737),
                                                    Color(0xFFFCAF45),
                                                    Color(0xFFFFDC80),
                                                  ],
                                                ),
                                              ),
                                              child: Center(
                                                child: FaIcon(
                                                  FontAwesomeIcons.instagram,
                                                  color: Colors.white,
                                                  size: 25,
                                                ),
                                              ),
                                            ),
                                            onTap: () {
                                              _launchInApp(snapshot.data!.docs[0]['user_instagram']);
                                            },
                                          ),
                                          snapshot.data!.docs[0]['user_tiktok'] == '' ? Container() :
                                          GestureDetector(
                                            child: Container(
                                              width: 28,
                                              height: 28,
                                              margin: EdgeInsets.only(right: 8, left: 8,),
                                              decoration: BoxDecoration(
                                                color: Colors.black87,
                                                borderRadius: BorderRadius.circular(7),
                                              ),
                                              child: Center(
                                                child: FaIcon(
                                                  FontAwesomeIcons.tiktok,
                                                  color: Colors.white,
                                                  size: 20,
                                                ),
                                              ),
                                            ),
                                            onTap: () {
                                              launchTiktok(snapshot.data!.docs[0]['user_tiktok']);
                                            },
                                          ),
                                          Spacer(),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              snapshot.data!.docs.length > 0 ?
                              snapshot.data!.docs[0]["user_image_500"] == "" ? Container() :
                              Container(
                                height: 110,
                                width: 30.w,
                                margin: EdgeInsets.only(top: 20, right: 35.w, left: 35.w),
                                child: CircleAvatar(
                                  radius: 100,
                                  backgroundColor: Colors.white,
                                  foregroundImage: NetworkImage(
                                    snapshot.data!.docs[0]["user_image_500"],
                                  ),
                                  backgroundImage: NetworkImage(
                                    'https://firebasestorage.googleapis.com/v0/b/photo-beauty-24f63.appspot.com/o/app-use%2Fresize_images%2F2_500x500.webp?alt=media&token'
                                  ),
                                ),
                                padding: EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                  color: Color(0xFFFFFFFF),
                                  shape: BoxShape.circle,
                                )
                              ) 
                              : Container(),
                            ]
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
            Container(
              width: 80.w,
              margin: EdgeInsets.only(top: 20, right: 10.w, left: 10.w),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                  .collection('posts')
                  .where('post_uid', isEqualTo: widget.name)
                  .orderBy("post_time", descending: true)
                  .snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return GridView.count(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      // physics: BouncingScrollPhysics(
                      //   parent: AlwaysScrollableScrollPhysics()
                      // ),
                      crossAxisCount: 2,
                      childAspectRatio: 7.0 / 7.0,
                      children: snapshot.data!.docs.map((document) {
                        return Container(
                          margin: EdgeInsets.all(5),
                          child: GestureDetector(
                            child: AspectRatio(
                              aspectRatio: 11.0 / 11.0,
                              child: GestureDetector(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5.0),
                                  child: Image.network(
                                    document["post_image_500"],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Item(document.id)),
                              );
                            },
                          ),
                        );
                      }).toList(),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
            Container(
              height: 100,
            ),
          ],
        ),
      ),
      
      // body: DefaultTabController(
      //   length: 2,
      //   child: NestedScrollView(
      //     physics: NeverScrollableScrollPhysics(),
      //     headerSliverBuilder: (context,isScolled) {
      //       return [
      //         SliverAppBar(
      //           backgroundColor: Colors.white,
      //           collapsedHeight: 280,
      //           expandedHeight: 280,
      //           automaticallyImplyLeading: false,
      //           flexibleSpace: Column(
      //             crossAxisAlignment: CrossAxisAlignment.start,
      //             children: [
      //               Container(
      //                 child: StreamBuilder(
      //                   stream: FirebaseFirestore.instance
      //                     .collection('users')
      //                     .where('user_uid', isEqualTo: widget.name)
      //                     // .orderBy("post_time", descending: true)
      //                     .snapshots(),
      //                   builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      //                     if (snapshot.hasData) {
      //                       return Container(
      //                         child: Stack(
      //                           children: [
      //                             Container(
      //                               width: double.infinity,
      //                               height: 140,
      //                               color: Color(0xFFFF8D89),
      //                             ),
      //                             Stack(
      //                               children: [
      //                                 Container(
      //                                   width: 80.w,
      //                                   margin: EdgeInsets.only(top: 80, right: 10.w, left: 10.w),
      //                                   padding: EdgeInsets.only(bottom: 20,),
      //                                   decoration: BoxDecoration(
      //                                     borderRadius: BorderRadius.circular(10),
      //                                     color: Colors.white,
      //                                     boxShadow: [
      //                                       BoxShadow(
      //                                         color: Colors.black12,
      //                                         blurRadius: 20.0,
      //                                         spreadRadius: 1.0,
      //                                         offset: Offset(0, 0)
      //                                       ),
      //                                     ],
      //                                   ),
      //                                   child: Column(
      //                                     children: [
      //                                       Container(
      //                                         margin: EdgeInsets.only(top: 60, right: 10.w, left: 10.w, bottom: 5,),
      //                                         child: snapshot.data!.docs.length > 0 ? Text(
      //                                           snapshot.data!.docs[0]["user_name"] != "" ?
      //                                           snapshot.data!.docs[0]["user_name"] : "unnamed",
      //                                           textAlign: TextAlign.center,
      //                                           style: TextStyle(
      //                                             fontWeight: FontWeight.bold,
      //                                             color: Colors.black87,
      //                                             fontSize: 20,
      //                                           ),
      //                                         ) : Text(""),
      //                                       ),
      //                                       Container(
      //                                         margin: EdgeInsets.only(top: 0, right: 10.w, left: 10.w),
      //                                         child: snapshot.data!.docs.length > 0 ? Text(
      //                                           snapshot.data!.docs[0]["user_text"],
      //                                           textAlign: TextAlign.center,
      //                                           style: TextStyle(
      //                                             fontWeight: FontWeight.bold,
      //                                             color: Colors.black26,
      //                                             fontSize: 12,
      //                                           ),
      //                                         ) : Text(""),
      //                                       ),
      //                                       Container(
      //                                         width: double.infinity,
      //                                         margin: EdgeInsets.only(top: 15, right: 20.w, left: 20.w),
      //                                         child: Row(
      //                                           children: [   
      //                                             Spacer(),                                              
      //                                             snapshot.data!.docs[0]['user_instagram'] == '' ? Container() :
      //                                             GestureDetector(
      //                                               child: Container(
      //                                                 width: 28,
      //                                                 height: 28,
      //                                                 margin: EdgeInsets.only(right: 8, left: 8,),
      //                                                 decoration: BoxDecoration(
      //                                                   borderRadius: BorderRadius.circular(5),
      //                                                   gradient: LinearGradient(
      //                                                     begin: Alignment.topRight,
      //                                                     end: Alignment.bottomLeft,
      //                                                     stops: [
      //                                                       0.1,
      //                                                       0.2,
      //                                                       0.3,
      //                                                       0.4,
      //                                                       0.5,
      //                                                       0.6,
      //                                                       0.7,
      //                                                       0.8,
      //                                                       0.9,
      //                                                       1.0,
      //                                                     ],
      //                                                     colors: [
      //                                                       Color(0xFF405DE6),
      //                                                       Color(0xFF5851DB),
      //                                                       Color(0xFF833AB4),
      //                                                       Color(0xFFC13584),
      //                                                       Color(0xFFE1306C),
      //                                                       Color(0xFFFD1D1D),
      //                                                       Color(0xFFF56040),
      //                                                       Color(0xFFF77737),
      //                                                       Color(0xFFFCAF45),
      //                                                       Color(0xFFFFDC80),
      //                                                     ],
      //                                                   ),
      //                                                 ),
      //                                                 child: Center(
      //                                                   child: FaIcon(
      //                                                     FontAwesomeIcons.instagram,
      //                                                     color: Colors.white,
      //                                                     size: 25,
      //                                                   ),
      //                                                 ),
      //                                               ),
      //                                               onTap: () {
      //                                                 // launchInstagram();
      //                                               },
      //                                             ),
      //                                             // snapshot.data!.docs[0]['user_tiktok'] == '' ? Container() :
      //                                             // GestureDetector(
      //                                             //   child: Container(
      //                                             //     width: 28,
      //                                             //     height: 28,
      //                                             //     margin: EdgeInsets.only(right: 8, left: 8,),
      //                                             //     decoration: BoxDecoration(
      //                                             //       color: Colors.black87,
      //                                             //       borderRadius: BorderRadius.circular(7),
      //                                             //     ),
      //                                             //     child: Center(
      //                                             //       child: FaIcon(
      //                                             //         FontAwesomeIcons.tiktok,
      //                                             //         color: Colors.white,
      //                                             //         size: 20,
      //                                             //       ),
      //                                             //     ),
      //                                             //   ),
      //                                             //   onTap: () {
      //                                             //     launchTiktok();
      //                                             //   },
      //                                             // ),
      //                                             Spacer(),
      //                                           ],
      //                                         ),
      //                                       ),
      //                                     ],
      //                                   ),
      //                                 ),
      //                                 snapshot.data!.docs.length > 0 ?
      //                                 snapshot.data!.docs[0]["user_image_500"] == "" ? Container() :
      //                                 Container(
      //                                   height: 110,
      //                                   width: 30.w,
      //                                   margin: EdgeInsets.only(top: 20, right: 35.w, left: 35.w),
      //                                   child: CircleAvatar(
      //                                     radius: 100,
      //                                     backgroundColor: Colors.white,
      //                                     backgroundImage: NetworkImage(
      //                                       snapshot.data!.docs[0]["user_image_500"],
      //                                     ),
      //                                   ),
      //                                   padding: EdgeInsets.all(5.0),
      //                                   decoration: BoxDecoration(
      //                                     color: Color(0xFFFFFFFF),
      //                                     shape: BoxShape.circle,
      //                                   )
      //                                 ) 
      //                                 : Container(),
      //                               ]
      //                             ),
      //                           ],
      //                         ),
      //                       );
      //                     } else {
      //                       return Container();
      //                     }
      //                   },
      //                 ),
      //               ),
      //             ],
      //           ),
      //         ),
      //         SliverPersistentHeader(
      //           delegate: MyDelegate(
      //             TabBar(
      //               tabs: [
      //                 Tab(
      //                   child: Align(
      //                     alignment: Alignment.center,
      //                     child: Text("作品撮り"),
      //                   ),
      //                 ),
      //                 Tab(
      //                   child: Align(
      //                     alignment: Alignment.center,
      //                     child: Text("ツイート"),
      //                   ),
      //                 ),
      //               ],
      //               indicatorColor: Color(0xFFFF8D89),
      //               unselectedLabelColor: Colors.grey,
      //               labelColor: Colors.black,
      //             )
      //           ),
      //           floating: true,
      //           pinned: true,
      //         )
      //       ];
      //     },
      //     body: TabBarView(
      //       children: [
      //         Container(
      //           width: 80.w,
      //           margin: EdgeInsets.only(top: 20, right: 10.w, left: 10.w),
      //           child: StreamBuilder(
      //             stream: FirebaseFirestore.instance
      //               .collection('posts')
      //               .where('post_uid', isEqualTo: widget.name)
      //               .orderBy("post_time", descending: true)
      //               .snapshots(),
      //             builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      //               if (snapshot.hasData) {
      //                 return GridView.count(
      //                   physics: BouncingScrollPhysics(
      //                     parent: AlwaysScrollableScrollPhysics()
      //                   ),
      //                   crossAxisCount: 2,
      //                   childAspectRatio: 7.0 / 7.0,
      //                   children: snapshot.data!.docs.map((document) {
      //                     return Container(
      //                       margin: EdgeInsets.all(5),
      //                       child: Stack(
      //                         children: <Widget>[
      //                           AspectRatio(
      //                             aspectRatio: 11.0 / 11.0,
      //                             child: document["post_image_500"] == "" ?
      //                             GestureDetector(
      //                               child: Container(
      //                                 decoration: BoxDecoration(
      //                                   image: DecorationImage(
      //                                     fit: BoxFit.cover,
      //                                     image: FileImage(
      //                                       File(
      //                                         document["post_image_path"].replaceFirst('File: \'', '').replaceFirst('\'', ''),
      //                                       ),
      //                                     ),
      //                                   ), 
      //                                 ),
      //                               ),
      //                               onTap: () async {
      //                                 await Navigator.push(
      //                                   context,MaterialPageRoute(builder: (context) => Item(document.id)),
      //                                 );
      //                                 // start();
      //                               },
      //                             )
      //                             :
      //                             GestureDetector(
      //                               child: ClipRRect(
      //                                 borderRadius: BorderRadius.circular(5.0),
      //                                 child: Image.network(
      //                                   document["post_image_500"],
      //                                   fit: BoxFit.cover,
      //                                 ),
      //                               ),
      //                               onTap: () async {
      //                                 await Navigator.push(
      //                                   context,MaterialPageRoute(builder: (context) => Item(document.id)),
      //                                 );
      //                                 // start();
      //                               },
      //                             ),
      //                           ),
      //                         ],
      //                       ),
      //                     );
      //                   }).toList(),
      //                 );
      //               } else {
      //                 return Container();
      //               }
      //             },
      //           ),
      //         ),
      //         Container(
      //           margin: EdgeInsets.only(top: 20),
      //           child: StreamBuilder(
      //             stream: FirebaseFirestore.instance
      //               .collection('tweets')
      //               .where('tweet_uid', isEqualTo: widget.name)
      //               .orderBy("tweet_time", descending: true)
      //               .snapshots(),
      //             builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      //               if (snapshot.hasData) {
      //                 return Container(
      //                   child: ListView.builder(
      //                     physics: NeverScrollableScrollPhysics(),
      //                     shrinkWrap: true,
      //                     itemCount: snapshot.data!.docs.length,
      //                     itemBuilder: (document, index) {
      //                       return Container(
      //                         margin: EdgeInsets.only(top: 5, bottom: 5, right: 10.w, left: 10.w,),
      //                         padding: EdgeInsets.only(top: 10, bottom: 10, right: 10, left: 10,),
      //                         decoration: BoxDecoration(
      //                           border: Border.all(
      //                             color: Colors.black12,
      //                             width: 1,
      //                           ),
      //                           borderRadius: BorderRadius.circular(5),
      //                         ),
      //                         child: Column(
      //                           children: [
      //                             Stack(
      //                               children: [
      //                                 Row(
      //                                   children: [
      //                                     Column(
      //                                       children: [
      //                                         Container(
      //                                           width: 74.w,
      //                                           child: Text(
      //                                             snapshot.data!.docs[index]["tweet_name"],
      //                                             textAlign: TextAlign.left,
      //                                             style: TextStyle(
      //                                               fontWeight: FontWeight.bold,
      //                                               fontSize: 15,
      //                                             ),
      //                                           ),
      //                                         ),
      //                                         Container(
      //                                           width: 74.w,
      //                                           child: Linkable(
      //                                             text: snapshot.data!.docs[index]["tweet_text"],
      //                                             textColor: Colors.black87,
      //                                             style: TextStyle(
      //                                               fontSize: 14,
      //                                             ),
      //                                           ),
      //                                         ),
      //                                         snapshot.data!.docs[index]["tweet_photo_1080"] != '' ? Container(
      //                                           width: 74.w,
      //                                           height: 74.w,
      //                                           margin: EdgeInsets.only(top: 5,),
      //                                           child: ClipRRect(
      //                                             borderRadius: BorderRadius.circular(5.0),
      //                                             child: Image.network(
      //                                               snapshot.data!.docs[index]["tweet_photo_1080"],
      //                                               fit: BoxFit.cover,
      //                                             ),
      //                                           ),
      //                                         ) : Container(),
      //                                       ],
      //                                     ),
      //                                   ],
      //                                 ),
      //                               ],
      //                             ),
      //                           ],
      //                         ),
      //                       );
      //                     }
      //                   ),
      //                 );
      //               } else {
      //                 return Container();
      //               }
      //             },
      //           ),
      //         ),
      //       ]
      //     ),
      //   ),
      // ),
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
