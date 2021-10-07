import 'dart:io';
import 'dart:math';
import 'package:app/3-account/items/accountEdit.dart';
import 'package:app/3-account/items/accountImage.dart';
import 'package:app/3-account/items/photoEdit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:linkable/linkable.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sizer/sizer.dart';
import '../singleton.dart';
import 'items/like.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

final navigatorssKey = GlobalKey<NavigatorState>();

class AccountAccountMain extends StatefulWidget {

  @override
  _AccountAccountMainState createState() => _AccountAccountMainState();
}

class _AccountAccountMainState extends State<AccountAccountMain> {

  // TabController? _controller;
  List accountPhotos = [];
  int favoriteCount = 0;

  @override
  void initState() {
    super.initState();
    // _controller = TabController(length: 2, vsync: this);
  }

  List<String> posts = [
    'https://storage.googleapis.com/photo-beauty-24f63.appspot.com/profiles/resize_images/8RI6oK0CzJTVDAhPlm0xCZ0YsLP2_1080x1080?GoogleAccessId=photo-beauty-24f63%40appspot.gserviceaccount.com&Expires=33166281600&Signature=SlwxnVhUDDntvTyJMzpTqGtGHyb1%2BCj7aZRogdOa8Lvke1DQYQbEMSLy8HX6ZVWDCsR3nIWFnTUW4RNlThB%2FjuPFHlFnimxpoDeAjtS4XMd%2FASueyTxoNM0wKta7esXa8vJu%2FzqFtqZHx8msdQRz1BQEtfe0fHEs67222K2LRflk9kFNQI94i0yZYeI9KutVi0XsbFiWH3%2FBEhde1n0MHSursQ1kIY7RZK2wHhf3o%2B7x5oVaL9QnbDiQkMuyjv%2Fy4XinCNTvKEQOiVTV59%2F%2ByqeAFN6MeiMQMOZ%2FXUIJ8BopfFqoZ3eGAye7cR6%2BxokuOBIcdSyvWma5%2FP0W3KKltA%3D%3D',
    'https://storage.googleapis.com/photo-beauty-24f63.appspot.com/profiles/resize_images/8RI6oK0CzJTVDAhPlm0xCZ0YsLP2_1080x1080?GoogleAccessId=photo-beauty-24f63%40appspot.gserviceaccount.com&Expires=33166281600&Signature=SlwxnVhUDDntvTyJMzpTqGtGHyb1%2BCj7aZRogdOa8Lvke1DQYQbEMSLy8HX6ZVWDCsR3nIWFnTUW4RNlThB%2FjuPFHlFnimxpoDeAjtS4XMd%2FASueyTxoNM0wKta7esXa8vJu%2FzqFtqZHx8msdQRz1BQEtfe0fHEs67222K2LRflk9kFNQI94i0yZYeI9KutVi0XsbFiWH3%2FBEhde1n0MHSursQ1kIY7RZK2wHhf3o%2B7x5oVaL9QnbDiQkMuyjv%2Fy4XinCNTvKEQOiVTV59%2F%2ByqeAFN6MeiMQMOZ%2FXUIJ8BopfFqoZ3eGAye7cR6%2BxokuOBIcdSyvWma5%2FP0W3KKltA%3D%3D',
    'https://storage.googleapis.com/photo-beauty-24f63.appspot.com/profiles/resize_images/8RI6oK0CzJTVDAhPlm0xCZ0YsLP2_1080x1080?GoogleAccessId=photo-beauty-24f63%40appspot.gserviceaccount.com&Expires=33166281600&Signature=SlwxnVhUDDntvTyJMzpTqGtGHyb1%2BCj7aZRogdOa8Lvke1DQYQbEMSLy8HX6ZVWDCsR3nIWFnTUW4RNlThB%2FjuPFHlFnimxpoDeAjtS4XMd%2FASueyTxoNM0wKta7esXa8vJu%2FzqFtqZHx8msdQRz1BQEtfe0fHEs67222K2LRflk9kFNQI94i0yZYeI9KutVi0XsbFiWH3%2FBEhde1n0MHSursQ1kIY7RZK2wHhf3o%2B7x5oVaL9QnbDiQkMuyjv%2Fy4XinCNTvKEQOiVTV59%2F%2ByqeAFN6MeiMQMOZ%2FXUIJ8BopfFqoZ3eGAye7cR6%2BxokuOBIcdSyvWma5%2FP0W3KKltA%3D%3D',
    'https://storage.googleapis.com/photo-beauty-24f63.appspot.com/profiles/resize_images/8RI6oK0CzJTVDAhPlm0xCZ0YsLP2_1080x1080?GoogleAccessId=photo-beauty-24f63%40appspot.gserviceaccount.com&Expires=33166281600&Signature=SlwxnVhUDDntvTyJMzpTqGtGHyb1%2BCj7aZRogdOa8Lvke1DQYQbEMSLy8HX6ZVWDCsR3nIWFnTUW4RNlThB%2FjuPFHlFnimxpoDeAjtS4XMd%2FASueyTxoNM0wKta7esXa8vJu%2FzqFtqZHx8msdQRz1BQEtfe0fHEs67222K2LRflk9kFNQI94i0yZYeI9KutVi0XsbFiWH3%2FBEhde1n0MHSursQ1kIY7RZK2wHhf3o%2B7x5oVaL9QnbDiQkMuyjv%2Fy4XinCNTvKEQOiVTV59%2F%2ByqeAFN6MeiMQMOZ%2FXUIJ8BopfFqoZ3eGAye7cR6%2BxokuOBIcdSyvWma5%2FP0W3KKltA%3D%3D',
    'https://storage.googleapis.com/photo-beauty-24f63.appspot.com/profiles/resize_images/8RI6oK0CzJTVDAhPlm0xCZ0YsLP2_1080x1080?GoogleAccessId=photo-beauty-24f63%40appspot.gserviceaccount.com&Expires=33166281600&Signature=SlwxnVhUDDntvTyJMzpTqGtGHyb1%2BCj7aZRogdOa8Lvke1DQYQbEMSLy8HX6ZVWDCsR3nIWFnTUW4RNlThB%2FjuPFHlFnimxpoDeAjtS4XMd%2FASueyTxoNM0wKta7esXa8vJu%2FzqFtqZHx8msdQRz1BQEtfe0fHEs67222K2LRflk9kFNQI94i0yZYeI9KutVi0XsbFiWH3%2FBEhde1n0MHSursQ1kIY7RZK2wHhf3o%2B7x5oVaL9QnbDiQkMuyjv%2Fy4XinCNTvKEQOiVTV59%2F%2ByqeAFN6MeiMQMOZ%2FXUIJ8BopfFqoZ3eGAye7cR6%2BxokuOBIcdSyvWma5%2FP0W3KKltA%3D%3D',
    'https://storage.googleapis.com/photo-beauty-24f63.appspot.com/profiles/resize_images/8RI6oK0CzJTVDAhPlm0xCZ0YsLP2_1080x1080?GoogleAccessId=photo-beauty-24f63%40appspot.gserviceaccount.com&Expires=33166281600&Signature=SlwxnVhUDDntvTyJMzpTqGtGHyb1%2BCj7aZRogdOa8Lvke1DQYQbEMSLy8HX6ZVWDCsR3nIWFnTUW4RNlThB%2FjuPFHlFnimxpoDeAjtS4XMd%2FASueyTxoNM0wKta7esXa8vJu%2FzqFtqZHx8msdQRz1BQEtfe0fHEs67222K2LRflk9kFNQI94i0yZYeI9KutVi0XsbFiWH3%2FBEhde1n0MHSursQ1kIY7RZK2wHhf3o%2B7x5oVaL9QnbDiQkMuyjv%2Fy4XinCNTvKEQOiVTV59%2F%2ByqeAFN6MeiMQMOZ%2FXUIJ8BopfFqoZ3eGAye7cR6%2BxokuOBIcdSyvWma5%2FP0W3KKltA%3D%3D',
    'https://storage.googleapis.com/photo-beauty-24f63.appspot.com/profiles/resize_images/8RI6oK0CzJTVDAhPlm0xCZ0YsLP2_1080x1080?GoogleAccessId=photo-beauty-24f63%40appspot.gserviceaccount.com&Expires=33166281600&Signature=SlwxnVhUDDntvTyJMzpTqGtGHyb1%2BCj7aZRogdOa8Lvke1DQYQbEMSLy8HX6ZVWDCsR3nIWFnTUW4RNlThB%2FjuPFHlFnimxpoDeAjtS4XMd%2FASueyTxoNM0wKta7esXa8vJu%2FzqFtqZHx8msdQRz1BQEtfe0fHEs67222K2LRflk9kFNQI94i0yZYeI9KutVi0XsbFiWH3%2FBEhde1n0MHSursQ1kIY7RZK2wHhf3o%2B7x5oVaL9QnbDiQkMuyjv%2Fy4XinCNTvKEQOiVTV59%2F%2ByqeAFN6MeiMQMOZ%2FXUIJ8BopfFqoZ3eGAye7cR6%2BxokuOBIcdSyvWma5%2FP0W3KKltA%3D%3D',
  ];

  // Future<void> start() async {
  //   favoriteCount = 0;
  //   UserData.instance.accountPostCount = 0;
  //   UserData.instance.account.clear();
  //   if (mounted) {setState(() {});}
  //   await FirebaseFirestore.instance.collection('users').doc(UserData.instance.user).get()
  //   .then((doc) {
  //     UserData.instance.account.add(doc);
  //     if (mounted) {setState(() {});}
  //   });
  //   await FirebaseFirestore.instance.collection('posts').where('post_uid', isEqualTo: UserData.instance.user).get()
  //   .then((QuerySnapshot querySnapshot) {
  //     querySnapshot.docs.forEach((doc) {
  //       UserData.instance.accountPostCount += 1;
  //       if (mounted) {setState(() {});}
  //     });
  //   });
  // }
  launchInApp() async {
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
  launchInInstagram() async {
    var url = 'https://www.instagram.com/memorii.photo';
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
                        child: TextButton(
                          child: UserData.instance.account.length > 0 ? Text(
                            UserData.instance.account[0]["user_instagram"] == "" ? "未登録" : UserData.instance.account[0]["user_instagram"],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15
                            ),
                          ) : Text(""),
                          onPressed: () {
                            launchInApp();
                          },
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
                                          'アカウント編集 [画像]',
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
                                            MaterialPageRoute(builder: (context) => AccountImage(UserData.instance.account[0]["user_image_1080"])),
                                          );
                                        },
                                      ),
                                    ),
                                    Container(
                                      color: Colors.black87,
                                      child: CupertinoActionSheetAction(
                                        child: Text(
                                          'アカウント編集 [文章]',
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
                                        },
                                      ),
                                    ),
                                    Container(
                                      color: Colors.black87,
                                      child: CupertinoActionSheetAction(
                                        child: Text(
                                          'いいね済み',
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
                                            MaterialPageRoute(builder: (context) => Like()),
                                          );
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
                                          launchInInstagram();
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
                length: 3,
                child: NestedScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  headerSliverBuilder: (context,isScolled){
                    return [
                      SliverAppBar(
                        backgroundColor: Colors.white,
                        collapsedHeight: 250,
                        expandedHeight: 250,
                        flexibleSpace: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Container(
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
                                                margin: EdgeInsets.only(top: 60, right: 10.w, left: 10.w),
                                                child: UserData.instance.account.length > 0 ? Text(
                                                  UserData.instance.account[0]["user_name"] != "" ?
                                                  UserData.instance.account[0]["user_name"] : "unnamed",
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
                                                child: UserData.instance.account.length > 0 ? Text(
                                                  UserData.instance.account[0]["user_short"],
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black26,
                                                    fontSize: 12,
                                                  ),
                                                ) : Text(""),
                                              ),
                                            ],
                                          ),
                                        ),
                                        UserData.instance.account.length > 0 ?
                                        UserData.instance.account[0]["user_image_500"] == "" ?
                                        Container(
                                          height: 110,
                                          width: 30.w,
                                          margin: EdgeInsets.only(top: 20, right: 35.w, left: 35.w),
                                          padding: EdgeInsets.all(5.0),
                                          decoration: BoxDecoration(
                                            color: Color(0xFFFFFFFF),
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 5,
                                            ),
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: FileImage(
                                                File(
                                                  UserData.instance.account[0]["user_image_path"].replaceFirst('File: \'', '').replaceFirst('\'', ''),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                        :
                                        Container(
                                          height: 110,
                                          width: 30.w,
                                          margin: EdgeInsets.only(top: 20, right: 35.w, left: 35.w),
                                          child: CircleAvatar(
                                            radius: 100,
                                            backgroundColor: Colors.white,
                                            backgroundImage: NetworkImage(
                                              UserData.instance.account[0]["user_image_500"],
                                            ),
                                          ),
                                          padding: EdgeInsets.all(5.0),
                                          decoration: BoxDecoration(
                                            color: Color(0xFFFFFFFF),
                                            shape: BoxShape.circle,
                                          )
                                        ) : Container(),
                                      ]
                                    ),
                                  ],
                                ),
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
                                  child: Text("Photos"),
                                ),
                              ),
                              Tab(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text("Tweets"),
                                ),
                              ),
                              Tab(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text("Likes"),
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
                                // physics: NeverScrollableScrollPhysics(),
                                // shrinkWrap: true,
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
                                          child: document["post_image_500"] == "" ?
                                          GestureDetector(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: FileImage(
                                                    File(
                                                      document["post_image_path"].replaceFirst('File: \'', '').replaceFirst('\'', ''),
                                                    ),
                                                  ),
                                                ), 
                                              ),
                                            ),
                                            onTap: () async {
                                              await Navigator.push(
                                                context,MaterialPageRoute(builder: (context) => PhotoEdit(document.id)),
                                              );
                                              // start();
                                            },
                                          )
                                          :
                                          GestureDetector(
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(5.0),
                                              child: Image.network(
                                                document["post_image_500"],
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            onTap: () async {
                                              await Navigator.push(
                                                context,MaterialPageRoute(builder: (context) => PhotoEdit(document.id)),
                                              );
                                              // start();
                                            },
                                          ),
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
                        margin: EdgeInsets.only(top: 20),
                        child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                            .collection('tweets')
                            .orderBy("tweet_time", descending: true)
                            .snapshots(),
                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasData) {
                              return Container(
                                child: ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: (document, index) {
                                    return Container(
                                      margin: EdgeInsets.only(right: 10.w, left: 10.w,),
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
                                                  // Column(
                                                  //   children: [
                                                  //     Container(
                                                  //       height: 60,
                                                  //       width: 60,
                                                  //       margin: EdgeInsets.only(right: 15,),
                                                  //     ),
                                                  //   ]
                                                  // ),
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
                                                            // GestureDetector(
                                                            //   child: Container(
                                                            //     padding: EdgeInsets.only(top: 5, bottom: 5, right: 5.w, left: 5.w,),
                                                            //     margin: EdgeInsets.only(top: 10, left: 0),
                                                            //     decoration: BoxDecoration(
                                                            //       border: Border.all(
                                                            //         color: Color(0xFFFF8D89),
                                                            //         width: 1,
                                                            //       ),
                                                            //       borderRadius: BorderRadius.circular(5),
                                                            //     ),
                                                            //     child: Text(
                                                            //       'instagram',
                                                            //       style: TextStyle(
                                                            //         color: Color(0xFFFF8D89),
                                                            //         fontSize: 12,
                                                            //         fontWeight: FontWeight.bold,
                                                            //       ),
                                                            //     ),
                                                            //   ),
                                                            //   onTap: () async {
                                                            //     var url = 'https://www.instagram.com/${snapshot.data!.docs[index]["tweet_instagram"]}';
                                                            //     if (await canLaunch(url)) {
                                                            //       await launch(
                                                            //         url,
                                                            //         forceSafariVC: true,
                                                            //         forceWebView: true,
                                                            //       );
                                                            //     } else {
                                                            //       throw 'このURLにはアクセスできません';
                                                            //     }
                                                            //   }
                                                            // ),
                                                            // GestureDetector(
                                                            //   child: Container(
                                                            //     padding: EdgeInsets.only(top: 5, bottom: 5, right: 5.w, left: 5.w,),
                                                            //     margin: EdgeInsets.only(top: 10, left: 10,),
                                                            //     decoration: BoxDecoration(
                                                            //       color: Colors.white,
                                                            //       border: Border.all(
                                                            //         color: Color(0xFFFF8D89),
                                                            //         width: 1,
                                                            //       ),
                                                            //       borderRadius: BorderRadius.circular(5),
                                                            //     ),
                                                            //     child: Text(
                                                            //       'tiktok',
                                                            //       // UserData.instance.account[0]["user_instagram"],
                                                            //       style: TextStyle(
                                                            //         color: Color(0xFFFF8D89),
                                                            //         fontSize: 12,
                                                            //         fontWeight: FontWeight.bold,
                                                            //       ),
                                                            //     ),
                                                            //   ),
                                                            //   onTap: () async {
                                                            //     var url = 'https://www.tiktok.com/@${snapshot.data!.docs[index]["tweet_tiktok"]}';
                                                            //     if (await canLaunch(url)) {
                                                            //       await launch(
                                                            //         url,
                                                            //         forceSafariVC: true,
                                                            //         forceWebView: true,
                                                            //       );
                                                            //     } else {
                                                            //       throw 'このURLにはアクセスできません';
                                                            //     }
                                                            //   },
                                                            // ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              // Container(
                                              //   height: 60,
                                              //   width: 60,
                                              //   margin: EdgeInsets.only(right: 10,),
                                              //   child: CircleAvatar(
                                              //     radius: 100,
                                              //     backgroundImage: NetworkImage(
                                              //       snapshot.data!.docs[index]["tweet_image_500"],
                                              //     ),
                                              //   ),
                                              // ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  }
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
                            .where('post_liker', arrayContains: UserData.instance.user)
                            .snapshots(),
                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasData) {
                              return GridView.count(
                                // physics: NeverScrollableScrollPhysics(),
                                // shrinkWrap: true,
                                crossAxisCount: 2,
                                childAspectRatio: 7.0 / 7.0,
                                children: snapshot.data!.docs.map((document) {
                                  return Container(
                                    margin: EdgeInsets.all(5),
                                    child: Stack(
                                      children: <Widget>[
                                        AspectRatio(
                                          aspectRatio: 11.0 / 11.0,
                                          child: document["post_image_500"] == "" ?
                                          GestureDetector(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: FileImage(
                                                    File(
                                                      document["post_image_path"].replaceFirst('File: \'', '').replaceFirst('\'', ''),
                                                    ),
                                                  ),
                                                ), 
                                              ),
                                            ),
                                            onTap: () async {
                                              await Navigator.push(
                                                context,MaterialPageRoute(builder: (context) => PhotoEdit(document.id)),
                                              );
                                              // start();
                                            },
                                          )
                                          :
                                          GestureDetector(
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(5.0),
                                              child: Image.network(
                                                document["post_image_500"],
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            onTap: () async {
                                              await Navigator.push(
                                                context,MaterialPageRoute(builder: (context) => PhotoEdit(document.id)),
                                              );
                                              // start();
                                            },
                                          ),
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
