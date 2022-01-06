import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../../singleton.dart';
import 'package:sizer/sizer.dart';

class AccountEdit extends StatefulWidget {
  @override
  _AccountEditState createState() => _AccountEditState();
}

class _AccountEditState extends State<AccountEdit> {

  final userName = TextEditingController();
  final userText = TextEditingController();
  final userInstagram = TextEditingController();
  final userTiktok = TextEditingController();
  final userYoutube = TextEditingController();

  List referenceId1 = [];
  List referenceId2 = [];
  int userNameLenth = 0;
  int userTextLenth = 0;

  String imageName1080 = '';
  String imageName500 = '';
  File? image;
  bool imageChenge = false;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    userName.text = UserData.instance.account[0]['user_name'];
    userNameLenth = UserData.instance.account[0]['user_name'].length;
    userText.text = UserData.instance.account[0]['user_text'];
    userTextLenth = UserData.instance.account[0]['user_text'].length;
    userInstagram.text = UserData.instance.account[0]['user_instagram'];
    userTiktok.text = UserData.instance.account[0]['user_tiktok'];
    userYoutube.text = UserData.instance.account[0]['user_youtube'];
    if (mounted) {setState(() {});}
    imageName1080 = 'https://firebasestorage.googleapis.com/v0/b/photo-beauty-24f63.appspot.com/o/profiles%2Fresize_images%2F' + UserData.instance.user + '_1080x1080?alt=media&token';
    imageName500 = 'https://firebasestorage.googleapis.com/v0/b/photo-beauty-24f63.appspot.com/o/profiles%2Fresize_images%2F' + UserData.instance.user + '_500x500?alt=media&token';
    if (mounted) {setState(() {});}
  }
  Future<void> getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      image = File(pickedFile.path);
      imageChenge = true;
      if (mounted) {setState(() {});}
    }
  }
  Future <void> update() async {
    await FirebaseFirestore.instance.collection('users').doc(UserData.instance.user)
    .update({
      'user_name': userName.text,
      'user_text': userText.text,
      'user_instagram': userInstagram.text.replaceFirst('@', ''),
      'user_tiktok': userTiktok.text.replaceFirst('@', ''),
      'user_youtube': userYoutube.text.replaceFirst('@', ''),
    });
    Navigator.pop(context);
    if (imageChenge == true) {
      await FirebaseStorage.instance.ref().child('profiles/${UserData.instance.user}').putFile(image!);
      await FirebaseFirestore.instance.collection("users").doc(UserData.instance.user)
      .update({
        "user_image_name": UserData.instance.user,
        "user_image_500" : imageName500,
        "user_image_1080" : imageName1080,
      });
    }
    if (UserData.instance.account[0]['user_instagram'] != userInstagram.text) {
      await FirebaseFirestore.instance.collection('posts').where('post_uid', isEqualTo: UserData.instance.user).get()
      .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) async{
          await FirebaseFirestore.instance.collection("posts").doc(doc.id).update({"post_instagram": userInstagram.text});
        });
      });
    }
    if (UserData.instance.account[0]['user_name'] != userName.text) {
      await FirebaseFirestore.instance.collection('posts').where('post_uid', isEqualTo: UserData.instance.user).get()
      .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) async{
          await FirebaseFirestore.instance.collection("posts").doc(doc.id).update({"post_name": userName.text});
        });
      });
    }
  }
  onUserName(String value) {
    userNameLenth = value.length;
    if (mounted) {setState(() {});}
  }
  onUserText(String value) {
    userTextLenth = value.length;
    if (mounted) {setState(() {});}
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
                padding: EdgeInsets.all(8.0),
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
                "アカウント編集",
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                child: Text(
                  "完了",
                  style: TextStyle(
                    color: userNameLenth == 0 || userTextLenth == 0 ? Colors.black12 : Color(0xFFFF8D89),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                onTap: () {
                  if (userNameLenth != 0 && userTextLenth != 0) {
                    update();
                  }
                },
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: GestureDetector(
          child: Column(
            children: [
              image == null ?
              Container(
                height: 26.w,
                width: 26.w,
                margin: EdgeInsets.only(top: 20, right: 37.w, left: 37.w),
                child: CircleAvatar(
                  radius: 100,
                  backgroundColor: Colors.white,
                  backgroundImage: NetworkImage(
                    UserData.instance.account[0]["user_image_500"],
                  ),
                ),
              )
              :
              Container(
                height: 26.w,
                width: 26.w,
                margin: EdgeInsets.only(top: 20, right: 37.w, left: 37.w),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30.w),
                  child: Image.file(
                    image!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              GestureDetector(
                child: Container(
                  width: 25.w,
                  height: 30,
                  margin: EdgeInsets.only(top: 15, right: 37.5.w, left: 37.5.w, bottom: 0,),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: Text(
                      "画像選択",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ), 
                onTap: () {
                  getImage();
                },
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                child: Container(
                  width: 90.w,
                  margin: EdgeInsets.only(right: 5.w, left: 5.w,),
                  color: Colors.white,
                  child: Row(
                    children: [
                      Container(
                        width: 30,
                        margin: EdgeInsets.only(right: 5, left: 5,),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 5.w,),
                        child: Text(
                          "ユーザーネーム",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      Spacer(),
                      userNameLenth == 0 ?
                      Container(
                        margin: EdgeInsets.only(left: 5.w,),
                        child: Text(
                          "入力してください",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: Color(0xFFFF8D89),
                          ),
                        ),
                      )
                      :
                      Container(
                        margin: EdgeInsets.only(left: 5.w,),
                        child: Text(
                          "$userNameLenth/20",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                            color: userNameLenth == 20 ?  Colors.red : Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                child: Container(
                  width: 90.w,
                  margin: EdgeInsets.only(top: 0, right: 5.w, left: 5.w,),
                  child: Row(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        margin: EdgeInsets.only(right: 5, bottom: 0, left: 5,),
                        decoration: BoxDecoration(
                          color: userNameLenth == 0 ? Colors.red : Colors.black87,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 5.w,),
                        width: 70.w,
                        child: TextFormField(
                          keyboardType: TextInputType.multiline,
                          maxLines: 1,
                          minLines: 1,
                          controller: userName,
                          maxLength: 20,
                          onChanged: onUserName,
                          autovalidateMode: AutovalidateMode.always,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            counterText: '',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: 90.w,
                height: 1,
                margin: EdgeInsets.only(top: 0, right: 5.w, left: 5.w, bottom: 20,),
                color: Colors.black12,
              ),
              Container(
                child: Container(
                  width: 90.w,
                  margin: EdgeInsets.only(right: 5.w, left: 5.w,),
                  color: Colors.white,
                  child: Row(
                    children: [
                      Container(
                        width: 30,
                        margin: EdgeInsets.only(right: 5, left: 5,),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 5.w,),
                        child: Text(
                          "一言",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      Spacer(),
                      userTextLenth == 0 ?
                      Container(
                        margin: EdgeInsets.only(left: 5.w,),
                        child: Text(
                          "入力してください",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: Color(0xFFFF8D89),
                          ),
                        ),
                      )
                      :
                      Container(
                        margin: EdgeInsets.only(left: 5.w,),
                        child: Text(
                          "$userTextLenth/30",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                            color: userTextLenth == 30 ?  Colors.red : Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                child: Container(
                  width: 90.w,
                  margin: EdgeInsets.only(top: 0, right: 5.w, left: 5.w,),
                  child: Row(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        margin: EdgeInsets.only(right: 5, bottom: 0, left: 5,),
                        decoration: BoxDecoration(
                          color: userTextLenth == 0 ? Colors.red : Colors.black87,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 5.w,),
                        width: 70.w,
                        child: TextFormField(
                          keyboardType: TextInputType.multiline,
                          maxLines: 1,
                          minLines: 1,
                          autovalidateMode: AutovalidateMode.always,
                          controller: userText,
                          maxLength: 30,
                          onChanged: onUserText,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            counterText: '',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: 90.w,
                height: 1,
                margin: EdgeInsets.only(top: 0, right: 5.w, left: 5.w, bottom: 20,),
                color: Colors.black12,
              ),
              Container(
                child: Container(
                  width: 90.w,
                  margin: EdgeInsets.only(right: 5.w, left: 5.w,),
                  color: Colors.white,
                  child: Row(
                    children: [
                      Container(
                        width: 30,
                        margin: EdgeInsets.only(right: 5, left: 5,),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 5.w,),
                        child: Text(
                          "インスタグラム",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                child: Container(
                  width: 90.w,
                  margin: EdgeInsets.only(top: 0, right: 5.w, left: 5.w,),
                  child: Row(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        margin: EdgeInsets.only(right: 5, bottom: 0, left: 5,),
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 5.w,),
                        width: 70.w,
                        child: TextFormField(
                          keyboardType: TextInputType.multiline,
                          maxLines: 1,
                          minLines: 1,
                          autovalidateMode: AutovalidateMode.always,
                          controller: userInstagram,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: 90.w,
                height: 1,
                margin: EdgeInsets.only(top: 0, right: 5.w, left: 5.w, bottom: 20,),
                color: Colors.black12,
              ),
              Container(
                child: Container(
                  width: 90.w,
                  margin: EdgeInsets.only(right: 5.w, left: 5.w,),
                  color: Colors.white,
                  child: Row(
                    children: [
                      Container(
                        width: 30,
                        margin: EdgeInsets.only(right: 5, left: 5,),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 5.w,),
                        child: Text(
                          "ティックトック",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                child: Container(
                  width: 90.w,
                  margin: EdgeInsets.only(top: 0, right: 5.w, left: 5.w,),
                  child: Row(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        margin: EdgeInsets.only(right: 5, bottom: 0, left: 5,),
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 5.w,),
                        width: 70.w,
                        child: TextFormField(
                          keyboardType: TextInputType.multiline,
                          maxLines: 1,
                          minLines: 1,
                          autovalidateMode: AutovalidateMode.always,
                          controller: userTiktok,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: 90.w,
                height: 1,
                margin: EdgeInsets.only(top: 0, right: 5.w, left: 5.w, bottom: 20,),
                color: Colors.black12,
              ),
              Container(
                child: Container(
                  width: 90.w,
                  margin: EdgeInsets.only(right: 5.w, left: 5.w,),
                  color: Colors.white,
                  child: Row(
                    children: [
                      Container(
                        width: 30,
                        margin: EdgeInsets.only(right: 5, left: 5,),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 5.w,),
                        child: Text(
                          "ユーチューブ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                child: Container(
                  width: 90.w,
                  margin: EdgeInsets.only(top: 0, right: 5.w, left: 5.w,),
                  child: Row(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        margin: EdgeInsets.only(right: 5, bottom: 0, left: 5,),
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 5.w,),
                        width: 70.w,
                        child: TextFormField(
                          keyboardType: TextInputType.multiline,
                          maxLines: 1,
                          minLines: 1,
                          autovalidateMode: AutovalidateMode.always,
                          controller: userYoutube,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: 90.w,
                height: 1,
                margin: EdgeInsets.only(top: 0, right: 5.w, left: 5.w, bottom: 20,),
                color: Colors.black12,
              ),
            ],
          ),
          onTap: () {
            FocusScope.of(context).unfocus();
          },
        ),
      ),
    );
  }
}
