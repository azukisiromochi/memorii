import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sizer/sizer.dart';

class ContestEdit extends StatefulWidget {
  final String name;
  final String image;
  final List list;
  ContestEdit(this.name, this.image, this.list);

  @override
  _ContestEditState createState() => _ContestEditState();
}

class _ContestEditState extends State<ContestEdit> {

  String hashTag1 = "";
  String hashTag2 = "";

  bool warningOption1 = false;
  bool warningOption2 = false;

  String postImage = "";

  @override
  void initState() {
    super.initState();
    hashTag1 = widget.list[0];
    hashTag2 = widget.list[1];
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
                  await FirebaseFirestore.instance.collection("contests").doc(widget.name).update({'post_tags': [hashTag1,hashTag2,]});
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
        child: GestureDetector(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    width: 100.w,
                    height: 250,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                          widget.image,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 0, sigmaY:0),
                      child: Container(
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ),
                  ),
                  Container(
                    width: 100.w,
                    height: 250,
                    child: Image.network(
                      widget.image,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
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
                          "ハッシュタグ No.1",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      Spacer(),
                      hashTag1 == '' ?
                      Container(
                        margin: EdgeInsets.only(left: 5.w,),
                        child: Text(
                          "選択してください",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: Color(0xFFFF8D89),
                          ),
                        ),
                      ) : Container(),
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
                          color: hashTag1 == '' ? Colors.red : Colors.black87,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      GestureDetector(
                        child: Container(
                          margin: EdgeInsets.only(left: 5.w,),
                          color: Colors.white,
                          width: 70.w,
                          height: 45,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                hashTag1,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
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
                                        'メンズ',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                        ),
                                      ),
                                      onPressed: () async {
                                        hashTag1 = "メンズ";
                                        if (mounted) {setState(() {});}
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ),
                                  Container(
                                    color: Colors.black87,
                                    child: CupertinoActionSheetAction(
                                      child: Text(
                                        'レディース',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                        ),
                                      ),
                                      onPressed: () async {
                                        hashTag1 = "レディース";
                                        if (mounted) {setState(() {});}
                                        Navigator.of(context).pop();
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
                          "ハッシュタグ No.2",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      Spacer(),
                      hashTag2 == '' ?
                      Container(
                        margin: EdgeInsets.only(left: 5.w,),
                        child: Text(
                          "選択してください",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: Color(0xFFFF8D89),
                          ),
                        ),
                      ) : Container(),
                    ],
                  ),
                ),
              ),
              Container(
                width: 90.w,
                margin: EdgeInsets.only(top: 0, right: 5.w, left: 5.w,),
                child: Row(
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      margin: EdgeInsets.only(right: 5, bottom: 0, left: 5,),
                      decoration: BoxDecoration(
                        color: hashTag2 == '' ? Colors.red : Colors.black87,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    GestureDetector(
                      child: Container(
                        margin: EdgeInsets.only(left: 5.w,),
                        color: Colors.white,
                        width: 70.w,
                        height: 45,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              hashTag2,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
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
                                      "ストリート",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                      ),
                                    ),
                                    onPressed: () async {
                                      hashTag2 = "ストリート";
                                      if (mounted) {setState(() {});}
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ),
                                Container(
                                  color: Colors.black87,
                                  child: CupertinoActionSheetAction(
                                    child: Text(
                                      "クラシック",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                      ),
                                    ),
                                    onPressed: () async {
                                      hashTag2 = "クラシック";
                                      if (mounted) {setState(() {});}
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ),
                                Container(
                                  color: Colors.black87,
                                  child: CupertinoActionSheetAction(
                                    child: Text(
                                      "モード",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                      ),
                                    ),
                                    onPressed: () async {
                                      hashTag2 = "モード";
                                      if (mounted) {setState(() {});}
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ),
                                Container(
                                  color: Colors.black87,
                                  child: CupertinoActionSheetAction(
                                    child: Text(
                                      "フェミニン",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                      ),
                                    ),
                                    onPressed: () async {
                                      hashTag2 = "フェミニン";
                                      if (mounted) {setState(() {});}
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ),
                                Container(
                                  color: Colors.black87,
                                  child: CupertinoActionSheetAction(
                                    child: Text(
                                      "グランジ",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                      ),
                                    ),
                                    onPressed: () async {
                                      hashTag2 = "グランジ";
                                      if (mounted) {setState(() {});}
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ),
                                Container(
                                  color: Colors.black87,
                                  child: CupertinoActionSheetAction(
                                    child: Text(
                                      "アンニュイ",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                      ),
                                    ),
                                    onPressed: () async {
                                      hashTag2 = "アンニュイ";
                                      if (mounted) {setState(() {});}
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ),
                                Container(
                                  color: Colors.black87,
                                  child: CupertinoActionSheetAction(
                                    child: Text(
                                      "ロック",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                      ),
                                    ),
                                    onPressed: () async {
                                      hashTag2 = "ロック";
                                      if (mounted) {setState(() {});}
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ),
                                Container(
                                  color: Colors.black87,
                                  child: CupertinoActionSheetAction(
                                    child: Text(
                                      "クリエイティブ",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                      ),
                                    ),
                                    onPressed: () async {
                                      hashTag2 = "クリエイティブ";
                                      if (mounted) {setState(() {});}
                                      Navigator.of(context).pop();
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



