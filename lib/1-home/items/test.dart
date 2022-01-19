// import 'dart:async';
// import 'dart:typed_data';
// import 'dart:ui';
// import 'package:photo_manager/photo_manager.dart';
// import 'package:sizer/sizer.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// import 'dart:math';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:uuid/uuid.dart';
// import 'package:video_player/video_player.dart';
// import '../../singleton.dart';
// import 'package:flutter/material.dart';



// class FileModel {
//   late List<String> files;
//   late String folder;

//   FileModel({required this.files, required this.folder});

//   FileModel.fromJson(Map<String, dynamic> json) {
//     files = json['files'].cast<String>();
//     folder = json['folderName'];
//   }
// }

// class Post extends StatefulWidget {

//   @override
//   _PostState createState() => _PostState();
// }

// class _PostState extends State<Post> {

//   List<FileModel> files = [];
//   FileModel? selectedModel;
//   String? image;

//   @override
//   void initState() {
//     super.initState();
//     getImagesPath();
//   }

//   getImagesPath() async {
//     var imagePath = await StoragePath.imagesPath;
//     if (imagePath.length > 0) {
//       var images = jsonDecode(imagePath) as List;
//       files = images.map<FileModel>((e) => FileModel.fromJson(e)).toList();
//       setState(() {
//         selectedModel = files[0];
//         image = files[0].files[0];
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           children: <Widget>[
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: <Widget>[
//                 Row(
//                   children: <Widget>[
//                     Icon(Icons.clear),
//                     SizedBox(width: 10),
//                     DropdownButtonHideUnderline(
//                       child: DropdownButton<FileModel>(
//                       items: getItems(),
//                       value: selectedModel,
//                       onChanged: (FileModel? d) {
//                         assert(d!.files.length > 0);
//                         image = d!.files[0];
//                         setState(() {
//                           selectedModel = d;
//                         });
//                       },
//                     ))
//                   ],
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Text(
//                     'Next',
//                     style: TextStyle(color: Colors.blue),
//                   ),
//                 )
//               ],
//             ),
//             Divider(),
//             Container(
//               height: MediaQuery.of(context).size.height * 0.45,
//               child: image != null ? Image.file(File(image!),
//                 height: MediaQuery.of(context).size.height * 0.45,
//                 width: MediaQuery.of(context).size.width)
//               : Container()
//             ),
//             Divider(),
//             selectedModel == null && (selectedModel?.files.length ?? 0) > 0 ? Container() :
//             Container(
//               height: MediaQuery.of(context).size.height * 0.38,
//               child: 
//               GridView.builder(
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 4,
//                   crossAxisSpacing: 4,
//                   mainAxisSpacing: 4
//                 ),
//                 itemCount: selectedModel?.files.length,
//                 itemBuilder: (_, i) {
//                   var file = selectedModel?.files[i];
//                   if (file == null) {
//                     return Text('none');
//                   }
//                   return GestureDetector(
//                     child: Text(file),
//                     onTap: () {
//                       setState(() {
//                         image = file;
//                       });
//                     },
//                   );
//                 },
//               )
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   List<DropdownMenuItem<FileModel>> getItems() {
//     return files
//     .map((e) => DropdownMenuItem(
//       child: Text(
//         e.folder,
//         style: TextStyle(color: Colors.black),
//       ),
//       value: e,
//     ))
//     .toList();
//   }
// }




// class Post extends StatefulWidget {
//   @override
//   _PostState createState() => _PostState();
// }

// class _PostState extends State<Post> {
//   List<AssetEntity> assets = [];
//   Uint8List? byte;

//   @override
//   void initState() {
//     _fetchAssets();
//     super.initState();
//   }

//   Future<Uint8List> _futureUint8List(Future<Uint8List?> src) async {
//     var completer = new Completer<Uint8List>();
//     src.then((value) => completer.complete(value!));
//     return completer.future;
//   }

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
//                 "作品選択",
//                 style: TextStyle(
//                   color: Colors.black87,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 15
//                 ),
//               ),
//             ),
//             Align(
//               alignment: Alignment.centerRight,
//               child: GestureDetector(
//                 child: Container(
//                   margin: EdgeInsets.only(right: 10,),
//                   child: Text(
//                     "投稿",
//                     style: TextStyle(
//                       color: Color(0xFFFF8D89),
//                       fontWeight: FontWeight.bold,
//                       fontSize: 15
//                     ),
//                   ),
//                 ),
//                 onTap: () {
//                   if (mounted) {setState(() {});}
//                 },
//               )
//             ),
//           ],
//         ),
//         backgroundColor: Colors.white,
//         centerTitle: true,
//         elevation: 0.0,
//       ),
//       body: Column(
//         children: [
//           Container(
//             width: 100.w,
//             height: 100.w,
//             child: byte == null ? Container() : 
//             Image(
//               image: ResizeImage(
//                 MemoryImage(byte!,),
//                 width: 2000,
//                 height: 2000,
//               ),
//               fit: BoxFit.fitWidth,
//             ),
//           ),
//           Expanded(
//             child: Container(
//               width: 100.w,
//               child: GridView.builder(
//                 shrinkWrap: true,
//                 physics: NeverScrollableScrollPhysics(),
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 4,
//                 ),
//                 itemCount: assets.length,
//                 itemBuilder: (_, index) { 
//                   return FutureBuilder<Uint8List>(
//                     future: _futureUint8List(assets[index].originBytes),
//                     builder: (_, snapshot) {
//                       final bytes = snapshot.data;
//                       if (bytes == null) return CircularProgressIndicator();
//                       return GestureDetector(
//                         child: Image.memory(bytes, fit: BoxFit.cover),
//                         onTap: () {
//                           byte = bytes;
//                           print(MemoryImage(byte!));
//                           if (mounted) {setState(() {});}
//                         },
//                       );
//                     },
//                   );
//                 },
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   _fetchAssets() async {
//     final albums = await PhotoManager.getAssetPathList(onlyAll: true);
//     final recentAlbum = albums.first;
//     final recentAssets = await recentAlbum.getAssetListRange(
//       start: 0,
//       end: 1000000,
//     );
//     setState(() => assets = recentAssets);
//   }
// }


// class Post extends StatefulWidget {
//   @override
//   _PostState createState() => _PostState();
// }

// class _PostState extends State<Post> {
//   List<AssetEntity> assets = [];
//   Uint8List? byte;

//   @override
//   void initState() {
//     _fetchAssets();
//     super.initState();
//   }

//   Future<Uint8List> _futureUint8List(Future<Uint8List?> src) async {
//     var completer = new Completer<Uint8List>();
//     src.then((value) => completer.complete(value!));
//     return completer.future;
//   }

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
//                 "作品選択",
//                 style: TextStyle(
//                   color: Colors.black87,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 15
//                 ),
//               ),
//             ),
//             Align(
//               alignment: Alignment.centerRight,
//               child: GestureDetector(
//                 child: Container(
//                   margin: EdgeInsets.only(right: 10,),
//                   child: Text(
//                     "投稿",
//                     style: TextStyle(
//                       color: Color(0xFFFF8D89),
//                       fontWeight: FontWeight.bold,
//                       fontSize: 15
//                     ),
//                   ),
//                 ),
//                 onTap: () {
//                   if (mounted) {setState(() {});}
//                 },
//               )
//             ),
//           ],
//         ),
//         backgroundColor: Colors.white,
//         centerTitle: true,
//         elevation: 0.0,
//       ),
//       body: Column(
//         children: [
//           Container(
//             width: 100.w,
//             height: 100.w,
//             // color: Colors.black26,
//             // child: byte == null ? Container() : Image.memory(byte as Uint8List, fit: BoxFit.cover),
//             child: byte == null ? Container() : 
//             Image(
//               image: ResizeImage(
//                 MemoryImage(byte!,),
//                 width: 2000,
//                 height: 2000,
//               ),
//               fit: BoxFit.fitWidth,
//             ),
//           ),
//           Expanded(
//             child: Container(
//               width: 100.w,
//               child: GridView.builder(
//                 shrinkWrap: true,
//                 physics: NeverScrollableScrollPhysics(),
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 4,
//                 ),
//                 itemCount: assets.length,
//                 itemBuilder: (_, index) { 
//                   // child: AssetThumbnail(asset: assets[index]),
//                   return FutureBuilder<Uint8List>(
//                     future: _futureUint8List(assets[index].thumbData),
//                     builder: (_, snapshot) {
//                       final bytes = snapshot.data;
//                       if (bytes == null) return CircularProgressIndicator();
//                       return GestureDetector(
//                         // child: Image.memory(bytes, fit: BoxFit.cover),
//                         child: Image.memory(bytes, fit: BoxFit.cover),
//                         onTap: () {
//                           byte = bytes;
//                           print(MemoryImage(byte!));
//                           if (mounted) {setState(() {});}
//                         },
//                       );
//                     },
//                   );
//                 },
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   _fetchAssets() async {
//     final albums = await PhotoManager.getAssetPathList(onlyAll: true);
//     final recentAlbum = albums.first;
//     final recentAssets = await recentAlbum.getAssetListRange(
//       start: 0,
//       end: 1000000,
//     );
//     setState(() => assets = recentAssets);
//   }
// }













// 最新


// class Post extends StatefulWidget {
//   @override
//   _PostState createState() => _PostState();
// }

// class _PostState extends State<Post> {
//   late Future<List<AssetEntity>> _future;
//   int postIndex = 0;
//   int currentPage = 0;

//   var _grid;

//   @override
//   void initState() {
//     _future = _fetchAssets();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_grid == null) {
//       _grid = _makeGrid();
//     }

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
//                     color: Colors.black87,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 15),
//               ),
//             ),
//             Align(
//                 alignment: Alignment.centerRight,
//                 child: GestureDetector(
//                   child: Container(
//                     margin: EdgeInsets.only(
//                       right: 10,
//                     ),
//                     child: Text(
//                       "投稿",
//                       style: TextStyle(
//                           color: Color(0xFFFF8D89),
//                           fontWeight: FontWeight.bold,
//                           fontSize: 15),
//                     ),
//                   ),
//                   onTap: () {
//                     if (mounted) {
//                       setState(() {});
//                     }
//                   },
//                 )),
//           ],
//         ),
//         backgroundColor: Colors.white,
//         centerTitle: true,
//         elevation: 0.0,
//       ),
//       body: _Inherited(
//         index: postIndex,
//         child: Column(
//           children: [
//             FutureBuilder(
//               future: _future,
//               builder: (BuildContext context, AsyncSnapshot<List<AssetEntity>> snapshot) {
//                 Widget childWidget;
//                 if (snapshot.hasData) {
//                   List<AssetEntity> assets = snapshot.data!;
//                   childWidget = MainImage(
//                     assets: assets,
//                   );
//                 } else {
//                   childWidget = Container();
//                   //  = const CircularProgressIndicator();
//                 }
//                 return childWidget;
//               }
//             ),
//             // _grid,
//             Expanded(
//               child: _grid,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<List<AssetEntity>> _fetchAssets() async {
//     final albums = await PhotoManager.getAssetPathList(onlyAll: true);
//     final recentAlbum = albums.first;
//     final recentAssets = await recentAlbum.getAssetListRange(
//       start: 0,
//       end: 1000000,
//     );
//     return recentAssets;
//   }

//   _makeGrid() {
//     return FutureBuilder(
//       future: _future,
//       builder: (BuildContext context, AsyncSnapshot<List<AssetEntity>> snapshot) {
//         Widget childWidget;
//         if (snapshot.hasData) {
//           List<AssetEntity> assets = snapshot.data!;
//           // childWidget = Expanded(
//           //   child: GridView.builder(
//           //     shrinkWrap: true,
//           //     physics: NeverScrollableScrollPhysics(),
//           //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//           //       crossAxisCount: 4,
//           //     ),
//           //     itemCount: assets.length,
//           //     itemBuilder: (_, index) {
//           //       return GestureDetector(
//           //         child: AssetThumbnail(asset: assets[index]),
//           //         onTap: () => setState(() {
//           //           postIndex = index;
//           //         }),
//           //       );
//           //     },
//           //   ),
//           // );
//           childWidget = GridView.builder(
//             shrinkWrap: true,
//             physics: ScrollPhysics(),
//             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 4,
//             ),
//             itemCount: assets.length,
//             itemBuilder: (_, index) {
//               return GestureDetector(
//                 child: AssetThumbnail(asset: assets[index]),
//                 onTap: () => setState(() {
//                   postIndex = index;
//                 }),
//               );
//             },
//           );
//         } else {
//           childWidget = Container();
//           // const CircularProgressIndicator();
//         }
//         return childWidget;
//       },
//     );
//   }
// }

// class AssetThumbnail extends StatelessWidget {
//   const AssetThumbnail({
//     Key? key,
//     required this.asset,
//   }) : super(key: key);

//   final AssetEntity asset;

//   Future<Uint8List> _futureUint8List(Future<Uint8List?> src) async {
//     var completer = new Completer<Uint8List>();
//     src.then((value) => completer.complete(value!));
//     return completer.future;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<Uint8List>(
//       future: _futureUint8List(asset.originBytes),
//       builder: (_, snapshot) {
//         final bytes = snapshot.data;
//         if (bytes == null) return CircularProgressIndicator();
//         return Container(
//           child: Image(
//             image: ResizeImage(
//               MemoryImage(bytes,),
//               width: 2000,
//               height: 2000,
//             ),
//             fit: BoxFit.cover,
//           ),
//           // child: Image.memory(bytes, fit: BoxFit.cover),
//         );
//       },
//     );
//   }
// }

// class MainImage extends StatelessWidget {
//   MainImage({
//     Key? key,
//     required this.assets,
//   }) : super(key: key);

//   final List<AssetEntity> assets;

//   @override
//   Widget build(BuildContext context) {
//     var newIndex = _Inherited.of(context) == null ? 0 : _Inherited.of(context)!.index;
//     return Container(
//       width: 100.w,
//       height: 100.w,
//       // child: GridView.builder(
//       //   shrinkWrap: true,
//       //   physics: NeverScrollableScrollPhysics(),
//       //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//       //     crossAxisCount: 1,
//       //   ),
//       //   itemCount: assets.length,
//       //   itemBuilder: (_, index) {
//       //     return AssetThumbnail(asset: assets[newIndex]);
//       //   },
//       // ),
//       child: AssetThumbnail(asset: assets[newIndex]),
//     );
//   }
// }

// class _Inherited extends InheritedWidget {
//   const _Inherited({
//     Key? key,
//     required this.index,
//     required Widget child,
//   }) : super(key: key, child: child);

//   final int index;

//   static _Inherited? of(BuildContext context) {
//     final _Inherited? result = context.dependOnInheritedWidgetOfExactType<_Inherited>();
//     return result;
//   }

//   @override
//   bool updateShouldNotify(_Inherited old) => index != old.index;
// }