import 'dart:async';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../../singleton.dart';
import 'package:sizer/sizer.dart';

class Tweet extends StatefulWidget {

  @override
  _TweetState createState() => _TweetState();
}

class _TweetState extends State<Tweet> {

  final userText = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (mounted) {setState(() {});}
  }

  Future <void> textUpdate() async {
    await FirebaseFirestore.instance.collection('tweets').doc()
    .set({
      'tweet_name': UserData.instance.account[0]["user_name"],
      'tweet_instagram': UserData.instance.account[0]["user_instagram"],
      'tweet_tiktok': UserData.instance.account[0]["user_tiktok"],
      'tweet_image_500': UserData.instance.account[0]["user_image_500"],
      'tweet_image_1080': UserData.instance.account[0]["user_image_1080"],
      'tweet_photo_500': '',
      'tweet_photo_1080': '',
      'tweet_text': userText.text,
      'tweet_photo': '',
      'tweet_uid': UserData.instance.user,
    });
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
                    color: Colors.black87,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                "作品投稿",
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 15
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                child: Container(
                  margin: EdgeInsets.only(right: 10,),
                  child: Text(
                    "投稿",
                    style: TextStyle(
                      color: Color(0xFFFF8D89),
                      fontWeight: FontWeight.bold,
                      fontSize: 15
                    ),
                  ),
                ),
                onTap: () {
                  if (userText.text != ''){
                    textUpdate();
                    Navigator.pop(context);
                  }
                },
              )
            ),
          ],
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
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
                          width: 80,
                          margin: EdgeInsets.only(right: 15,),
                        ),
                      ]
                    ),
                    Column(
                      children: [
                        Container(
                          width: 70.w,
                          child: Text(
                            UserData.instance.account[0]["user_name"],
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        Container(
                          width: 70.w,
                          child: TextFormField(
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            minLines: 1,
                            autovalidateMode: AutovalidateMode.always,
                            controller: userText,
                            decoration: InputDecoration(
                              hintText: '宣伝したいことありますか？',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  height: 60,
                  width: 60,
                  margin: EdgeInsets.only(left: 20,),
                  child: CircleAvatar(
                    radius: 100,
                    backgroundImage: NetworkImage(
                      UserData.instance.account[0]["user_image_500"],
                    ),
                  ),
                ),
              ],
            ),
          ]
        ),
      ),
    );
  }
}