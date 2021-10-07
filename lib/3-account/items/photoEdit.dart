import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sizer/sizer.dart';

class PhotoEdit extends StatefulWidget {
  final String name;
  PhotoEdit(this.name);

  @override
  _PhotoEditState createState() => _PhotoEditState();
}

class _PhotoEditState extends State<PhotoEdit> {

  List documentList = [];
  String searchListOne = "";
  String searchListTwo = "";
  List referenceId = [];

  String name = "";
  String postImage = "";
  String postImageName = "";

  bool btnmenColor = false;
  bool btnladiesColor = false;
  bool btnstreetColor = false;
  bool btnclassicColor = false;
  bool btnmodeColor = false;
  bool btnfemininColor = false;
  bool btngrungeColor = false;
  bool btnannuiColor = false;
  bool btnrockColor = false;
  bool btncrieitiveColor = false;

  String message = "";

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance.collection('posts').doc(widget.name).get()
    .then((doc) {
      postImage = doc["post_image_500"];
      postImageName = doc["post_image_name"];
      searchListOne = doc["post_tags"][0];
      searchListTwo = doc["post_tags"][1];
      if (mounted) {setState(() {});}
    });
  }

  final userTitleInputController = new TextEditingController();
  final userTextInputController = new TextEditingController();

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
                '作品編集',
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
                    color: Color(0xffED7470),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                onTap: () async {
                  await FirebaseFirestore.instance.collection("posts")
                  .doc(widget.name)
                  .update({"post_tags": [searchListOne,searchListTwo],});
                  Navigator.pop(context);
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
        child: Container(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 30, right: 23.w, bottom: 0, left: 23.w,),
                height: 150,
                width: double.infinity,
                child: postImage == "" ? null : Image.network(
                  postImage,
                  fit: BoxFit.contain,
                  ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black12,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20, right: 23.w, bottom: 0, left: 23.w,),
                width: double.infinity,
                height: 40,
                child: ElevatedButton(
                  child: Text(
                    searchListOne,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xffED7470),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: () async {
                    await showModalBottomSheet<void>(
                      context: context,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                      ), 
                      builder: (context) {
                        return StatefulBuilder(
                          builder: (BuildContext context, StateSetter setState) {
                            return BottomSheet(
                              onClosing: () {},
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                  BorderRadius.vertical(top: Radius.circular(20)),
                              ),
                              builder: (context) {
                                return Container(
                                  height:240,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(top: 20, bottom: 0,),
                                        child: Text(
                                          "ジャンル選択 No.1",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(top: 20,),
                                            width: 29.w,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(color: Colors.black12),
                                              borderRadius: BorderRadius.circular(5),
                                            ),
                                            child: TextButton(
                                              child: Text(
                                                "メンズ",
                                                style: TextStyle(
                                                  color: btnmenColor ? Color(0xffED7470) : Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 8.sp,
                                                ),
                                              ),
                                              style: TextButton.styleFrom(
                                                primary: Colors.white,
                                              ),
                                              onPressed: () {
                                                if (mounted) {setState(() {
                                                  searchListOne = "メンズ";
                                                  btnmenColor = true;
                                                  btnladiesColor = false;
                                                });}
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(top: 20,),
                                            width: 29.w,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(color: Colors.black12),
                                              borderRadius: BorderRadius.circular(5),
                                            ),
                                            child: TextButton(
                                              child: Text(
                                                "レディース",
                                                style: TextStyle(
                                                  color: btnladiesColor ? Color(0xffED7470) : Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 8.sp,
                                                ),
                                              ),
                                              style: TextButton.styleFrom(
                                                primary: Colors.white,
                                              ),
                                              onPressed: () {
                                                if (mounted) {setState(() {
                                                  searchListOne = "レディース";
                                                  btnmenColor = false;
                                                  btnladiesColor = true;
                                                });}
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(top: 10,),
                                            width: 29.w,
                                            height: 50,
                                          ),
                                        ],
                                      ),                   
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    );
                    if (mounted) {setState(() {});}
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20, right: 23.w, bottom: 0, left: 23.w,),
                width: double.infinity,
                height: 40,
                child: ElevatedButton(
                  child: Text(
                    searchListTwo,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xffED7470),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: () async {
                    await showModalBottomSheet<void>(
                      context: context,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      builder: (context) {
                        return StatefulBuilder(
                          builder: (BuildContext context, StateSetter setState) {
                            return BottomSheet(
                              onClosing: () {},
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                  BorderRadius.vertical(top: Radius.circular(20)),
                              ),
                              builder: (context) {
                                return Container(
                                  height: 380,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(top: 20, bottom: 0,),
                                        child: Text(
                                          "ジャンル選択 No.2",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(top: 20,),
                                              width: 29.w,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border.all(color: Colors.black12),
                                                borderRadius: BorderRadius.circular(5),
                                              ),
                                              child: TextButton(
                                                child: Text(
                                                  "ストリート",
                                                  style: TextStyle(
                                                    color: btnstreetColor ? Color(0xffED7470) : Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 8.sp,
                                                  ),
                                                ),
                                              style: TextButton.styleFrom(
                                                primary: Colors.white,
                                              ),
                                              onPressed: () {
                                                if (mounted) {setState(() {
                                                  searchListTwo = "ストリート";
                                                  btnstreetColor = true;
                                                  btnclassicColor = false;
                                                  btnmodeColor = false;
                                                  btnfemininColor = false;
                                                  btngrungeColor = false;
                                                  btnannuiColor = false;
                                                  btnrockColor = false;
                                                  btncrieitiveColor = false;
                                                });}
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(top: 20,),
                                            width: 29.w,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(color: Colors.black12),
                                              borderRadius: BorderRadius.circular(5),
                                            ),
                                            child: TextButton(
                                              child: Text(
                                                "クラシック",
                                                style: TextStyle(
                                                  color: btnclassicColor ? Color(0xffED7470) : Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 8.sp,
                                                ),
                                              ),
                                              style: TextButton.styleFrom(
                                                primary: Colors.white,
                                              ),
                                              onPressed: () {
                                                if (mounted) {setState(() {
                                                  searchListTwo = "クラシック";
                                                  btnstreetColor = false;
                                                  btnclassicColor = true;
                                                  btnmodeColor = false;
                                                  btnfemininColor = false;
                                                  btngrungeColor = false;
                                                  btnannuiColor = false;
                                                  btnrockColor = false;
                                                  btncrieitiveColor = false;
                                                });}
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(top: 20,),
                                            width: 29.w,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(color: Colors.black12),
                                              borderRadius: BorderRadius.circular(5),
                                            ),
                                            child: TextButton(
                                              child: Text(
                                                "モード",
                                                style: TextStyle(
                                                  color: btnmodeColor ? Color(0xffED7470) : Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 8.sp,
                                                ),
                                              ),
                                              style: TextButton.styleFrom(
                                                primary: Colors.white,
                                              ),
                                              onPressed: () {
                                                if (mounted) {setState(() {
                                                  searchListTwo = "モード";
                                                  btnstreetColor = false;
                                                  btnclassicColor = false;
                                                  btnmodeColor = true;
                                                  btnfemininColor = false;
                                                  btngrungeColor = false;
                                                  btnannuiColor = false;
                                                  btnrockColor = false;
                                                  btncrieitiveColor = false;
                                                });}
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(top: 20,),
                                            width: 29.w,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(color: Colors.black12),
                                              borderRadius: BorderRadius.circular(5),
                                            ),
                                            child: TextButton(
                                              child: Text(
                                                "フェミニン",
                                                style: TextStyle(
                                                  color: btnfemininColor ? Color(0xffED7470) : Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 8.sp,
                                                ),
                                              ),
                                              style: TextButton.styleFrom(
                                                primary: Colors.white,
                                              ),
                                              onPressed: () {
                                                if (mounted) {setState(() {
                                                  searchListTwo = "フェミニン";
                                                  btnstreetColor = false;
                                                  btnclassicColor = false;
                                                  btnmodeColor = false;
                                                  btnfemininColor = true;
                                                  btngrungeColor = false;
                                                  btnannuiColor = false;
                                                  btnrockColor = false;
                                                  btncrieitiveColor = false;
                                                });}
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(top: 20,),
                                            width: 29.w,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(color: Colors.black12),
                                              borderRadius: BorderRadius.circular(5),
                                            ),
                                            child: TextButton(
                                              child: Text(
                                                "グランジ",
                                                style: TextStyle(
                                                  color: btngrungeColor ? Color(0xffED7470) : Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 8.sp,
                                                ),
                                              ),
                                              style: TextButton.styleFrom(
                                                primary: Colors.white,
                                              ),
                                              onPressed: () {
                                                if (mounted) {setState(() {
                                                  searchListTwo = "グランジ";
                                                  btnstreetColor = false;
                                                  btnclassicColor = false;
                                                  btnmodeColor = false;
                                                  btnfemininColor = false;
                                                  btngrungeColor = true;
                                                  btnannuiColor = false;
                                                  btnrockColor = false;
                                                  btncrieitiveColor = false;
                                                });}
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(top: 20,),
                                            width: 29.w,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(color: Colors.black12),
                                              borderRadius: BorderRadius.circular(5),
                                            ),
                                            child: TextButton(
                                              child: Text(
                                                "アンニュイ",
                                                style: TextStyle(
                                                  color: btnannuiColor ? Color(0xffED7470) : Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 8.sp,
                                                ),
                                              ),
                                              style: TextButton.styleFrom(
                                                primary: Colors.white,
                                              ),
                                              onPressed: () {
                                                if (mounted) {setState(() {
                                                  searchListTwo = "アンニュイ";
                                                  btnstreetColor = false;
                                                  btnclassicColor = false;
                                                  btnmodeColor = false;
                                                  btnfemininColor = false;
                                                  btngrungeColor = false;
                                                  btnannuiColor = true;
                                                  btnrockColor = false;
                                                  btncrieitiveColor = false;
                                                });}
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(top: 20,),
                                            width: 29.w,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(color: Colors.black12),
                                              borderRadius: BorderRadius.circular(5),
                                            ),
                                            child: TextButton(
                                              child: Text(
                                                "ロック",
                                                style: TextStyle(
                                                  color: btnrockColor ? Color(0xffED7470) : Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 8.sp,
                                                ),
                                              ),
                                              style: TextButton.styleFrom(
                                                primary: Colors.white,
                                              ),
                                              onPressed: () {
                                                if (mounted) {setState(() {
                                                  searchListTwo = "ロック";
                                                  btnstreetColor = false;
                                                  btnclassicColor = false;
                                                  btnmodeColor = false;
                                                  btnfemininColor = false;
                                                  btngrungeColor = false;
                                                  btnannuiColor = false;
                                                  btnrockColor = true;
                                                  btncrieitiveColor = false;
                                                });}
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(top: 20,),
                                            width: 29.w,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(color: Colors.black12),
                                              borderRadius: BorderRadius.circular(5),
                                            ),
                                            child: TextButton(
                                              child: Text(
                                                "クリエイティブ",
                                                style: TextStyle(
                                                  color: btncrieitiveColor ? Color(0xffED7470) : Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 8.sp,
                                                ),
                                              ),
                                              style: TextButton.styleFrom(
                                                primary: Colors.white,
                                              ),
                                              onPressed: () {
                                                if (mounted) {setState(() {
                                                  searchListTwo = "クリエイティブ";
                                                  btnstreetColor = true;
                                                  btnclassicColor = false;
                                                  btnmodeColor = false;
                                                  btnfemininColor = false;
                                                  btngrungeColor = false;
                                                  btnannuiColor = false;
                                                  btnrockColor = false;
                                                  btncrieitiveColor = false;
                                                });}
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(top: 10,),
                                            width: 29.w,
                                            height: 50,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    );
                    if (mounted) {setState(() {});}
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20, right: 23.w, bottom: 50, left: 23.w,),
                width: double.infinity,
                height: 40,
                child: ElevatedButton(
                  child: Text(
                    '削除',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xffED7470),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: () async {
                    Navigator.pop(context);
                    await FirebaseStorage.instance.ref("image/resize_images").child('${postImageName}_500x500').delete();
                    await FirebaseStorage.instance.ref("image/resize_images").child('${postImageName}_1080x1080').delete();
                    await FirebaseFirestore.instance.collection("posts").doc(widget.name).delete();
                    await FirebaseFirestore.instance.collection('users').where('user_likes', arrayContains: widget.name).get()
                    .then((QuerySnapshot querySnapshot) {
                      querySnapshot.docs.forEach((doc) {
                        print(doc.id);
                        FirebaseFirestore.instance.collection('users')
                          .doc(doc.id)
                          .update({
                            'user_likes': FieldValue.arrayRemove([widget.name,])
                          });
                      });
                    });
                    if (mounted) {setState(() {});}
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



