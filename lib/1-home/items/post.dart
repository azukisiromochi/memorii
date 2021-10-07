import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:photo_manager/photo_manager.dart';

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