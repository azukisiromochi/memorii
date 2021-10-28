import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../singleton.dart';
import '../../main.dart';
import 'package:sizer/sizer.dart';
import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthMain extends StatefulWidget {
  @override
  _AuthMainState createState() => _AuthMainState();
}

class _AuthMainState extends State<AuthMain> {

  final googleSignIn = GoogleSignIn();

  Future signInWithGoogle() async {
    final user = await googleSignIn.signIn();

    if (user == null) {
      return;
    } else {
      final auth = await user.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: auth.accessToken,
        idToken: auth.idToken,
      );
      FirebaseAuth.instance.signInWithCredential(credential).then((value) => {
        FirebaseFirestore.instance.collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
            if (documentSnapshot.exists) {
              UserData.instance.user = FirebaseAuth.instance.currentUser!.uid;
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => Nav()),
                (Route<dynamic> route) => false,
              );
            } else {
              UserData.instance.user = FirebaseAuth.instance.currentUser!.uid;
              FirebaseFirestore.instance.collection('users').doc(UserData.instance.user)
              .set({
                'user_like_count' : 0,
                'user_likes' : [],
                'user_image_name' : '3e589930-188a-11ec-921a-e1ffda1fa37d',
                'user_image_500' : 'https://firebasestorage.googleapis.com/v0/b/photo-beauty-24f63.appspot.com/o/image%2Fresize_images%2Fhead_500x500.webp?alt=media&token=3ee30bd9-3528-4c39-8d28-993fba5e9da4',
                'user_image_1080' : 'https://firebasestorage.googleapis.com/v0/b/photo-beauty-24f63.appspot.com/o/image%2Fresize_images%2Fhead_1080x1080.webp?alt=media&token=3ee30bd9-3528-4c39-8d28-993fba5e9da4',
                'user_name' : 'memorii',
                'user_text' : '作品撮りチェックしてください！',
                'user_instagram' : '',
                'user_tiktok' : '',
                'user_uid' : UserData.instance.user,
                'user_createdAt' : DateTime.now(),
              });
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => Nav()),
                (Route<dynamic> route) => false,
              );
            }
          })
        }
      );
    }
  }

  String generateNonce([int length = 32]) {
    final charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)]).join();
  }

  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future signInWithApple() async {
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );
    final oauthCredential = OAuthProvider('apple.com').credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );
    FirebaseAuth.instance.signInWithCredential(oauthCredential).then((value) => {
      FirebaseFirestore.instance.collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
          if (documentSnapshot.exists) {
            UserData.instance.user = FirebaseAuth.instance.currentUser!.uid;
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => Nav()),
              (Route<dynamic> route) => false,
            );
          } else {
            UserData.instance.user = FirebaseAuth.instance.currentUser!.uid;
            FirebaseFirestore.instance.collection('users').doc(UserData.instance.user)
              .set({
                'user_like_count' : 0,
                'user_image_name' : '3e589930-188a-11ec-921a-e1ffda1fa37d',
                'user_image_500' : 'https://firebasestorage.googleapis.com/v0/b/photo-beauty-24f63.appspot.com/o/image%2Fresize_images%2Fhead_500x500.webp?alt=media&token=3ee30bd9-3528-4c39-8d28-993fba5e9da4',
                'user_image_1080' : 'https://firebasestorage.googleapis.com/v0/b/photo-beauty-24f63.appspot.com/o/image%2Fresize_images%2Fhead_1080x1080.webp?alt=media&token=3ee30bd9-3528-4c39-8d28-993fba5e9da4',
                'user_instagram' : '',
                'user_text' : '作品撮りチェックしてください！',
                'user_likes' : [],
                'user_name' : '',
                'user_uid' : UserData.instance.user,
                'user_tiktok' : '',
                'user_createdAt' : DateTime.now(),
            });
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => Nav()),
              (Route<dynamic> route) => false,
            );
          }
        })
    });
  }

  launchInApp() async {
    var url = 'https://photo-beauty.work/terms';
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
      onGenerateRoute: (settings) {
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (context) {
            return Scaffold(
              backgroundColor: Colors.white,
              body: Stack(
                children: [
                  Container(
                    height: 100.h,
                    child: Image.asset(
                      'assets/auth.png',
                      fit: BoxFit.cover,
                    )
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 80,left: 40.w, right: 40.w,),
                    width: 20.w,
                    height: 20.w,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset(
                        'assets/splash.png',
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      width: 100.w,
                      child: Text(
                        'beauty photograph',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 25,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 75.h),
                    child: Column(
                      children: [
                        GestureDetector(
                          child: Container(
                            margin: EdgeInsets.only(left: 10.w, right: 10.w,),
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: 5, bottom: 5,),
                                  width: 10.w,
                                  height: 20,
                                  child: Image.asset(
                                    'assets/apple.png',
                                  ),
                                ),
                                Row(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(right: 10.w,),
                                      width: 60.w,
                                      child: Text(
                                        'sign in with apple',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    )
                                  ]
                                ),
                              ],
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
                                          '同意する',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                          ),
                                        ),
                                        onPressed: () async {
                                          Navigator.of(context).pop();
                                          signInWithApple();
                                        },
                                      ),
                                    ),
                                    Container(
                                      color: Colors.black87,
                                      child: CupertinoActionSheetAction(
                                        child: Text(
                                          '利用規約を見る',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                          ),
                                        ),
                                        onPressed: () async {
                                          Navigator.of(context).pop();
                                          await launchInApp();
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
                        GestureDetector(
                          child: Container(
                            margin: EdgeInsets.only(top: 10, left: 10.w, right: 10.w,),
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: 5, bottom: 5,),
                                  width: 10.w,
                                  height: 20,
                                  child: Image.asset(
                                    'assets/google.png',
                                  ),
                                ),
                                Row(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(right: 10.w,),
                                      width: 60.w,
                                      child: Text(
                                        'sign in with google',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    )
                                  ]
                                ),
                              ],
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
                                          '同意する',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                          ),
                                        ),
                                        onPressed: () async {
                                          Navigator.of(context).pop();
                                          signInWithGoogle();
                                        },
                                      ),
                                    ),
                                    Container(
                                      color: Colors.black87,
                                      child: CupertinoActionSheetAction(
                                        child: Text(
                                          '利用規約を見る',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                          ),
                                        ),
                                        onPressed: () async {
                                          Navigator.of(context).pop();
                                          await launchInApp();
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
                  ),
                ],
              ),
            );
          }
        );
      }
    );
  }
}


