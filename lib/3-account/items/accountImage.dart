import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import '../../singleton.dart';
import 'package:sizer/sizer.dart';

class AccountImage extends StatefulWidget {
  final String imageName;
  AccountImage(this.imageName);

  @override
  _AccountImageState createState() => _AccountImageState();
}

class _AccountImageState extends State<AccountImage> {

  @override
  void initState() {
    super.initState();
    if (mounted) {setState(() {});}
  }

  File? image;
  bool imageChenge = false;
  final picker = ImagePicker();

  Future<void> postImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      image = File(pickedFile.path);
      imageChenge = true;
      if (mounted) {setState(() {});}
    }
  }

  Future <void> imageUpdate() async {
    if (imageChenge == true) {
      await FirebaseStorage.instance.ref().child('profiles/${UserData.instance.user}').putFile(image!);
      await FirebaseFirestore.instance.collection("users").doc(UserData.instance.user)
      .update({
        "user_image_path" : image.toString(),
        "user_image_500" : "",
        "user_image_1080" : "",
      });
      await FirebaseFirestore.instance.collection("users").doc(UserData.instance.user).update({"user_image_name" : FieldValue.delete()});
      Navigator.pop(context);
      await FirebaseFunctions.instanceFor(app: Firebase.app(), region: 'us-central1')
      .httpsCallable('userResizeImage').call(<String, String>{'userUid': UserData.instance.user});
      if (mounted) {setState(() {});}
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                    color: Color(0xFFFF8D89),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                onTap: () {
                  imageUpdate();
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
        child: Column(
          children: [
            Container(
              width: 100.w,
            ),
            image == null ?
            Container(
              width: 100.w,
              height: 100.w,
              margin: EdgeInsets.only(top: 15, right: 10, left: 10, bottom: 0,),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5.0),
                child: Image.network(
                  widget.imageName,
                  fit: BoxFit.cover,
                ),
              ),
            )
            :
            Container(
              width: 100.w,
              height: 100.w,
              margin: EdgeInsets.only(top: 15, right: 10, left: 10, bottom: 0,),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.file(
                  image!,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            GestureDetector(
              child: Container(
                height: 40,
                width: 150,
                margin: EdgeInsets.only(top: 15,),
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
              onTap: () async {
                await postImage();
              },
            ),
          ],
        ),
      ),
    );
  }
}
