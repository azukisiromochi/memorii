import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:uuid/uuid.dart';
import '../../singleton.dart';
import 'package:sizer/sizer.dart';
// import 'dart:convert';
// import 'package:storage_path/storage_path.dart';
// import 'package:flutter/services.dart';

class OtherMainPost extends StatefulWidget {
  final Function() onTap;
  const OtherMainPost(this.onTap,);


  @override
  _OtherMainPostState createState() => _OtherMainPostState();
}

class _OtherMainPostState extends State<OtherMainPost> {

  List list = [
    "https://firebasestorage.googleapis.com/v0/b/photo-beauty-24f63.appspot.com/o/app-use%2Fresize_images%2Fpost_default_1_1080x1080.webp?alt=media&token=cee0fe3b-deef-42a6-9dfe-63ae8cf925d9",
    "https://firebasestorage.googleapis.com/v0/b/photo-beauty-24f63.appspot.com/o/app-use%2Fresize_images%2Fpost_default_2_1080x1080.webp?alt=media&token=edf4717e-1ec9-4586-87e4-d1f36bfafbef",
    "https://firebasestorage.googleapis.com/v0/b/photo-beauty-24f63.appspot.com/o/app-use%2Fresize_images%2Fpost_default_3_1080x1080.webp?alt=media&token=ef87b0ea-a887-4678-b8aa-07ca10df0f56",
    "https://firebasestorage.googleapis.com/v0/b/photo-beauty-24f63.appspot.com/o/app-use%2Fresize_images%2Fpost_default_4_1080x1080.webp?alt=media&token=4c58e7b9-cf22-4010-81b8-3b6aaefaf051",
    "https://firebasestorage.googleapis.com/v0/b/photo-beauty-24f63.appspot.com/o/app-use%2Fresize_images%2Fpost_default_5_1080x1080.webp?alt=media&token=30dedc8c-4f6b-46ff-acb9-287863fd0af2",
    "https://firebasestorage.googleapis.com/v0/b/photo-beauty-24f63.appspot.com/o/app-use%2Fresize_images%2Fpost_default_6_1080x1080.webp?alt=media&token=800b7b89-8442-4aa8-93e6-af1c5be933dd",
    "https://firebasestorage.googleapis.com/v0/b/photo-beauty-24f63.appspot.com/o/app-use%2Fresize_images%2Fpost_default_7_1080x1080.webp?alt=media&token=7a59538a-4d23-4fad-bef6-eb8dfc5f245a",
    "https://firebasestorage.googleapis.com/v0/b/photo-beauty-24f63.appspot.com/o/app-use%2Fresize_images%2Fpost_default_8_1080x1080.webp?alt=media&token=7723ed29-f465-45da-9e5d-3e32c7da9cd0",
    "https://firebasestorage.googleapis.com/v0/b/photo-beauty-24f63.appspot.com/o/app-use%2Fresize_images%2Fpost_default_9_1080x1080.webp?alt=media&token=5f758d4e-143c-4e97-98e6-c6d06e9ccdf3",
    "https://firebasestorage.googleapis.com/v0/b/photo-beauty-24f63.appspot.com/o/app-use%2Fresize_images%2Fpost_default_10_1080x1080.webp?alt=media&token=47b5fe2a-a9ff-41b4-beba-023bfe825276",
  ];

  // ジャンル選択
  String searchListOne = "";
  String searchListTwo = "";

  // 警告ボタン
  bool warningImage = false;
  bool warningListOne = false;

  // postImage
  var uuid = Uuid();
  File? image;
  final picker = ImagePicker();
  String imageUuid = "";

  String defaultImage = "";

  @override
  void initState() {
    super.initState();
    imageUuid = uuid.v1();
    defaultImage = list[Random().nextInt(9)];
    if (mounted) {setState(() {});}
  }

  Future<void> postImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      image = File(pickedFile.path);
      if (mounted) {setState(() {});}
      await FirebaseStorage.instance.ref().child("image/$imageUuid").putFile(File(pickedFile.path));
    }
  }

  Future<void> getFile() async {
    if (mounted) {setState(() {});}
    FirebaseFirestore.instance.collection("posts").doc()
    .set({
      "post_count": 0,
      "post_liker": [],
      "post_instagram": UserData.instance.account[0]["user_instagram"],
      "post_image_500": "",
      "post_image_1080": "",
      "post_image_name": imageUuid,
      "post_image_path": image.toString(),
      "post_tags": [searchListOne,searchListTwo],
      "post_uid": UserData.instance.user,
      "post_time": DateTime.now(),
    });
    widget.onTap();
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
                  warningImage = false;
                  warningListOne = false;
                  if (image == null){
                    warningImage = true;
                  } else if (searchListOne == "" || searchListTwo == ""){
                    warningListOne = true;
                  } else {
                    getFile();
                  }
                  if (mounted) {setState(() {});}
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
            image == null ? Container(
              margin: EdgeInsets.only(top: 15, right: 10, left: 10, bottom: 0,),
              width: 100.w,
              height: 100.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(8.0),
                ),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    defaultImage,
                  ),
                ),
              ),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  children: [
                    Container(
                      height: 75.w,
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 10,),
                      child: Text(
                        "please choice image",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 0, right: 35.w, bottom: 0, left: 35.w,),
                      width: double.infinity,
                      height: 35,
                      child: ElevatedButton(
                        child: Text(
                          '作品選択',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 8.sp,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.black87,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onPressed: () {
                          postImage();
                        },
                      ),
                    ),
                  ]
                )
              ),
            )
            :
            Container(
              margin: EdgeInsets.only(top: 15, right: 10, left: 10, bottom: 0,),
              width: 100.w,
              height: 100.w,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.file(
                  image!,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 5, right: 23.w, bottom: 0, left: 23.w,),
              child: Row(
                children: [
                  Icon(
                    Icons.warning,
                    color: warningImage ? Color(0xFFFF8D89) : Colors.black12,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10,),
                    child: Text(
                      "画像を選択してください",
                      style: TextStyle(
                        color: warningImage ? Color(0xFFFF8D89) : Colors.black12,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              width: 90.w,
              // height: 1,
              margin: EdgeInsets.only(top: 10, right: 5.w, left: 5.w,),
              color: Colors.black12,
            ),
            GestureDetector(
              child: Container(
                width: 90.w,
                height: 40,
                margin: EdgeInsets.only(top: 20, right: 5.w, left: 5.w,),
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 30,
                          height: 30,
                          margin: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.black87,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          // child: Icon(
                          //   Icons.image,
                          //   color: Colors.white,
                          //   size: 20,
                          // ),
                          child: Center(
                            child: Text(
                              '１',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 3.w,),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'ジャンル選択 No.1',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10.w,),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                searchListOne,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 40,
                      height: 40,
                      child: Icon(
                        Icons.chevron_right,
                        color: Colors.black38,
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
                              searchListOne = "メンズ";
                              // btnmenColor = true;
                              // btnladiesColor = false;
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
                              searchListOne = "レディース";
                              // btnladiesColor = true;
                              // btnmenColor = false;
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
            Container(
              width: 90.w,
              height: 1,
              margin: EdgeInsets.only(top: 10, right: 5.w, left: 5.w,),
              color: Colors.black12,
            ),
            GestureDetector(
              child: Container(
                width: 90.w,
                height: 40,
                margin: EdgeInsets.only(top: 20, right: 5.w, left: 5.w,),
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 30,
                          height: 30,
                          margin: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.black87,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Center(
                            child: Text(
                              '２',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 3.w,),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'ジャンル選択 No.2',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10.w,),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                searchListTwo,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 40,
                      height: 40,
                      child: Icon(
                        Icons.chevron_right,
                        color: Colors.black38,
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
                              searchListTwo = "ストリート";
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
                              searchListTwo = "クラシック";
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
                              searchListTwo = "モード";
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
                              searchListTwo = "フェミニン";
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
                              searchListTwo = "グランジ";
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
                              searchListTwo = "アンニュイ";
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
                              searchListTwo = "ロック";
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
                              searchListTwo = "クリエイティブ";
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
            Container(
              width: 90.w,
              height: 1,
              margin: EdgeInsets.only(top: 10, right: 5.w, left: 5.w,),
              color: Colors.black12,
            ),
            Container(
              margin: EdgeInsets.only(top: 5, right: 23.w, bottom: 0, left: 23.w,),
              child: Row(
                children: [
                  Icon(
                    Icons.warning,
                    color: warningListOne ? Color(0xFFFF8D89) : Colors.black12,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10,),
                    child: Text(
                      "ジャンルを選択してください",
                      style: TextStyle(
                        color: warningListOne ? Color(0xFFFF8D89) : Colors.black12,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: 150,
            ),
          ],
        ),
      ),
    );
  }
}

class Post extends StatefulWidget {

  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  List<AssetEntity> assets = [];

  @override
  void initState() {
    _fetchAssets();
    super.initState();
  }

  _fetchAssets() async {
    final albums = await PhotoManager.getAssetPathList(onlyAll: true);
    final recentAlbum = albums.first;

    final recentAssets = await recentAlbum.getAssetListRange(
      start: 0,
      end: 1000000,
    );

    setState(() => assets = recentAssets);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gallery'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemCount: assets.length,
        itemBuilder: (_, index) {
          // return AssetThumbnail(asset: assets[index]);
          // print(assets[index]);
          return Container();
        },
      ),
    );
  }
}

// class AssetThumbnail extends StatelessWidget {
//   const AssetThumbnail({
//     Key? key,
//     required this.asset,
//   }) : super(key: key);

//   final AssetEntity asset;

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<Uint8List>(
//       // future: asset.thumbData,
//       builder: (_, snapshot) {
//         final bytes = snapshot.data;
//         if (bytes == null) return CircularProgressIndicator();
//         return InkWell(
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (_) {
//                   if (asset.type == AssetType.image) {
//                     print(asset.file);
//                     // return ImageScreen(imageFile: asset.file);
//                     return Container();
//                   } else {
//                     return Container();
//                     // return VideoScreen(videoFile: asset.file);
//                   }
//                 },
//               ),
//             );
//           },
//           child: Stack(
//             children: [
//               Positioned.fill(
//                 child: Image.memory(bytes, fit: BoxFit.cover),
//               ),
//               if (asset.type == AssetType.video)
//                 Center(
//                   child: Container(
//                     color: Colors.blue,
//                     child: Icon(
//                       Icons.play_arrow,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

// class ImageScreen extends StatelessWidget {
//   const ImageScreen({
//     Key key,
//     @required this.imageFile,
//   }) : super(key: key);

//   final Future<File> imageFile;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.black,
//       alignment: Alignment.center,
//       child: FutureBuilder<File>(
//         future: imageFile,
//         builder: (_, snapshot) {
//           final file = snapshot.data;
//           if (file == null) return Container();
//           return Image.file(file);
//         },
//       ),
//     );
//   }
// }

// class VideoScreen extends StatefulWidget {
//   const VideoScreen({
//     Key key,
//     @required this.videoFile,
//   }) : super(key: key);

//   final Future<File> videoFile;

//   @override
//   _VideoScreenState createState() => _VideoScreenState();
// }

// class _VideoScreenState extends State<VideoScreen> {
//   VideoPlayerController _controller;
//   bool initialized = false;

//   @override
//   void initState() {
//     _initVideo();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   _initVideo() async {
//     final video = await widget.videoFile;
//     _controller = VideoPlayerController.file(video)
//       ..setLooping(true)
//       ..initialize().then((_) => setState(() => initialized = true));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: initialized
//           ? Scaffold(
//               body: Center(
//                 child: AspectRatio(
//                   aspectRatio: _controller.value.aspectRatio,
//                   child: VideoPlayer(_controller),
//                 ),
//               ),
//               floatingActionButton: FloatingActionButton(
//                 onPressed: () {
//                   setState(() {
//                     if (_controller.value.isPlaying) {
//                       _controller.pause();
//                     } else {
//                       _controller.play();
//                     }
//                   });
//                 },
//                 child: Icon(
//                   _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
//                 ),
//               ),
//             )
//           : Center(child: CircularProgressIndicator()),
//     );
//   }
// }