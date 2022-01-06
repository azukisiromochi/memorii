import 'dart:io';
import 'package:app/1-home/items/item.dart';
import 'package:app/2-account/items/accountEdit.dart';
import 'package:app/2-account/items/photoEdit.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:linkable/linkable.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sizer/sizer.dart';
import '../singleton.dart';

final navigatorssKey = GlobalKey<NavigatorState>();

class AccountAccountMain extends StatefulWidget {

  @override
  _AccountAccountMainState createState() => _AccountAccountMainState();
}

class _AccountAccountMainState extends State<AccountAccountMain> {

  launchInstagram() async {
    var url = 'https://www.instagram.com/${UserData.instance.account[0]["user_instagram"]}';
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
  launchTiktok() async {
    var url = 'https://www.tiktok.com/@${UserData.instance.account[0]["user_tiktok"]}';
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
  // Future<void> start() async {
  //   await FirebaseFirestore.instance.collection('users').doc(UserData.instance.user).get()
  //   .then((doc) {
  //     UserData.instance.account.clear();
  //     UserData.instance.account.add(doc);
  //     if (mounted) {setState(() {});}
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorssKey,
      onGenerateRoute: (settings) {
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (context) {
            return  Scaffold(
              appBar: AppBar(
                title: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: ButtonTheme(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        minWidth: 0,
                        height: 0,
                        child: Text(
                          'プロフィール',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: GestureDetector(
                          child: Icon(
                            Icons.menu,
                            color: Colors.white,
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
                                          'アカウント編集',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                          ),
                                        ),
                                        onPressed: () async {
                                          HapticFeedback.heavyImpact();
                                          Navigator.of(context).pop();
                                          await Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => AccountEdit()),
                                          );
                                          // start();
                                        },
                                      ),
                                    ),
                                    Container(
                                      color: Colors.black87,
                                      child: CupertinoActionSheetAction(
                                        child: Text(
                                          'アカウント URL',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                          ),
                                        ),
                                        onPressed: () async {
                                          HapticFeedback.heavyImpact();
                                          Navigator.of(context).pop();
                                          final data = ClipboardData(
                                            text: "https://photo-beauty.work/id?q=${UserData.instance.user}"
                                          );
                                          Clipboard.setData(data);
                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                            backgroundColor: Color(0xFFFF8D89),
                                            content: Text("コピーしました。"),
                                          ));
                                        },
                                      ),
                                    ),
                                    Container(
                                      color: Colors.black87,
                                      child: CupertinoActionSheetAction(
                                        child: Text(
                                          'memorii photo[Instagram]',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                          ),
                                        ),
                                        onPressed: () async {
                                          HapticFeedback.heavyImpact();
                                          Navigator.of(context).pop();
                                          launchInstagram();
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
                backgroundColor: Color(0xFFFF8D89),
                centerTitle: true,
                elevation: 0.0,
              ),
              
              body: DefaultTabController(
                length: 2,
                child: NestedScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  headerSliverBuilder: (context,isScolled){
                    return [
                      SliverAppBar(
                        backgroundColor: Colors.white,
                        collapsedHeight: 280,
                        expandedHeight: 280,
                        flexibleSpace: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: StreamBuilder(
                                stream: FirebaseFirestore.instance
                                  .collection('users')
                                  .where('user_uid', isEqualTo: UserData.instance.user)
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
                                                      child: Text(
                                                        snapshot.data!.docs[0]["user_name"] != "" ?
                                                        snapshot.data!.docs[0]["user_name"] : "unnamed",
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors.black87,
                                                          fontSize: 20,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(top: 0, right: 10.w, left: 10.w),
                                                      child: Text(
                                                        snapshot.data!.docs[0]["user_text"],
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors.black26,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      width: double.infinity,
                                                      margin: EdgeInsets.only(top: 15, right: 20.w, left: 20.w),
                                                      child: Row(
                                                        children: [   
                                                          Spacer(),
                                                          snapshot.data!.docs[0]["user_instagram"] == '' ? Container() :
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
                                                              launchInstagram();
                                                            },
                                                          ),
                                                          snapshot.data!.docs[0]["user_tiktok"] == '' ? Container() :
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
                                                              launchTiktok();
                                                            },
                                                          ),
                                                          snapshot.data!.docs[0]["user_youtube"] == '' ? Container() :
                                                          GestureDetector(
                                                            child: Container(
                                                              width: 28,
                                                              height: 28,
                                                              margin: EdgeInsets.only(right: 8, left: 8,),
                                                              decoration: BoxDecoration(
                                                                color: Colors.red,
                                                                borderRadius: BorderRadius.circular(7),
                                                              ),
                                                              child: Center(
                                                                child: FaIcon(
                                                                  FontAwesomeIcons.youtube,
                                                                  color: Colors.white,
                                                                  size: 20,
                                                                ),
                                                              ),
                                                            ),
                                                            onTap: () {
                                                              launchTiktok();
                                                            },
                                                          ),
                                                          Spacer(),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                height: 26.w,
                                                width: 26.w,
                                                margin: EdgeInsets.only(top: 20, right: 37.w, left: 37.w),
                                                child: CircleAvatar(
                                                  radius: 100,
                                                  backgroundColor: Colors.white,
                                                  backgroundImage: NetworkImage(
                                                    snapshot.data!.docs[0]["user_image_500"],
                                                  ),
                                                ),
                                                padding: EdgeInsets.all(5.0),
                                                decoration: BoxDecoration(
                                                  color: Color(0xFFFFFFFF),
                                                  shape: BoxShape.circle,
                                                )
                                              ),
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
                          ],
                        ),
                      ),
                      SliverPersistentHeader(
                        delegate: MyDelegate(
                          TabBar(
                            tabs: [
                              Tab(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text("作品撮り"),
                                ),
                              ),
                              Tab(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text("いいね"),
                                ),
                              ),
                            ],
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
                        width: 80.w,
                        margin: EdgeInsets.only(top: 20, right: 10.w, left: 10.w),
                        child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                            .collection('posts')
                            .where('post_uid', isEqualTo: UserData.instance.user)
                            .orderBy("post_time", descending: true)
                            .snapshots(),
                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasData) {
                              return GridView.count(
                                physics: BouncingScrollPhysics(
                                  parent: AlwaysScrollableScrollPhysics()
                                ),
                                crossAxisCount: 2,
                                childAspectRatio: 7.0 / 7.0,
                                children: snapshot.data!.docs.map((document) {
                                  return Container(
                                    margin: EdgeInsets.all(5),
                                    child: Stack(
                                      children: <Widget>[
                                        AspectRatio(
                                          aspectRatio: 11.0 / 11.0,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(5.0),
                                            child: Image.network(
                                              document["post_image_500"],
                                              fit: BoxFit.cover,
                                              errorBuilder: (c, o, s) {
                                                return Container(
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: FileImage(
                                                        File(
                                                          document["post_image_path"],
                                                        ),
                                                      ),
                                                    ), 
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          child: Align(
                                            alignment: Alignment.topRight,
                                            child: Container(
                                              margin: EdgeInsets.only(right: 5,),
                                              child: Icon(
                                                Icons.more_horiz,
                                                color: Colors.black87,
                                              ),
                                            ),
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
                                                          '削除',
                                                          style: TextStyle(
                                                            color: Colors.red,
                                                            fontSize: 15,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                        onPressed: () async {
                                                          HapticFeedback.heavyImpact();
                                                          Navigator.of(context).pop();
                                                          await FirebaseStorage.instance.ref("image/resize_images")
                                                            .child('${document["post_image_name"]}_500x500').delete();
                                                          await FirebaseStorage.instance.ref("image/resize_images")
                                                            .child('${document["post_image_name"]}_1080x1080').delete();
                                                          await FirebaseFirestore.instance.collection("posts").doc(document.id).delete();
                                                          await FirebaseFirestore.instance.collection('users').where('user_likes', arrayContains: document.id).get()
                                                            .then((QuerySnapshot querySnapshot) {
                                                              querySnapshot.docs.forEach((doc) {
                                                                print(doc.id);
                                                                FirebaseFirestore.instance.collection('users')
                                                                  .doc(doc.id)
                                                                  .update({
                                                                    'user_likes': FieldValue.arrayRemove([document.id,])
                                                                  });
                                                              });
                                                            });
                                                        },
                                                      ),
                                                    ),
                                                    Container(
                                                      color: Colors.black87,
                                                      child: CupertinoActionSheetAction(
                                                        child: Text(
                                                          '編集',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 15,
                                                            // fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                        onPressed: () async {
                                                          Navigator.of(context).pop();
                                                          await Navigator.push(
                                                            context,MaterialPageRoute(builder: (context) => 
                                                            PhotoEdit(document.id, document['post_image_500'], document['post_tags'],)),
                                                          );
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
                                      ],
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
                        width: 80.w,
                        margin: EdgeInsets.only(top: 20, right: 10.w, left: 10.w),
                        child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                            .collection('posts')
                            .where('post_liker', arrayContains: UserData.instance.user)
                            .snapshots(),
                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasData) {
                              return GridView.count(
                                crossAxisCount: 2,
                                childAspectRatio: 7.0 / 7.0,
                                children: snapshot.data!.docs.map((document) {
                                  return Container(
                                    margin: EdgeInsets.all(5),
                                    child: Stack(
                                      children: <Widget>[
                                        GestureDetector(
                                          child: AspectRatio(
                                            aspectRatio: 11.0 / 11.0,
                                            child: document["post_image_500"] == "" ? Container() :
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(5.0),
                                              child: Image.network(
                                                document["post_image_500"],
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          onTap: () async {
                                            await Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => Item(document.id, document['post_video'])),
                                            );
                                          },
                                        ),
                                      ],
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

