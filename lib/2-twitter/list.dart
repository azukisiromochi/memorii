import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:linkable/linkable.dart';
import 'package:app/2-twitter/items/tweet.dart';
import 'package:url_launcher/url_launcher.dart';

final navigatorsKey = GlobalKey<NavigatorState>();

class Twitter extends StatefulWidget {

  @override
  _TwitterState createState() => _TwitterState();
}

class _TwitterState extends State<Twitter> {
  
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
            return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Twitter",
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
                            MaterialPageRoute(builder: (context) => Tweet()),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                backgroundColor: Colors.white,
                centerTitle: false,
                elevation: 0.0,
                bottom: PreferredSize(
                  child: Container(
                    color: Colors.black12,
                    height: 1.0,
                  ),
                  preferredSize: Size.fromHeight(4.0)
                ),
              ),
              body: Scrollbar(
                isAlwaysShown: false,
                child: Container(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                      .collection('tweets')
                      .orderBy("tweet_time", descending: true)
                      .snapshots(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (document, index) {
                            return Container(
                              padding: EdgeInsets.only(top: 10, bottom: 10, right: 10, left: 10,),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.black12,
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Stack(
                                    children: [
                                      Row(
                                        children: [
                                          Column(
                                            children: [
                                              Container(
                                                height: 60,
                                                width: 60,
                                                margin: EdgeInsets.only(right: 15,),
                                              ),
                                            ]
                                          ),
                                          Column(
                                            children: [
                                              Container(
                                                width: 74.w,
                                                child: Text(
                                                  snapshot.data!.docs[index]["tweet_name"],
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: 74.w,
                                                child: Linkable(
                                                  text: snapshot.data!.docs[index]["tweet_text"],
                                                  textColor: Colors.black87,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                              snapshot.data!.docs[index]["tweet_photo_1080"] != '' ? Container(
                                                width: 74.w,
                                                height: 74.w,
                                                margin: EdgeInsets.only(top: 5,),
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(5.0),
                                                  child: Image.network(
                                                    snapshot.data!.docs[index]["tweet_photo_1080"],
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ) : Container(),
                                              Container(
                                                width: 74.w,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    GestureDetector(
                                                      child: Container(
                                                        padding: EdgeInsets.only(top: 5, bottom: 5, right: 5.w, left: 5.w,),
                                                        margin: EdgeInsets.only(top: 10, left: 0),
                                                        decoration: BoxDecoration(
                                                          border: Border.all(
                                                            color: Color(0xFFFF8D89),
                                                            width: 1,
                                                          ),
                                                          borderRadius: BorderRadius.circular(5),
                                                        ),
                                                        child: Text(
                                                          'instagram',
                                                          style: TextStyle(
                                                            color: Color(0xFFFF8D89),
                                                            fontSize: 12,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                      onTap: () async {
                                                        var url = 'https://www.instagram.com/${snapshot.data!.docs[index]["tweet_instagram"]}';
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
                                                    ),
                                                    GestureDetector(
                                                      child: Container(
                                                        padding: EdgeInsets.only(top: 5, bottom: 5, right: 5.w, left: 5.w,),
                                                        margin: EdgeInsets.only(top: 10, left: 10,),
                                                        decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          border: Border.all(
                                                            color: Color(0xFFFF8D89),
                                                            width: 1,
                                                          ),
                                                          borderRadius: BorderRadius.circular(5),
                                                        ),
                                                        child: Text(
                                                          'tiktok',
                                                          // UserData.instance.account[0]["user_instagram"],
                                                          style: TextStyle(
                                                            color: Color(0xFFFF8D89),
                                                            fontSize: 12,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                      onTap: () async {
                                                        var url = 'https://www.tiktok.com/@${snapshot.data!.docs[index]["tweet_tiktok"]}';
                                                        if (await canLaunch(url)) {
                                                          await launch(
                                                            url,
                                                            forceSafariVC: true,
                                                            forceWebView: true,
                                                          );
                                                        } else {
                                                          throw 'このURLにはアクセスできません';
                                                        }
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Container(
                                        height: 60,
                                        width: 60,
                                        margin: EdgeInsets.only(right: 10,),
                                        child: CircleAvatar(
                                          radius: 100,
                                          backgroundImage: NetworkImage(
                                            snapshot.data!.docs[index]["tweet_image_500"],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }
                        );
                      } else {
                        return Container();
                      }
                    },
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

