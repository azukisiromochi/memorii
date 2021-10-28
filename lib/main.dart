import 'dart:async';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '1-home/list.dart';
import '3-account/account.dart';
import 'package:sizer/sizer.dart';
import 'auth/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'singleton.dart';
import '../../singleton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:page_transition/page_transition.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:geocoding/geocoding.dart';

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
    }
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
          ),
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
    start();
    _widgetOptions = <Widget>[
      PhotoMain(onTap),
      // ContestMain(onTap),
      AccountAccountMain(),
    ];
  }

  Future<void> start() async {
    await FirebaseFirestore.instance.collection('users').doc(UserData.instance.user).get()
    .then((doc) {
      UserData.instance.account.add(doc);
      if (mounted) {setState(() {});}
    });
    await FirebaseMessaging.instance.getToken().then((String? token) async{
      await FirebaseFirestore.instance.collection("users").doc(UserData.instance.user).update({'user_token' : token});
    });
    Position _currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks = await placemarkFromCoordinates(_currentPosition.latitude, _currentPosition.longitude);
    await FirebaseFirestore.instance.collection('users').doc(UserData.instance.user)
    .update({
      'user_address_postalCode': placemarks.first.postalCode,
      'user_address': [placemarks.first.isoCountryCode,placemarks.first.administrativeArea,placemarks.first.locality,placemarks.first.thoroughfare,placemarks.first.subThoroughfare,],
    });
  }

  void onTap() {
    _selectedIndex = 1;
    navBtn1 = false;
    navBtn2 = false;
    if (mounted) {setState(() {});}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                  // IconButton(
                  //   icon: Icon(
                  //     Icons.emoji_events,
                  //     // Icons.article,
                  //     color: navBtn2 ? Colors.black87 : Colors.black54,
                  //   ),
                  //   onPressed: () {
                  //     if (_selectedIndex == 1){
                  //       _selectedIndex = 1;
                  //       navigatorsKey.currentState!.popUntil((route) => route.isFirst);
                  //       if (mounted) {setState(() {});}
                  //     } else {
                  //       _selectedIndex = 1;
                  //       if (mounted) {setState(() {});}
                  //     }
                  //     navBtn1 = false;
                  //     navBtn2 = true;
                  //     if (mounted) {setState(() {});}
                  //   },
                  // ),
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
                      child: CircleAvatar(
                        radius: 100,
                        backgroundColor: Colors.white,
                        foregroundImage: UserData.instance.account.length > 0 ? NetworkImage(
                          '${UserData.instance.account[0]['user_image_500']}',
                        ) : null,
                        backgroundImage: NetworkImage(
                          'https://firebasestorage.googleapis.com/v0/b/photo-beauty-24f63.appspot.com/o/profiles%2Fresize_images%2FIkUjEEryaCSRwjZnGUAzPZMlWei1_1080x1080?alt=media&token=01efd83b-19ba-419a-a9c7-8204b34e60e7',
                        ),
                      ),
                    ) : Container(),
                    onTap: () {
                      if (_selectedIndex == 1){
                        _selectedIndex = 1;
                        navigatorssKey.currentState!.popUntil((route) => route.isFirst);
                        if (mounted) {setState(() {});}
                      } else{
                        _selectedIndex = 1;
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
