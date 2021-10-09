import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import '../../singleton.dart';
import 'package:sizer/sizer.dart';

class AccountEdit extends StatefulWidget {
  const AccountEdit();
  @override
  _AccountEditState createState() => _AccountEditState();
}

class _AccountEditState extends State<AccountEdit> {

  final userName = TextEditingController();
  final userText = TextEditingController();
  final userInstagram = TextEditingController();
  final userTiktok = TextEditingController();

  bool warningName = false;
  bool warningText = false;

  bool messageTextNon = false;
  bool messageTextOver = false;

  List referenceId = [];

  @override
  void initState() {
    super.initState();
    userName.text = UserData.instance.account[0]['user_name'];
    userText.text = UserData.instance.account[0]['user_text'];
    userInstagram.text = UserData.instance.account[0]['user_instagram'];
    userTiktok.text = UserData.instance.account[0]['user_tiktok'];
    if (mounted) {setState(() {});}
  }

  var batch = FirebaseFirestore.instance.batch();

  Future <void> textUpdate() async {
    await FirebaseFirestore.instance.collection('users').doc(UserData.instance.user)
    .update({
      'user_name': userName.text,
      'user_text': userText.text,
      'user_instagram': userInstagram.text.replaceFirst('@', ''),
      'user_tiktok': userTiktok.text.replaceFirst('@', ''),
    });

    if (UserData.instance.account[0]['user_name'] == userInstagram.text) {
      await FirebaseFirestore.instance.collection('posts').where('post_uid', isEqualTo: UserData.instance.user).get()
      .then((doc) {
        referenceId = doc.docs.map((e) => e.reference).toList();
      });
      for (var sfRef in referenceId) {
        batch.update(sfRef, {"post_instagram": userInstagram.text});
      }
      batch.commit();
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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
                      color: Color(0xFFFF8D89),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  onTap: () {
                    warningName = false;
                    warningText = false;
                    messageTextNon = false;
                    messageTextOver = false;
                    if (userName.text == '') {
                      warningName = true;
                    } else if (userText.text == '') {
                      warningText = true;
                      messageTextNon = true;
                    } else if (userText.text.length > 20) {
                      warningText = true;
                      messageTextOver = true;
                    } else {
                      textUpdate();
                    }
                    if (mounted) {setState(() {});}
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
                      warningName ?
                      Container(
                        margin: EdgeInsets.only(left: 5.w,),
                        child: Text(
                          "ユーザーネームを入力してください",
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
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Icon(
                          Icons.play_arrow,
                          color: warningName ? Colors.red : Colors.white,
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
                          autovalidateMode: AutovalidateMode.always,
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
                          "一言",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      Spacer(),
                      messageTextNon ?
                      Container(
                        margin: EdgeInsets.only(left: 5.w,),
                        child: Text(
                          "一言を入力してください",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: Color(0xFFFF8D89),
                          ),
                        ),
                      ) : Container(),
                      messageTextOver ?
                      Container(
                        margin: EdgeInsets.only(left: 5.w,),
                        child: Text(
                          "20文字以内にしてください",
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
                          color: warningText ? Colors.red : Colors.black87,
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
              
              // Container(
              //   child: Container(
              //     width: 90.w,
              //     margin: EdgeInsets.only(right: 5.w, left: 5.w,),
              //     color: Colors.white,
              //     child: Row(
              //       children: [
              //         Container(
              //           width: 30,
              //           margin: EdgeInsets.only(right: 5, left: 5,),
              //         ),
              //         Container(
              //           margin: EdgeInsets.only(left: 5.w,),
              //           child: Text(
              //             "ユーチューブ",
              //             style: TextStyle(
              //               fontWeight: FontWeight.bold,
              //               fontSize: 13,
              //             ),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              // Container(
              //   child: Container(
              //     width: 90.w,
              //     margin: EdgeInsets.only(top: 0, right: 5.w, left: 5.w,),
              //     child: Row(
              //       children: [
              //         Container(
              //           width: 30,
              //           height: 30,
              //           margin: EdgeInsets.only(right: 5, bottom: 0, left: 5,),
              //           decoration: BoxDecoration(
              //             color: Colors.black87,
              //             borderRadius: BorderRadius.circular(5),
              //           ),
              //           child: Icon(
              //             Icons.play_arrow,
              //             color: Colors.white,
              //             size: 20,
              //           ),
              //         ),
              //         Container(
              //           margin: EdgeInsets.only(left: 5.w,),
              //           width: 70.w,
              //           child: TextFormField(
              //             keyboardType: TextInputType.multiline,
              //             maxLines: 1,
              //             minLines: 1,
              //             autovalidateMode: AutovalidateMode.always,
              //             controller: userYoutube,
              //             decoration: InputDecoration(
              //               border: InputBorder.none,
              //             ),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              // Container(
              //   width: 90.w,
              //   height: 1,
              //   margin: EdgeInsets.only(top: 0, right: 5.w, left: 5.w, bottom: 20,),
              //   color: Colors.black12,
              // ),
              // Container(
              //   child: Container(
              //     width: 90.w,
              //     margin: EdgeInsets.only(right: 5.w, left: 5.w,),
              //     color: Colors.white,
              //     child: Row(
              //       children: [
              //         Container(
              //           width: 30,
              //           margin: EdgeInsets.only(right: 5, left: 5,),
              //         ),
              //         Container(
              //           margin: EdgeInsets.only(left: 5.w,),
              //           child: Text(
              //             "自己紹介",
              //             style: TextStyle(
              //               fontWeight: FontWeight.bold,
              //               fontSize: 13,
              //             ),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              // Container(
              //   child: Container(
              //     width: 90.w,
              //     margin: EdgeInsets.only(top: 0, right: 5.w, left: 5.w,),
              //     child: Row(
              //       children: [
              //         Container(
              //           width: 30,
              //           height: 30,
              //           margin: EdgeInsets.only(right: 5, bottom: 0, left: 5,),
              //           decoration: BoxDecoration(
              //             color: Colors.black87,
              //             borderRadius: BorderRadius.circular(5),
              //           ),
              //           child: Icon(
              //             Icons.play_arrow,
              //             color: Colors.white,
              //             size: 20,
              //           ),
              //         ),
              //         Container(
              //           margin: EdgeInsets.only(left: 5.w,),
              //           width: 70.w,
              //           child: TextFormField(
              //             keyboardType: TextInputType.multiline,
              //             maxLines: 3,
              //             minLines: 1,
              //             autovalidateMode: AutovalidateMode.always,
              //             controller: userText,
              //             decoration: InputDecoration(
              //               border: InputBorder.none,
              //             ),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              // Container(
              //   width: 90.w,
              //   height: 1,
              //   margin: EdgeInsets.only(top: 0, right: 5.w, left: 5.w, bottom: 20,),
              //   color: Colors.black12,
              // ),
              // Container(
              //   child: Container(
              //     width: 90.w,
              //     margin: EdgeInsets.only(right: 5.w, left: 5.w,),
              //     color: Colors.white,
              //     child: Row(
              //       children: [
              //         Container(
              //           width: 30,
              //           margin: EdgeInsets.only(right: 5, left: 5,),
              //         ),
              //         Container(
              //           margin: EdgeInsets.only(left: 5.w,),
              //           child: Text(
              //             "好みのジャンル No.1",
              //             style: TextStyle(
              //               fontWeight: FontWeight.bold,
              //               fontSize: 13,
              //             ),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              // Container(
              //   child: Container(
              //     width: 90.w,
              //     margin: EdgeInsets.only(top: 0, right: 5.w, left: 5.w,),
              //     child: Row(
              //       children: [
              //         Container(
              //           width: 30,
              //           height: 30,
              //           margin: EdgeInsets.only(right: 5, bottom: 0, left: 5,),
              //           decoration: BoxDecoration(
              //             color: Colors.black87,
              //             borderRadius: BorderRadius.circular(5),
              //           ),
              //           child: Icon(
              //             Icons.play_arrow,
              //             color: Colors.white,
              //             size: 20,
              //           ),
              //         ),
              //         GestureDetector(
              //           child: Container(
              //             margin: EdgeInsets.only(left: 5.w,),
              //             width: 70.w,
              //             height: 50,
              //             color: Colors.white,
              //             child: Row(
              //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //               children: [
              //                 Text(
              //                   likeStyleOne,
              //                 ),
              //                 Container()
              //               ],
              //             )
              //           ),
              //           onTap: () async {
              //             await showCupertinoModalPopup(
              //               context: context,
              //               builder: (BuildContext context) {
              //                 return CupertinoActionSheet(
              //                   actions: [
              //                     Container(
              //                       color: Colors.black87,
              //                       child: CupertinoActionSheetAction(
              //                         child: Text(
              //                           'メンズ',
              //                           style: TextStyle(
              //                             color: Colors.white,
              //                             fontSize: 15,
              //                           ),
              //                         ),
              //                         onPressed: () async {
              //                           HapticFeedback.heavyImpact();
              //                           likeStyleOne = "メンズ";
              //                           if (mounted) {setState(() {});}
              //                           Navigator.of(context).pop();
              //                         },
              //                       ),
              //                     ),
              //                     Container(
              //                       color: Colors.black87,
              //                       child: CupertinoActionSheetAction(
              //                         child: Text(
              //                           'レディース',
              //                           style: TextStyle(
              //                             color: Colors.white,
              //                             fontSize: 15,
              //                           ),
              //                         ),
              //                         onPressed: () async {
              //                           HapticFeedback.heavyImpact();
              //                           likeStyleOne = "レディース";
              //                           if (mounted) {setState(() {});}
              //                           Navigator.of(context).pop();
              //                         },
              //                       ),
              //                     ),
              //                   ],
              //                   cancelButton: CupertinoButton(
              //                     color: Colors.black87,
              //                     child: Text(
              //                       'キャンセル',
              //                       style: TextStyle(
              //                         color: Colors.white,
              //                         fontSize: 15,
              //                       ),
              //                     ),
              //                     onPressed: () {
              //                       Navigator.of(context).pop();
              //                     }
              //                   ),
              //                 );
              //               },
              //             );
              //           },
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              // Container(
              //   width: 90.w,
              //   height: 1,
              //   margin: EdgeInsets.only(top: 0, right: 5.w, left: 5.w, bottom: 20,),
              //   color: Colors.black12,
              // ),
              // Container(
              //   child: Container(
              //     width: 90.w,
              //     margin: EdgeInsets.only(right: 5.w, left: 5.w,),
              //     color: Colors.white,
              //     child: Row(
              //       children: [
              //         Container(
              //           width: 30,
              //           margin: EdgeInsets.only(right: 5, left: 5,),
              //         ),
              //         Container(
              //           margin: EdgeInsets.only(left: 5.w,),
              //           child: Text(
              //             "好みのジャンル No.2",
              //             style: TextStyle(
              //               fontWeight: FontWeight.bold,
              //               fontSize: 13,
              //             ),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              // Container(
              //   child: Container(
              //     width: 90.w,
              //     margin: EdgeInsets.only(top: 0, right: 5.w, left: 5.w,),
              //     child: Row(
              //       children: [
              //         Container(
              //           width: 30,
              //           height: 30,
              //           margin: EdgeInsets.only(right: 5, bottom: 0, left: 5,),
              //           decoration: BoxDecoration(
              //             color: Colors.black87,
              //             borderRadius: BorderRadius.circular(5),
              //           ),
              //           child: Icon(
              //             Icons.play_arrow,
              //             color: Colors.white,
              //             size: 20,
              //           ),
              //         ),
              //         GestureDetector(
              //           child: Container(
              //             margin: EdgeInsets.only(left: 5.w,),
              //             width: 70.w,
              //             height: 50,
              //             color: Colors.white,
              //             child: Row(
              //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //               children: [
              //                 Text(
              //                   likeStyleTwo,
              //                 ),
              //                 Container()
              //               ],
              //             )
              //           ),
              //           onTap: () async {
              //             await showCupertinoModalPopup(
              //               context: context,
              //               builder: (BuildContext context) {
              //                 return CupertinoActionSheet(
              //                   actions: [
              //                     Container(
              //                       color: Colors.black87,
              //                       child: CupertinoActionSheetAction(
              //                         child: Text(
              //                           "ストリート",
              //                           style: TextStyle(
              //                             color: Colors.white,
              //                             fontSize: 15,
              //                           ),
              //                         ),
              //                         onPressed: () async {
              //                           HapticFeedback.heavyImpact();
              //                           likeStyleTwo = "ストリート";
              //                           if (mounted) {setState(() {});}
              //                           Navigator.of(context).pop();
              //                         },
              //                       ),
              //                     ),
              //                     Container(
              //                       color: Colors.black87,
              //                       child: CupertinoActionSheetAction(
              //                         child: Text(
              //                           "クラシック",
              //                           style: TextStyle(
              //                             color: Colors.white,
              //                             fontSize: 15,
              //                           ),
              //                         ),
              //                         onPressed: () async {
              //                           HapticFeedback.heavyImpact();
              //                           likeStyleTwo = "クラシック";
              //                           if (mounted) {setState(() {});}
              //                           Navigator.of(context).pop();
              //                         },
              //                       ),
              //                     ),
              //                     Container(
              //                       color: Colors.black87,
              //                       child: CupertinoActionSheetAction(
              //                         child: Text(
              //                           "モード",
              //                           style: TextStyle(
              //                             color: Colors.white,
              //                             fontSize: 15,
              //                           ),
              //                         ),
              //                         onPressed: () async {
              //                           HapticFeedback.heavyImpact();
              //                           likeStyleTwo = "モード";
              //                           if (mounted) {setState(() {});}
              //                           Navigator.of(context).pop();
              //                         },
              //                       ),
              //                     ),
              //                     Container(
              //                       color: Colors.black87,
              //                       child: CupertinoActionSheetAction(
              //                         child: Text(
              //                           "フェミニン",
              //                           style: TextStyle(
              //                             color: Colors.white,
              //                             fontSize: 15,
              //                           ),
              //                         ),
              //                         onPressed: () async {
              //                           HapticFeedback.heavyImpact();
              //                           likeStyleTwo = "フェミニン";
              //                           if (mounted) {setState(() {});}
              //                           Navigator.of(context).pop();
              //                         },
              //                       ),
              //                     ),
              //                     Container(
              //                       color: Colors.black87,
              //                       child: CupertinoActionSheetAction(
              //                         child: Text(
              //                           "グランジ",
              //                           style: TextStyle(
              //                             color: Colors.white,
              //                             fontSize: 15,
              //                           ),
              //                         ),
              //                         onPressed: () async {
              //                           HapticFeedback.heavyImpact();
              //                           likeStyleTwo = "グランジ";
              //                           if (mounted) {setState(() {});}
              //                           Navigator.of(context).pop();
              //                         },
              //                       ),
              //                     ),
              //                     Container(
              //                       color: Colors.black87,
              //                       child: CupertinoActionSheetAction(
              //                         child: Text(
              //                           "アンニュイ",
              //                           style: TextStyle(
              //                             color: Colors.white,
              //                             fontSize: 15,
              //                           ),
              //                         ),
              //                         onPressed: () async {
              //                           HapticFeedback.heavyImpact();
              //                           likeStyleTwo = "アンニュイ";
              //                           if (mounted) {setState(() {});}
              //                           Navigator.of(context).pop();
              //                         },
              //                       ),
              //                     ),
              //                     Container(
              //                       color: Colors.black87,
              //                       child: CupertinoActionSheetAction(
              //                         child: Text(
              //                           "ロック",
              //                           style: TextStyle(
              //                             color: Colors.white,
              //                             fontSize: 15,
              //                           ),
              //                         ),
              //                         onPressed: () async {
              //                           HapticFeedback.heavyImpact();
              //                           likeStyleTwo = "ロック";
              //                           if (mounted) {setState(() {});}
              //                           Navigator.of(context).pop();
              //                         },
              //                       ),
              //                     ),
              //                     Container(
              //                       color: Colors.black87,
              //                       child: CupertinoActionSheetAction(
              //                         child: Text(
              //                           "クリエイティブ",
              //                           style: TextStyle(
              //                             color: Colors.white,
              //                             fontSize: 15,
              //                           ),
              //                         ),
              //                         onPressed: () async {
              //                           HapticFeedback.heavyImpact();
              //                           likeStyleTwo = "クリエイティブ";
              //                           if (mounted) {setState(() {});}
              //                           Navigator.of(context).pop();
              //                         },
              //                       ),
              //                     ),
              //                   ],
              //                   cancelButton: CupertinoButton(
              //                     color: Colors.black87,
              //                     child: Text(
              //                       'キャンセル',
              //                       style: TextStyle(
              //                         color: Colors.white,
              //                         fontSize: 15,
              //                       ),
              //                     ),
              //                     onPressed: () {
              //                       Navigator.of(context).pop();
              //                     }
              //                   ),
              //                 );
              //               },
              //             );
              //           },
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              // Container(
              //   width: 90.w,
              //   height: 1,
              //   margin: EdgeInsets.only(top: 0, right: 5.w, left: 5.w, bottom: 20,),
              //   color: Colors.black12,
              // ),              
              // Container(
              //   child: Container(
              //     width: 90.w,
              //     margin: EdgeInsets.only(right: 5.w, left: 5.w,),
              //     color: Colors.white,
              //     child: Row(
              //       children: [
              //         Container(
              //           width: 30,
              //           margin: EdgeInsets.only(right: 5, left: 5,),
              //         ),
              //         Container(
              //           margin: EdgeInsets.only(left: 5.w,),
              //           child: Text(
              //             '得意な事',
              //             style: TextStyle(
              //               fontWeight: FontWeight.bold,
              //               fontSize: 13,
              //             ),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              // Container(
              //   child: Container(
              //     width: 90.w,
              //     margin: EdgeInsets.only(top: 0, right: 5.w, left: 5.w,),
              //     child: Row(
              //       children: [
              //         Container(
              //           width: 30,
              //           height: 30,
              //           margin: EdgeInsets.only(right: 5, bottom: 0, left: 5,),
              //           decoration: BoxDecoration(
              //             color: Colors.black87,
              //             borderRadius: BorderRadius.circular(5),
              //           ),
              //           child: Icon(
              //             Icons.play_arrow,
              //             color: Colors.white,
              //             size: 20,
              //           ),
              //         ),
              //         GestureDetector(
              //           child: Container(
              //             margin: EdgeInsets.only(left: 5.w,),
              //             width: 70.w,
              //             height: 50,
              //             color: Colors.white,
              //             child: Row(
              //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //               children: [
              //                 Text(
              //                   nowBest,
              //                 ),
              //                 Container()
              //               ],
              //             )
              //           ),
              //           onTap: () async {
              //             await showCupertinoModalPopup(
              //               context: context,
              //               builder: (BuildContext context) {
              //                 return CupertinoActionSheet(
              //                   actions: [
              //                     Container(
              //                       color: Colors.black87,
              //                       child: CupertinoActionSheetAction(
              //                         child: Text(
              //                           "メンズセット",
              //                           style: TextStyle(
              //                             color: Colors.white,
              //                             fontSize: 15,
              //                           ),
              //                         ),
              //                         onPressed: () async {
              //                           HapticFeedback.heavyImpact();
              //                           nowBest = "メンズセット";
              //                           if (mounted) {setState(() {});}
              //                           Navigator.of(context).pop();
              //                         },
              //                       ),
              //                     ),
              //                     Container(
              //                       color: Colors.black87,
              //                       child: CupertinoActionSheetAction(
              //                         child: Text(
              //                           "レディースセット",
              //                           style: TextStyle(
              //                             color: Colors.white,
              //                             fontSize: 15,
              //                           ),
              //                         ),
              //                         onPressed: () async {
              //                           HapticFeedback.heavyImpact();
              //                           nowBest = "レディースセット";
              //                           if (mounted) {setState(() {});}
              //                           Navigator.of(context).pop();
              //                         },
              //                       ),
              //                     ),
              //                     Container(
              //                       color: Colors.black87,
              //                       child: CupertinoActionSheetAction(
              //                         child: Text(
              //                           "メンズカット",
              //                           style: TextStyle(
              //                             color: Colors.white,
              //                             fontSize: 15,
              //                           ),
              //                         ),
              //                         onPressed: () async {
              //                           HapticFeedback.heavyImpact();
              //                           nowBest = "メンズカット";
              //                           if (mounted) {setState(() {});}
              //                           Navigator.of(context).pop();
              //                         },
              //                       ),
              //                     ),
              //                     Container(
              //                       color: Colors.black87,
              //                       child: CupertinoActionSheetAction(
              //                         child: Text(
              //                           "レディースカット",
              //                           style: TextStyle(
              //                             color: Colors.white,
              //                             fontSize: 15,
              //                           ),
              //                         ),
              //                         onPressed: () async {
              //                           HapticFeedback.heavyImpact();
              //                           nowBest = "レディースカット";
              //                           if (mounted) {setState(() {});}
              //                           Navigator.of(context).pop();
              //                         },
              //                       ),
              //                     ),
              //                     Container(
              //                       color: Colors.black87,
              //                       child: CupertinoActionSheetAction(
              //                         child: Text(
              //                           "パーマ",
              //                           style: TextStyle(
              //                             color: Colors.white,
              //                             fontSize: 15,
              //                           ),
              //                         ),
              //                         onPressed: () async {
              //                           HapticFeedback.heavyImpact();
              //                           nowBest = "パーマ";
              //                           if (mounted) {setState(() {});}
              //                           Navigator.of(context).pop();
              //                         },
              //                       ),
              //                     ),
              //                     Container(
              //                       color: Colors.black87,
              //                       child: CupertinoActionSheetAction(
              //                         child: Text(
              //                           "カラー",
              //                           style: TextStyle(
              //                             color: Colors.white,
              //                             fontSize: 15,
              //                           ),
              //                         ),
              //                         onPressed: () async {
              //                           HapticFeedback.heavyImpact();
              //                           nowBest = "カラー";
              //                           if (mounted) {setState(() {});}
              //                           Navigator.of(context).pop();
              //                         },
              //                       ),
              //                     ),
              //                     Container(
              //                       color: Colors.black87,
              //                       child: CupertinoActionSheetAction(
              //                         child: Text(
              //                           "縮毛矯正",
              //                           style: TextStyle(
              //                             color: Colors.white,
              //                             fontSize: 15,
              //                           ),
              //                         ),
              //                         onPressed: () async {
              //                           HapticFeedback.heavyImpact();
              //                           nowBest = "縮毛矯正";
              //                           if (mounted) {setState(() {});}
              //                           Navigator.of(context).pop();
              //                         },
              //                       ),
              //                     ),
              //                     Container(
              //                       color: Colors.black87,
              //                       child: CupertinoActionSheetAction(
              //                         child: Text(
              //                           "メイク",
              //                           style: TextStyle(
              //                             color: Colors.white,
              //                             fontSize: 15,
              //                           ),
              //                         ),
              //                         onPressed: () async {
              //                           HapticFeedback.heavyImpact();
              //                           nowBest = "メイク";
              //                           if (mounted) {setState(() {});}
              //                           Navigator.of(context).pop();
              //                         },
              //                       ),
              //                     ),
              //                     Container(
              //                       color: Colors.black87,
              //                       child: CupertinoActionSheetAction(
              //                         child: Text(
              //                           "作品撮り",
              //                           style: TextStyle(
              //                             color: Colors.white,
              //                             fontSize: 15,
              //                           ),
              //                         ),
              //                         onPressed: () async {
              //                           HapticFeedback.heavyImpact();
              //                           nowBest = "作品撮り";
              //                           if (mounted) {setState(() {});}
              //                           Navigator.of(context).pop();
              //                         },
              //                       ),
              //                     ),
              //                     Container(
              //                       color: Colors.black87,
              //                       child: CupertinoActionSheetAction(
              //                         child: Text(
              //                           "イベント企画/主催",
              //                           style: TextStyle(
              //                             color: Colors.white,
              //                             fontSize: 15,
              //                           ),
              //                         ),
              //                         onPressed: () async {
              //                           HapticFeedback.heavyImpact();
              //                           nowBest = "イベント企画/主催";
              //                           if (mounted) {setState(() {});}
              //                           Navigator.of(context).pop();
              //                         },
              //                       ),
              //                     ),
              //                   ],
              //                   cancelButton: CupertinoButton(
              //                     color: Colors.black87,
              //                     child: Text(
              //                       'キャンセル',
              //                       style: TextStyle(
              //                         color: Colors.white,
              //                         fontSize: 15,
              //                       ),
              //                     ),
              //                     onPressed: () {
              //                       Navigator.of(context).pop();
              //                     }
              //                   ),
              //                 );
              //               },
              //             );
              //           },
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              // Container(
              //   width: 90.w,
              //   height: 1,
              //   margin: EdgeInsets.only(top: 0, right: 5.w, left: 5.w, bottom: 20,),
              //   color: Colors.black12,
              // ),              
              // Container(
              //   child: Container(
              //     width: 90.w,
              //     margin: EdgeInsets.only(right: 5.w, left: 5.w,),
              //     color: Colors.white,
              //     child: Row(
              //       children: [
              //         Container(
              //           width: 30,
              //           margin: EdgeInsets.only(right: 5, left: 5,),
              //         ),
              //         Container(
              //           margin: EdgeInsets.only(left: 5.w,),
              //           child: Text(
              //             '今力を入れてる事',
              //             style: TextStyle(
              //               fontWeight: FontWeight.bold,
              //               fontSize: 13,
              //             ),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              // Container(
              //   child: Container(
              //     width: 90.w,
              //     margin: EdgeInsets.only(top: 0, right: 5.w, left: 5.w,),
              //     child: Row(
              //       children: [
              //         Container(
              //           width: 30,
              //           height: 30,
              //           margin: EdgeInsets.only(right: 5, bottom: 0, left: 5,),
              //           decoration: BoxDecoration(
              //             color: Colors.black87,
              //             borderRadius: BorderRadius.circular(5),
              //           ),
              //           child: Icon(
              //             Icons.play_arrow,
              //             color: Colors.white,
              //             size: 20,
              //           ),
              //         ),
              //         GestureDetector(
              //           child: Container(
              //             margin: EdgeInsets.only(left: 5.w,),
              //             width: 70.w,
              //             height: 50,
              //             color: Colors.white,
              //             child: Row(
              //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //               children: [
              //                 Text(
              //                   nowFight,
              //                 ),
              //                 Container()
              //               ],
              //             )
              //           ),
              //           onTap: () async {
              //             await showCupertinoModalPopup(
              //               context: context,
              //               builder: (BuildContext context) {
              //                 return CupertinoActionSheet(
              //                   actions: [
              //                     Container(
              //                       color: Colors.black87,
              //                       child: CupertinoActionSheetAction(
              //                         child: Text(
              //                           "instagram",
              //                           style: TextStyle(
              //                             color: Colors.white,
              //                             fontSize: 15,
              //                           ),
              //                         ),
              //                         onPressed: () async {
              //                           HapticFeedback.heavyImpact();
              //                           nowFight = "パーマ";
              //                           if (mounted) {setState(() {});}
              //                           Navigator.of(context).pop();
              //                         },
              //                       ),
              //                     ),
              //                     Container(
              //                       color: Colors.black87,
              //                       child: CupertinoActionSheetAction(
              //                         child: Text(
              //                           "tiktok",
              //                           style: TextStyle(
              //                             color: Colors.white,
              //                             fontSize: 15,
              //                           ),
              //                         ),
              //                         onPressed: () async {
              //                           HapticFeedback.heavyImpact();
              //                           nowFight = "パーマ";
              //                           if (mounted) {setState(() {});}
              //                           Navigator.of(context).pop();
              //                         },
              //                       ),
              //                     ),
              //                     Container(
              //                       color: Colors.black87,
              //                       child: CupertinoActionSheetAction(
              //                         child: Text(
              //                           "youtube",
              //                           style: TextStyle(
              //                             color: Colors.white,
              //                             fontSize: 15,
              //                           ),
              //                         ),
              //                         onPressed: () async {
              //                           HapticFeedback.heavyImpact();
              //                           nowFight = "パーマ";
              //                           if (mounted) {setState(() {});}
              //                           Navigator.of(context).pop();
              //                         },
              //                       ),
              //                     ),
              //                     Container(
              //                       color: Colors.black87,
              //                       child: CupertinoActionSheetAction(
              //                         child: Text(
              //                           "メンズセット",
              //                           style: TextStyle(
              //                             color: Colors.white,
              //                             fontSize: 15,
              //                           ),
              //                         ),
              //                         onPressed: () async {
              //                           HapticFeedback.heavyImpact();
              //                           nowFight = "メンズセット";
              //                           if (mounted) {setState(() {});}
              //                           Navigator.of(context).pop();
              //                         },
              //                       ),
              //                     ),
              //                     Container(
              //                       color: Colors.black87,
              //                       child: CupertinoActionSheetAction(
              //                         child: Text(
              //                           "レディースセット",
              //                           style: TextStyle(
              //                             color: Colors.white,
              //                             fontSize: 15,
              //                           ),
              //                         ),
              //                         onPressed: () async {
              //                           HapticFeedback.heavyImpact();
              //                           nowFight = "レディースセット";
              //                           if (mounted) {setState(() {});}
              //                           Navigator.of(context).pop();
              //                         },
              //                       ),
              //                     ),
              //                     Container(
              //                       color: Colors.black87,
              //                       child: CupertinoActionSheetAction(
              //                         child: Text(
              //                           "メンズカット",
              //                           style: TextStyle(
              //                             color: Colors.white,
              //                             fontSize: 15,
              //                           ),
              //                         ),
              //                         onPressed: () async {
              //                           HapticFeedback.heavyImpact();
              //                           nowFight = "メンズカット";
              //                           if (mounted) {setState(() {});}
              //                           Navigator.of(context).pop();
              //                         },
              //                       ),
              //                     ),
              //                     Container(
              //                       color: Colors.black87,
              //                       child: CupertinoActionSheetAction(
              //                         child: Text(
              //                           "レディースカット",
              //                           style: TextStyle(
              //                             color: Colors.white,
              //                             fontSize: 15,
              //                           ),
              //                         ),
              //                         onPressed: () async {
              //                           HapticFeedback.heavyImpact();
              //                           nowFight = "レディースカット";
              //                           if (mounted) {setState(() {});}
              //                           Navigator.of(context).pop();
              //                         },
              //                       ),
              //                     ),
              //                     Container(
              //                       color: Colors.black87,
              //                       child: CupertinoActionSheetAction(
              //                         child: Text(
              //                           "パーマ",
              //                           style: TextStyle(
              //                             color: Colors.white,
              //                             fontSize: 15,
              //                           ),
              //                         ),
              //                         onPressed: () async {
              //                           HapticFeedback.heavyImpact();
              //                           nowFight = "パーマ";
              //                           if (mounted) {setState(() {});}
              //                           Navigator.of(context).pop();
              //                         },
              //                       ),
              //                     ),
              //                     Container(
              //                       color: Colors.black87,
              //                       child: CupertinoActionSheetAction(
              //                         child: Text(
              //                           "カラー",
              //                           style: TextStyle(
              //                             color: Colors.white,
              //                             fontSize: 15,
              //                           ),
              //                         ),
              //                         onPressed: () async {
              //                           HapticFeedback.heavyImpact();
              //                           nowFight = "カラー";
              //                           if (mounted) {setState(() {});}
              //                           Navigator.of(context).pop();
              //                         },
              //                       ),
              //                     ),
              //                     Container(
              //                       color: Colors.black87,
              //                       child: CupertinoActionSheetAction(
              //                         child: Text(
              //                           "縮毛矯正",
              //                           style: TextStyle(
              //                             color: Colors.white,
              //                             fontSize: 15,
              //                           ),
              //                         ),
              //                         onPressed: () async {
              //                           HapticFeedback.heavyImpact();
              //                           nowFight = "縮毛矯正";
              //                           if (mounted) {setState(() {});}
              //                           Navigator.of(context).pop();
              //                         },
              //                       ),
              //                     ),
              //                     Container(
              //                       color: Colors.black87,
              //                       child: CupertinoActionSheetAction(
              //                         child: Text(
              //                           "メイク",
              //                           style: TextStyle(
              //                             color: Colors.white,
              //                             fontSize: 15,
              //                           ),
              //                         ),
              //                         onPressed: () async {
              //                           HapticFeedback.heavyImpact();
              //                           nowFight = "メイク";
              //                           if (mounted) {setState(() {});}
              //                           Navigator.of(context).pop();
              //                         },
              //                       ),
              //                     ),
              //                     Container(
              //                       color: Colors.black87,
              //                       child: CupertinoActionSheetAction(
              //                         child: Text(
              //                           "作品撮り",
              //                           style: TextStyle(
              //                             color: Colors.white,
              //                             fontSize: 15,
              //                           ),
              //                         ),
              //                         onPressed: () async {
              //                           HapticFeedback.heavyImpact();
              //                           nowFight = "作品撮り";
              //                           if (mounted) {setState(() {});}
              //                           Navigator.of(context).pop();
              //                         },
              //                       ),
              //                     ),
              //                     Container(
              //                       color: Colors.black87,
              //                       child: CupertinoActionSheetAction(
              //                         child: Text(
              //                           "イベント企画/主催",
              //                           style: TextStyle(
              //                             color: Colors.white,
              //                             fontSize: 15,
              //                           ),
              //                         ),
              //                         onPressed: () async {
              //                           HapticFeedback.heavyImpact();
              //                           nowFight = "イベント企画/主催";
              //                           if (mounted) {setState(() {});}
              //                           Navigator.of(context).pop();
              //                         },
              //                       ),
              //                     ),
              //                   ],
              //                   cancelButton: CupertinoButton(
              //                     color: Colors.black87,
              //                     child: Text(
              //                       'キャンセル',
              //                       style: TextStyle(
              //                         color: Colors.white,
              //                         fontSize: 15,
              //                       ),
              //                     ),
              //                     onPressed: () {
              //                       Navigator.of(context).pop();
              //                     }
              //                   ),
              //                 );
              //               },
              //             );
              //           },
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              // Container(
              //   width: 90.w,
              //   height: 1,
              //   margin: EdgeInsets.only(top: 0, right: 5.w, left: 5.w, bottom: 20,),
              //   color: Colors.black12,
              // ),           
              // Container(
              //   child: Container(
              //     width: 90.w,
              //     margin: EdgeInsets.only(right: 5.w, left: 5.w,),
              //     color: Colors.white,
              //     child: Row(
              //       children: [
              //         Container(
              //           width: 30,
              //           margin: EdgeInsets.only(right: 5, left: 5,),
              //         ),
              //         Container(
              //           margin: EdgeInsets.only(left: 5.w,),
              //           child: Text(
              //             '在住の都道府県',
              //             style: TextStyle(
              //               fontWeight: FontWeight.bold,
              //               fontSize: 13,
              //             ),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              // Container(
              //   child: Container(
              //     width: 90.w,
              //     margin: EdgeInsets.only(top: 0, right: 5.w, left: 5.w,),
              //     child: Row(
              //       children: [
              //         Container(
              //           width: 30,
              //           height: 30,
              //           margin: EdgeInsets.only(right: 5, bottom: 0, left: 5,),
              //           decoration: BoxDecoration(
              //             color: Colors.black87,
              //             borderRadius: BorderRadius.circular(5),
              //           ),
              //           child: Icon(
              //             Icons.play_arrow,
              //             color: Colors.white,
              //             size: 20,
              //           ),
              //         ),
              //         GestureDetector(
              //           child: Container(
              //             margin: EdgeInsets.only(left: 5.w,),
              //             width: 70.w,
              //             height: 50,
              //             color: Colors.white,
              //             child: Row(
              //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //               children: [
              //                 Text(
              //                   prefecture,
              //                 ),
              //                 Container()
              //               ],
              //             )
              //           ),
              //           onTap: () async {
              //             await showCupertinoModalPopup(
              //               context: context,
              //               builder: (BuildContext context) {
              //                 return CupertinoActionSheet(
              //                   actions: [
              //                     Container(
              //                       color: Colors.black87,
              //                       child: CupertinoActionSheetAction(
              //                         child: Text(
              //                           "北海道",
              //                           style: TextStyle(
              //                             color: Colors.white,
              //                             fontSize: 15,
              //                           ),
              //                         ),
              //                         onPressed: () async {
              //                           HapticFeedback.heavyImpact();
              //                           prefecture = "北海道";
              //                           if (mounted) {setState(() {});}
              //                           Navigator.of(context).pop();
              //                         },
              //                       ),
              //                     ),
              //                     Container(
              //                       color: Colors.black87,
              //                       child: CupertinoActionSheetAction(
              //                         child: Text(
              //                           "東北",
              //                           style: TextStyle(
              //                             color: Colors.white,
              //                             fontSize: 15,
              //                           ),
              //                         ),
              //                         onPressed: () async {
              //                           HapticFeedback.heavyImpact();
              //                           Navigator.of(context).pop();
              //                           await showCupertinoModalPopup(
              //                             context: context,
              //                             builder: (BuildContext context) {
              //                               return CupertinoActionSheet(
              //                                 actions: [
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "青森県",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         prefecture = "青森県";
              //                                         if (mounted) {setState(() {});}
              //                                         Navigator.of(context).pop();
              //                                       },
              //                                     ),
              //                                   ),
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "岩手県",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         prefecture = "岩手県";
              //                                         if (mounted) {setState(() {});}
              //                                         Navigator.of(context).pop();
              //                                       },
              //                                     ),
              //                                   ),
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "秋田県",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         prefecture = "秋田県";
              //                                         if (mounted) {setState(() {});}
              //                                         Navigator.of(context).pop();
              //                                       },
              //                                     ),
              //                                   ),
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "宮城県",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         prefecture = "宮城県";
              //                                         if (mounted) {setState(() {});}
              //                                         Navigator.of(context).pop();
              //                                       },
              //                                     ),
              //                                   ),
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "山形県",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         prefecture = "山形県";
              //                                         if (mounted) {setState(() {});}
              //                                         Navigator.of(context).pop();
              //                                       },
              //                                     ),
              //                                   ),
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "福島県",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         prefecture = "福島県";
              //                                         if (mounted) {setState(() {});}
              //                                         Navigator.of(context).pop();
              //                                       },
              //                                     ),
              //                                   ),
              //                                 ],
              //                                 cancelButton: CupertinoButton(
              //                                   color: Colors.black87,
              //                                   child: Text(
              //                                     'キャンセル',
              //                                     style: TextStyle(
              //                                       color: Colors.white,
              //                                       fontSize: 15,
              //                                     ),
              //                                   ),
              //                                   onPressed: () {
              //                                     Navigator.of(context).pop();
              //                                   }
              //                                 ),
              //                               );
              //                             },
              //                           );
              //                         },
              //                       ),
              //                     ),
              //                     Container(
              //                       color: Colors.black87,
              //                       child: CupertinoActionSheetAction(
              //                         child: Text(
              //                           "関東",
              //                           style: TextStyle(
              //                             color: Colors.white,
              //                             fontSize: 15,
              //                           ),
              //                         ),
              //                         onPressed: () async {
              //                           HapticFeedback.heavyImpact();
              //                           Navigator.of(context).pop();
              //                           await showCupertinoModalPopup(
              //                             context: context,
              //                             builder: (BuildContext context) {
              //                               return CupertinoActionSheet(
              //                                 actions: [
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "茨城県",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         prefecture = "茨城県";
              //                                         if (mounted) {setState(() {});}
              //                                         Navigator.of(context).pop();
              //                                       },
              //                                     ),
              //                                   ),
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "栃木県",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         prefecture = "栃木県";
              //                                         if (mounted) {setState(() {});}
              //                                         Navigator.of(context).pop();
              //                                       },
              //                                     ),
              //                                   ),
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "群馬県",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         prefecture = "群馬県";
              //                                         if (mounted) {setState(() {});}
              //                                         Navigator.of(context).pop();
              //                                       },
              //                                     ),
              //                                   ),
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "埼玉県",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         prefecture = "埼玉県";
              //                                         if (mounted) {setState(() {});}
              //                                         Navigator.of(context).pop();
              //                                       },
              //                                     ),
              //                                   ),
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "千葉県",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         prefecture = "千葉県";
              //                                         if (mounted) {setState(() {});}
              //                                         Navigator.of(context).pop();
              //                                       },
              //                                     ),
              //                                   ),
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "東京都",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         prefecture = "東京都";
              //                                         if (mounted) {setState(() {});}
              //                                         Navigator.of(context).pop();
              //                                       },
              //                                     ),
              //                                   ),
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "神奈川県",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         prefecture = "神奈川県";
              //                                         if (mounted) {setState(() {});}
              //                                         Navigator.of(context).pop();
              //                                       },
              //                                     ),
              //                                   ),
              //                                 ],
              //                                 cancelButton: CupertinoButton(
              //                                   color: Colors.black87,
              //                                   child: Text(
              //                                     'キャンセル',
              //                                     style: TextStyle(
              //                                       color: Colors.white,
              //                                       fontSize: 15,
              //                                     ),
              //                                   ),
              //                                   onPressed: () {
              //                                     Navigator.of(context).pop();
              //                                   }
              //                                 ),
              //                               );
              //                             },
              //                           );
              //                         },
              //                       ),
              //                     ),
              //                     Container(
              //                       color: Colors.black87,
              //                       child: CupertinoActionSheetAction(
              //                         child: Text(
              //                           "中部",
              //                           style: TextStyle(
              //                             color: Colors.white,
              //                             fontSize: 15,
              //                           ),
              //                         ),
              //                         onPressed: () async {
              //                           HapticFeedback.heavyImpact();
              //                           Navigator.of(context).pop();
              //                           await showCupertinoModalPopup(
              //                             context: context,
              //                             builder: (BuildContext context) {
              //                               return CupertinoActionSheet(
              //                                 actions: [
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "新潟県",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         prefecture = "新潟県";
              //                                         if (mounted) {setState(() {});}
              //                                         Navigator.of(context).pop();
              //                                       },
              //                                     ),
              //                                   ),
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "富山県",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         prefecture = "富山県";
              //                                         if (mounted) {setState(() {});}
              //                                         Navigator.of(context).pop();
              //                                       },
              //                                     ),
              //                                   ),
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "石川県",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         prefecture = "石川県";
              //                                         if (mounted) {setState(() {});}
              //                                         Navigator.of(context).pop();
              //                                       },
              //                                     ),
              //                                   ),
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "福井県",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         prefecture = "福井県";
              //                                         if (mounted) {setState(() {});}
              //                                         Navigator.of(context).pop();
              //                                       },
              //                                     ),
              //                                   ),
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "山梨県",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         prefecture = "山梨県";
              //                                         if (mounted) {setState(() {});}
              //                                         Navigator.of(context).pop();
              //                                       },
              //                                     ),
              //                                   ),
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "長野県",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         prefecture = "長野県";
              //                                         if (mounted) {setState(() {});}
              //                                         Navigator.of(context).pop();
              //                                       },
              //                                     ),
              //                                   ),
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "岐阜県",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         prefecture = "岐阜県";
              //                                         if (mounted) {setState(() {});}
              //                                         Navigator.of(context).pop();
              //                                       },
              //                                     ),
              //                                   ),
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "静岡県",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         prefecture = "静岡県";
              //                                         if (mounted) {setState(() {});}
              //                                         Navigator.of(context).pop();
              //                                       },
              //                                     ),
              //                                   ),
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "愛知県",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         prefecture = "愛知県";
              //                                         if (mounted) {setState(() {});}
              //                                         Navigator.of(context).pop();
              //                                       },
              //                                     ),
              //                                   ),
              //                                 ],
              //                                 cancelButton: CupertinoButton(
              //                                   color: Colors.black87,
              //                                   child: Text(
              //                                     'キャンセル',
              //                                     style: TextStyle(
              //                                       color: Colors.white,
              //                                       fontSize: 15,
              //                                     ),
              //                                   ),
              //                                   onPressed: () {
              //                                     Navigator.of(context).pop();
              //                                   }
              //                                 ),
              //                               );
              //                             },
              //                           );
              //                         },
              //                       ),
              //                     ),
              //                     Container(
              //                       color: Colors.black87,
              //                       child: CupertinoActionSheetAction(
              //                         child: Text(
              //                           "近畿",
              //                           style: TextStyle(
              //                             color: Colors.white,
              //                             fontSize: 15,
              //                           ),
              //                         ),
              //                         onPressed: () async {
              //                           HapticFeedback.heavyImpact();
              //                           Navigator.of(context).pop();
              //                           await showCupertinoModalPopup(
              //                             context: context,
              //                             builder: (BuildContext context) {
              //                               return CupertinoActionSheet(
              //                                 actions: [
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "三重県",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         prefecture = "三重県";
              //                                         if (mounted) {setState(() {});}
              //                                         Navigator.of(context).pop();
              //                                       },
              //                                     ),
              //                                   ),
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "滋賀県",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         prefecture = "滋賀県";
              //                                         if (mounted) {setState(() {});}
              //                                         Navigator.of(context).pop();
              //                                       },
              //                                     ),
              //                                   ),
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "京都府",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         prefecture = "京都府";
              //                                         if (mounted) {setState(() {});}
              //                                         Navigator.of(context).pop();
              //                                       },
              //                                     ),
              //                                   ),
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "大阪府",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         prefecture = "大阪府";
              //                                         if (mounted) {setState(() {});}
              //                                         Navigator.of(context).pop();
              //                                       },
              //                                     ),
              //                                   ),
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "兵庫県",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         prefecture = "兵庫県";
              //                                         if (mounted) {setState(() {});}
              //                                         Navigator.of(context).pop();
              //                                       },
              //                                     ),
              //                                   ),
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "奈良県",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         prefecture = "奈良県";
              //                                         if (mounted) {setState(() {});}
              //                                         Navigator.of(context).pop();
              //                                       },
              //                                     ),
              //                                   ),
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "和歌山県",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         prefecture = "和歌山県";
              //                                         if (mounted) {setState(() {});}
              //                                         Navigator.of(context).pop();
              //                                       },
              //                                     ),
              //                                   ),
              //                                 ],
              //                                 cancelButton: CupertinoButton(
              //                                   color: Colors.black87,
              //                                   child: Text(
              //                                     'キャンセル',
              //                                     style: TextStyle(
              //                                       color: Colors.white,
              //                                       fontSize: 15,
              //                                     ),
              //                                   ),
              //                                   onPressed: () {
              //                                     Navigator.of(context).pop();
              //                                   }
              //                                 ),
              //                               );
              //                             },
              //                           );
              //                         },
              //                       ),
              //                     ),
              //                     Container(
              //                       color: Colors.black87,
              //                       child: CupertinoActionSheetAction(
              //                         child: Text(
              //                           "中国",
              //                           style: TextStyle(
              //                             color: Colors.white,
              //                             fontSize: 15,
              //                           ),
              //                         ),
              //                         onPressed: () async {
              //                           HapticFeedback.heavyImpact();
              //                           Navigator.of(context).pop();
              //                           await showCupertinoModalPopup(
              //                             context: context,
              //                             builder: (BuildContext context) {
              //                               return CupertinoActionSheet(
              //                                 actions: [
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "鳥取県",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         prefecture = "鳥取県";
              //                                         if (mounted) {setState(() {});}
              //                                         Navigator.of(context).pop();
              //                                       },
              //                                     ),
              //                                   ),
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "島根県",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         prefecture = "島根県";
              //                                         if (mounted) {setState(() {});}
              //                                         Navigator.of(context).pop();
              //                                       },
              //                                     ),
              //                                   ),
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "岡山県",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         prefecture = "岡山県";
              //                                         if (mounted) {setState(() {});}
              //                                         Navigator.of(context).pop();
              //                                       },
              //                                     ),
              //                                   ),
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "広島県",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         prefecture = "広島県";
              //                                         if (mounted) {setState(() {});}
              //                                         Navigator.of(context).pop();
              //                                       },
              //                                     ),
              //                                   ),
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "山口県",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         prefecture = "山口県";
              //                                         if (mounted) {setState(() {});}
              //                                         Navigator.of(context).pop();
              //                                       },
              //                                     ),
              //                                   ),
              //                                 ],
              //                                 cancelButton: CupertinoButton(
              //                                   color: Colors.black87,
              //                                   child: Text(
              //                                     'キャンセル',
              //                                     style: TextStyle(
              //                                       color: Colors.white,
              //                                       fontSize: 15,
              //                                     ),
              //                                   ),
              //                                   onPressed: () {
              //                                     Navigator.of(context).pop();
              //                                   }
              //                                 ),
              //                               );
              //                             },
              //                           );
              //                         },
              //                       ),
              //                     ),
              //                     Container(
              //                       color: Colors.black87,
              //                       child: CupertinoActionSheetAction(
              //                         child: Text(
              //                           "四国",
              //                           style: TextStyle(
              //                             color: Colors.white,
              //                             fontSize: 15,
              //                           ),
              //                         ),
              //                         onPressed: () async {
              //                           HapticFeedback.heavyImpact();
              //                           Navigator.of(context).pop();
              //                           await showCupertinoModalPopup(
              //                             context: context,
              //                             builder: (BuildContext context) {
              //                               return CupertinoActionSheet(
              //                                 actions: [
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "徳島県",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         prefecture = "徳島県";
              //                                         if (mounted) {setState(() {});}
              //                                         Navigator.of(context).pop();
              //                                       },
              //                                     ),
              //                                   ),
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "香川県",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         prefecture = "香川県";
              //                                         if (mounted) {setState(() {});}
              //                                         Navigator.of(context).pop();
              //                                       },
              //                                     ),
              //                                   ),
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "愛媛県",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         prefecture = "愛媛県";
              //                                         if (mounted) {setState(() {});}
              //                                         Navigator.of(context).pop();
              //                                       },
              //                                     ),
              //                                   ),
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "高知県",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         prefecture = "高知県";
              //                                         if (mounted) {setState(() {});}
              //                                         Navigator.of(context).pop();
              //                                       },
              //                                     ),
              //                                   ),
              //                                 ],
              //                                 cancelButton: CupertinoButton(
              //                                   color: Colors.black87,
              //                                   child: Text(
              //                                     'キャンセル',
              //                                     style: TextStyle(
              //                                       color: Colors.white,
              //                                       fontSize: 15,
              //                                     ),
              //                                   ),
              //                                   onPressed: () {
              //                                     Navigator.of(context).pop();
              //                                   }
              //                                 ),
              //                               );
              //                             },
              //                           );
              //                         },
              //                       ),
              //                     ),
              //                     Container(
              //                       color: Colors.black87,
              //                       child: CupertinoActionSheetAction(
              //                         child: Text(
              //                           "九州",
              //                           style: TextStyle(
              //                             color: Colors.white,
              //                             fontSize: 15,
              //                           ),
              //                         ),
              //                         onPressed: () async {
              //                           HapticFeedback.heavyImpact();
              //                           Navigator.of(context).pop();
              //                           await showCupertinoModalPopup(
              //                             context: context,
              //                             builder: (BuildContext context) {
              //                               return CupertinoActionSheet(
              //                                 actions: [
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "	福岡県",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         prefecture = "	福岡県";
              //                                         if (mounted) {setState(() {});}
              //                                         Navigator.of(context).pop();
              //                                       },
              //                                     ),
              //                                   ),
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "佐賀県",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         prefecture = "佐賀県";
              //                                         if (mounted) {setState(() {});}
              //                                         Navigator.of(context).pop();
              //                                       },
              //                                     ),
              //                                   ),
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "長崎県",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         prefecture = "長崎県";
              //                                         if (mounted) {setState(() {});}
              //                                         Navigator.of(context).pop();
              //                                       },
              //                                     ),
              //                                   ),
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "熊本県",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         prefecture = "熊本県";
              //                                         if (mounted) {setState(() {});}
              //                                         Navigator.of(context).pop();
              //                                       },
              //                                     ),
              //                                   ),
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "大分県",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         prefecture = "大分県";
              //                                         if (mounted) {setState(() {});}
              //                                         Navigator.of(context).pop();
              //                                       },
              //                                     ),
              //                                   ),
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "宮崎県",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         prefecture = "宮崎県";
              //                                         if (mounted) {setState(() {});}
              //                                         Navigator.of(context).pop();
              //                                       },
              //                                     ),
              //                                   ),
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "鹿児島県",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         prefecture = "鹿児島県";
              //                                         if (mounted) {setState(() {});}
              //                                         Navigator.of(context).pop();
              //                                       },
              //                                     ),
              //                                   ),
              //                                 ],
              //                                 cancelButton: CupertinoButton(
              //                                   color: Colors.black87,
              //                                   child: Text(
              //                                     'キャンセル',
              //                                     style: TextStyle(
              //                                       color: Colors.white,
              //                                       fontSize: 15,
              //                                     ),
              //                                   ),
              //                                   onPressed: () {
              //                                     Navigator.of(context).pop();
              //                                   }
              //                                 ),
              //                               );
              //                             },
              //                           );
              //                         },
              //                       ),
              //                     ),
              //                     Container(
              //                       color: Colors.black87,
              //                       child: CupertinoActionSheetAction(
              //                         child: Text(
              //                           "沖縄県",
              //                           style: TextStyle(
              //                             color: Colors.white,
              //                             fontSize: 15,
              //                           ),
              //                         ),
              //                         onPressed: () async {
              //                           HapticFeedback.heavyImpact();
              //                           prefecture = "沖縄県";
              //                           if (mounted) {setState(() {});}
              //                           Navigator.of(context).pop();
              //                         },
              //                       ),
              //                     ),
              //                   ],
              //                   cancelButton: CupertinoButton(
              //                     color: Colors.black87,
              //                     child: Text(
              //                       'キャンセル',
              //                       style: TextStyle(
              //                         color: Colors.white,
              //                         fontSize: 15,
              //                       ),
              //                     ),
              //                     onPressed: () {
              //                       Navigator.of(context).pop();
              //                     }
              //                   ),
              //                 );
              //               },
              //             );
              //           },
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              // Container(
              //   width: 90.w,
              //   height: 1,
              //   margin: EdgeInsets.only(top: 0, right: 5.w, left: 5.w, bottom: 20,),
              //   color: Colors.black12,
              // ),
              // Container(
              //   child: Container(
              //     width: 90.w,
              //     margin: EdgeInsets.only(right: 5.w, left: 5.w,),
              //     color: Colors.white,
              //     child: Row(
              //       children: [
              //         Container(
              //           width: 30,
              //           margin: EdgeInsets.only(right: 5, left: 5,),
              //         ),
              //         Container(
              //           margin: EdgeInsets.only(left: 5.w,),
              //           child: Text(
              //             '学校名',
              //             style: TextStyle(
              //               fontWeight: FontWeight.bold,
              //               fontSize: 13,
              //             ),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              // Container(
              //   child: Container(
              //     width: 90.w,
              //     margin: EdgeInsets.only(top: 0, right: 5.w, left: 5.w,),
              //     child: Row(
              //       children: [
              //         Container(
              //           width: 30,
              //           height: 30,
              //           margin: EdgeInsets.only(right: 5, bottom: 0, left: 5,),
              //           decoration: BoxDecoration(
              //             color: Colors.black87,
              //             borderRadius: BorderRadius.circular(5),
              //           ),
              //           child: Icon(
              //             Icons.play_arrow,
              //             color: Colors.white,
              //             size: 20,
              //           ),
              //         ),
              //         GestureDetector(
              //           child: Container(
              //             margin: EdgeInsets.only(left: 5.w,),
              //             width: 70.w,
              //             height: 50,
              //             color: Colors.white,
              //             child: Row(
              //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //               children: [
              //                 Text(
              //                   nowSchool,
              //                 ),
              //                 Container()
              //               ],
              //             )
              //           ),
              //           onTap: () async {
              //             await showCupertinoModalPopup(
              //               context: context,
              //               builder: (BuildContext context) {
              //                 return CupertinoActionSheet(
              //                   actions: [
              //                     Container(
              //                       color: Colors.black87,
              //                       child: CupertinoActionSheetAction(
              //                         child: Text(
              //                           "北海道",
              //                           style: TextStyle(
              //                             color: Colors.white,
              //                             fontSize: 15,
              //                           ),
              //                         ),
              //                         onPressed: () async {
              //                           HapticFeedback.heavyImpact();
              //                           Navigator.of(context).pop();
              //                           await showCupertinoModalPopup(
              //                             context: context,
              //                             builder: (BuildContext context) {
              //                               return CupertinoActionSheet(
              //                                 actions: [
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "旭川理容美容専門学校",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         nowSchool= "旭川理容美容専門学校";
              //                                         if (mounted) {setState(() {});}
              //                                         Navigator.of(context).pop();
              //                                       },
              //                                     ),
              //                                   ),
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "北見美容専門学校",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         nowSchool= "北見美容専門学校";
              //                                         if (mounted) {setState(() {});}
              //                                         Navigator.of(context).pop();
              //                                       },
              //                                     ),
              //                                   ),
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "札幌ビューティーアート専門学校",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         nowSchool= "札幌ビューティーアート専門学校";
              //                                         if (mounted) {setState(() {});}
              //                                         Navigator.of(context).pop();
              //                                       },
              //                                     ),
              //                                   ),
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "札幌ビューティックアカデミー",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         nowSchool= "札幌ビューティックアカデミー";
              //                                         if (mounted) {setState(() {});}
              //                                         Navigator.of(context).pop();
              //                                       },
              //                                     ),
              //                                   ),
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "札幌ベルエポック美容専門学校",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         nowSchool= "札幌ベルエポック美容専門学校";
              //                                         if (mounted) {setState(() {});}
              //                                         Navigator.of(context).pop();
              //                                       },
              //                                     ),
              //                                   ),
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "道東ヘアメイク専門学校",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         nowSchool= "道東ヘアメイク専門学校";
              //                                         if (mounted) {setState(() {});}
              //                                         Navigator.of(context).pop();
              //                                       },
              //                                     ),
              //                                   ),
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "函館理容美容専門学校",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         nowSchool= "函館理容美容専門学校";
              //                                         if (mounted) {setState(() {});}
              //                                         Navigator.of(context).pop();
              //                                       },
              //                                     ),
              //                                   ),
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "北海道美容専門学校",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         nowSchool= "北海道美容専門学校";
              //                                         if (mounted) {setState(() {});}
              //                                         Navigator.of(context).pop();
              //                                       },
              //                                     ),
              //                                   ),
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "北海道理容美容専門学校",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         nowSchool= "北海道理容美容専門学校";
              //                                         if (mounted) {setState(() {});}
              //                                         Navigator.of(context).pop();
              //                                       },
              //                                     ),
              //                                   ),
              //                                 ],
              //                                 cancelButton: CupertinoButton(
              //                                   color: Colors.black87,
              //                                   child: Text(
              //                                     'キャンセル',
              //                                     style: TextStyle(
              //                                       color: Colors.white,
              //                                       fontSize: 15,
              //                                     ),
              //                                   ),
              //                                   onPressed: () {
              //                                     Navigator.of(context).pop();
              //                                   }
              //                                 ),
              //                               );
              //                             },
              //                           );
              //                         },
              //                       ),
              //                     ),
              //                     Container(
              //                       color: Colors.black87,
              //                       child: CupertinoActionSheetAction(
              //                         child: Text(
              //                           "東北",
              //                           style: TextStyle(
              //                             color: Colors.white,
              //                             fontSize: 15,
              //                           ),
              //                         ),
              //                         onPressed: () async {
              //                           HapticFeedback.heavyImpact();
              //                           Navigator.of(context).pop();
              //                           await showCupertinoModalPopup(
              //                             context: context,
              //                             builder: (BuildContext context) {
              //                               return CupertinoActionSheet(
              //                                 actions: [
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "青森県",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         Navigator.of(context).pop();
              //                                         await showCupertinoModalPopup(
              //                                           context: context,
              //                                           builder: (BuildContext context) {
              //                                             return CupertinoActionSheet(
              //                                               actions: [
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "青森県ビューティー&メディカル専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool= "青森県ビューティー&メディカル専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "青森県ヘアアーチスト専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool= "青森県ヘアアーチスト専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "八戸理容美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool= "八戸理容美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                               ],
              //                                               cancelButton: CupertinoButton(
              //                                                 color: Colors.black87,
              //                                                 child: Text(
              //                                                   'キャンセル',
              //                                                   style: TextStyle(
              //                                                     color: Colors.white,
              //                                                     fontSize: 15,
              //                                                   ),
              //                                                 ),
              //                                                 onPressed: () {
              //                                                   Navigator.of(context).pop();
              //                                                 }
              //                                               ),
              //                                             );
              //                                           },
              //                                         );
              //                                       },
              //                                     ),
              //                                   ),
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "岩手県",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         Navigator.of(context).pop();
              //                                         await showCupertinoModalPopup(
              //                                           context: context,
              //                                           builder: (BuildContext context) {
              //                                             return CupertinoActionSheet(
              //                                               actions: [
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "岩手理容美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool= "岩手理容美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "専門学校 北日本ヘア・スタイリストカレッジ",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool= "専門学校 北日本ヘア・スタイリストカレッジ";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "東北ヘア－モード学院",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool= "東北ヘア－モード学院";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "盛岡ヘアメイク専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool= "盛岡ヘアメイク専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                               ],
              //                                               cancelButton: CupertinoButton(
              //                                                 color: Colors.black87,
              //                                                 child: Text(
              //                                                   'キャンセル',
              //                                                   style: TextStyle(
              //                                                     color: Colors.white,
              //                                                     fontSize: 15,
              //                                                   ),
              //                                                 ),
              //                                                 onPressed: () {
              //                                                   Navigator.of(context).pop();
              //                                                 }
              //                                               ),
              //                                             );
              //                                           },
              //                                         );
              //                                       },
              //                                     ),
              //                                   ),
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "秋田県",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         Navigator.of(context).pop();
              //                                         await showCupertinoModalPopup(
              //                                           context: context,
              //                                           builder: (BuildContext context) {
              //                                             return CupertinoActionSheet(
              //                                               actions: [
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "秋田県理容美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool= "秋田県理容美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "秋田ヘアビューティカレッジ",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool= "秋田ヘアビューティカレッジ";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                               ],
              //                                               cancelButton: CupertinoButton(
              //                                                 color: Colors.black87,
              //                                                 child: Text(
              //                                                   'キャンセル',
              //                                                   style: TextStyle(
              //                                                     color: Colors.white,
              //                                                     fontSize: 15,
              //                                                   ),
              //                                                 ),
              //                                                 onPressed: () {
              //                                                   Navigator.of(context).pop();
              //                                                 }
              //                                               ),
              //                                             );
              //                                           },
              //                                         );
              //                                       },
              //                                     ),
              //                                   ),
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "宮城県",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         Navigator.of(context).pop();
              //                                         await showCupertinoModalPopup(
              //                                           context: context,
              //                                           builder: (BuildContext context) {
              //                                             return CupertinoActionSheet(
              //                                               actions: [
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "SENDAI中央理容美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool= "SENDAI中央理容美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "仙台ビューティーアート専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool= "仙台ビューティーアート専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "仙台ヘアメイク専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool= "仙台ヘアメイク専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "仙台理容美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool= "仙台理容美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                               ],
              //                                               cancelButton: CupertinoButton(
              //                                                 color: Colors.black87,
              //                                                 child: Text(
              //                                                   'キャンセル',
              //                                                   style: TextStyle(
              //                                                     color: Colors.white,
              //                                                     fontSize: 15,
              //                                                   ),
              //                                                 ),
              //                                                 onPressed: () {
              //                                                   Navigator.of(context).pop();
              //                                                 }
              //                                               ),
              //                                             );
              //                                           },
              //                                         );
              //                                       },
              //                                     ),
              //                                   ),
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "山形県",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         Navigator.of(context).pop();
              //                                         await showCupertinoModalPopup(
              //                                           context: context,
              //                                           builder: (BuildContext context) {
              //                                             return CupertinoActionSheet(
              //                                               actions: [
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "Beauty アカデミー山形",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool= "Beauty アカデミー山形";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "山形美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool= "山形美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                               ],
              //                                               cancelButton: CupertinoButton(
              //                                                 color: Colors.black87,
              //                                                 child: Text(
              //                                                   'キャンセル',
              //                                                   style: TextStyle(
              //                                                     color: Colors.white,
              //                                                     fontSize: 15,
              //                                                   ),
              //                                                 ),
              //                                                 onPressed: () {
              //                                                   Navigator.of(context).pop();
              //                                                 }
              //                                               ),
              //                                             );
              //                                           },
              //                                         );
              //                                       },
              //                                     ),
              //                                   ),
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "福島県",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         Navigator.of(context).pop();
              //                                         await showCupertinoModalPopup(
              //                                           context: context,
              //                                           builder: (BuildContext context) {
              //                                             return CupertinoActionSheet(
              //                                               actions: [
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "AIZUビューティーカレッジ",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool= "AIZUビューティーカレッジ";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "iwakiヘアメイクアカデミー",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool= "iwakiヘアメイクアカデミー";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "郡山ヘアメイクカレッジ",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool= "郡山ヘアメイクカレッジ";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "国際ビューティー＆フード大学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool= "国際ビューティー＆フード大学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "福島県高等理容美容学院",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool= "福島県高等理容美容学院";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                               ],
              //                                               cancelButton: CupertinoButton(
              //                                                 color: Colors.black87,
              //                                                 child: Text(
              //                                                   'キャンセル',
              //                                                   style: TextStyle(
              //                                                     color: Colors.white,
              //                                                     fontSize: 15,
              //                                                   ),
              //                                                 ),
              //                                                 onPressed: () {
              //                                                   Navigator.of(context).pop();
              //                                                 }
              //                                               ),
              //                                             );
              //                                           },
              //                                         );
              //                                       },
              //                                     ),
              //                                   ),
              //                                 ],
              //                                 cancelButton: CupertinoButton(
              //                                   color: Colors.black87,
              //                                   child: Text(
              //                                     'キャンセル',
              //                                     style: TextStyle(
              //                                       color: Colors.white,
              //                                       fontSize: 15,
              //                                     ),
              //                                   ),
              //                                   onPressed: () {
              //                                     Navigator.of(context).pop();
              //                                   }
              //                                 ),
              //                               );
              //                             },
              //                           );
              //                         },
              //                       ),
              //                     ),
              //                     Container(
              //                       color: Colors.black87,
              //                       child: CupertinoActionSheetAction(
              //                         child: Text(
              //                           "関東",
              //                           style: TextStyle(
              //                             color: Colors.white,
              //                             fontSize: 15,
              //                           ),
              //                         ),
              //                         onPressed: () async {
              //                           HapticFeedback.heavyImpact();
              //                           Navigator.of(context).pop();
              //                           await showCupertinoModalPopup(
              //                             context: context,
              //                             builder: (BuildContext context) {
              //                               return CupertinoActionSheet(
              //                                 actions: [
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "茨城県",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         Navigator.of(context).pop();
              //                                         await showCupertinoModalPopup(
              //                                           context: context,
              //                                           builder: (BuildContext context) {
              //                                             return CupertinoActionSheet(
              //                                               actions: [
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "茨城理容美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool= "茨城理容美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "EIKA美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool= "EIKA美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "WFAビューティアカデミー",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool= "WFAビューティアカデミー";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "水戸ビューティーカレッジ",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool= "水戸ビューティーカレッジ";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "水戸美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool= "水戸美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                               ],
              //                                               cancelButton: CupertinoButton(
              //                                                 color: Colors.black87,
              //                                                 child: Text(
              //                                                   'キャンセル',
              //                                                   style: TextStyle(
              //                                                     color: Colors.white,
              //                                                     fontSize: 15,
              //                                                   ),
              //                                                 ),
              //                                                 onPressed: () {
              //                                                   Navigator.of(context).pop();
              //                                                 }
              //                                               ),
              //                                             );
              //                                           },
              //                                         );
              //                                       },
              //                                     ),
              //                                   ),
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "栃木県",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         Navigator.of(context).pop();
              //                                         await showCupertinoModalPopup(
              //                                           context: context,
              //                                           builder: (BuildContext context) {
              //                                             return CupertinoActionSheet(
              //                                               actions: [
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "足利デザイン・ビューティ専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool= "足利デザイン・ビューティ専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "宇都宮美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool= "宇都宮美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "国際自動車・ビューティ専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool= "国際自動車・ビューティ専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "国際テクニカル美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool= "国際テクニカル美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "国際テクニカル理容美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool= "国際テクニカル理容美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "センスビューティカレッジ",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool= "センスビューティカレッジ";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "栃木県美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool= "栃木県美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                               ],
              //                                               cancelButton: CupertinoButton(
              //                                                 color: Colors.black87,
              //                                                 child: Text(
              //                                                   'キャンセル',
              //                                                   style: TextStyle(
              //                                                     color: Colors.white,
              //                                                     fontSize: 15,
              //                                                   ),
              //                                                 ),
              //                                                 onPressed: () {
              //                                                   Navigator.of(context).pop();
              //                                                 }
              //                                               ),
              //                                             );
              //                                           },
              //                                         );
              //                                       },
              //                                     ),
              //                                   ),
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "群馬県",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         Navigator.of(context).pop();
              //                                         await showCupertinoModalPopup(
              //                                           context: context,
              //                                           builder: (BuildContext context) {
              //                                             return CupertinoActionSheet(
              //                                               actions: [
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "伊勢崎美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool= "伊勢崎美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "群馬県美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool= "群馬県美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "高崎ビューティモード専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool= "高崎ビューティモード専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                               ],
              //                                               cancelButton: CupertinoButton(
              //                                                 color: Colors.black87,
              //                                                 child: Text(
              //                                                   'キャンセル',
              //                                                   style: TextStyle(
              //                                                     color: Colors.white,
              //                                                     fontSize: 15,
              //                                                   ),
              //                                                 ),
              //                                                 onPressed: () {
              //                                                   Navigator.of(context).pop();
              //                                                 }
              //                                               ),
              //                                             );
              //                                           },
              //                                         );
              //                                       },
              //                                     ),
              //                                   ),
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "埼玉県",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         Navigator.of(context).pop();
              //                                         await showCupertinoModalPopup(
              //                                           context: context,
              //                                           builder: (BuildContext context) {
              //                                             return CupertinoActionSheet(
              //                                               actions: [
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "大宮ビューティー＆ブライダル専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool= "大宮ビューティー＆ブライダル専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "大宮理容美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool= "大宮理容美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "グルノーブル美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool= "グルノーブル美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "埼玉県理容美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool= "埼玉県理容美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "専門学校 トータルビューティカレッジ川越",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool= "専門学校 トータルビューティカレッジ川越";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "専門学校 東萌ビューティーカレッジ",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool= "専門学校 東萌ビューティーカレッジ";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "ミス・パリ・ビューティ専門学校 大宮校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool= "ミス・パリ・ビューティ専門学校 大宮校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                               ],
              //                                               cancelButton: CupertinoButton(
              //                                                 color: Colors.black87,
              //                                                 child: Text(
              //                                                   'キャンセル',
              //                                                   style: TextStyle(
              //                                                     color: Colors.white,
              //                                                     fontSize: 15,
              //                                                   ),
              //                                                 ),
              //                                                 onPressed: () {
              //                                                   Navigator.of(context).pop();
              //                                                 }
              //                                               ),
              //                                             );
              //                                           },
              //                                         );
              //                                       },
              //                                     ),
              //                                   ),
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "千葉県",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         Navigator.of(context).pop();
              //                                         await showCupertinoModalPopup(
              //                                           context: context,
              //                                           builder: (BuildContext context) {
              //                                             return CupertinoActionSheet(
              //                                               actions: [
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "ジェイ ヘアメイク専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool= "ジェイ ヘアメイク専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "千葉美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool= "千葉美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "東京ベイカレッジ",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool= "東京ベイカレッジ";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "東洋理容美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool= "東洋理容美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "パリ総合美容専門学校 柏校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool= "パリ総合美容専門学校 柏校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "パリ総合美容専門学校 千葉校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool= "パリ総合美容専門学校 千葉校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "ユニバーサルビューティーカレッジ",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool= "ユニバーサルビューティーカレッジ";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                               ],
              //                                               cancelButton: CupertinoButton(
              //                                                 color: Colors.black87,
              //                                                 child: Text(
              //                                                   'キャンセル',
              //                                                   style: TextStyle(
              //                                                     color: Colors.white,
              //                                                     fontSize: 15,
              //                                                   ),
              //                                                 ),
              //                                                 onPressed: () {
              //                                                   Navigator.of(context).pop();
              //                                                 }
              //                                               ),
              //                                             );
              //                                           },
              //                                         );
              //                                       },
              //                                     ),
              //                                   ),
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "東京都 No.1",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         Navigator.of(context).pop();
              //                                         await showCupertinoModalPopup(
              //                                           context: context,
              //                                           builder: (BuildContext context) {
              //                                             return CupertinoActionSheet(
              //                                               actions: [
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "アポロ美容理容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool= "アポロ美容理容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "窪田理容美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool= "窪田理容美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "国際文化理容美容専門学校 国分寺校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool= "国際文化理容美容専門学校 国分寺校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "国際文化理容美容専門学校 渋谷校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool= "国際文化理容美容専門学校 渋谷校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "国際理容美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool= "国際理容美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "コーセー美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool= "コーセー美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "資生堂美容技術専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool= "資生堂美容技術専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "住田美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool= "住田美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "専門学校 エビスビューティカレッジ",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool= "専門学校 エビスビューティカレッジ";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "高山美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool= "高山美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                               ],
              //                                               cancelButton: CupertinoButton(
              //                                                 color: Colors.black87,
              //                                                 child: Text(
              //                                                   'キャンセル',
              //                                                   style: TextStyle(
              //                                                     color: Colors.white,
              //                                                     fontSize: 15,
              //                                                   ),
              //                                                 ),
              //                                                 onPressed: () {
              //                                                   Navigator.of(context).pop();
              //                                                 }
              //                                               ),
              //                                             );
              //                                           },
              //                                         );
              //                                       },
              //                                     ),
              //                                   ),
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "東京都 No.2",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         Navigator.of(context).pop();
              //                                         await showCupertinoModalPopup(
              //                                           context: context,
              //                                           builder: (BuildContext context) {
              //                                             return CupertinoActionSheet(
              //                                               actions: [
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "タカラ美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool= "タカラ美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "中央理美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool= "中央理美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "東京総合美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool= "東京総合美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "東京ビューティーアート専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool= "東京ビューティーアート専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "東京美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool= "東京美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "東京文化美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool= "東京文化美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "東京ベルエポック美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool= "東京ベルエポック美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "東京マックス美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool= "東京マックス美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "東京モード学園",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool= "東京モード学園";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "東京理容専修学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool= "東京理容専修学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                               ],
              //                                               cancelButton: CupertinoButton(
              //                                                 color: Colors.black87,
              //                                                 child: Text(
              //                                                   'キャンセル',
              //                                                   style: TextStyle(
              //                                                     color: Colors.white,
              //                                                     fontSize: 15,
              //                                                   ),
              //                                                 ),
              //                                                 onPressed: () {
              //                                                   Navigator.of(context).pop();
              //                                                 }
              //                                               ),
              //                                             );
              //                                           },
              //                                         );
              //                                       },
              //                                     ),
              //                                   ),
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "東京都 No.3",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         Navigator.of(context).pop();
              //                                         await showCupertinoModalPopup(
              //                                           context: context,
              //                                           builder: (BuildContext context) {
              //                                             return CupertinoActionSheet(
              //                                               actions: [
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "日本美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool= "日本美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "ハリウッド美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool= "ハリウッド美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "ベルエポック美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool= "ベルエポック美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "町田美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool= "町田美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "真野美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool= "真野美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "マリー・ルイズ美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool= "マリー・ルイズ美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "ミスパリ ビューティ専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool= "ミスパリ ビューティ専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "山野美容芸術短期大学",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool= "山野美容芸術短期大学";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "山野美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool= "山野美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "早稲田美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool= "早稲田美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                               ],
              //                                               cancelButton: CupertinoButton(
              //                                                 color: Colors.black87,
              //                                                 child: Text(
              //                                                   'キャンセル',
              //                                                   style: TextStyle(
              //                                                     color: Colors.white,
              //                                                     fontSize: 15,
              //                                                   ),
              //                                                 ),
              //                                                 onPressed: () {
              //                                                   Navigator.of(context).pop();
              //                                                 }
              //                                               ),
              //                                             );
              //                                           },
              //                                         );
              //                                       },
              //                                     ),
              //                                   ),
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "神奈川県",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         Navigator.of(context).pop();
              //                                         await showCupertinoModalPopup(
              //                                           context: context,
              //                                           builder: (BuildContext context) {
              //                                             return CupertinoActionSheet(
              //                                               actions: [
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "アイム湘南美容教育専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "アイム湘南美容教育専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "アーティスティックＢ横浜美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "アーティスティックＢ横浜美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "M.D.F BEAUTY COLLEGE",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "M.D.F BEAUTY COLLEGE";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "鎌倉早見美容芸術専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "鎌倉早見美容芸術専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "関東美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "関東美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "国際総合ビューティーカレッジ",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "国際総合ビューティーカレッジ";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "湘南ビューティカレッジ",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "湘南ビューティカレッジ";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "横浜 ｆ カレッジ（ビューティースタイリスト科）",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "横浜 ｆ カレッジ（ビューティースタイリスト科）";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "横浜市立横浜商業高等学校別科（美容科）",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "横浜市立横浜商業高等学校別科（美容科）";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "横浜ビューティーアート専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "横浜ビューティーアート専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "横浜理容美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "横浜理容美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                               ],
              //                                               cancelButton: CupertinoButton(
              //                                                 color: Colors.black87,
              //                                                 child: Text(
              //                                                   'キャンセル',
              //                                                   style: TextStyle(
              //                                                     color: Colors.white,
              //                                                     fontSize: 15,
              //                                                   ),
              //                                                 ),
              //                                                 onPressed: () {
              //                                                   Navigator.of(context).pop();
              //                                                 }
              //                                               ),
              //                                             );
              //                                           },
              //                                         );
              //                                       },
              //                                     ),
              //                                   ),
              //                                 ],
              //                                 cancelButton: CupertinoButton(
              //                                   color: Colors.black87,
              //                                   child: Text(
              //                                     'キャンセル',
              //                                     style: TextStyle(
              //                                       color: Colors.white,
              //                                       fontSize: 15,
              //                                     ),
              //                                   ),
              //                                   onPressed: () {
              //                                     Navigator.of(context).pop();
              //                                   }
              //                                 ),
              //                               );
              //                             },
              //                           );
              //                         },
              //                       ),
              //                     ),
              //                     Container(
              //                       color: Colors.black87,
              //                       child: CupertinoActionSheetAction(
              //                         child: Text(
              //                           "中部",
              //                           style: TextStyle(
              //                             color: Colors.white,
              //                             fontSize: 15,
              //                           ),
              //                         ),
              //                         onPressed: () async {
              //                           HapticFeedback.heavyImpact();
              //                           Navigator.of(context).pop();
              //                           await showCupertinoModalPopup(
              //                             context: context,
              //                             builder: (BuildContext context) {
              //                               return CupertinoActionSheet(
              //                                 actions: [
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "新潟県",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         Navigator.of(context).pop();
              //                                         await showCupertinoModalPopup(
              //                                           context: context,
              //                                           builder: (BuildContext context) {
              //                                             return CupertinoActionSheet(
              //                                               actions: [
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "クレア ヘアモード専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "クレア ヘアモード専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "国際ビューティモード専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "国際ビューティモード専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "長岡美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "長岡美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "新潟美容専門学校 ジャパン・ビューティ・アカデミー",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "新潟美容専門学校 ジャパン・ビューティ・アカデミー";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "新潟理容美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "新潟理容美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                               ],
              //                                               cancelButton: CupertinoButton(
              //                                                 color: Colors.black87,
              //                                                 child: Text(
              //                                                   'キャンセル',
              //                                                   style: TextStyle(
              //                                                     color: Colors.white,
              //                                                     fontSize: 15,
              //                                                   ),
              //                                                 ),
              //                                                 onPressed: () {
              //                                                   Navigator.of(context).pop();
              //                                                 }
              //                                               ),
              //                                             );
              //                                           },
              //                                         );
              //                                       },
              //                                     ),
              //                                   ),
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "富山県",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         Navigator.of(context).pop();
              //                                         await showCupertinoModalPopup(
              //                                           context: context,
              //                                           builder: (BuildContext context) {
              //                                             return CupertinoActionSheet(
              //                                               actions: [
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "臼井美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "臼井美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "専門学校 富山ビューティーカレッジ",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "専門学校 富山ビューティーカレッジ";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "富山県理容美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "富山県理容美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                               ],
              //                                               cancelButton: CupertinoButton(
              //                                                 color: Colors.black87,
              //                                                 child: Text(
              //                                                   'キャンセル',
              //                                                   style: TextStyle(
              //                                                     color: Colors.white,
              //                                                     fontSize: 15,
              //                                                   ),
              //                                                 ),
              //                                                 onPressed: () {
              //                                                   Navigator.of(context).pop();
              //                                                 }
              //                                               ),
              //                                             );
              //                                           },
              //                                         );
              //                                       },
              //                                     ),
              //                                   ),
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "石川県",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         Navigator.of(context).pop();
              //                                         await showCupertinoModalPopup(
              //                                           context: context,
              //                                           builder: (BuildContext context) {
              //                                             return CupertinoActionSheet(
              //                                               actions: [
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "石川県理容美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "石川県理容美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "専門学校 金沢美専",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "専門学校 金沢美専";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                               ],
              //                                               cancelButton: CupertinoButton(
              //                                                 color: Colors.black87,
              //                                                 child: Text(
              //                                                   'キャンセル',
              //                                                   style: TextStyle(
              //                                                     color: Colors.white,
              //                                                     fontSize: 15,
              //                                                   ),
              //                                                 ),
              //                                                 onPressed: () {
              //                                                   Navigator.of(context).pop();
              //                                                 }
              //                                               ),
              //                                             );
              //                                           },
              //                                         );
              //                                       },
              //                                     ),
              //                                   ),
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "福井県",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         Navigator.of(context).pop();
              //                                         await showCupertinoModalPopup(
              //                                           context: context,
              //                                           builder: (BuildContext context) {
              //                                             return CupertinoActionSheet(
              //                                               actions: [
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "大原スポーツ医療保育福祉専門学校（美容科）",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "大原スポーツ医療保育福祉専門学校（美容科）";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "福井県理容美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "福井県理容美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                               ],
              //                                               cancelButton: CupertinoButton(
              //                                                 color: Colors.black87,
              //                                                 child: Text(
              //                                                   'キャンセル',
              //                                                   style: TextStyle(
              //                                                     color: Colors.white,
              //                                                     fontSize: 15,
              //                                                   ),
              //                                                 ),
              //                                                 onPressed: () {
              //                                                   Navigator.of(context).pop();
              //                                                 }
              //                                               ),
              //                                             );
              //                                           },
              //                                         );
              //                                       },
              //                                     ),
              //                                   ),
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "山梨県",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         Navigator.of(context).pop();
              //                                         await showCupertinoModalPopup(
              //                                           context: context,
              //                                           builder: (BuildContext context) {
              //                                             return CupertinoActionSheet(
              //                                               actions: [
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "山梨県美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "山梨県美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                               ],
              //                                               cancelButton: CupertinoButton(
              //                                                 color: Colors.black87,
              //                                                 child: Text(
              //                                                   'キャンセル',
              //                                                   style: TextStyle(
              //                                                     color: Colors.white,
              //                                                     fontSize: 15,
              //                                                   ),
              //                                                 ),
              //                                                 onPressed: () {
              //                                                   Navigator.of(context).pop();
              //                                                 }
              //                                               ),
              //                                             );
              //                                           },
              //                                         );
              //                                       },
              //                                     ),
              //                                   ),
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "長野県",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         Navigator.of(context).pop();
              //                                         await showCupertinoModalPopup(
              //                                           context: context,
              //                                           builder: (BuildContext context) {
              //                                             return CupertinoActionSheet(
              //                                               actions: [
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "長野理容美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "長野理容美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "松本理容美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "松本理容美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                               ],
              //                                               cancelButton: CupertinoButton(
              //                                                 color: Colors.black87,
              //                                                 child: Text(
              //                                                   'キャンセル',
              //                                                   style: TextStyle(
              //                                                     color: Colors.white,
              //                                                     fontSize: 15,
              //                                                   ),
              //                                                 ),
              //                                                 onPressed: () {
              //                                                   Navigator.of(context).pop();
              //                                                 }
              //                                               ),
              //                                             );
              //                                           },
              //                                         );
              //                                       },
              //                                     ),
              //                                   ),
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "岐阜県",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         Navigator.of(context).pop();
              //                                         await showCupertinoModalPopup(
              //                                           context: context,
              //                                           builder: (BuildContext context) {
              //                                             return CupertinoActionSheet(
              //                                               actions: [
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "岐阜美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "岐阜美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "ベルフォート　アカデミー　オブ　ビューティー",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "ベルフォート　アカデミー　オブ　ビューティー";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                               ],
              //                                               cancelButton: CupertinoButton(
              //                                                 color: Colors.black87,
              //                                                 child: Text(
              //                                                   'キャンセル',
              //                                                   style: TextStyle(
              //                                                     color: Colors.white,
              //                                                     fontSize: 15,
              //                                                   ),
              //                                                 ),
              //                                                 onPressed: () {
              //                                                   Navigator.of(context).pop();
              //                                                 }
              //                                               ),
              //                                             );
              //                                           },
              //                                         );
              //                                       },
              //                                     ),
              //                                   ),
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "静岡県",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         Navigator.of(context).pop();
              //                                         await showCupertinoModalPopup(
              //                                           context: context,
              //                                           builder: (BuildContext context) {
              //                                             return CupertinoActionSheet(
              //                                               actions: [
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "池田美容学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "池田美容学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "静岡アルス美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "静岡アルス美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "静岡県西部理容美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "静岡県西部理容美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "静岡県東部総合美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "静岡県東部総合美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "静岡県美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "静岡県美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "静岡新美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "静岡新美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "タカヤマ アドバンス ビューティー専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "タカヤマ アドバンス ビューティー専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "フリーエース美容学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "フリーエース美容学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "ルネサンス デザイン・美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "ルネサンス デザイン・美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                               ],
              //                                               cancelButton: CupertinoButton(
              //                                                 color: Colors.black87,
              //                                                 child: Text(
              //                                                   'キャンセル',
              //                                                   style: TextStyle(
              //                                                     color: Colors.white,
              //                                                     fontSize: 15,
              //                                                   ),
              //                                                 ),
              //                                                 onPressed: () {
              //                                                   Navigator.of(context).pop();
              //                                                 }
              //                                               ),
              //                                             );
              //                                           },
              //                                         );
              //                                       },
              //                                     ),
              //                                   ),
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "愛知県 No.1",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         Navigator.of(context).pop();
              //                                         await showCupertinoModalPopup(
              //                                           context: context,
              //                                           builder: (BuildContext context) {
              //                                             return CupertinoActionSheet(
              //                                               actions: [
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "愛知県東三高等理容美容学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "愛知県東三高等理容美容学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "愛知中央美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "愛知中央美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "愛知美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "愛知美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "アクア理美容学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "アクア理美容学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "アリアーレビューティ専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "アリアーレビューティ専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "セントラルビューティストカレッジ",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "セントラルビューティストカレッジ";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "専門学校 中部ビューティ・デザイン・デンタルカレッジ",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "専門学校 中部ビューティ・デザイン・デンタルカレッジ";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "中日美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "中日美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "中部美容専門学校 岡崎校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "中部美容専門学校 岡崎校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "中部美容専門学校 名古屋校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "中部美容専門学校 名古屋校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                               ],
              //                                               cancelButton: CupertinoButton(
              //                                                 color: Colors.black87,
              //                                                 child: Text(
              //                                                   'キャンセル',
              //                                                   style: TextStyle(
              //                                                     color: Colors.white,
              //                                                     fontSize: 15,
              //                                                   ),
              //                                                 ),
              //                                                 onPressed: () {
              //                                                   Navigator.of(context).pop();
              //                                                 }
              //                                               ),
              //                                             );
              //                                           },
              //                                         );
              //                                       },
              //                                     ),
              //                                   ),
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "愛知県 No.2",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         Navigator.of(context).pop();
              //                                         await showCupertinoModalPopup(
              //                                           context: context,
              //                                           builder: (BuildContext context) {
              //                                             return CupertinoActionSheet(
              //                                               actions: [
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "東海美容学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "東海美容学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "名古屋綜合美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "名古屋綜合美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "名古屋ビューティーアート専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "名古屋ビューティーアート専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "名古屋美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "名古屋美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "名古屋モード学園",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "名古屋モード学園";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "名古屋理容美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "名古屋理容美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "ビーキュービック美容学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "ビーキュービック美容学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "美容専門学校 アーティス・ヘアー・カレッジ",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "美容専門学校 アーティス・ヘアー・カレッジ";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "ビューティープロフェッショナルジャパンアカデミー",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "ビューティープロフェッショナルジャパンアカデミー";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "MOOビューティーアソシエイション",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "MOOビューティーアソシエイション";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                               ],
              //                                               cancelButton: CupertinoButton(
              //                                                 color: Colors.black87,
              //                                                 child: Text(
              //                                                   'キャンセル',
              //                                                   style: TextStyle(
              //                                                     color: Colors.white,
              //                                                     fontSize: 15,
              //                                                   ),
              //                                                 ),
              //                                                 onPressed: () {
              //                                                   Navigator.of(context).pop();
              //                                                 }
              //                                               ),
              //                                             );
              //                                           },
              //                                         );
              //                                       },
              //                                     ),
              //                                   ),
              //                                 ],
              //                                 cancelButton: CupertinoButton(
              //                                   color: Colors.black87,
              //                                   child: Text(
              //                                     'キャンセル',
              //                                     style: TextStyle(
              //                                       color: Colors.white,
              //                                       fontSize: 15,
              //                                     ),
              //                                   ),
              //                                   onPressed: () {
              //                                     Navigator.of(context).pop();
              //                                   }
              //                                 ),
              //                               );
              //                             },
              //                           );
              //                         },
              //                       ),
              //                     ),
              //                     Container(
              //                       color: Colors.black87,
              //                       child: CupertinoActionSheetAction(
              //                         child: Text(
              //                           "近畿",
              //                           style: TextStyle(
              //                             color: Colors.white,
              //                             fontSize: 15,
              //                           ),
              //                         ),
              //                         onPressed: () async {
              //                           HapticFeedback.heavyImpact();
              //                           Navigator.of(context).pop();
              //                           await showCupertinoModalPopup(
              //                             context: context,
              //                             builder: (BuildContext context) {
              //                               return CupertinoActionSheet(
              //                                 actions: [
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "三重県",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         Navigator.of(context).pop();
              //                                         await showCupertinoModalPopup(
              //                                           context: context,
              //                                           builder: (BuildContext context) {
              //                                             return CupertinoActionSheet(
              //                                               actions: [
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "旭美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "旭美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "伊勢理容美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "伊勢理容美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "ミエ・ヘア・アーチストアカデミー",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "ミエ・ヘア・アーチストアカデミー";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                               ],
              //                                               cancelButton: CupertinoButton(
              //                                                 color: Colors.black87,
              //                                                 child: Text(
              //                                                   'キャンセル',
              //                                                   style: TextStyle(
              //                                                     color: Colors.white,
              //                                                     fontSize: 15,
              //                                                   ),
              //                                                 ),
              //                                                 onPressed: () {
              //                                                   Navigator.of(context).pop();
              //                                                 }
              //                                               ),
              //                                             );
              //                                           },
              //                                         );
              //                                       },
              //                                     ),
              //                                   ),
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "京都府",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         Navigator.of(context).pop();
              //                                         await showCupertinoModalPopup(
              //                                           context: context,
              //                                           builder: (BuildContext context) {
              //                                             return CupertinoActionSheet(
              //                                               actions: [
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "アミューズ美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "アミューズ美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "京都美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "京都美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "京都理容美容専修学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "京都理容美容専修学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "YIC京都ビューティ専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "YIC京都ビューティ専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                               ],
              //                                               cancelButton: CupertinoButton(
              //                                                 color: Colors.black87,
              //                                                 child: Text(
              //                                                   'キャンセル',
              //                                                   style: TextStyle(
              //                                                     color: Colors.white,
              //                                                     fontSize: 15,
              //                                                   ),
              //                                                 ),
              //                                                 onPressed: () {
              //                                                   Navigator.of(context).pop();
              //                                                 }
              //                                               ),
              //                                             );
              //                                           },
              //                                         );
              //                                       },
              //                                     ),
              //                                   ),
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "大阪府 No.1",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         Navigator.of(context).pop();
              //                                         await showCupertinoModalPopup(
              //                                           context: context,
              //                                           builder: (BuildContext context) {
              //                                             return CupertinoActionSheet(
              //                                               actions: [
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "アイム・キンキ理容美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "アイム・キンキ理容美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "アーデントビューティーカレッジ",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "アーデントビューティーカレッジ";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "ECCアーティスト美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "ECCアーティスト美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "ヴェールルージュ美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "ヴェールルージュ美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "NRB日本理容美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "NRB日本理容美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "大阪樟蔭女子大学（学芸学部化粧ファッション学科）",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "大阪樟蔭女子大学（学芸学部化粧ファッション学科）";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "大阪中央理容美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "大阪中央理容美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "大阪ビューティーアート専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "大阪ビューティーアート専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "大阪美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "大阪美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "大阪ベルェベル美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "大阪ベルェベル美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                               ],
              //                                               cancelButton: CupertinoButton(
              //                                                 color: Colors.black87,
              //                                                 child: Text(
              //                                                   'キャンセル',
              //                                                   style: TextStyle(
              //                                                     color: Colors.white,
              //                                                     fontSize: 15,
              //                                                   ),
              //                                                 ),
              //                                                 onPressed: () {
              //                                                   Navigator.of(context).pop();
              //                                                 }
              //                                               ),
              //                                             );
              //                                           },
              //                                         );
              //                                       },
              //                                     ),
              //                                   ),
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "大阪府 No.2",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         Navigator.of(context).pop();
              //                                         await showCupertinoModalPopup(
              //                                           context: context,
              //                                           builder: (BuildContext context) {
              //                                             return CupertinoActionSheet(
              //                                               actions: [
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "大阪モード学園",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "大阪モード学園";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "桂make-upデザイン専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "桂make-upデザイン専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "関西美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "関西美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "グラムール美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "グラムール美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "小出美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "小出美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "小出美容専門学校 大阪校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "小出美容専門学校 大阪校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "高津理容美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "高津理容美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "堺女子短期大学（美容文化コース）",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "堺女子短期大学（美容文化コース）";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "スタリアビューティーカレッジ",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "スタリアビューティーカレッジ";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "スタリアビューティーカレッジ",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "スタリアビューティーカレッジ";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                               ],
              //                                               cancelButton: CupertinoButton(
              //                                                 color: Colors.black87,
              //                                                 child: Text(
              //                                                   'キャンセル',
              //                                                   style: TextStyle(
              //                                                     color: Colors.white,
              //                                                     fontSize: 15,
              //                                                   ),
              //                                                 ),
              //                                                 onPressed: () {
              //                                                   Navigator.of(context).pop();
              //                                                 }
              //                                               ),
              //                                             );
              //                                           },
              //                                         );
              //                                       },
              //                                     ),
              //                                   ),
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "大阪府 No.3",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         Navigator.of(context).pop();
              //                                         await showCupertinoModalPopup(
              //                                           context: context,
              //                                           builder: (BuildContext context) {
              //                                             return CupertinoActionSheet(
              //                                               actions: [
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "西日本ヘアメイクカレッジ 天王寺MiO校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "西日本ヘアメイクカレッジ 天王寺MiO校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "花園国際美容学院",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "花園国際美容学院";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "理容美容専門学校 西日本ヘアメイクカレッジ",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "理容美容専門学校 西日本ヘアメイクカレッジ";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "ル・トーア東亜美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "ル・トーア東亜美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "ロゼ＆ビューティ美容専門学院",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "ロゼ＆ビューティ美容専門学院";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                               ],
              //                                               cancelButton: CupertinoButton(
              //                                                 color: Colors.black87,
              //                                                 child: Text(
              //                                                   'キャンセル',
              //                                                   style: TextStyle(
              //                                                     color: Colors.white,
              //                                                     fontSize: 15,
              //                                                   ),
              //                                                 ),
              //                                                 onPressed: () {
              //                                                   Navigator.of(context).pop();
              //                                                 }
              //                                               ),
              //                                             );
              //                                           },
              //                                         );
              //                                       },
              //                                     ),
              //                                   ),
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "兵庫県",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         Navigator.of(context).pop();
              //                                         await showCupertinoModalPopup(
              //                                           context: context,
              //                                           builder: (BuildContext context) {
              //                                             return CupertinoActionSheet(
              //                                               actions: [
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "尼崎理容美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "尼崎理容美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "アルファジャパン美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "アルファジャパン美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "神戸ビーツー理容美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "神戸ビーツー理容美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "神戸ベルェベル美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "神戸ベルェベル美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "姫路理容美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "姫路理容美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "BEAUTY ARTS KOBE 日本高等美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "BEAUTY ARTS KOBE 日本高等美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                               ],
              //                                               cancelButton: CupertinoButton(
              //                                                 color: Colors.black87,
              //                                                 child: Text(
              //                                                   'キャンセル',
              //                                                   style: TextStyle(
              //                                                     color: Colors.white,
              //                                                     fontSize: 15,
              //                                                   ),
              //                                                 ),
              //                                                 onPressed: () {
              //                                                   Navigator.of(context).pop();
              //                                                 }
              //                                               ),
              //                                             );
              //                                           },
              //                                         );
              //                                       },
              //                                     ),
              //                                   ),
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "奈良県",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         Navigator.of(context).pop();
              //                                         await showCupertinoModalPopup(
              //                                           context: context,
              //                                           builder: (BuildContext context) {
              //                                             return CupertinoActionSheet(
              //                                               actions: [
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "奈良理容美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "奈良理容美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "ル・クレエ橿原美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "ル・クレエ橿原美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                               ],
              //                                               cancelButton: CupertinoButton(
              //                                                 color: Colors.black87,
              //                                                 child: Text(
              //                                                   'キャンセル',
              //                                                   style: TextStyle(
              //                                                     color: Colors.white,
              //                                                     fontSize: 15,
              //                                                   ),
              //                                                 ),
              //                                                 onPressed: () {
              //                                                   Navigator.of(context).pop();
              //                                                 }
              //                                               ),
              //                                             );
              //                                           },
              //                                         );
              //                                       },
              //                                     ),
              //                                   ),
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "和歌山県",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         Navigator.of(context).pop();
              //                                         await showCupertinoModalPopup(
              //                                           context: context,
              //                                           builder: (BuildContext context) {
              //                                             return CupertinoActionSheet(
              //                                               actions: [
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "IBW美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "IBW美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "和歌山高等美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "和歌山高等美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                               ],
              //                                               cancelButton: CupertinoButton(
              //                                                 color: Colors.black87,
              //                                                 child: Text(
              //                                                   'キャンセル',
              //                                                   style: TextStyle(
              //                                                     color: Colors.white,
              //                                                     fontSize: 15,
              //                                                   ),
              //                                                 ),
              //                                                 onPressed: () {
              //                                                   Navigator.of(context).pop();
              //                                                 }
              //                                               ),
              //                                             );
              //                                           },
              //                                         );
              //                                       },
              //                                     ),
              //                                   ),
              //                                 ],
              //                                 cancelButton: CupertinoButton(
              //                                   color: Colors.black87,
              //                                   child: Text(
              //                                     'キャンセル',
              //                                     style: TextStyle(
              //                                       color: Colors.white,
              //                                       fontSize: 15,
              //                                     ),
              //                                   ),
              //                                   onPressed: () {
              //                                     Navigator.of(context).pop();
              //                                   }
              //                                 ),
              //                               );
              //                             },
              //                           );
              //                         },
              //                       ),
              //                     ),
              //                     Container(
              //                       color: Colors.black87,
              //                       child: CupertinoActionSheetAction(
              //                         child: Text(
              //                           "中国",
              //                           style: TextStyle(
              //                             color: Colors.white,
              //                             fontSize: 15,
              //                           ),
              //                         ),
              //                         onPressed: () async {
              //                           HapticFeedback.heavyImpact();
              //                           Navigator.of(context).pop();
              //                           await showCupertinoModalPopup(
              //                             context: context,
              //                             builder: (BuildContext context) {
              //                               return CupertinoActionSheet(
              //                                 actions: [
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "鳥取県",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         Navigator.of(context).pop();
              //                                         await showCupertinoModalPopup(
              //                                           context: context,
              //                                           builder: (BuildContext context) {
              //                                             return CupertinoActionSheet(
              //                                               actions: [
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "鳥取県理容美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "鳥取県理容美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                               ],
              //                                               cancelButton: CupertinoButton(
              //                                                 color: Colors.black87,
              //                                                 child: Text(
              //                                                   'キャンセル',
              //                                                   style: TextStyle(
              //                                                     color: Colors.white,
              //                                                     fontSize: 15,
              //                                                   ),
              //                                                 ),
              //                                                 onPressed: () {
              //                                                   Navigator.of(context).pop();
              //                                                 }
              //                                               ),
              //                                             );
              //                                           },
              //                                         );
              //                                       },
              //                                     ),
              //                                   ),
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "島根県",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         Navigator.of(context).pop();
              //                                         await showCupertinoModalPopup(
              //                                           context: context,
              //                                           builder: (BuildContext context) {
              //                                             return CupertinoActionSheet(
              //                                               actions: [
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "島根県立東部高等技術校（美容科）",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "島根県立東部高等技術校（美容科）";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "浜田ビューティーカレッジ",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "浜田ビューティーカレッジ";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "松江理容美容専門大学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "松江理容美容専門大学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                               ],
              //                                               cancelButton: CupertinoButton(
              //                                                 color: Colors.black87,
              //                                                 child: Text(
              //                                                   'キャンセル',
              //                                                   style: TextStyle(
              //                                                     color: Colors.white,
              //                                                     fontSize: 15,
              //                                                   ),
              //                                                 ),
              //                                                 onPressed: () {
              //                                                   Navigator.of(context).pop();
              //                                                 }
              //                                               ),
              //                                             );
              //                                           },
              //                                         );
              //                                       },
              //                                     ),
              //                                   ),
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "岡山県",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         Navigator.of(context).pop();
              //                                         await showCupertinoModalPopup(
              //                                           context: context,
              //                                           builder: (BuildContext context) {
              //                                             return CupertinoActionSheet(
              //                                               actions: [
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "岡山県理容美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "岡山県理容美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "専門学校 岡山ビューティモード",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "専門学校 岡山ビューティモード";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "専門学校 倉敷ビューティーカレッジ",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "専門学校 倉敷ビューティーカレッジ";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                               ],
              //                                               cancelButton: CupertinoButton(
              //                                                 color: Colors.black87,
              //                                                 child: Text(
              //                                                   'キャンセル',
              //                                                   style: TextStyle(
              //                                                     color: Colors.white,
              //                                                     fontSize: 15,
              //                                                   ),
              //                                                 ),
              //                                                 onPressed: () {
              //                                                   Navigator.of(context).pop();
              //                                                 }
              //                                               ),
              //                                             );
              //                                           },
              //                                         );
              //                                       },
              //                                     ),
              //                                   ),
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "広島県",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         Navigator.of(context).pop();
              //                                         await showCupertinoModalPopup(
              //                                           context: context,
              //                                           builder: (BuildContext context) {
              //                                             return CupertinoActionSheet(
              //                                               actions: [
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "穴吹ビューティー専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "穴吹ビューティー専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "専門学校 マインドビューティーカレッジ",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "専門学校 マインドビューティーカレッジ";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "広島県東部美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "広島県東部美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "広島県理容美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "広島県理容美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "広島美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "広島美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                               ],
              //                                               cancelButton: CupertinoButton(
              //                                                 color: Colors.black87,
              //                                                 child: Text(
              //                                                   'キャンセル',
              //                                                   style: TextStyle(
              //                                                     color: Colors.white,
              //                                                     fontSize: 15,
              //                                                   ),
              //                                                 ),
              //                                                 onPressed: () {
              //                                                   Navigator.of(context).pop();
              //                                                 }
              //                                               ),
              //                                             );
              //                                           },
              //                                         );
              //                                       },
              //                                     ),
              //                                   ),
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "山口県",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         Navigator.of(context).pop();
              //                                         await showCupertinoModalPopup(
              //                                           context: context,
              //                                           builder: (BuildContext context) {
              //                                             return CupertinoActionSheet(
              //                                               actions: [
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "下関理容美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "下関理容美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "東亜大学 芸術学部（トータルビューティ学科）",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "東亜大学 芸術学部（トータルビューティ学科）";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "山口県理容美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "山口県理容美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "YICビューティモード専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "YICビューティモード専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                               ],
              //                                               cancelButton: CupertinoButton(
              //                                                 color: Colors.black87,
              //                                                 child: Text(
              //                                                   'キャンセル',
              //                                                   style: TextStyle(
              //                                                     color: Colors.white,
              //                                                     fontSize: 15,
              //                                                   ),
              //                                                 ),
              //                                                 onPressed: () {
              //                                                   Navigator.of(context).pop();
              //                                                 }
              //                                               ),
              //                                             );
              //                                           },
              //                                         );
              //                                       },
              //                                     ),
              //                                   ),
              //                                 ],
              //                                 cancelButton: CupertinoButton(
              //                                   color: Colors.black87,
              //                                   child: Text(
              //                                     'キャンセル',
              //                                     style: TextStyle(
              //                                       color: Colors.white,
              //                                       fontSize: 15,
              //                                     ),
              //                                   ),
              //                                   onPressed: () {
              //                                     Navigator.of(context).pop();
              //                                   }
              //                                 ),
              //                               );
              //                             },
              //                           );
              //                         },
              //                       ),
              //                     ),
              //                     Container(
              //                       color: Colors.black87,
              //                       child: CupertinoActionSheetAction(
              //                         child: Text(
              //                           "四国",
              //                           style: TextStyle(
              //                             color: Colors.white,
              //                             fontSize: 15,
              //                           ),
              //                         ),
              //                         onPressed: () async {
              //                           HapticFeedback.heavyImpact();
              //                           Navigator.of(context).pop();
              //                           await showCupertinoModalPopup(
              //                             context: context,
              //                             builder: (BuildContext context) {
              //                               return CupertinoActionSheet(
              //                                 actions: [
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "徳島県",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         Navigator.of(context).pop();
              //                                         await showCupertinoModalPopup(
              //                                           context: context,
              //                                           builder: (BuildContext context) {
              //                                             return CupertinoActionSheet(
              //                                               actions: [
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "専修学校 徳島県美容学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "専修学校 徳島県美容学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "専門学校 穴吹デザインビューティカレッジ 徳島",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "専門学校 穴吹デザインビューティカレッジ 徳島";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "徳島県立中央テクノスクール",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "徳島県立中央テクノスクール";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                               ],
              //                                               cancelButton: CupertinoButton(
              //                                                 color: Colors.black87,
              //                                                 child: Text(
              //                                                   'キャンセル',
              //                                                   style: TextStyle(
              //                                                     color: Colors.white,
              //                                                     fontSize: 15,
              //                                                   ),
              //                                                 ),
              //                                                 onPressed: () {
              //                                                   Navigator.of(context).pop();
              //                                                 }
              //                                               ),
              //                                             );
              //                                           },
              //                                         );
              //                                       },
              //                                     ),
              //                                   ),
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "香川県",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         Navigator.of(context).pop();
              //                                         await showCupertinoModalPopup(
              //                                           context: context,
              //                                           builder: (BuildContext context) {
              //                                             return CupertinoActionSheet(
              //                                               actions: [
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "専修学校 香川県美容学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "専修学校 香川県美容学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "専門学校 穴吹ビューティカレッジ 高松",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "専門学校 穴吹ビューティカレッジ 高松";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                               ],
              //                                               cancelButton: CupertinoButton(
              //                                                 color: Colors.black87,
              //                                                 child: Text(
              //                                                   'キャンセル',
              //                                                   style: TextStyle(
              //                                                     color: Colors.white,
              //                                                     fontSize: 15,
              //                                                   ),
              //                                                 ),
              //                                                 onPressed: () {
              //                                                   Navigator.of(context).pop();
              //                                                 }
              //                                               ),
              //                                             );
              //                                           },
              //                                         );
              //                                       },
              //                                     ),
              //                                   ),
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "愛媛県",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         Navigator.of(context).pop();
              //                                         await showCupertinoModalPopup(
              //                                           context: context,
              //                                           builder: (BuildContext context) {
              //                                             return CupertinoActionSheet(
              //                                               actions: [
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "一般社団法人 宇和島美容学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "一般社団法人 宇和島美容学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "愛媛県美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "愛媛県美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "河原ビューティモード専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "河原ビューティモード専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "東予理容美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "東予理容美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                               ],
              //                                               cancelButton: CupertinoButton(
              //                                                 color: Colors.black87,
              //                                                 child: Text(
              //                                                   'キャンセル',
              //                                                   style: TextStyle(
              //                                                     color: Colors.white,
              //                                                     fontSize: 15,
              //                                                   ),
              //                                                 ),
              //                                                 onPressed: () {
              //                                                   Navigator.of(context).pop();
              //                                                 }
              //                                               ),
              //                                             );
              //                                           },
              //                                         );
              //                                       },
              //                                     ),
              //                                   ),
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "高知県",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         Navigator.of(context).pop();
              //                                         await showCupertinoModalPopup(
              //                                           context: context,
              //                                           builder: (BuildContext context) {
              //                                             return CupertinoActionSheet(
              //                                               actions: [
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "高知理容美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "高知理容美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "国際デザイン・ビューティカレッジ",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "国際デザイン・ビューティカレッジ";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                               ],
              //                                               cancelButton: CupertinoButton(
              //                                                 color: Colors.black87,
              //                                                 child: Text(
              //                                                   'キャンセル',
              //                                                   style: TextStyle(
              //                                                     color: Colors.white,
              //                                                     fontSize: 15,
              //                                                   ),
              //                                                 ),
              //                                                 onPressed: () {
              //                                                   Navigator.of(context).pop();
              //                                                 }
              //                                               ),
              //                                             );
              //                                           },
              //                                         );
              //                                       },
              //                                     ),
              //                                   ),
              //                                 ],
              //                                 cancelButton: CupertinoButton(
              //                                   color: Colors.black87,
              //                                   child: Text(
              //                                     'キャンセル',
              //                                     style: TextStyle(
              //                                       color: Colors.white,
              //                                       fontSize: 15,
              //                                     ),
              //                                   ),
              //                                   onPressed: () {
              //                                     Navigator.of(context).pop();
              //                                   }
              //                                 ),
              //                               );
              //                             },
              //                           );
              //                         },
              //                       ),
              //                     ),
              //                     Container(
              //                       color: Colors.black87,
              //                       child: CupertinoActionSheetAction(
              //                         child: Text(
              //                           "九州",
              //                           style: TextStyle(
              //                             color: Colors.white,
              //                             fontSize: 15,
              //                           ),
              //                         ),
              //                         onPressed: () async {
              //                           HapticFeedback.heavyImpact();
              //                           Navigator.of(context).pop();
              //                           await showCupertinoModalPopup(
              //                             context: context,
              //                             builder: (BuildContext context) {
              //                               return CupertinoActionSheet(
              //                                 actions: [
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "	福岡県",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         Navigator.of(context).pop();
              //                                         await showCupertinoModalPopup(
              //                                           context: context,
              //                                           builder: (BuildContext context) {
              //                                             return CupertinoActionSheet(
              //                                               actions: [
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "飯塚理容美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "飯塚理容美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "大村美容ファッション専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "大村美容ファッション専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "北九州市立高等理容美容学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "北九州市立高等理容美容学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "専修学校 麻生ビューティーカレッジ",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "専修学校 麻生ビューティーカレッジ";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "ハリウッドワールド美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "ハリウッドワールド美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "東筑紫短期大学（美容ファッションビジネス学科）",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "東筑紫短期大学（美容ファッションビジネス学科）";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "福岡ビューティーアート専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "福岡ビューティーアート専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "福岡美容専門学校 北九州校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "福岡美容専門学校 北九州校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "福岡美容専門学校 福岡校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "福岡美容専門学校 福岡校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "福岡ベルエポック美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "福岡ベルエポック美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "福岡南美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "福岡南美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "福岡理容美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "福岡理容美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                               ],
              //                                               cancelButton: CupertinoButton(
              //                                                 color: Colors.black87,
              //                                                 child: Text(
              //                                                   'キャンセル',
              //                                                   style: TextStyle(
              //                                                     color: Colors.white,
              //                                                     fontSize: 15,
              //                                                   ),
              //                                                 ),
              //                                                 onPressed: () {
              //                                                   Navigator.of(context).pop();
              //                                                 }
              //                                               ),
              //                                             );
              //                                           },
              //                                         );
              //                                       },
              //                                     ),
              //                                   ),
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "佐賀県",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         Navigator.of(context).pop();
              //                                         await showCupertinoModalPopup(
              //                                           context: context,
              //                                           builder: (BuildContext context) {
              //                                             return CupertinoActionSheet(
              //                                               actions: [
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "アイ・ビービューティカレッジ",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "アイ・ビービューティカレッジ";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "エッジ国際美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "エッジ国際美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                               ],
              //                                               cancelButton: CupertinoButton(
              //                                                 color: Colors.black87,
              //                                                 child: Text(
              //                                                   'キャンセル',
              //                                                   style: TextStyle(
              //                                                     color: Colors.white,
              //                                                     fontSize: 15,
              //                                                   ),
              //                                                 ),
              //                                                 onPressed: () {
              //                                                   Navigator.of(context).pop();
              //                                                 }
              //                                               ),
              //                                             );
              //                                           },
              //                                         );
              //                                       },
              //                                     ),
              //                                   ),
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "長崎県",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         Navigator.of(context).pop();
              //                                         await showCupertinoModalPopup(
              //                                           context: context,
              //                                           builder: (BuildContext context) {
              //                                             return CupertinoActionSheet(
              //                                               actions: [
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "佐世保美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "佐世保美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "長崎県美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "長崎県美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                               ],
              //                                               cancelButton: CupertinoButton(
              //                                                 color: Colors.black87,
              //                                                 child: Text(
              //                                                   'キャンセル',
              //                                                   style: TextStyle(
              //                                                     color: Colors.white,
              //                                                     fontSize: 15,
              //                                                   ),
              //                                                 ),
              //                                                 onPressed: () {
              //                                                   Navigator.of(context).pop();
              //                                                 }
              //                                               ),
              //                                             );
              //                                           },
              //                                         );
              //                                       },
              //                                     ),
              //                                   ),
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "熊本県",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         Navigator.of(context).pop();
              //                                         await showCupertinoModalPopup(
              //                                           context: context,
              //                                           builder: (BuildContext context) {
              //                                             return CupertinoActionSheet(
              //                                               actions: [
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "九州美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "九州美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "熊本ベルェベル美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "熊本ベルェベル美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "専修学校 モア・ヘアメイクカレッジ",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "専修学校 モア・ヘアメイクカレッジ";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "八代実業専門学校（美容師養成科）",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "八代実業専門学校（美容師養成科）";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                               ],
              //                                               cancelButton: CupertinoButton(
              //                                                 color: Colors.black87,
              //                                                 child: Text(
              //                                                   'キャンセル',
              //                                                   style: TextStyle(
              //                                                     color: Colors.white,
              //                                                     fontSize: 15,
              //                                                   ),
              //                                                 ),
              //                                                 onPressed: () {
              //                                                   Navigator.of(context).pop();
              //                                                 }
              //                                               ),
              //                                             );
              //                                           },
              //                                         );
              //                                       },
              //                                     ),
              //                                   ),
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "大分県",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         Navigator.of(context).pop();
              //                                         await showCupertinoModalPopup(
              //                                           context: context,
              //                                           builder: (BuildContext context) {
              //                                             return CupertinoActionSheet(
              //                                               actions: [
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "明日香美容文化専門大学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "明日香美容文化専門大学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "アンビシャス国際美容学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "アンビシャス国際美容学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "明星国際ビューティカレッジ",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "明星国際ビューティカレッジ";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                               ],
              //                                               cancelButton: CupertinoButton(
              //                                                 color: Colors.black87,
              //                                                 child: Text(
              //                                                   'キャンセル',
              //                                                   style: TextStyle(
              //                                                     color: Colors.white,
              //                                                     fontSize: 15,
              //                                                   ),
              //                                                 ),
              //                                                 onPressed: () {
              //                                                   Navigator.of(context).pop();
              //                                                 }
              //                                               ),
              //                                             );
              //                                           },
              //                                         );
              //                                       },
              //                                     ),
              //                                   ),
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "宮崎県",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         Navigator.of(context).pop();
              //                                         await showCupertinoModalPopup(
              //                                           context: context,
              //                                           builder: (BuildContext context) {
              //                                             return CupertinoActionSheet(
              //                                               actions: [
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "宮崎サザンビューティ美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "宮崎サザンビューティ美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "宮崎美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "宮崎美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                               ],
              //                                               cancelButton: CupertinoButton(
              //                                                 color: Colors.black87,
              //                                                 child: Text(
              //                                                   'キャンセル',
              //                                                   style: TextStyle(
              //                                                     color: Colors.white,
              //                                                     fontSize: 15,
              //                                                   ),
              //                                                 ),
              //                                                 onPressed: () {
              //                                                   Navigator.of(context).pop();
              //                                                 }
              //                                               ),
              //                                             );
              //                                           },
              //                                         );
              //                                       },
              //                                     ),
              //                                   ),
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "鹿児島県",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         Navigator.of(context).pop();
              //                                         await showCupertinoModalPopup(
              //                                           context: context,
              //                                           builder: (BuildContext context) {
              //                                             return CupertinoActionSheet(
              //                                               actions: [
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "赤塚学園美容・デザイン専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "赤塚学園美容・デザイン専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "鹿児島県美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "鹿児島県美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "鹿児島県理容美容専門学校",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "鹿児島県理容美容専門学校";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 Container(
              //                                                   color: Colors.black87,
              //                                                   child: CupertinoActionSheetAction(
              //                                                     child: Text(
              //                                                       "鹿児島レディスカレッジ",
              //                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 15,
              //                                                       ),
              //                                                     ),
              //                                                     onPressed: () async {
              //                                                       HapticFeedback.heavyImpact();
              //                                                       nowSchool = "鹿児島レディスカレッジ";
              //                                                       if (mounted) {setState(() {});}
              //                                                       Navigator.of(context).pop();
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                               ],
              //                                               cancelButton: CupertinoButton(
              //                                                 color: Colors.black87,
              //                                                 child: Text(
              //                                                   'キャンセル',
              //                                                   style: TextStyle(
              //                                                     color: Colors.white,
              //                                                     fontSize: 15,
              //                                                   ),
              //                                                 ),
              //                                                 onPressed: () {
              //                                                   Navigator.of(context).pop();
              //                                                 }
              //                                               ),
              //                                             );
              //                                           },
              //                                         );
              //                                       },
              //                                     ),
              //                                   ),
              //                                 ],
              //                                 cancelButton: CupertinoButton(
              //                                   color: Colors.black87,
              //                                   child: Text(
              //                                     'キャンセル',
              //                                     style: TextStyle(
              //                                       color: Colors.white,
              //                                       fontSize: 15,
              //                                     ),
              //                                   ),
              //                                   onPressed: () {
              //                                     Navigator.of(context).pop();
              //                                   }
              //                                 ),
              //                               );
              //                             },
              //                           );
              //                         },
              //                       ),
              //                     ),
              //                     Container(
              //                       color: Colors.black87,
              //                       child: CupertinoActionSheetAction(
              //                         child: Text(
              //                           "沖縄県",
              //                           style: TextStyle(
              //                             color: Colors.white,
              //                             fontSize: 15,
              //                           ),
              //                         ),
              //                         onPressed: () async {
              //                           HapticFeedback.heavyImpact();
              //                           Navigator.of(context).pop();
              //                           await showCupertinoModalPopup(
              //                             context: context,
              //                             builder: (BuildContext context) {
              //                               return CupertinoActionSheet(
              //                                 actions: [
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "スターウッドBeB美容専門学校",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         nowSchool = "スターウッドBeB美容専門学校";
              //                                         if (mounted) {setState(() {});}
              //                                         Navigator.of(context).pop();
              //                                       },
              //                                     ),
              //                                   ),
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "専修学校 ビューティーモードカレッジ",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         nowSchool = "専修学校 ビューティーモードカレッジ";
              //                                         if (mounted) {setState(() {});}
              //                                         Navigator.of(context).pop();
              //                                       },
              //                                     ),
              //                                   ),
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "大育理容美容専門学校",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         nowSchool = "大育理容美容専門学校";
              //                                         if (mounted) {setState(() {});}
              //                                         Navigator.of(context).pop();
              //                                       },
              //                                     ),
              //                                   ),
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "中部美容専門学校",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         nowSchool = "中部美容専門学校";
              //                                         if (mounted) {setState(() {});}
              //                                         Navigator.of(context).pop();
              //                                       },
              //                                     ),
              //                                   ),
              //                                   Container(
              //                                     color: Colors.black87,
              //                                     child: CupertinoActionSheetAction(
              //                                       child: Text(
              //                                         "琉美インターナショナルビューティーカレッジ",
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         HapticFeedback.heavyImpact();
              //                                         nowSchool = "琉美インターナショナルビューティーカレッジ";
              //                                         if (mounted) {setState(() {});}
              //                                         Navigator.of(context).pop();
              //                                       },
              //                                     ),
              //                                   ),
              //                                 ],
              //                                 cancelButton: CupertinoButton(
              //                                   color: Colors.black87,
              //                                   child: Text(
              //                                     'キャンセル',
              //                                     style: TextStyle(
              //                                       color: Colors.white,
              //                                       fontSize: 15,
              //                                     ),
              //                                   ),
              //                                   onPressed: () {
              //                                     Navigator.of(context).pop();
              //                                   }
              //                                 ),
              //                               );
              //                             },
              //                           );
              //                         },
              //                       ),
              //                     ),
              //                   ],
              //                   cancelButton: CupertinoButton(
              //                     color: Colors.black87,
              //                     child: Text(
              //                       'キャンセル',
              //                       style: TextStyle(
              //                         color: Colors.white,
              //                         fontSize: 15,
              //                       ),
              //                     ),
              //                     onPressed: () {
              //                       Navigator.of(context).pop();
              //                     }
              //                   ),
              //                 );
              //               },
              //             );
              //           },
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              // Container(
              //   width: 90.w,
              //   height: 1,
              //   margin: EdgeInsets.only(top: 0, right: 5.w, left: 5.w, bottom: 20,),
              //   color: Colors.black12,
              // ),
              SizedBox(
                height: 100,
              )
            ],
          ),
        ),
      ),
      onTap: () {
        FocusScope.of(context).unfocus();
      },
    );
  }
}


