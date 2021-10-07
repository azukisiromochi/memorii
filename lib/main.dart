import 'dart:async';
import 'dart:io';
import 'package:app/2-twitter/list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:page_transition/page_transition.dart';
import '1-home/list.dart';
import '2-twitter/list.dart';
import '3-account/account.dart';
import 'package:sizer/sizer.dart';
import 'auth/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'singleton.dart';
import '../../singleton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp();
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    if (FirebaseAuth.instance.currentUser != null) {
      UserData.instance.user = FirebaseAuth.instance.currentUser!.uid;
      if (mounted) {setState(() {});}
      start();
    }
  }

  Future<void> start() async {
    await FirebaseFirestore.instance.collection('users').doc(UserData.instance.user).get()
    .then((doc) {
      UserData.instance.account.add(doc);
      if (mounted) {setState(() {});}
    });

    await FirebaseFirestore.instance.collection('posts').orderBy("post_count", descending: true).get()
    .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        UserData.instance.documentList.add(doc);
        if (mounted) {setState(() {});}
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: ("memorii photo"),
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.white,
            fontFamily: 'system-ui',
          ),
          home: AnimatedSplashScreen(
            duration: 1000,
            splash: Center(
              child: Image.asset(
                'assets/splash.png',
                height: 100,
              )
            ),
            nextScreen: UserData.instance.user == '' ? AuthMain() : Nav(),
            splashTransition: SplashTransition.fadeTransition,
            pageTransitionType: PageTransitionType.fade,
          )
        );
      }
    );
  }
}

class Nav extends StatefulWidget {
  const Nav();
  @override
  _NavState createState() => _NavState();
}

class _NavState extends State<Nav> {

  int _selectedIndex = 0;
  late List<Widget> _widgetOptions;

  bool navBtn1 = true;
  bool navBtn2 = false;
  
  @override
  void initState() {
    super.initState();

    _widgetOptions = <Widget>[
      PhotoMain(onTap),
      Twitter(),
      AccountAccountMain(),
    ];
  
    start();
  }

  Future<void> start() async {
    like();all();men();ladies();street();classic();mode();feminin();grunge();annui();rock();creative();
  }
  Future<void> all() async {
    await FirebaseFirestore.instance.collection('posts').orderBy("post_count", descending: true).get()
    .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        UserData.instance.listAll.add(doc);
        if (mounted) {setState(() {});}
      });
    });
  }
  Future<void> men() async {
    await FirebaseFirestore.instance.collection('posts')
    .where('post_tags', arrayContains: 'メンズ')
    .orderBy("post_count", descending: true).get()
    .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        UserData.instance.listMen.add(doc);
        if (mounted) {setState(() {});}
      });
    });
  }
  Future<void> ladies() async {
    await FirebaseFirestore.instance.collection('posts')
    .where('post_tags', arrayContains: 'レディース')
    .orderBy("post_count", descending: true).get()
    .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        UserData.instance.listLadies.add(doc);
        if (mounted) {setState(() {});}
      });
    });
  }
  Future<void> street() async {
    await FirebaseFirestore.instance.collection('posts')
    .where('post_tags', arrayContains: 'ストリート')
    .orderBy("post_count", descending: true).get()
    .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        UserData.instance.listStreet.add(doc);
        if (mounted) {setState(() {});}
      });
    });
  }
  Future<void> classic() async {
    await FirebaseFirestore.instance.collection('posts')
    .where('post_tags', arrayContains: 'クラシック')
    .orderBy("post_count", descending: true).get()
    .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        UserData.instance.listClassic.add(doc);
        if (mounted) {setState(() {});}
      });
    });
  }
  Future<void> mode() async {
    await FirebaseFirestore.instance.collection('posts')
    .where('post_tags', arrayContains: 'モード')
    .orderBy("post_count", descending: true).get()
    .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        UserData.instance.listMode.add(doc);
        if (mounted) {setState(() {});}
      });
    });
  }
  Future<void> feminin() async {
    await FirebaseFirestore.instance.collection('posts')
    .where('post_tags', arrayContains: 'フェミニン')
    .orderBy("post_count", descending: true).get()
    .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        UserData.instance.listFeminin.add(doc);
        if (mounted) {setState(() {});}
      });
    });
  }
  Future<void> grunge() async {
    await FirebaseFirestore.instance.collection('posts')
    .where('post_tags', arrayContains: 'グランジ')
    .orderBy("post_count", descending: true).get()
    .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        UserData.instance.listGrunge.add(doc);
        if (mounted) {setState(() {});}
      });
    });
  }
  Future<void> annui() async {
    await FirebaseFirestore.instance.collection('posts')
    .where('post_tags', arrayContains: 'アンニュイ')
    .orderBy("post_count", descending: true).get()
    .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        UserData.instance.listAnnui.add(doc);
        if (mounted) {setState(() {});}
      });
    });
  }
  Future<void> rock() async {
    await FirebaseFirestore.instance.collection('posts')
    .where('post_tags', arrayContains: 'ロック')
    .orderBy("post_count", descending: true).get()
    .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        UserData.instance.listRock.add(doc);
        if (mounted) {setState(() {});}
      });
    });
  }
  Future<void> creative() async {
    await FirebaseFirestore.instance.collection('posts')
    .where('post_tags', arrayContains: 'クリエイティブ')
    .orderBy("post_count", descending: true).get()
    .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        UserData.instance.listCrieitive.add(doc);
        if (mounted) {setState(() {});}
      });
    });
  }
  Future<void> like() async {
    UserData.instance.documentLikeList.clear();
    await FirebaseFirestore.instance.collection('users').doc(UserData.instance.user).get()
    .then((doc) {
      UserData.instance.documentLikeList = doc["user_likes"];
      if (mounted) {setState(() {});}
    });
  }

  void onTap() {
    _selectedIndex = 2;
    navBtn1 = false;
    navBtn2 = false;
    if (mounted) {setState(() {});}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // body: Container()
      body: Stack(
        children: <Widget>[
          _widgetOptions.elementAt(_selectedIndex),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: 50.w,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.white,
              ),
              margin: EdgeInsets.only(bottom: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    child: IconButton(
                      icon: Icon(
                        Icons.home,
                        color: navBtn1 ? Colors.black87 : Colors.black54,
                      ),
                      onPressed: () {
                        if (_selectedIndex == 0){
                          _selectedIndex = 0;
                          navigatorKey.currentState!.popUntil((route) => route.isFirst);
                          if (mounted) {setState(() {});}
                        } else {
                          _selectedIndex = 0;
                          if (mounted) {setState(() {});}
                        }
                        navBtn1 = true;
                        navBtn2 = false;
                        if (mounted) {setState(() {});}
                      },
                    ),
                    onLongPress: () async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => AuthMain()),
                        (Route<dynamic> route) => false,
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.article,
                      color: navBtn2 ? Colors.black87 : Colors.black54,
                    ),
                    onPressed: () {
                      if (_selectedIndex == 1){
                        _selectedIndex = 1;
                        navigatorsKey.currentState!.popUntil((route) => route.isFirst);
                        if (mounted) {setState(() {});}
                      } else {
                        _selectedIndex = 1;
                        if (mounted) {setState(() {});}
                      }
                      navBtn1 = false;
                      navBtn2 = true;
                      if (mounted) {setState(() {});}
                    },
                  ),
                  GestureDetector(
                    child: UserData.instance.account.length > 0 ?
                    UserData.instance.account[0]["user_image_500"] == "" ?
                    Container(
                      width: 25,
                      height: 25,
                      margin: EdgeInsets.only(right: 13,),
                      foregroundDecoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black26,
                          width: 1.0,
                        ),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: FileImage(
                            File(
                              UserData.instance.account[0]["user_image_path"].replaceFirst('File: \'', '').replaceFirst('\'', ''),
                            ),
                          ),
                        ),
                        borderRadius: BorderRadius.circular(40),
                      ),
                    )
                    :
                    Container(
                      width: 25,
                      height: 25,
                      margin: EdgeInsets.only(right: 15, left: 5,),
                      foregroundDecoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black26,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(40.0),
                        child: UserData.instance.account.length > 0 ? Image.network(
                          "${UserData.instance.account[0]["user_image_500"]}",
                          fit: BoxFit.cover,
                        ) : null,
                      ),
                    ) : Container(),
                    onTap: () {
                      if (_selectedIndex == 2){
                        _selectedIndex = 2;
                        navigatorssKey.currentState!.popUntil((route) => route.isFirst);
                        if (mounted) {setState(() {});}
                      } else{
                        _selectedIndex = 2;
                        if (mounted) {setState(() {});}
                      }
                      navBtn1 = false;
                      navBtn2 = false;
                      if (mounted) {setState(() {});}
                    },
                  ),
                ],
              ),
            ),
          ),
        ]
      ),
    );
  }
}

class Splash extends StatefulWidget {
  const Splash();
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  @override
  void initState() {
    super.initState();
    start();
  }

  Future<void> start() async {
    await Future.delayed(Duration(seconds: 1), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => Nav()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          'assets/splash.png',
          height: 100,
        )
      )
    );
  }
}
