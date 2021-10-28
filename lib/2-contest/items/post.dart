// import 'dart:io';
// import 'package:flutter/cupertino%202.dart';
// import 'package:flutter/material.dart';
// import 'dart:async';
// import 'dart:ui';
// import 'package:sizer/sizer.dart';
// import 'dart:math';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:uuid/uuid.dart';
// import '../../singleton.dart';

// class Post extends StatefulWidget {
//   final Function() onTap;
//   const Post(this.onTap);

//   @override
//   _PostState createState() => _PostState();
// }

// class _PostState extends State<Post> {

//   var uuid = Uuid();
//   File? imageFile;
//   String imageFilePath = '';
//   final picker = ImagePicker();
//   String imageUuid = "";
//   String defaultImage = "";
//   String imageUrl1080 = "";
//   String imageUrl500 = "";
//   String contestImageUrl1080 = "";
//   String contestImageUrl500 = "";

//   String contest = "";

//   String hashTag1 = "";
//   String hashTag2 = "";
//   final hashTag3 = TextEditingController();
//   final hashTag4 = TextEditingController();
//   final hashTag5 = TextEditingController();

//   int postHashTag1 = 0;
//   int postHashTag2 = 0;
//   int postHashTag3 = 0;

//   List list = [
//     'assets/default1.png',
//     'assets/default2.png',
//     'assets/default3.png',
//     'assets/default4.png',
//     'assets/default5.png',
//   ];

//   @override
//   void initState() {
//     super.initState();
//     imageUuid = uuid.v1().substring(0,23);
//     defaultImage = list[Random().nextInt(4)];
//     imageUrl1080 = 'https://firebasestorage.googleapis.com/v0/b/photo-beauty-24f63.appspot.com/o/image%2Fresize_images%2F' + imageUuid + '_1080x1080?alt=media&token';
//     imageUrl500 = 'https://firebasestorage.googleapis.com/v0/b/photo-beauty-24f63.appspot.com/o/image%2Fresize_images%2F' + imageUuid + '_500x500?alt=media&token';
//     contestImageUrl1080 = 'https://firebasestorage.googleapis.com/v0/b/photo-beauty-24f63.appspot.com/o/contests%2Fresize_images%2F' + imageUuid + '_1080x1080?alt=media&token';
//     contestImageUrl500 = 'https://firebasestorage.googleapis.com/v0/b/photo-beauty-24f63.appspot.com/o/contests%2Fresize_images%2F' + imageUuid + '_500x500?alt=media&token';
//     if (mounted) {setState(() {});}
//   }
//   Future<void> getImage() async {
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       imageFile = File(pickedFile.path);
//       imageFilePath = pickedFile.path;
//       if (mounted) {setState(() {});}
//     }
//   }
//   Future<void> postImage() async {
//     if (contest == 'はい'){
//       await FirebaseFirestore.instance.collection('posts').doc(imageUuid)
//       .set({
//         'post_count': 0,
//         'post_liker': [],
//         'post_instagram': UserData.instance.account[0]['user_instagram'],
//         'post_name': UserData.instance.account[0]['user_name'],
//         'post_image_1080': imageUrl1080,
//         'post_image_500': imageUrl500,
//         'post_image_name': imageUuid,
//         'post_image_path': imageFilePath.replaceFirst('File: \'', '').replaceFirst('\'', ''),
//         'post_tags': [hashTag1,hashTag2,hashTag3.text.replaceFirst('#', ''),hashTag4.text.replaceFirst('#', ''),hashTag5.text.replaceFirst('#', ''),],
//         'post_uid': UserData.instance.user,
//         'post_time': DateTime.now(),
//       });
//       await FirebaseFirestore.instance.collection('contests').doc(imageUuid)
//       .set({
//         'post_count': 0,
//         'post_liker': [],
//         'post_instagram': UserData.instance.account[0]['user_instagram'],
//         'post_name': UserData.instance.account[0]['user_name'],
//         'post_image_1080': contestImageUrl1080,
//         'post_image_500': contestImageUrl500,
//         'post_image_name': imageUuid,
//         'post_image_path': imageFilePath.replaceFirst('File: \'', '').replaceFirst('\'', ''),
//         'post_tags': [hashTag1,hashTag2,hashTag3.text.replaceFirst('#', ''),hashTag4.text.replaceFirst('#', ''),hashTag5.text.replaceFirst('#', ''),],
//         'post_uid': UserData.instance.user,
//         'post_time': DateTime.now(),
//       });
//       widget.onTap();
//       await FirebaseStorage.instance.ref().child("image/$imageUuid").putFile(File(imageFilePath));
//       await FirebaseStorage.instance.ref().child("contests/$imageUuid").putFile(File(imageFilePath));
//     } else if (contest == 'いいえ') {
//       await FirebaseFirestore.instance.collection('contests').doc(imageUuid)
//       .set({
//         'post_count': 0,
//         'post_liker': [],
//         'post_instagram': UserData.instance.account[0]['user_instagram'],
//         'post_name': UserData.instance.account[0]['user_name'],
//         'post_image_1080': contestImageUrl1080,
//         'post_image_500': contestImageUrl500,
//         'post_image_name': imageUuid,
//         'post_image_path': imageFilePath.replaceFirst('File: \'', '').replaceFirst('\'', ''),
//         'post_tags': [hashTag1,hashTag2,hashTag3.text.replaceFirst('#', ''),hashTag4.text.replaceFirst('#', ''),hashTag5.text.replaceFirst('#', ''),],
//         'post_uid': UserData.instance.user,
//         'post_time': DateTime.now(),
//       });
//       widget.onTap();
//       await FirebaseStorage.instance.ref().child("contests/$imageUuid").putFile(File(imageFilePath));
//     }
//   }
//   onHashtag1(String value) {postHashTag1 = value.length;if (mounted) {setState(() {});}}
//   onHashtag2(String value) {postHashTag2 = value.length;if (mounted) {setState(() {});}}
//   onHashtag3(String value) {postHashTag3 = value.length;if (mounted) {setState(() {});}}

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: Stack(
//           alignment: Alignment.center,
//           children: <Widget>[
//             Align(
//               alignment: Alignment.centerLeft,
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: GestureDetector(
//                   child: Icon(
//                     Icons.clear_outlined,
//                     color: Colors.black87,
//                   ),
//                   onTap: () {
//                     Navigator.pop(context);
//                   },
//                 ),
//               ),
//             ),
//             Align(
//               alignment: Alignment.center,
//               child: Text(
//                 "作品投稿",
//                 style: TextStyle(
//                   color: Colors.black87,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 15
//                 ),
//               ),
//             ),
//             imageFile == null ? 
//             Align(
//               alignment: Alignment.centerRight,
//               child: GestureDetector(
//                 child: Container(
//                   margin: EdgeInsets.only(right: 10,),
//                   child: Text(
//                     '画像',
//                     style: TextStyle(
//                       color: Color(0xFFFF8D89),
//                       fontWeight: FontWeight.bold,
//                       fontSize: 15
//                     ),
//                   ),
//                 ),
//                 onTap: () {
//                   getImage();
//                 },
//               )
//             )
//             :
//             Align(
//               alignment: Alignment.centerRight,
//               child: GestureDetector(
//                 child: Container(
//                   margin: EdgeInsets.only(right: 10,),
//                   child: Text(
//                     '投稿',
//                     style: TextStyle(
//                       color: hashTag1 == '' || hashTag2 == '' ? Colors.black12 : Color(0xFFFF8D89),
//                       fontWeight: FontWeight.bold,
//                       fontSize: 15
//                     ),
//                   ),
//                 ),
//                 onTap: () {
//                   if (hashTag1 != '' && hashTag2 != '') {
//                     postImage();
//                   }
//                 },
//               )
//             ),
//           ],
//         ),
//         backgroundColor: Colors.white,
//         centerTitle: true,
//         elevation: 0.0,
//       ),
//       body: SingleChildScrollView(
//         child: GestureDetector(
//           child: Column(
//             children: [
//               Stack(
//                 children: [
//                   imageFile == null ?
//                   Container(
//                     width: 100.w,
//                     height: 250,
//                     decoration: BoxDecoration(
//                       image: DecorationImage(
//                         image: AssetImage(
//                           defaultImage,
//                         ),
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                     child: BackdropFilter(
//                       filter: ImageFilter.blur(sigmaX: 0, sigmaY:0),
//                       child: Container(
//                         color: Colors.white.withOpacity(0.5),
//                       ),
//                     ),
//                   )
//                   :
//                   Container(
//                     width: 100.w,
//                     height: 250,
//                     child: Stack(
//                       children: <Widget>[
//                         Container(
//                           width: 100.w,
//                           height: 250,
//                           child: Image.file(
//                             imageFile!,
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                         BackdropFilter(
//                           filter: ImageFilter.blur(sigmaX: 0, sigmaY:0),
//                           child: Container(
//                             color: Colors.white.withOpacity(0.5),
//                           ),
//                         ),
//                       ]
//                     ),
//                   ),
//                   imageFile == null ?
//                   Container(
//                     width: 100.w,
//                     height: 250,
//                     decoration: BoxDecoration(
//                       image: DecorationImage(
//                         image: AssetImage(
//                           defaultImage,
//                         ),
//                         fit: BoxFit.contain,
//                       ),
//                     ),
//                   )
//                   :
//                   Container(
//                     width: 100.w,
//                     height: 250,
//                     child: Image.file(
//                       imageFile!,
//                       fit: BoxFit.contain,
//                     ),
//                   ),
//                   imageFile == null ?
//                   Container(
//                     width: 100.w,
//                     height: 250,
//                     child: Center(
//                       child: Text(
//                         'default image',
//                         style: TextStyle(
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   )
//                   :
//                   Container(),
//                 ],
//               ),
//               SizedBox(
//                 height: 30,
//               ),
//               Container(
//                 child: Container(
//                   width: 90.w,
//                   margin: EdgeInsets.only(right: 5.w, left: 5.w,),
//                   color: Colors.white,
//                   child: Row(
//                     children: [
//                       Container(
//                         width: 30,
//                         margin: EdgeInsets.only(right: 5, left: 5,),
//                       ),
//                       Container(
//                         margin: EdgeInsets.only(left: 5.w,),
//                         child: Text(
//                           "一般にも投稿しますか？",
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 13,
//                           ),
//                         ),
//                       ),
//                       Spacer(),
//                       contest == '' ?
//                       Container(
//                         margin: EdgeInsets.only(left: 5.w,),
//                         child: Text(
//                           "選択してください",
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 13,
//                             color: Color(0xFFFF8D89),
//                           ),
//                         ),
//                       ) : Container(),
//                     ],
//                   ),
//                 ),
//               ),
//               Container(
//                 child: Container(
//                   width: 90.w,
//                   margin: EdgeInsets.only(top: 0, right: 5.w, left: 5.w,),
//                   child: Row(
//                     children: [
//                       Container(
//                         width: 30,
//                         height: 30,
//                         margin: EdgeInsets.only(right: 5, bottom: 0, left: 5,),
//                         decoration: BoxDecoration(
//                           color: contest == '' ? Colors.red : Colors.black87,
//                           borderRadius: BorderRadius.circular(5),
//                         ),
//                         child: Icon(
//                           Icons.play_arrow,
//                           color: Colors.white,
//                           size: 20,
//                         ),
//                       ),
//                       GestureDetector(
//                         child: Container(
//                           margin: EdgeInsets.only(left: 5.w,),
//                           color: Colors.white,
//                           width: 70.w,
//                           height: 45,
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 contest,
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 13,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         onTap: () async {
//                           await showCupertinoModalPopup(
//                             context: context,
//                             builder: (BuildContext context) {
//                               return CupertinoActionSheet(
//                                 actions: [
//                                   Container(
//                                     color: Colors.black87,
//                                     child: CupertinoActionSheetAction(
//                                       child: Text(
//                                         'はい',
//                                         style: TextStyle(
//                                           color: Colors.white,
//                                           fontSize: 15,
//                                         ),
//                                       ),
//                                       onPressed: () async {
//                                         contest = "はい";
//                                         if (mounted) {setState(() {});}
//                                         Navigator.of(context).pop();
//                                       },
//                                     ),
//                                   ),
//                                   Container(
//                                     color: Colors.black87,
//                                     child: CupertinoActionSheetAction(
//                                       child: Text(
//                                         'いいえ',
//                                         style: TextStyle(
//                                           color: Colors.white,
//                                           fontSize: 15,
//                                         ),
//                                       ),
//                                       onPressed: () async {
//                                         contest = "いいえ";
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
//                     ],
//                   ),
//                 ),
//               ),
//               Container(
//                 width: 90.w,
//                 height: 1,
//                 margin: EdgeInsets.only(top: 0, right: 5.w, left: 5.w, bottom: 20,),
//                 color: Colors.black12,
//               ),
//               Container(
//                 child: Container(
//                   width: 90.w,
//                   margin: EdgeInsets.only(right: 5.w, left: 5.w,),
//                   color: Colors.white,
//                   child: Row(
//                     children: [
//                       Container(
//                         width: 30,
//                         margin: EdgeInsets.only(right: 5, left: 5,),
//                       ),
//                       Container(
//                         margin: EdgeInsets.only(left: 5.w,),
//                         child: Text(
//                           "ハッシュタグ No.1",
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 13,
//                           ),
//                         ),
//                       ),
//                       Spacer(),
//                       hashTag1 == '' ?
//                       Container(
//                         margin: EdgeInsets.only(left: 5.w,),
//                         child: Text(
//                           "選択してください",
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 13,
//                             color: Color(0xFFFF8D89),
//                           ),
//                         ),
//                       ) : Container(),
//                     ],
//                   ),
//                 ),
//               ),
//               Container(
//                 child: Container(
//                   width: 90.w,
//                   margin: EdgeInsets.only(top: 0, right: 5.w, left: 5.w,),
//                   child: Row(
//                     children: [
//                       Container(
//                         width: 30,
//                         height: 30,
//                         margin: EdgeInsets.only(right: 5, bottom: 0, left: 5,),
//                         decoration: BoxDecoration(
//                           color: hashTag1 == '' ? Colors.red : Colors.black87,
//                           borderRadius: BorderRadius.circular(5),
//                         ),
//                         child: Icon(
//                           Icons.play_arrow,
//                           color: Colors.white,
//                           size: 20,
//                         ),
//                       ),
//                       GestureDetector(
//                         child: Container(
//                           margin: EdgeInsets.only(left: 5.w,),
//                           color: Colors.white,
//                           width: 70.w,
//                           height: 45,
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 hashTag1,
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 13,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         onTap: () async {
//                           await showCupertinoModalPopup(
//                             context: context,
//                             builder: (BuildContext context) {
//                               return CupertinoActionSheet(
//                                 actions: [
//                                   Container(
//                                     color: Colors.black87,
//                                     child: CupertinoActionSheetAction(
//                                       child: Text(
//                                         'メンズ',
//                                         style: TextStyle(
//                                           color: Colors.white,
//                                           fontSize: 15,
//                                         ),
//                                       ),
//                                       onPressed: () async {
//                                         hashTag1 = "メンズ";
//                                         if (mounted) {setState(() {});}
//                                         Navigator.of(context).pop();
//                                       },
//                                     ),
//                                   ),
//                                   Container(
//                                     color: Colors.black87,
//                                     child: CupertinoActionSheetAction(
//                                       child: Text(
//                                         'レディース',
//                                         style: TextStyle(
//                                           color: Colors.white,
//                                           fontSize: 15,
//                                         ),
//                                       ),
//                                       onPressed: () async {
//                                         hashTag1 = "レディース";
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
//                     ],
//                   ),
//                 ),
//               ),
//               Container(
//                 width: 90.w,
//                 height: 1,
//                 margin: EdgeInsets.only(top: 0, right: 5.w, left: 5.w, bottom: 20,),
//                 color: Colors.black12,
//               ),
//               Container(
//                 child: Container(
//                   width: 90.w,
//                   margin: EdgeInsets.only(right: 5.w, left: 5.w,),
//                   color: Colors.white,
//                   child: Row(
//                     children: [
//                       Container(
//                         width: 30,
//                         margin: EdgeInsets.only(right: 5, left: 5,),
//                       ),
//                       Container(
//                         margin: EdgeInsets.only(left: 5.w,),
//                         child: Text(
//                           "ハッシュタグ No.2",
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 13,
//                           ),
//                         ),
//                       ),
//                       Spacer(),
//                       hashTag2 == '' ?
//                       Container(
//                         margin: EdgeInsets.only(left: 5.w,),
//                         child: Text(
//                           "選択してください",
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 13,
//                             color: Color(0xFFFF8D89),
//                           ),
//                         ),
//                       ) : Container(),
//                     ],
//                   ),
//                 ),
//               ),
//               Container(
//                 width: 90.w,
//                 margin: EdgeInsets.only(top: 0, right: 5.w, left: 5.w,),
//                 child: Row(
//                   children: [
//                     Container(
//                       width: 30,
//                       height: 30,
//                       margin: EdgeInsets.only(right: 5, bottom: 0, left: 5,),
//                       decoration: BoxDecoration(
//                         color: hashTag2 == '' ? Colors.red : Colors.black87,
//                         borderRadius: BorderRadius.circular(5),
//                       ),
//                       child: Icon(
//                         Icons.play_arrow,
//                         color: Colors.white,
//                         size: 20,
//                       ),
//                     ),
//                     GestureDetector(
//                       child: Container(
//                         margin: EdgeInsets.only(left: 5.w,),
//                         color: Colors.white,
//                         width: 70.w,
//                         height: 45,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               hashTag2,
//                               style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 13,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       onTap: () async {
//                         await showCupertinoModalPopup(
//                           context: context,
//                           builder: (BuildContext context) {
//                             return CupertinoActionSheet(
//                               actions: [
//                                 Container(
//                                   color: Colors.black87,
//                                   child: CupertinoActionSheetAction(
//                                     child: Text(
//                                       "ストリート",
//                                       style: TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 15,
//                                       ),
//                                     ),
//                                     onPressed: () async {
//                                       hashTag2 = "ストリート";
//                                       if (mounted) {setState(() {});}
//                                       Navigator.of(context).pop();
//                                     },
//                                   ),
//                                 ),
//                                 Container(
//                                   color: Colors.black87,
//                                   child: CupertinoActionSheetAction(
//                                     child: Text(
//                                       "クラシック",
//                                       style: TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 15,
//                                       ),
//                                     ),
//                                     onPressed: () async {
//                                       hashTag2 = "クラシック";
//                                       if (mounted) {setState(() {});}
//                                       Navigator.of(context).pop();
//                                     },
//                                   ),
//                                 ),
//                                 Container(
//                                   color: Colors.black87,
//                                   child: CupertinoActionSheetAction(
//                                     child: Text(
//                                       "モード",
//                                       style: TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 15,
//                                       ),
//                                     ),
//                                     onPressed: () async {
//                                       hashTag2 = "モード";
//                                       if (mounted) {setState(() {});}
//                                       Navigator.of(context).pop();
//                                     },
//                                   ),
//                                 ),
//                                 Container(
//                                   color: Colors.black87,
//                                   child: CupertinoActionSheetAction(
//                                     child: Text(
//                                       "フェミニン",
//                                       style: TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 15,
//                                       ),
//                                     ),
//                                     onPressed: () async {
//                                       hashTag2 = "フェミニン";
//                                       if (mounted) {setState(() {});}
//                                       Navigator.of(context).pop();
//                                     },
//                                   ),
//                                 ),
//                                 Container(
//                                   color: Colors.black87,
//                                   child: CupertinoActionSheetAction(
//                                     child: Text(
//                                       "グランジ",
//                                       style: TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 15,
//                                       ),
//                                     ),
//                                     onPressed: () async {
//                                       hashTag2 = "グランジ";
//                                       if (mounted) {setState(() {});}
//                                       Navigator.of(context).pop();
//                                     },
//                                   ),
//                                 ),
//                                 Container(
//                                   color: Colors.black87,
//                                   child: CupertinoActionSheetAction(
//                                     child: Text(
//                                       "アンニュイ",
//                                       style: TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 15,
//                                       ),
//                                     ),
//                                     onPressed: () async {
//                                       hashTag2 = "アンニュイ";
//                                       if (mounted) {setState(() {});}
//                                       Navigator.of(context).pop();
//                                     },
//                                   ),
//                                 ),
//                                 Container(
//                                   color: Colors.black87,
//                                   child: CupertinoActionSheetAction(
//                                     child: Text(
//                                       "ロック",
//                                       style: TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 15,
//                                       ),
//                                     ),
//                                     onPressed: () async {
//                                       hashTag2 = "ロック";
//                                       if (mounted) {setState(() {});}
//                                       Navigator.of(context).pop();
//                                     },
//                                   ),
//                                 ),
//                                 Container(
//                                   color: Colors.black87,
//                                   child: CupertinoActionSheetAction(
//                                     child: Text(
//                                       "クリエイティブ",
//                                       style: TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 15,
//                                       ),
//                                     ),
//                                     onPressed: () async {
//                                       hashTag2 = "クリエイティブ";
//                                       if (mounted) {setState(() {});}
//                                       Navigator.of(context).pop();
//                                     },
//                                   ),
//                                 ),
//                               ],
//                               cancelButton: CupertinoButton(
//                                 color: Colors.black87,
//                                 child: Text(
//                                   'キャンセル',
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 15,
//                                   ),
//                                 ),
//                                 onPressed: () {
//                                   Navigator.of(context).pop();
//                                 }
//                               ),
//                             );
//                           },
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//               Container(
//                 width: 90.w,
//                 height: 1,
//                 margin: EdgeInsets.only(top: 0, right: 5.w, left: 5.w, bottom: 20,),
//                 color: Colors.black12,
//               ),
//               Container(
//                 child: Container(
//                   width: 90.w,
//                   margin: EdgeInsets.only(right: 5.w, left: 5.w,),
//                   color: Colors.white,
//                   child: Row(
//                     children: [
//                       Container(
//                         width: 30,
//                         margin: EdgeInsets.only(right: 5, left: 5,),
//                       ),
//                       Container(
//                         margin: EdgeInsets.only(left: 5.w,),
//                         child: Text(
//                           "ハッシュタグ No.3",
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 13,
//                           ),
//                         ),
//                       ),
//                       Spacer(),
//                       Container(
//                         margin: EdgeInsets.only(left: 5.w,),
//                         child: Text(
//                           "$postHashTag1/15",
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 11,
//                             color: postHashTag1 >= 15 ?  Colors.red : Colors.black87,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               Container(
//                 child: Container(
//                   width: 90.w,
//                   margin: EdgeInsets.only(top: 0, right: 5.w, left: 5.w,),
//                   child: Row(
//                     children: [
//                       Container(
//                         width: 30,
//                         height: 30,
//                         margin: EdgeInsets.only(right: 5, bottom: 0, left: 5,),
//                         decoration: BoxDecoration(
//                           color: Colors.black87,
//                           borderRadius: BorderRadius.circular(5),
//                         ),
//                         child: Icon(
//                           Icons.play_arrow,
//                           color: Colors.white,
//                           size: 20,
//                         ),
//                       ),
//                       Container(
//                         margin: EdgeInsets.only(left: 5.w,),
//                         width: 70.w,
//                         child: TextFormField(
//                           keyboardType: TextInputType.multiline,
//                           maxLines: 1,
//                           minLines: 1,
//                           maxLength: 15,
//                           onChanged: onHashtag1,
//                           autovalidateMode: AutovalidateMode.always,
//                           controller: hashTag3,
//                           decoration: InputDecoration(
//                             border: InputBorder.none,
//                             counterText: '',
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               Container(
//                 width: 90.w,
//                 height: 1,
//                 margin: EdgeInsets.only(top: 0, right: 5.w, left: 5.w, bottom: 20,),
//                 color: Colors.black12,
//               ),
//               Container(
//                 child: Container(
//                   width: 90.w,
//                   margin: EdgeInsets.only(right: 5.w, left: 5.w,),
//                   color: Colors.white,
//                   child: Row(
//                     children: [
//                       Container(
//                         width: 30,
//                         margin: EdgeInsets.only(right: 5, left: 5,),
//                       ),
//                       Container(
//                         margin: EdgeInsets.only(left: 5.w,),
//                         child: Text(
//                           "ハッシュタグ No.4",
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 13,
//                           ),
//                         ),
//                       ),
//                       Spacer(),
//                       Container(
//                         margin: EdgeInsets.only(left: 5.w,),
//                         child: Text(
//                           "$postHashTag2/15",
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 11,
//                             color: postHashTag2 >= 15 ?  Colors.red : Colors.black87,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               Container(
//                 child: Container(
//                   width: 90.w,
//                   margin: EdgeInsets.only(top: 0, right: 5.w, left: 5.w,),
//                   child: Row(
//                     children: [
//                       Container(
//                         width: 30,
//                         height: 30,
//                         margin: EdgeInsets.only(right: 5, bottom: 0, left: 5,),
//                         decoration: BoxDecoration(
//                           color: Colors.black87,
//                           borderRadius: BorderRadius.circular(5),
//                         ),
//                         child: Icon(
//                           Icons.play_arrow,
//                           color: Colors.white,
//                           size: 20,
//                         ),
//                       ),
//                       Container(
//                         margin: EdgeInsets.only(left: 5.w,),
//                         width: 70.w,
//                         child: TextFormField(
//                           keyboardType: TextInputType.multiline,
//                           maxLines: 1,
//                           minLines: 1,
//                           maxLength: 15,
//                           onChanged: onHashtag2,
//                           autovalidateMode: AutovalidateMode.always,
//                           controller: hashTag4,
//                           decoration: InputDecoration(
//                             border: InputBorder.none,
//                             counterText: '',
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               Container(
//                 width: 90.w,
//                 height: 1,
//                 margin: EdgeInsets.only(top: 0, right: 5.w, left: 5.w, bottom: 20,),
//                 color: Colors.black12,
//               ),
//               Container(
//                 child: Container(
//                   width: 90.w,
//                   margin: EdgeInsets.only(right: 5.w, left: 5.w,),
//                   color: Colors.white,
//                   child: Row(
//                     children: [
//                       Container(
//                         width: 30,
//                         margin: EdgeInsets.only(right: 5, left: 5,),
//                       ),
//                       Container(
//                         margin: EdgeInsets.only(left: 5.w,),
//                         child: Text(
//                           "ハッシュタグ No.5",
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 13,
//                           ),
//                         ),
//                       ),
//                       Spacer(),
//                       Container(
//                         margin: EdgeInsets.only(left: 5.w,),
//                         child: Text(
//                           "$postHashTag3/15",
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 11,
//                             color: postHashTag3 >= 15 ?  Colors.red : Colors.black87,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               Container(
//                 child: Container(
//                   width: 90.w,
//                   margin: EdgeInsets.only(top: 0, right: 5.w, left: 5.w,),
//                   child: Row(
//                     children: [
//                       Container(
//                         width: 30,
//                         height: 30,
//                         margin: EdgeInsets.only(right: 5, bottom: 0, left: 5,),
//                         decoration: BoxDecoration(
//                           color: Colors.black87,
//                           borderRadius: BorderRadius.circular(5),
//                         ),
//                         child: Icon(
//                           Icons.play_arrow,
//                           color: Colors.white,
//                           size: 20,
//                         ),
//                       ),
//                       Container(
//                         margin: EdgeInsets.only(left: 5.w,),
//                         width: 70.w,
//                         child: TextFormField(
//                           keyboardType: TextInputType.multiline,
//                           maxLines: 1,
//                           minLines: 1,
//                           maxLength: 15,
//                           onChanged: onHashtag3,
//                           autovalidateMode: AutovalidateMode.always,
//                           controller: hashTag5,
//                           decoration: InputDecoration(
//                             border: InputBorder.none,
//                             counterText: '',
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               Container(
//                 width: 90.w,
//                 height: 1,
//                 margin: EdgeInsets.only(top: 0, right: 5.w, left: 5.w, bottom: 20,),
//                 color: Colors.black12,
//               ),
//               Container(
//                 height: 100,
//               ),
//             ],
//           ),
//           onTap: () {
//             FocusScope.of(context).unfocus();
//           },
//         ),
//       ),
//     );
//   }
// }